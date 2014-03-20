Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaCTEO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:14:57 -0400
Received: from ozlabs.org ([203.10.76.45]:52900 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaCTEOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:14:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, fes@google.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] virtio-blk: make the queue depth configurable
In-Reply-To: <1395250293.8649.51.camel@joe-AO722>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu> <1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org> <87y509scl3.fsf@rustcorp.com.au> <1395032434.2556.10.camel@joe-AO722> <1395041214.2556.17.camel@joe-AO722> <87zjkmr8w1.fsf@rustcorp.com.au> <CAErSpo7rhDGX2DB1kRb4iZDLGNRGrm+sEwt6LuRsd19X5coG8Q@mail.gmail.com> <1395250293.8649.51.camel@joe-AO722>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 20 Mar 2014 14:05:04 +1030
Message-ID: <87ior9r193.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:
> Couple more bikesheddy things:
>
> Is there ever a reason to use a non __builtin_const_p(perms)?

It's a bit conservative, and anyway, the test is useless since AFAICT
BUILD_BUG_ON() is a noop if !__builtin_const_p().  I removed it
and re-tested.

> Maybe that should be a BUILD_BUG_ON too
> 	BUILD_BUG_ON(!builtin_const_p_perms)
>
> My brain of little size gets confused by the
> 	BUILD_BUG_ON_ZERO(foo) +
> vs
> 	BUILD_BUG_ON(foo);
> as it just seems like more text for the same content.
>
> Is there any value on the "_ZERO(foo) +" I don't understand?

I don't like to use statement expressions unless we really need them,
and BUILD_BUG_ON_ZERO() was build for this purpose.

Cheers,
Rusty.

Subject: VERIFY_OCTAL_PERMISSIONS: stricter checking for sysfs perms.

Summary of http://lkml.org/lkml/2014/3/14/363 :

  Ted: module_param(queue_depth, int, 444)
  Joe: 0444!
  Rusty: User perms >= group perms >= other perms?
  Joe: CLASS_ATTR, DEVICE_ATTR, SENSOR_ATTR and SENSOR_ATTR_2?

Side effect of stricter permissions means removing the unnecessary
S_IFREG from several callers.

Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com> for drivers/pci/slot.c
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 7dd62fa9d0bd..396c200b9ddb 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -116,11 +116,11 @@ static void pci_slot_release(struct kobject *kobj)
 }
 
 static struct pci_slot_attribute pci_slot_attr_address =
-	__ATTR(address, (S_IFREG | S_IRUGO), address_read_file, NULL);
+	__ATTR(address, S_IRUGO, address_read_file, NULL);
 static struct pci_slot_attribute pci_slot_attr_max_speed =
-	__ATTR(max_bus_speed, (S_IFREG | S_IRUGO), max_speed_read_file, NULL);
+	__ATTR(max_bus_speed, S_IRUGO, max_speed_read_file, NULL);
 static struct pci_slot_attribute pci_slot_attr_cur_speed =
