Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3J3O2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:28:41 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:63135 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3J3O2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:28:40 -0400
Date: Wed, 30 Oct 2013 10:28:36 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH driver-core-next] sysfs: rename sysfs_assoc_lock and explain
 what it's about
Message-ID: <20131030142836.GC27632@htj.dyndns.org>
References: <20131029220939.GA23060@kroah.com>
 <8761sflhi1.fsf@tw-ebiederman.twitter.com>
 <CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
 <87sivj9vi0.fsf@xmission.com>
 <20131030132831.GB27632@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030132831.GB27632@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, again.

How about something like the following?

Thanks.
----- >8 -----
sysfs_assoc_lock is an odd piece of locking.  In general, whoever owns
a kobject is responsible for synchronizing sysfs operations and sysfs
proper assumes that, for example, removal won't race with any other
operation; however, this doesn't work for symlinking because an entity
performing symlink doesn't usually own the target kobject and thus has
no control over its removal.

sysfs_assoc_lock synchronizes symlink operations against kobj->sd
disassociation so that symlink code doesn't end up dereferencing
already freed sysfs_dirent by racing with removal of the target
kobject.

This is quite obscure and the generic name of the lock and lack of
comments make it difficult to understand its role.  Let's rename it to
sysfs_symlink_target_lock and add comments explaining what's going on.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/sysfs/dir.c     |   18 +++++++++++++++---
 fs/sysfs/symlink.c |   20 ++++++++++++++------
 fs/sysfs/sysfs.h   |    2 +-
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index de47ed3..08c6696 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -26,7 +26,7 @@
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
-DEFINE_SPINLOCK(sysfs_assoc_lock);
+DEFINE_SPINLOCK(sysfs_symlink_target_lock);
 
 #define to_sysfs_dirent(X) rb_entry((X), struct sysfs_dirent, s_rb)
 
@@ -902,9 +902,21 @@ void sysfs_remove_dir(struct kobject *kobj)
 {
 	struct sysfs_dirent *sd = kobj->sd;
 
-	spin_lock(&sysfs_assoc_lock);
+	/*
+	 * In general, kboject owner is responsible for ensuring removal
+	 * doesn't race with other operations and sysfs doesn't provide any
+	 * protection; however, when @kobj is used as a symlink target, the
+	 * symlinking entity usually doesn't own @kobj and thus has no
+	 * control over removal.  @kobj->sd may be removed anytime and
+	 * symlink code may end up dereferencing an already freed sd.
+	 *
+	 * sysfs_symlink_target_lock synchronizes @kobj->sd disassociation
+	 * against symlink operations so that symlink code can safely
+	 * dereference @kobj->sd.
+	 */
+	spin_lock(&sysfs_symlink_target_lock);
 	kobj->sd = NULL;
-	spin_unlock(&sysfs_assoc_lock);
+	spin_unlock(&sysfs_symlink_target_lock);
 
 	if (sd) {
 		WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 22ea2f5..1a23681 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -32,13 +32,15 @@ static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
 
 	BUG_ON(!name || !parent_sd);
 
-	/* target->sd can go away beneath us but is protected with
-	 * sysfs_assoc_lock.  Fetch target_sd from it.
+	/*
+	 * We don't own @target and it may be removed at any time.
+	 * Synchronize using sysfs_symlink_target_lock.  See
+	 * sysfs_remove_dir() for details.
 	 */
-	spin_lock(&sysfs_assoc_lock);
+	spin_lock(&sysfs_symlink_target_lock);
 	if (target->sd)
 		target_sd = sysfs_get(target->sd);
-	spin_unlock(&sysfs_assoc_lock);
+	spin_unlock(&sysfs_symlink_target_lock);
 
 	error = -ENOENT;
 	if (!target_sd)
@@ -140,10 +142,16 @@ void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
 			const char *name)
 {
 	const void *ns = NULL;
-	spin_lock(&sysfs_assoc_lock);
+
+	/*
+	 * We don't own @target and it may be removed at any time.
+	 * Synchronize using sysfs_symlink_target_lock.  See
+	 * sysfs_remove_dir() for details.
+	 */
+	spin_lock(&sysfs_symlink_target_lock);
 	if (targ->sd)
 		ns = targ->sd->s_ns;
-	spin_unlock(&sysfs_assoc_lock);
+	spin_unlock(&sysfs_symlink_target_lock);
 	sysfs_hash_and_remove(kobj->sd, name, ns);
 }
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 05d063f..e3aea92 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -159,7 +159,7 @@ extern struct kmem_cache *sysfs_dir_cachep;
  * dir.c
  */
 extern struct mutex sysfs_mutex;
-extern spinlock_t sysfs_assoc_lock;
+extern spinlock_t sysfs_symlink_target_lock;
 extern const struct dentry_operations sysfs_dentry_ops;
 
 extern const struct file_operations sysfs_dir_operations;
