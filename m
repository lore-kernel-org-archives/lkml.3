Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbaA1XXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:23:47 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:35340 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbaA1XWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:22:06 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>, kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH 07/11] kernfs, sysfs, driver-core: implement kernfs_remove_self() and its wrappers
Date: Tue, 28 Jan 2014 18:21:47 -0500
Message-Id: <1390951311-15325-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it's necessary to implement a node which wants to delete
nodes including itself.  This isn't straightforward because of kernfs
active reference.  While a file operation is in progress, an active
reference is held and kernfs_remove() waits for all such references to
drain before completing.  For a self-deleting node, this is a deadlock
as kernfs_remove() ends up waiting for an active reference that itself
is sitting on top of.

This currently is worked around in the sysfs layer using
sysfs_schedule_callback() which makes such removals asynchronous.
While it works, it's rather cumbersome and inherently breaks
synchronicity of the operation - the file operation which triggered
the operation may complete before the removal is finished (or even
started) and the removal may fail asynchronously.  If a removal
operation is immmediately followed by another operation which expects
the specific name to be available (e.g. removal followed by rename
onto the same name), there's no way to make the latter operation
reliable.

The thing is there's no inherent reason for this to be asynchrnous.
All that's necessary to do this synchronous is a dedicated operation
which drops its own active ref and deactivates self.  This patch
implements kernfs_remove_self() and its wrappers in sysfs and driver
core.  kernfs_remove_self() is to be called from one of the file
operations, drops the active ref the task is holding, removes the self
node, and restores active ref to the dead node so that the ref is
balanced afterwards.  __kernfs_remove() is updated so that it takes an
early exit if the target node is already fully removed so that the
active ref restored by kernfs_remove_self() after removal doesn't
confuse the deactivation path.

This makes implementing self-deleting nodes very easy.  The normal
removal path doesn't even need to be changed to use
kernfs_remove_self() for the self-deleting node.  The method can
invoke kernfs_remove_self() on itself before proceeding the normal
removal path.  kernfs_remove() invoked on the node by the normal
deletion path will simply be ignored.

This will replace sysfs_schedule_callback().  A subtle feature of
sysfs_schedule_callback() is that it collapses multiple invocations -
even if multiple removals are triggered, the removal callback is run
only once.  An equivalent effect can be achieved by testing the return
value of kernfs_remove_self() - only the one which gets %true return
value should proceed with actual deletion.  All other instances of
kernfs_remove_self() will wait till the enclosing kernfs operation
which invoked the winning instance of kernfs_remove_self() finishes
and then return %false.  This trivially makes all users of
kernfs_remove_self() automatically show correct synchronous behavior
even when there are multiple concurrent operations - all "echo 1 >
delete" instances will finish only after the whole operation is
completed by one of the instances.

Note that manipulation of active ref is implemented in separate public
functions - kernfs_[un]break_active_protection().
kernfs_remove_self() is the only user at the moment but this will be
used to cater to more complex cases.

v2: For !CONFIG_SYSFS, dummy version kernfs_remove_self() was missing
    and sysfs_remove_file_self() had incorrect return type.  Fix it.
    Reported by kbuild test bot.

v3: kernfs_[un]break_active_protection() separated out from
    kernfs_remove_self() and exposed as public API.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: kbuild test robot <fengguang.wu@intel.com>
