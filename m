Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbbAVFAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:00:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbbAVFAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:00:30 -0500
Subject: [PATCH v2 5/5] audit: replace getname()/putname() hacks with
 reference counters
From: Paul Moore <pmoore@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com
Cc: rgb@redhat.com, sd@queasysnail.net, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, viro@zeniv.linux.org.uk
Date: Thu, 22 Jan 2015 00:00:23 -0500
Message-ID: <20150122050023.1347.6866.stgit@localhost>
In-Reply-To: <20150122045303.1347.98054.stgit@localhost>
References: <20150122045303.1347.98054.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to ensure that filenames are not released before the audit
subsystem is done with the strings there are a number of hacks built
into the fs and audit subsystems around getname() and putname().  To
say these hacks are "ugly" would be kind.

This patch removes the filename hackery in favor of a more
conventional reference count based approach.  The diffstat below tells
most of the story; lots of audit/fs specific code is replaced with a
traditional reference count based approach that is easily understood,
even by those not familiar with the audit and/or fs subsystems.

CC: viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Paul Moore <pmoore@redhat.com>
---
 fs/namei.c            |   29 +++++++-------
 include/linux/audit.h |    3 -
 include/linux/fs.h    |    9 +---
 kernel/audit.h        |   17 +-------
 kernel/auditsc.c      |  105 +++++--------------------------------------------
 5 files changed, 29 insertions(+), 134 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e18a2b5..f73e757 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -117,15 +117,6 @@
  * POSIX.1 2.4: an empty pathname is invalid (ENOENT).
  * PATH_MAX includes the nul terminator --RR.
  */
-void final_putname(struct filename *name)
-{
-	if (name->separate) {
-		__putname(name->name);
-		kfree(name);
-	} else {
-		__putname(name);
-	}
-}
 
 #define EMBEDDED_NAME_MAX	(PATH_MAX - sizeof(struct filename))
 
@@ -144,6 +135,7 @@ getname_flags(const char __user *filename, int flags, int *empty)
 	result = __getname();
 	if (unlikely(!result))
 		return ERR_PTR(-ENOMEM);
+	result->refcnt = 1;
 
 	/*
 	 * First, try to embed the struct filename inside the names_cache
@@ -178,6 +170,7 @@ recopy:
 		}
 		result->name = kname;
 		result->separate = true;
+		result->refcnt = 1;
 		max = PATH_MAX;
 		goto recopy;
 	}
@@ -201,7 +194,7 @@ recopy:
 	return result;
 
 error:
-	final_putname(result);
+	putname(result);
 	return err;
 }
 
@@ -242,19 +235,25 @@ getname_kernel(const char * filename)
 	memcpy((char *)result->name, filename, len);
 	result->uptr = NULL;
 	result->aname = NULL;
+	result->refcnt = 1;
 	audit_getname(result);
 
 	return result;
 }
 
-#ifdef CONFIG_AUDITSYSCALL
 void putname(struct filename *name)
 {
-	if (unlikely(!audit_dummy_context()))
-		return audit_putname(name);
-	final_putname(name);
+	BUG_ON(name->refcnt <= 0);
+
+	if (--name->refcnt > 0)
+		return;
+
+	if (name->separate) {
+		__putname(name->name);
+		kfree(name);
+	} else
+		__putname(name);
 }
-#endif
 
 static int check_acl(struct inode *inode, int mask)
 {
diff --git a/include/linux/audit.h b/include/linux/audit.h
index b481779..5f2ad5f 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -127,7 +127,6 @@ extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 extern void __audit_syscall_exit(int ret_success, long ret_value);
 extern struct filename *__audit_reusename(const __user char *uptr);
 extern void __audit_getname(struct filename *name);
-extern void audit_putname(struct filename *name);
 
 #define AUDIT_INODE_PARENT	1	/* dentry represents the parent */
 #define AUDIT_INODE_HIDDEN	2	/* audit record should be hidden */
@@ -346,8 +345,6 @@ static inline struct filename *audit_reusename(const __user char *name)
 }
 static inline void audit_getname(struct filename *name)
 { }
