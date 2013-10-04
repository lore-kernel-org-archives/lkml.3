Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3JDWmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:42:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53870 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3JDWmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:42:50 -0400
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
Date: Fri, 04 Oct 2013 15:42:37 -0700
In-Reply-To: <87li281wx6.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Fri, 04 Oct 2013 15:41:25 -0700")
Message-ID: <87fvsg1wv6.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19N+RokjWusl+aV9wGm/1kJqFNBLBm49m4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0603]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: **;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: [RFC][PATCH 1/3] vfs: Keep a list of mounts on a mount point
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>
---
 fs/mount.h     |    2 ++
 fs/namespace.c |    5 +++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index 64a858143ff9..e4342b8dfab1 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -21,6 +21,7 @@ struct mnt_pcp {
 struct mountpoint {
 	struct list_head m_hash;
 	struct dentry *m_dentry;
+	struct list_head m_list;
 	int m_count;
 };
 
@@ -47,6 +48,7 @@ struct mount {
 	struct mount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	struct mountpoint *mnt_mp;	/* where is it mounted */
+	struct list_head mnt_mp_list;	/* list mounts with the same mountpoint */
 #ifdef CONFIG_FSNOTIFY
 	struct hlist_head mnt_fsnotify_marks;
 	__u32 mnt_fsnotify_mask;
diff --git a/fs/namespace.c b/fs/namespace.c
index da5c49483430..d092964fe7f9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -197,6 +197,7 @@ static struct mount *alloc_vfsmnt(const char *name)
 		INIT_LIST_HEAD(&mnt->mnt_share);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
+		INIT_LIST_HEAD(&mnt->mnt_mp_list);
 #ifdef CONFIG_FSNOTIFY
 		INIT_HLIST_HEAD(&mnt->mnt_fsnotify_marks);
 #endif
@@ -636,6 +637,7 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
 	mp->m_dentry = dentry;
 	mp->m_count = 1;
 	list_add(&mp->m_hash, chain);
+	INIT_LIST_HEAD(&mp->m_list);
 	return mp;
 }
 
@@ -691,6 +693,7 @@ static void detach_mnt(struct mount *mnt, struct path *old_path)
 	list_del_init(&mnt->mnt_hash);
 	put_mountpoint(mnt->mnt_mp);
 	mnt->mnt_mp = NULL;
+	list_del_init(&mnt->mnt_mp_list);
 }
 
 /*
@@ -705,6 +708,7 @@ void mnt_set_mountpoint(struct mount *mnt,
 	child_mnt->mnt_mountpoint = dget(mp->m_dentry);
 	child_mnt->mnt_parent = mnt;
 	child_mnt->mnt_mp = mp;
+	list_add_tail(&child_mnt->mnt_mp_list, &mp->m_list);
 }
 
 /*
@@ -1193,6 +1197,7 @@ void umount_tree(struct mount *mnt, int propagate)
 			p->mnt_parent->mnt_ghosts++;
 			put_mountpoint(p->mnt_mp);
 			p->mnt_mp = NULL;
+			list_del_init(&mnt->mnt_mp_list);
 		}
 		change_mnt_propagation(p, MS_PRIVATE);
 	}
-- 
1.7.5.4

