Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaBOVkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 16:40:37 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54413 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBOVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 16:40:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
Date: Sat, 15 Feb 2014 13:40:26 -0800
In-Reply-To: <87ob28kqks.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sat, 15 Feb 2014 13:34:43 -0800")
Message-ID: <8738jkjbqt.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+0FN9U9nkfsbHg/5SfRCPiQCG6JJ7TmJM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4213]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 10/11] vfs: Remove d_drop calls from d_revalidate implementations
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that d_invalidate always succeeds it is not longer necessary or
desirable to hard code d_drop calls into filesystem specific
d_revalidate implementations.

Remove the unnecessary d_drop calls and rely on d_invalidate
to drop the dentries.  Using d_invalidate ensures that paths
to mount points will not be dropped.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/ceph/dir.c  |    1 -
 fs/proc/base.c |    4 ----
 fs/proc/fd.c   |    2 --
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 6da4df84ba30..ecd2402739e2 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1052,7 +1052,6 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 		ceph_dentry_lru_touch(dentry);
 	} else {
 		ceph_dir_clear_complete(dir);
-		d_drop(dentry);
 	}
 	iput(dir);
 	return valid;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 51507065263b..aa62b37f1303 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1654,7 +1654,6 @@ int pid_revalidate(struct dentry *dentry, unsigned int flags)
 		put_task_struct(task);
 		return 1;
 	}
-	d_drop(dentry);
 	return 0;
 }
 
@@ -1791,9 +1790,6 @@ out:
 	put_task_struct(task);
 
 out_notask:
-	if (status <= 0)
-		d_drop(dentry);
-
 	return status;
 }
 
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 985ea881b5bc..7e4f04ccab31 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -127,8 +127,6 @@ static int tid_fd_revalidate(struct dentry *dentry, unsigned int flags)
 		}
 		put_task_struct(task);
 	}
-
-	d_drop(dentry);
 	return 0;
 }
 
-- 
1.7.5.4