-static inline void audit_putname(struct filename *name)
-{ }
 static inline void __audit_inode(struct filename *name,
 					const struct dentry *dentry,
 					unsigned int flags)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e11d60c..df7a047 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2017,6 +2017,7 @@ struct filename {
 	const char		*name;	/* pointer to actual string */
 	const __user char	*uptr;	/* original userland pointer */
 	struct audit_names	*aname;
+	int			refcnt;
 	bool			separate; /* should "name" be freed? */
 };
 
@@ -2036,6 +2037,7 @@ extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname(const char __user *);
 extern struct filename *getname_kernel(const char *);
+extern void putname(struct filename *name);
 
 enum {
 	FILE_CREATED = 1,
@@ -2056,15 +2058,8 @@ extern void __init vfs_caches_init(unsigned long);
 
 extern struct kmem_cache *names_cachep;
 
-extern void final_putname(struct filename *name);
-
 #define __getname()		kmem_cache_alloc(names_cachep, GFP_KERNEL)
 #define __putname(name)		kmem_cache_free(names_cachep, (void *)(name))
-#ifndef CONFIG_AUDITSYSCALL
-#define putname(name)		final_putname(name)
-#else
-extern void putname(struct filename *name);
-#endif
 
 #ifdef CONFIG_BLOCK
 extern int register_blkdev(unsigned int, const char *);
diff --git a/kernel/audit.h b/kernel/audit.h
index 3cdffad..1caa0d3 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -24,12 +24,6 @@
 #include <linux/skbuff.h>
 #include <uapi/linux/mqueue.h>
 
-/* 0 = no checking
-   1 = put_count checking
-   2 = verbose put_count checking
-*/
-#define AUDIT_DEBUG 0
-
 /* AUDIT_NAMES is the number of slots we reserve in the audit_context
  * for saving names from getname().  If we get more names we will allocate
  * a name dynamically and also add those to the list anchored by names_list. */
@@ -74,9 +68,8 @@ struct audit_cap_data {
 	};
 };
 
-/* When fs/namei.c:getname() is called, we store the pointer in name and
- * we don't let putname() free it (instead we free all of the saved
- * pointers at syscall exit time).
+/* When fs/namei.c:getname() is called, we store the pointer in name and bump
+ * the refcnt in the associated filename struct.
  *
  * Further, in fs/namei.c:path_lookup() we store the inode and device.
  */
@@ -86,7 +79,6 @@ struct audit_names {
 	struct filename		*name;
 	int			name_len;	/* number of chars to log */
 	bool			hidden;		/* don't log this record */
-	bool			name_put;	/* call __putname()? */
 
 	unsigned long		ino;
 	dev_t			dev;
@@ -208,11 +200,6 @@ struct audit_context {
 	};
 	int fds[2];
 	struct audit_proctitle proctitle;
-
-#if AUDIT_DEBUG
-	int		    put_count;
-	int		    ino_count;
-#endif
 };
 
 extern u32 audit_ever_enabled;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index c54b5f0..0a93b71 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -866,33 +866,10 @@ static inline void audit_free_names(struct audit_context *context)
 {
 	struct audit_names *n, *next;
 
-#if AUDIT_DEBUG == 2
-	if (context->put_count + context->ino_count != context->name_count) {
-		int i = 0;
-
-		pr_err("%s:%d(:%d): major=%d in_syscall=%d"
-		       " name_count=%d put_count=%d ino_count=%d"
-		       " [NOT freeing]\n", __FILE__, __LINE__,
-		       context->serial, context->major, context->in_syscall,
-		       context->name_count, context->put_count,
-		       context->ino_count);
-		list_for_each_entry(n, &context->names_list, list) {
-			pr_err("names[%d] = %p = %s\n", i++, n->name,
-			       n->name->name ?: "(null)");
-		}
-		dump_stack();
-		return;
-	}
-#endif
-#if AUDIT_DEBUG
-	context->put_count  = 0;
-	context->ino_count  = 0;
-#endif
-
 	list_for_each_entry_safe(n, next, &context->names_list, list) {
 		list_del(&n->list);
-		if (n->name && n->name_put)
-			final_putname(n->name);
+		if (n->name)
+			putname(n->name);
 		if (n->should_free)
 			kfree(n);
 	}
@@ -1711,9 +1688,6 @@ static struct audit_names *audit_alloc_name(struct audit_context *context,
 	list_add_tail(&aname->list, &context->names_list);
 
 	context->name_count++;
-#if AUDIT_DEBUG
-	context->ino_count++;
-#endif
 	return aname;
 }
 
@@ -1734,8 +1708,10 @@ __audit_reusename(const __user char *uptr)
 	list_for_each_entry(n, &context->names_list, list) {
 		if (!n->name)
 			continue;
-		if (n->name->uptr == uptr)
+		if (n->name->uptr == uptr) {
+			n->name->refcnt++;
 			return n->name;
+		}
 	}
 	return NULL;
 }