-	__ATTR(cur_bus_speed, (S_IFREG | S_IRUGO), cur_speed_read_file, NULL);
+	__ATTR(cur_bus_speed, S_IRUGO, cur_speed_read_file, NULL);
 
 static struct attribute *pci_slot_default_attrs[] = {
 	&pci_slot_attr_address.attr,
diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index b96a49b37d66..77cf5eeeabd1 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -568,7 +568,7 @@ static ssize_t cuse_class_waiting_show(struct device *dev,
 
 	return sprintf(buf, "%d\n", atomic_read(&cc->fc.num_waiting));
 }
-static DEVICE_ATTR(waiting, S_IFREG | 0400, cuse_class_waiting_show, NULL);
+static DEVICE_ATTR(waiting, 0400, cuse_class_waiting_show, NULL);
 
 static ssize_t cuse_class_abort_store(struct device *dev,
 				      struct device_attribute *attr,
@@ -579,7 +579,7 @@ static ssize_t cuse_class_abort_store(struct device *dev,
 	fuse_abort_conn(&cc->fc);
 	return count;
 }
-static DEVICE_ATTR(abort, S_IFREG | 0200, NULL, cuse_class_abort_store);
+static DEVICE_ATTR(abort, 0200, NULL, cuse_class_abort_store);
 
 static struct attribute *cuse_class_dev_attrs[] = {
 	&dev_attr_waiting.attr,
diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index a4b07730b2e1..b7f57271d49c 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -41,7 +41,7 @@ static ssize_t version_show(struct kobject *kobj, struct kobj_attribute *attr,
 	return snprintf(buf, PAGE_SIZE, "%u\n", O2NM_API_VERSION);
 }
 static struct kobj_attribute attr_version =
-	__ATTR(interface_revision, S_IFREG | S_IRUGO, version_show, NULL);
+	__ATTR(interface_revision, S_IRUGO, version_show, NULL);
 
 static struct attribute *o2cb_attrs[] = {
 	&attr_version.attr,
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 1324e6600e57..25e9f7b5bad3 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -494,7 +494,7 @@ static ssize_t ocfs2_max_locking_protocol_show(struct kobject *kobj,
 }
 
 static struct kobj_attribute ocfs2_attr_max_locking_protocol =
-	__ATTR(max_locking_protocol, S_IFREG | S_IRUGO,
+	__ATTR(max_locking_protocol, S_IRUGO,
 	       ocfs2_max_locking_protocol_show, NULL);
 
 static ssize_t ocfs2_loaded_cluster_plugins_show(struct kobject *kobj,
@@ -526,7 +526,7 @@ static ssize_t ocfs2_loaded_cluster_plugins_show(struct kobject *kobj,
 }
 
 static struct kobj_attribute ocfs2_attr_loaded_cluster_plugins =
-	__ATTR(loaded_cluster_plugins, S_IFREG | S_IRUGO,
+	__ATTR(loaded_cluster_plugins, S_IRUGO,
 	       ocfs2_loaded_cluster_plugins_show, NULL);
 
 static ssize_t ocfs2_active_cluster_plugin_show(struct kobject *kobj,
@@ -548,7 +548,7 @@ static ssize_t ocfs2_active_cluster_plugin_show(struct kobject *kobj,
 }
 
 static struct kobj_attribute ocfs2_attr_active_cluster_plugin =
-	__ATTR(active_cluster_plugin, S_IFREG | S_IRUGO,
+	__ATTR(active_cluster_plugin, S_IRUGO,
 	       ocfs2_active_cluster_plugin_show, NULL);
 
 static ssize_t ocfs2_cluster_stack_show(struct kobject *kobj,
@@ -597,7 +597,7 @@ static ssize_t ocfs2_cluster_stack_store(struct kobject *kobj,
 
 
 static struct kobj_attribute ocfs2_attr_cluster_stack =
-	__ATTR(cluster_stack, S_IFREG | S_IRUGO | S_IWUSR,
+	__ATTR(cluster_stack, S_IRUGO | S_IWUSR,
 	       ocfs2_cluster_stack_show,
 	       ocfs2_cluster_stack_store);
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 471090093c67..4679eddc110a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -842,4 +842,12 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
 
+/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
+#define VERIFY_OCTAL_PERMISSIONS(perms)					\
+	(BUILD_BUG_ON_ZERO((perms) < 0) +				\
+	 BUILD_BUG_ON_ZERO((perms) > 0777) +				\
+	 /* User perms >= group perms >= other perms */			\
+	 BUILD_BUG_ON_ZERO(((perms) >> 6) < (((perms) >> 3) & 7)) +	\
+	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 7) < ((perms) & 7)) +	\
+	 (perms))
 #endif
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 175f6995d1af..204a67743804 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -186,14 +186,12 @@ struct kparam_array
    parameters. */
 #define __module_param_call(prefix, name, ops, arg, perm, level)	\
 	/* Default value instead of permissions? */			\
-	static int __param_perm_check_##name __attribute__((unused)) =	\
-	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
-	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
-	static const char __param_str_##name[] = prefix #name;		\
+	static const char __param_str_##name[] = prefix #name; \
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, ops, perm, level, { arg } }
+	= { __param_str_##name, ops, VERIFY_OCTAL_PERMISSIONS(perm),	\
+	    level, { arg } }
 
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 30b2ebee6439..f517e6e488c8 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -71,7 +71,8 @@ struct attribute_group {
  */
 
 #define __ATTR(_name, _mode, _show, _store) {				\
-	.attr = {.name = __stringify(_name), .mode = _mode },		\
+	.attr = {.name = __stringify(_name),				\
+		 .mode = VERIFY_OCTAL_PERMISSIONS(_mode) },		\
 	.show	= _show,						\
 	.store	= _store,						\
 }
