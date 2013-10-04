Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3JDWnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:43:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54029 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3JDWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:43:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
Date: Fri, 04 Oct 2013 15:43:18 -0700
In-Reply-To: <87li281wx6.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Fri, 04 Oct 2013 15:41:25 -0700")
Message-ID: <87a9io1wu1.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+rkduCZfq0EV0UW01VC8NUdwM12yGJRp8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0006]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: [RFC][PATCH 2/3] vfs: Add a function to lazily unmount all mounts from any dentry.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
index d092964fe7f9..8eaee0c14fdb 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1294,6 +1294,30 @@ static int do_umount(struct mount *mnt, int flags)
 	return retval;
 }
 
+void detach_mounts(struct dentry *dentry)
+{
+	struct mount *mnt, *next;
+	struct mountpoint *mp;
+
+	namespace_lock();
+	if (!d_mountpoint(dentry)) {
+		namespace_unlock();
+		return;
+	}
+	mp = new_mountpoint(dentry);
+	if (IS_ERR(mp)) {
+		return;
+	}
+	br_write_lock(&vfsmount_lock);
+	list_for_each_entry_safe(mnt, next, &mp->m_list, mnt_mp_list) {
+		if (!list_empty(&mnt->mnt_list))
+			umount_tree(mnt, 1);
+	}
+	br_write_unlock(&vfsmount_lock);
+	put_mountpoint(mp);
+	namespace_unlock();
+}
+
 /* 
  * Is the caller allowed to modify his namespace?
  */
-- 
1.7.5.4

