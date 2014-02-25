Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaBYJkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:40:36 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34280 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaBYJkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:40:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<874n3n7czm.fsf_-_@xmission.com>
Date: Tue, 25 Feb 2014 01:40:24 -0800
In-Reply-To: <874n3n7czm.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 25 Feb 2014 01:33:49 -0800")
Message-ID: <87lhwz4jjr.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/GxrAJ3N7O37W9dqd1aT+oHAS2UynS6Y8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4586]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 09/12] vfs: Merge check_submounts_and_drop and d_invalidate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that d_invalidate is the only caller of check_submounts_and_drop,
expand check_submounts_and_drop inline in d_invalidate.

Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/dcache.c            |   55 +++++++++++++++++++----------------------------
 include/linux/dcache.h |    1 -
 2 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 27585b1dd6f1..5b41205cbf33 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -608,32 +608,6 @@ kill_it:
 }
 EXPORT_SYMBOL(dput);
 
-/**
- * d_invalidate - invalidate a dentry
- * @dentry: dentry to invalidate
- *
- * Try to invalidate the dentry if it turns out to be
- * possible. If there are reasons not to delete it
- * return -EBUSY. On success return 0.
- *
- * no dcache lock.
- */
- 
-int d_invalidate(struct dentry * dentry)
-{
-	/*
-	 * If it's already been dropped, return OK.
-	 */
-	spin_lock(&dentry->d_lock);
-	if (d_unhashed(dentry)) {
-		spin_unlock(&dentry->d_lock);
-		return 0;
-	}
-	spin_unlock(&dentry->d_lock);
-
-	return check_submounts_and_drop(dentry);
-}
-EXPORT_SYMBOL(d_invalidate);
 
 /* This must be called with d_lock held */
 static inline void __dget_dlock(struct dentry *dentry)
@@ -1175,7 +1149,7 @@ EXPORT_SYMBOL(have_submounts);
  * reachable (e.g. NFS can unhash a directory dentry and then the complete
  * subtree can become unreachable).
  *
- * Only one of check_submounts_and_drop() and d_set_mounted() must succeed.  For
+ * Only one of d_invalidate() and d_set_mounted() must succeed.  For
  * this reason take rename_lock and d_lock on dentry and ancestors.
  */
 int d_set_mounted(struct dentry *dentry)
@@ -1184,7 +1158,7 @@ int d_set_mounted(struct dentry *dentry)
 	int ret = -ENOENT;
 	write_seqlock(&rename_lock);
 	for (p = dentry->d_parent; !IS_ROOT(p); p = p->d_parent) {
-		/* Need exclusion wrt. check_submounts_and_drop() */
+		/* Need exclusion wrt. d_invalidate() */
 		spin_lock(&p->d_lock);
 		if (unlikely(d_unhashed(p))) {
 			spin_unlock(&p->d_lock);
@@ -1400,18 +1374,33 @@ static void check_and_drop(void *_data)
 }
 
 /**
- * check_submounts_and_drop - detach submounts, prune dcache, and drop
+ * d_invalidate - detach submounts, prune dcache, and drop
+ * @dentry: dentry to invalidate (aka detach, prune and drop)
+ *
+ * Try to invalidate the dentry if it turns out to be
+ * possible. If there are reasons not to delete it
+ * return -EBUSY. On success return 0.
+ *
+ * no dcache lock.
  *
  * The final d_drop is done as an atomic operation relative to
  * rename_lock ensuring there are no races with d_set_mounted.  This
  * ensures there are no unhashed dentries on the path to a mountpoint.
- *
- * @dentry: dentry to detach, prune and drop
  */
-int check_submounts_and_drop(struct dentry *dentry)
+int d_invalidate(struct dentry *dentry)
 {
 	int ret = 0;
 
+	/*
+	 * If it's already been dropped, return OK.
+	 */
+	spin_lock(&dentry->d_lock);
+	if (d_unhashed(dentry)) {
+		spin_unlock(&dentry->d_lock);
+		return 0;
+	}
+	spin_unlock(&dentry->d_lock);
+
 	/* Negative dentries can be dropped without further checks */
 	if (!dentry->d_inode) {
 		d_drop(dentry);
@@ -1445,7 +1434,7 @@ int check_submounts_and_drop(struct dentry *dentry)
 out:
 	return ret;
 }
-EXPORT_SYMBOL(check_submounts_and_drop);
+EXPORT_SYMBOL(d_invalidate);
 
 /**
  * __d_alloc	-	allocate a dcache entry
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index bf72e9ac6de0..ae77222c3e86 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -265,7 +265,6 @@ extern void d_prune_aliases(struct inode *);
 
 /* test whether we have any submounts in a subdir tree */
 extern int have_submounts(struct dentry *);
-extern int check_submounts_and_drop(struct dentry *);
 
 /*
  * This adds the entry to the hash queues.
-- 
1.7.5.4

