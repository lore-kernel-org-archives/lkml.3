Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaIOT32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:29:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaIOT3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:29:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.16 124/158] fix copy_tree() regression
Date: Mon, 15 Sep 2014 12:26:03 -0700
Message-Id: <20140915192546.608235877@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 12a5b5294cb1896e9a3c9fca8ff5a7e3def4e8c6 upstream.

Since 3.14 we had copy_tree() get the shadowing wrong - if we had one
vfsmount shadowing another (i.e. if A is a slave of B, C is mounted
on A/foo, then D got mounted on B/foo creating D' on A/foo shadowed
by C), copy_tree() of A would make a copy of D' shadow the the copy of
C, not the other way around.

It's easy to fix, fortunately - just make sure that mount follows
the one that shadows it in mnt_child as well as in mnt_hash, and when
copy_tree() decides to attach a new mount, check if the last child
it has added to the same parent should be shadowing the new one.
And if it should, just use the same logics commit_tree() has - put the
new mount into the hash and children lists right after the one that
should shadow it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -779,6 +779,20 @@ static void attach_mnt(struct mount *mnt
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
 }
 
+static void attach_shadowed(struct mount *mnt,
+			struct mount *parent,
+			struct mount *shadows)
+{
+	if (shadows) {
+		hlist_add_after_rcu(&shadows->mnt_hash, &mnt->mnt_hash);
+		list_add(&mnt->mnt_child, &shadows->mnt_child);
+	} else {
+		hlist_add_head_rcu(&mnt->mnt_hash,
+				m_hash(&parent->mnt, mnt->mnt_mountpoint));
+		list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
+	}
+}
+
 /*
  * vfsmount lock must be held for write
  */
@@ -797,12 +811,7 @@ static void commit_tree(struct mount *mn
 
 	list_splice(&head, n->list.prev);
 
-	if (shadows)
-		hlist_add_after_rcu(&shadows->mnt_hash, &mnt->mnt_hash);
-	else
-		hlist_add_head_rcu(&mnt->mnt_hash,
-				m_hash(&parent->mnt, mnt->mnt_mountpoint));
-	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
+	attach_shadowed(mnt, parent, shadows);
 	touch_mnt_namespace(n);
 }
 
@@ -1513,6 +1522,7 @@ struct mount *copy_tree(struct mount *mn
 			continue;
 
 		for (s = r; s; s = next_mnt(s, r)) {
+			struct mount *t = NULL;
 			if (!(flag & CL_COPY_UNBINDABLE) &&
 			    IS_MNT_UNBINDABLE(s)) {
 				s = skip_mnt_tree(s);
@@ -1534,7 +1544,14 @@ struct mount *copy_tree(struct mount *mn
 				goto out;
 			lock_mount_hash();
 			list_add_tail(&q->mnt_list, &res->mnt_list);
-			attach_mnt(q, parent, p->mnt_mp);
+			mnt_set_mountpoint(parent, p->mnt_mp, q);
+			if (!list_empty(&parent->mnt_mounts)) {
+				t = list_last_entry(&parent->mnt_mounts,
+					struct mount, mnt_child);
+				if (t->mnt_mp != p->mnt_mp)
+					t = NULL;
+			}
+			attach_shadowed(q, parent, t);
 			unlock_mount_hash();
 		}
 	}


