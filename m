Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbaDIW7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 18:59:47 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51613 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbaDIW6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 18:58:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<874n3n7czm.fsf_-_@xmission.com>
	<87wqezl5df.fsf_-_@x220.int.ebiederm.org>
	<20140409023027.GX18016@ZenIV.linux.org.uk>
	<20140409023947.GY18016@ZenIV.linux.org.uk>
	<87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
	<87txa286fu.fsf@x220.int.ebiederm.org>
Date: Wed, 09 Apr 2014 15:58:25 -0700
In-Reply-To: <87txa286fu.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Wed, 09 Apr 2014 15:49:09 -0700")
Message-ID: <87fvlm860e.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Guov0TQDvK1Cu1gxKA9etrfVF9hvZTdI=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [RFC][PATCH] vfs: In mntput run deactivate_super on a shallow stack.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mntput as part of pathput is called from all over the vfs sometimes as
in the case of symlink chasing from some rather deep call chains.
During filesystem unmount with the right set of races those innocuous
little mntput calls that take very little stack space can become calls
become mosters calling deactivate_super that can take up 3k or more of
stack space as syncrhonous filesystem I/O is performed, through
multiple levels of the I/O stack.

Avoid deactivate_super being called from a deep stack by converting
mntput to use task_work_add when the mnt_count goes to 0.  The
filesystem is still unmounted synchronously preserving the semantics
that system calls like umount require.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

This patch has only seen light testing so far but it emperically it
appears to solve the stack depth problem.  A simple umount of ext4 went
from having 5162 stack bytes untouched to having 5568 stack bytes
untouched.  Freeing up at least 416 bytes of stack in that simple case.

 fs/mount.h     |  2 +-
 fs/namespace.c | 24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index aa3c0aa473df..4e78ca90467f 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -30,7 +30,7 @@ struct mount {
 	struct mount *mnt_parent;
 	struct dentry *mnt_mountpoint;
 	struct vfsmount mnt;
-	struct rcu_head mnt_rcu;
+	struct callback_head mnt_callback;
 #ifdef CONFIG_SMP
 	struct mnt_pcp __percpu *mnt_pcp;
 #else
diff --git a/fs/namespace.c b/fs/namespace.c
index c809205f30df..686afe9942bc 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -24,6 +24,7 @@
 #include <linux/proc_ns.h>
 #include <linux/magic.h>
 #include <linux/bootmem.h>
+#include <linux/task_work.h>
 #include "pnode.h"
 #include "internal.h"
 
@@ -981,7 +982,7 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 
 static void delayed_free(struct rcu_head *head)
 {
-	struct mount *mnt = container_of(head, struct mount, mnt_rcu);
+	struct mount *mnt = container_of(head, struct mount, mnt_callback);
 	kfree(mnt->mnt_devname);
 #ifdef CONFIG_SMP
 	free_percpu(mnt->mnt_pcp);
@@ -989,6 +990,17 @@ static void delayed_free(struct rcu_head *head)
 	kmem_cache_free(mnt_cache, mnt);
 }
 
+static void mntput_delayed(struct callback_head *head)
+{
+	struct mount *mnt = container_of(head, struct mount, mnt_callback);
+
+	fsnotify_vfsmount_delete(&mnt->mnt);
+	dput(mnt->mnt.mnt_root);
+	deactivate_super(mnt->mnt.mnt_sb);
+	mnt_free_id(mnt);
+	call_rcu(&mnt->mnt_callback, delayed_free);
+}
+
 static void mntput_no_expire(struct mount *mnt)
 {
 put_again:
@@ -1034,11 +1046,11 @@ put_again:
 	 * so mnt_get_writers() below is safe.
 	 */
 	WARN_ON(mnt_get_writers(mnt));
-	fsnotify_vfsmount_delete(&mnt->mnt);
-	dput(mnt->mnt.mnt_root);
-	deactivate_super(mnt->mnt.mnt_sb);
-	mnt_free_id(mnt);
-	call_rcu(&mnt->mnt_rcu, delayed_free);
+	/* The stack may be deep here so perform this where the stack
+	 * is guaranteed to be shallow.
+	 */
+	init_task_work(&mnt->mnt_callback, mntput_delayed);
+	WARN_ON(task_work_add(current, &mnt->mnt_callback, true) != 0);
 }
 
 void mntput(struct vfsmount *mnt)
-- 
1.9.1

