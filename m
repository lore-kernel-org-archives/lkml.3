Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaBYJfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:35:34 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:34726 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaBYJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:35:30 -0500
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
Date: Tue, 25 Feb 2014 01:35:23 -0800
In-Reply-To: <874n3n7czm.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 25 Feb 2014 01:33:49 -0800")
Message-ID: <87sir75yck.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/X1NtXjLnYXK7x7esjENqtCd9+jDMJ+sY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4956]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 02/12] vfs: More precise tests in d_invalidate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The current comments in d_invalidate about what and why it is doing
what it is doing are wildly off-base.  Which is not surprising as
the comments date back to last minute bug fix of the 2.2 kernel.

The big fat lie of a comment said: If it's a directory, we can't drop
it for fear of somebody re-populating it with children (even though
dropping it would make it unreachable from that root, we still might
repopulate it if it was a working directory or similar).

The truth is that for remote filesystems the failure of d_revalidate
and d_weak_revalidate prevents us from populating or otherwise
inappropriately using a directory.  For local filesystems and for
local directory removals the setting of S_DEAD prevents us from
populating or otherwise inappropriate using a directory.

The current rules are:
- To prevent mount point leaks dentries that are mount points or that
  have childrent that are mount points may not be be unhashed.
- All dentries may be unhashed.
- Directories may be rehashed with d_materialise_unique

check_submounts_and_drop implements this already for well maintained
remote filesystems so implement the current rules in d_invalidate
by just calling check_submounts_and_drop.

The one difference between d_invalidate and check_submounts_and_drop
is that d_invalidate must respect it when a d_revalidate method has
earlier called d_drop so preserve the d_unhashed check in
d_invalidate.

Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/dcache.c |   38 ++++----------------------------------
 1 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index c71c86f7780e..b0add629f5fe 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -613,9 +613,8 @@ EXPORT_SYMBOL(dput);
  * @dentry: dentry to invalidate
  *
  * Try to invalidate the dentry if it turns out to be
- * possible. If there are other dentries that can be
- * reached through this one we can't delete it and we
- * return -EBUSY. On success we return 0.
+ * possible. If there are reasons not to delete it
+ * return -EBUSY. On success return 0.
  *
  * no dcache lock.
  */
@@ -630,38 +629,9 @@ int d_invalidate(struct dentry * dentry)
 		spin_unlock(&dentry->d_lock);
 		return 0;
 	}
-	/*
-	 * Check whether to do a partial shrink_dcache
-	 * to get rid of unused child entries.
-	 */
-	if (!list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dentry->d_lock);
-		shrink_dcache_parent(dentry);
-		spin_lock(&dentry->d_lock);
-	}
-
-	/*
-	 * Somebody else still using it?
-	 *
-	 * If it's a directory, we can't drop it
-	 * for fear of somebody re-populating it
-	 * with children (even though dropping it
-	 * would make it unreachable from the root,
-	 * we might still populate it if it was a
-	 * working directory or similar).
-	 * We also need to leave mountpoints alone,
-	 * directory or not.
-	 */
-	if (dentry->d_lockref.count > 1 && dentry->d_inode) {
-		if (S_ISDIR(dentry->d_inode->i_mode) || d_mountpoint(dentry)) {
-			spin_unlock(&dentry->d_lock);
-			return -EBUSY;
-		}
-	}
-
-	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	return 0;
+
+	return check_submounts_and_drop(dentry);
 }
 EXPORT_SYMBOL(d_invalidate);
 
-- 
1.7.5.4

