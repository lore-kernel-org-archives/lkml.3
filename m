Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBYJjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:39:39 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47464 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaBYJjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:39:33 -0500
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
Date: Tue, 25 Feb 2014 01:39:26 -0800
In-Reply-To: <874n3n7czm.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 25 Feb 2014 01:33:49 -0800")
Message-ID: <87txbn4jld.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/z+4xuZ6UWMakOpbRKD3PRKynE74p/0zU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1613]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 08/12] vfs: Remove unnecessary calls of check_submounts_and_drop
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that check_submounts_and_drop can not fail and is called from
d_invalidate there is no longer a need to call check_submounts_and_drom
from filesystem d_revalidate methods so remove it.

Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/afs/dir.c     |    5 -----
 fs/fuse/dir.c    |    3 ---
 fs/gfs2/dentry.c |    3 ---
 fs/kernfs/dir.c  |   11 -----------
 fs/nfs/dir.c     |    4 ----
 5 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 529300327f45..a1645b88fe8a 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -669,7 +669,6 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 
 out_valid:
 	dentry->d_fsdata = dir_version;
-out_skip:
 	dput(parent);
 	key_put(key);
 	_leave(" = 1 [valid]");
@@ -682,10 +681,6 @@ not_found:
 	spin_unlock(&dentry->d_lock);
 
 out_bad:
-	/* don't unhash if we have submounts */
-	if (check_submounts_and_drop(dentry) != 0)
-		goto out_skip;
-
 	_debug("dropping dentry %s/%s",
 	       parent->d_name.name, dentry->d_name.name);
 	dput(parent);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 1d1292c581c3..5192d0a04d20 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -273,9 +273,6 @@ out:
 
 invalid:
 	ret = 0;
-
-	if (!(flags & LOOKUP_RCU) && check_submounts_and_drop(entry) != 0)
-		ret = 1;
 	goto out;
 }
 
diff --git a/fs/gfs2/dentry.c b/fs/gfs2/dentry.c
index d3a5d4e29ba5..589f4ea9381c 100644
--- a/fs/gfs2/dentry.c
+++ b/fs/gfs2/dentry.c
@@ -93,9 +93,6 @@ invalid_gunlock:
 	if (!had_lock)
 		gfs2_glock_dq_uninit(&d_gh);
 invalid:
-	if (check_submounts_and_drop(dentry) != 0)
-		goto valid;
-
 	dput(parent);
 	return 0;
 
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 5104cf5d25c5..43d5ab905238 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -296,21 +296,10 @@ static int kernfs_dop_revalidate(struct dentry *dentry, unsigned int flags)
 		goto out_bad;
 
 	mutex_unlock(&kernfs_mutex);
-out_valid:
 	return 1;
 out_bad:
 	mutex_unlock(&kernfs_mutex);
 out_bad_unlocked:
-	/*
-	 * @dentry doesn't match the underlying kernfs node, drop the
-	 * dentry and force lookup.  If we have submounts we must allow the
-	 * vfs caches to lie about the state of the filesystem to prevent
-	 * leaks and other nasty things, so use check_submounts_and_drop()
-	 * instead of d_drop().
-	 */
-	if (check_submounts_and_drop(dentry) != 0)
-		goto out_valid;
-
 	return 0;
 }
 
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index be38b573495a..a8a2f7f86c45 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1143,10 +1143,6 @@ out_zap_parent:
 		if (IS_ROOT(dentry))
 			goto out_valid;
 	}
-	/* If we have submounts, don't unhash ! */
-	if (check_submounts_and_drop(dentry) != 0)
-		goto out_valid;
-
 	dput(parent);
 	dfprintk(LOOKUPCACHE, "NFS: %s(%pd2) is invalid\n",
 			__func__, dentry);
-- 
1.7.5.4