@@ -1752,19 +1728,8 @@ void __audit_getname(struct filename *name)
 	struct audit_context *context = current->audit_context;
 	struct audit_names *n;
 
-	if (!context->in_syscall) {
-#if AUDIT_DEBUG == 2
-		pr_err("%s:%d(:%d): ignoring getname(%p)\n",
-		       __FILE__, __LINE__, context->serial, name);
-		dump_stack();
-#endif
+	if (!context->in_syscall)
 		return;
-	}
-
-#if AUDIT_DEBUG
-	/* The filename _must_ have a populated ->name */
-	BUG_ON(!name->name);
-#endif
 
 	n = audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
 	if (!n)
@@ -1772,56 +1737,13 @@ void __audit_getname(struct filename *name)
 
 	n->name = name;
 	n->name_len = AUDIT_NAME_FULL;
-	n->name_put = true;
 	name->aname = n;
+	name->refcnt++;
 
 	if (!context->pwd.dentry)
 		get_fs_pwd(current->fs, &context->pwd);
 }
 
-/* audit_putname - intercept a putname request
- * @name: name to intercept and delay for putname
- *
- * If we have stored the name from getname in the audit context,
- * then we delay the putname until syscall exit.
- * Called from include/linux/fs.h:putname().
- */
-void audit_putname(struct filename *name)
-{
-	struct audit_context *context = current->audit_context;
-
-	BUG_ON(!context);
-	if (!name->aname || !context->in_syscall) {
-#if AUDIT_DEBUG == 2
-		pr_err("%s:%d(:%d): final_putname(%p)\n",
-		       __FILE__, __LINE__, context->serial, name);
-		if (context->name_count) {
-			struct audit_names *n;
-			int i = 0;
-
-			list_for_each_entry(n, &context->names_list, list)
-				pr_err("name[%d] = %p = %s\n", i++, n->name,
-				       n->name->name ?: "(null)");
-			}
-#endif
-		final_putname(name);
-	}
-#if AUDIT_DEBUG
-	else {
-		++context->put_count;
-		if (context->put_count > context->name_count) {
-			pr_err("%s:%d(:%d): major=%d in_syscall=%d putname(%p)"
-			       " name_count=%d put_count=%d\n",
-			       __FILE__, __LINE__,
-			       context->serial, context->major,
-			       context->in_syscall, name->name,
-			       context->name_count, context->put_count);
-			dump_stack();
-		}
-	}
-#endif
-}
-
 /**
  * __audit_inode - store the inode and device from a lookup
  * @name: name being audited
@@ -1842,11 +1764,6 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
 	if (!name)
 		goto out_alloc;
 
-#if AUDIT_DEBUG
-	/* The struct filename _must_ have a populated ->name */
-	BUG_ON(!name->name);
-#endif
-
 	/*
 	 * If we have a pointer to an audit_names entry already, then we can
 	 * just use it directly if the type is correct.
@@ -1893,9 +1810,10 @@ out_alloc:
 	n = audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
 	if (!n)
 		return;
-	if (name)
-		/* no need to set ->name_put as the original will cleanup */
+	if (name) {
 		n->name = name;
+		name->refcnt++;
+	}
 
 out:
 	if (parent) {
@@ -1995,8 +1913,7 @@ void __audit_inode_child(const struct inode *parent,
 		if (found_parent) {
 			found_child->name = found_parent->name;
 			found_child->name_len = AUDIT_NAME_FULL;
-			/* don't call __putname() */
-			found_child->name_put = false;
+			found_child->name->refcnt++;
 		}
 	}
 