---
 drivers/base/core.c    |  17 ++++++
 fs/kernfs/dir.c        | 138 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/sysfs/file.c        |  23 +++++++++
 include/linux/device.h |   2 +
 include/linux/kernfs.h |   8 +++
 include/linux/sysfs.h  |   7 +++
 6 files changed, 194 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2b56717..9db57af 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -571,6 +571,23 @@ void device_remove_file(struct device *dev,
 EXPORT_SYMBOL_GPL(device_remove_file);
 
 /**
+ * device_remove_file_self - remove sysfs attribute file from its own method.
+ * @dev: device.
+ * @attr: device attribute descriptor.
+ *
+ * See kernfs_remove_self() for details.
+ */
+bool device_remove_file_self(struct device *dev,
+			     const struct device_attribute *attr)
+{
+	if (dev)
+		return sysfs_remove_file_self(&dev->kobj, &attr->attr);
+	else
+		return false;
+}
+EXPORT_SYMBOL_GPL(device_remove_file_self);
+
+/**
  * device_create_bin_file - create sysfs binary attribute file for device.
  * @dev: device.
  * @attr: device binary attribute descriptor.
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index d0fd739..8c63ae1 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -761,7 +761,12 @@ static void __kernfs_remove(struct kernfs_node *kn)
 
 	lockdep_assert_held(&kernfs_mutex);
 
-	if (!kn)
+	/*
+	 * Short-circuit if non-root @kn has already finished removal.
+	 * This is for kernfs_remove_self() which plays with active ref
+	 * after removal.
+	 */
+	if (!kn || (kn->parent && RB_EMPTY_NODE(&kn->rb)))
 		return;
 
 	pr_debug("kernfs %s: removing\n", kn->name);
@@ -821,6 +826,137 @@ void kernfs_remove(struct kernfs_node *kn)
 }
 
 /**
+ * kernfs_break_active_protection - break out of active protection
+ * @kn: the self kernfs_node
+ *
+ * The caller must be running off of a kernfs operation which is invoked
+ * with an active reference - e.g. one of kernfs_ops.  Each invocation of
+ * this function must also be matched with an invocation of
+ * kernfs_unbreak_active_protection().
+ *
+ * This function releases the active reference of @kn the caller is
+ * holding.  Once this function is called, @kn may be removed at any point
+ * and the caller is solely responsible for ensuring that the objects it
+ * dereferences are accessible.
+ */
+void kernfs_break_active_protection(struct kernfs_node *kn)
+{
+	/*
+	 * Take out ourself out of the active ref dependency chain.  If
+	 * we're called without an active ref, lockdep will complain.
+	 */
+	kernfs_put_active(kn);
+}
+
+/**
+ * kernfs_unbreak_active_protection - undo kernfs_break_active_protection()
+ * @kn: the self kernfs_node
+ *
+ * If kernfs_break_active_protection() was called, this function must be
+ * invoked before finishing the kernfs operation.  Note that while this
+ * function restores the active reference, it doesn't and can't actually
+ * restore the active protection - @kn may already or be in the process of
+ * being removed.  Once kernfs_break_active_protection() is invoked, that
+ * protection is irreversibly gone for the kernfs operation instance.
+ *
+ * While this function may be called at any point after
+ * kernfs_break_active_protection() is invoked, its most useful location
+ * would be right before the enclosing kernfs operation returns.
+ */
+void kernfs_unbreak_active_protection(struct kernfs_node *kn)
+{
+	/*
+	 * @kn->active could be in any state; however, the increment we do
+	 * here will be undone as soon as the enclosing kernfs operation
+	 * finishes and this temporary bump can't break anything.  If @kn
+	 * is alive, nothing changes.  If @kn is being deactivated, the
+	 * soon-to-follow put will either finish deactivation or restore
+	 * deactivated state.  If @kn is already removed, the temporary
+	 * bump is guaranteed to be gone before @kn is released.
+	 */
+	atomic_inc(&kn->active);
+	if (kernfs_lockdep(kn))
+		rwsem_acquire(&kn->dep_map, 0, 1, _RET_IP_);
+}
+
+/**
+ * kernfs_remove_self - remove a kernfs_node from its own method
+ * @kn: the self kernfs_node to remove
+ *
+ * The caller must be running off of a kernfs operation which is invoked
+ * with an active reference - e.g. one of kernfs_ops.  This can be used to
+ * implement a file operation which deletes itself.
+ *
+ * For example, the "delete" file for a sysfs device directory can be
+ * implemented by invoking kernfs_remove_self() on the "delete" file
+ * itself.  This function breaks the circular dependency of trying to
+ * deactivate self while holding an active ref itself.  It isn't necessary
+ * to modify the usual removal path to use kernfs_remove_self().  The
+ * "delete" implementation can simply invoke kernfs_remove_self() on self
+ * before proceeding with the usual removal path.  kernfs will ignore later
+ * kernfs_remove() on self.
+ *
+ * kernfs_remove_self() can be called multiple times concurrently on the
+ * same kernfs_node.  Only the first one actually performs removal and
+ * returns %true.  All others will wait until the kernfs operation which
+ * won self-removal finishes and return %false.  Note that the losers wait
+ * for the completion of not only the winning kernfs_remove_self() but also
+ * the whole kernfs_ops which won the arbitration.  This can be used to
+ * guarantee, for example, all concurrent writes to a "delete" file to
+ * finish only after the whole operation is complete.
+ */
+bool kernfs_remove_self(struct kernfs_node *kn)
+{
+	bool ret;
+
+	mutex_lock(&kernfs_mutex);
+	kernfs_break_active_protection(kn);
+
+	/*
+	 * SUICIDAL is used to arbitrate among competing invocations.  Only
+	 * the first one will actually perform removal.  When the removal
+	 * is complete, SUICIDED is set and the active ref is restored
+	 * while holding kernfs_mutex.  The ones which lost arbitration
+	 * waits for SUICDED && drained which can happen only after the
+	 * enclosing kernfs operation which executed the winning instance
+	 * of kernfs_remove_self() finished.
+	 */
+	if (!(kn->flags & KERNFS_SUICIDAL)) {
+		kn->flags |= KERNFS_SUICIDAL;
+		__kernfs_remove(kn);
+		kn->flags |= KERNFS_SUICIDED;
+		ret = true;
+	} else {
+		wait_queue_head_t *waitq = &kernfs_root(kn)->deactivate_waitq;
+		DEFINE_WAIT(wait);
+
+		while (true) {
+			prepare_to_wait(waitq, &wait, TASK_UNINTERRUPTIBLE);
+
+			if ((kn->flags & KERNFS_SUICIDED) &&
+			    atomic_read(&kn->active) == KN_DEACTIVATED_BIAS)
+				break;
+
+			mutex_unlock(&kernfs_mutex);
+			schedule();
+			mutex_lock(&kernfs_mutex);
+		}
+		finish_wait(waitq, &wait);
+		WARN_ON_ONCE(!RB_EMPTY_NODE(&kn->rb));
+		ret = false;
+	}
+
+	/*
+	 * This must be done while holding kernfs_mutex; otherwise, waiting
+	 * for SUICIDED && deactivated could finish prematurely.
+	 */
+	kernfs_unbreak_active_protection(kn);
+
+	mutex_unlock(&kernfs_mutex);
+	return ret;
+}
+
+/**
  * kernfs_remove_by_name_ns - find a kernfs_node by name and remove it
  * @parent: parent of the target
  * @name: name of the kernfs_node to remove
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 810cf6e..1b8b91b 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -372,6 +372,29 @@ void sysfs_remove_file_ns(struct kobject *kobj, const struct attribute *attr,
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_ns);
 
+/**
+ * sysfs_remove_file_self - remove an object attribute from its own method
+ * @kobj: object we're acting for
+ * @attr: attribute descriptor
+ *
+ * See kernfs_remove_self() for details.
+ */
+bool sysfs_remove_file_self(struct kobject *kobj, const struct attribute *attr)
+{
+	struct kernfs_node *parent = kobj->sd;
+	struct kernfs_node *kn;
+	bool ret;
+
+	kn = kernfs_find_and_get(parent, attr->name);
+	if (WARN_ON_ONCE(!kn))
+		return false;
+
+	ret = kernfs_remove_self(kn);
+
+	kernfs_put(kn);
+	return ret;
+}
+
 void sysfs_remove_files(struct kobject *kobj, const struct attribute **ptr)
 {
 	int i;
diff --git a/include/linux/device.h b/include/linux/device.h
index 952b010..1ff3f16 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -560,6 +560,8 @@ extern int device_create_file(struct device *device,
 			      const struct device_attribute *entry);
 extern void device_remove_file(struct device *dev,
 			       const struct device_attribute *attr);
+extern bool device_remove_file_self(struct device *dev,
+				    const struct device_attribute *attr);
 extern int __must_check device_create_bin_file(struct device *dev,
 					const struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 917bc6c..02ac334 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -43,6 +43,8 @@ enum kernfs_node_flag {
 	KERNFS_HAS_MMAP		= 0x0080,
 	KERNFS_LOCKDEP		= 0x0100,
 	KERNFS_STATIC_NAME	= 0x0200,
+	KERNFS_SUICIDAL		= 0x0400,
+	KERNFS_SUICIDED		= 0x0800,
 };
 
 /* type-specific structures for kernfs_node union members */
@@ -234,6 +236,9 @@ struct kernfs_node *kernfs_create_link(struct kernfs_node *parent,
 				       const char *name,
 				       struct kernfs_node *target);
 void kernfs_remove(struct kernfs_node *kn);
+void kernfs_break_active_protection(struct kernfs_node *kn);
+void kernfs_unbreak_active_protection(struct kernfs_node *kn);
+bool kernfs_remove_self(struct kernfs_node *kn);
 int kernfs_remove_by_name_ns(struct kernfs_node *parent, const char *name,
 			     const void *ns);
 int kernfs_rename_ns(struct kernfs_node *kn, struct kernfs_node *new_parent,
@@ -291,6 +296,9 @@ kernfs_create_link(struct kernfs_node *parent, const char *name,
 
 static inline void kernfs_remove(struct kernfs_node *kn) { }
 
+static inline bool kernfs_remove_self(struct kernfs_node *kn)
+{ return false; }
+
 static inline int kernfs_remove_by_name_ns(struct kernfs_node *kn,
 					   const char *name, const void *ns)
 { return -ENOSYS; }
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 30b2ebe..bd96c60 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -198,6 +198,7 @@ int __must_check sysfs_chmod_file(struct kobject *kobj,
 				  const struct attribute *attr, umode_t mode);
 void sysfs_remove_file_ns(struct kobject *kobj, const struct attribute *attr,
 			  const void *ns);
+bool sysfs_remove_file_self(struct kobject *kobj, const struct attribute *attr);
 void sysfs_remove_files(struct kobject *kobj, const struct attribute **attr);
 
 int __must_check sysfs_create_bin_file(struct kobject *kobj,
@@ -301,6 +302,12 @@ static inline void sysfs_remove_file_ns(struct kobject *kobj,
 {
 }
 
+static inline bool sysfs_remove_file_self(struct kobject *kobj,
+					  const struct attribute *attr)
+{
+	return false;
+}
+
 static inline void sysfs_remove_files(struct kobject *kobj,
 				     const struct attribute **attr)
 {
-- 
1.8.5.3

