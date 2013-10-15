Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab3JOUSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:18:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59833 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759706Ab3JOUSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:18:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthias Schniedermeyer <ms@citd.de>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87a9ioo37a.fsf_-_@xmission.com>
	<20131007043919.GB10284@mail.hallyn.com> <87vc191sf2.fsf@xmission.com>
	<CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
	<87d2ngyb02.fsf@xmission.com>
	<20131008160601.GJ14242@tucsk.piliscsaba.szeredi.hu>
	<CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
	<20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
	<87li23trll.fsf@tw-ebiederman.twitter.com>
	<CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
	<87vc15mjuw.fsf@xmission.com>
	<CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
	<87iox38fkv.fsf@xmission.com> <87d2nb8dxy.fsf@xmission.com>
	<87iowyxpci.fsf_-_@xmission.com>
Date: Tue, 15 Oct 2013 13:17:55 -0700
In-Reply-To: <87iowyxpci.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 15 Oct 2013 13:15:41 -0700")
Message-ID: <871u3mxp8s.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+lo7ZZcSe4F2uTc0F+qlM8uuR05IsVVZ0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4123]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 3/4] vfs: Add a function to lazily unmount all mounts from any dentry. v3
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2: Always drop the lock when exiting early.
v3: Make detach_mounts robust about freeing several
    mounts on the same mountpoint at one time, and remove
    the unneeded mnt_list list test.

Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>
---
 fs/mount.h     |    1 +
 fs/namespace.c |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index e4342b8dfab1..7a6a2bb3f290 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -79,6 +79,7 @@ static inline int is_mounted(struct vfsmount *mnt)
 }
 
 extern struct mount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
+extern void detach_mounts(struct dentry *dentry);
 
 static inline void get_mnt_ns(struct mnt_namespace *ns)
 {
diff --git a/fs/namespace.c b/fs/namespace.c
index e4fe22c23e00..78f7c5c9e673 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1295,6 +1295,30 @@ static int do_umount(struct mount *mnt, int flags)
 	return retval;
 }
 
+void detach_mounts(struct dentry *dentry)
+{
+	struct mountpoint *mp;
+	struct mount *mnt;
+
+	namespace_lock();
+	if (!d_mountpoint(dentry))
+		goto out_unlock;
+
+	mp = new_mountpoint(dentry);
+	if (IS_ERR(mp))
+		goto out_unlock;
+
+	br_write_lock(&vfsmount_lock);
+	while (!list_empty(&mp->m_list)) {
+		mnt = list_first_entry(&mp->m_list, struct mount, mnt_mp_list);
+		umount_tree(mnt, 1);
+	}
+	br_write_unlock(&vfsmount_lock);
+	put_mountpoint(mp);
+out_unlock:
+	namespace_unlock();
+}
+
 /* 
  * Is the caller allowed to modify his namespace?
  */
-- 
1.7.5.4

