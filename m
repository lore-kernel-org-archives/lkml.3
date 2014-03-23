Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaCWQ4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 12:56:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57208 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaCWQ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 12:56:31 -0400
Date: Sun, 23 Mar 2014 16:56:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs fixes
Message-ID: <20140323165629.GK18016@ZenIV.linux.org.uk>
References: <20140323071601.GH18016@ZenIV.linux.org.uk>
 <CA+icZUU=VzD+LM6i9VK6HuJooOj+yKHtJR+MOjaXjs68MGcRPQ@mail.gmail.com>
 <20140323153505.GI18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323153505.GI18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 03:35:05PM +0000, Al Viro wrote:
> On Sun, Mar 23, 2014 at 11:57:16AM +0100, Sedat Dilek wrote:
> 
> > Your branch on top of Linux v3.14-rc7-66-g774868c7094d is freezing my
> > Ubuntu/precise AMD64 (WUBI) system when running LTP.
> 
> Which test?

Argh...  I see what's going on; could you check if the following fixes all
the problems you are seeing?

diff --git a/fs/namespace.c b/fs/namespace.c
index d6e6daf..2ffc5a2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -746,7 +746,7 @@ static void detach_mnt(struct mount *mnt, struct path *old_path)
 	mnt->mnt_parent = mnt;
 	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 	list_del_init(&mnt->mnt_child);
-	hlist_del_rcu(&mnt->mnt_hash);
+	hlist_del_init_rcu(&mnt->mnt_hash);
 	put_mountpoint(mnt->mnt_mp);
 	mnt->mnt_mp = NULL;
 }
@@ -1236,7 +1236,7 @@ void umount_tree(struct mount *mnt, int how)
 	struct mount *last = NULL;
 
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
-		hlist_del_rcu(&p->mnt_hash);
+		hlist_del_init_rcu(&p->mnt_hash);
 		hlist_add_head(&p->mnt_hash, &tmp_list);
 	}
 
diff --git a/fs/pnode.c b/fs/pnode.c
index 72aa2b7..88396df 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -341,7 +341,7 @@ static void __propagate_umount(struct mount *mnt)
 		 * other children
 		 */
 		if (child && list_empty(&child->mnt_mounts)) {
-			hlist_del_rcu(&child->mnt_hash);
+			hlist_del_init_rcu(&child->mnt_hash);
 			hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
 		}
 	}
