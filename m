Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbbA2GIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:08:05 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64565 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbbA2GID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:08:03 -0500
Date: Thu, 29 Jan 2015 11:37:43 +0530
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] afs: Prevent callback expiry timer overflow
Message-ID: <20150129060743.GA3478@tinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_seconds() returns real wall-clock seconds. On 32-bit systems
this value will overflow in year 2038 and beyond. This patch changes
afs_vnode record to use ktime_get_real_seconds() instead, for the
fields cb_expires and cb_expires_at.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
 fs/afs/fsclient.c | 2 +-
 fs/afs/inode.c    | 7 ++++---
 fs/afs/internal.h | 4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index c2e930e..c775fef 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -139,7 +139,7 @@ static void xdr_decode_AFSCallBack(const __be32 **_bp, struct afs_vnode *vnode)
 	vnode->cb_version	= ntohl(*bp++);
 	vnode->cb_expiry	= ntohl(*bp++);
 	vnode->cb_type		= ntohl(*bp++);
-	vnode->cb_expires	= vnode->cb_expiry + get_seconds();
+	vnode->cb_expires	= vnode->cb_expiry + ktime_get_real_seconds();
 	*_bp = bp;
 }
 
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 8a1d38e..6f04ede 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -244,12 +244,13 @@ struct inode *afs_iget(struct super_block *sb, struct key *key,
 			vnode->cb_version = 0;
 			vnode->cb_expiry = 0;
 			vnode->cb_type = 0;
-			vnode->cb_expires = get_seconds();
+			vnode->cb_expires = ktime_get_real_seconds();
 		} else {
 			vnode->cb_version = cb->version;
 			vnode->cb_expiry = cb->expiry;
 			vnode->cb_type = cb->type;
-			vnode->cb_expires = vnode->cb_expiry + get_seconds();
+			vnode->cb_expires = vnode->cb_expiry +
+				ktime_get_real_seconds();
 		}
 	}
 
@@ -322,7 +323,7 @@ int afs_validate(struct afs_vnode *vnode, struct key *key)
 	    !test_bit(AFS_VNODE_CB_BROKEN, &vnode->flags) &&
 	    !test_bit(AFS_VNODE_MODIFIED, &vnode->flags) &&
 	    !test_bit(AFS_VNODE_ZAP_DATA, &vnode->flags)) {
-		if (vnode->cb_expires < get_seconds() + 10) {
+		if (vnode->cb_expires < ktime_get_real_seconds() + 10) {
 			_debug("callback expired");
 			set_bit(AFS_VNODE_CB_BROKEN, &vnode->flags);
 		} else {
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 63c97e2..36e5f05 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -375,8 +375,8 @@ struct afs_vnode {
 	struct rb_node		server_rb;	/* link in server->fs_vnodes */
 	struct rb_node		cb_promise;	/* link in server->cb_promises */
 	struct work_struct	cb_broken_work;	/* work to be done on callback break */
-	time_t			cb_expires;	/* time at which callback expires */
-	time_t			cb_expires_at;	/* time used to order cb_promise */
+	time64_t		cb_expires;	/* time at which callback expires */
+	time64_t		cb_expires_at;	/* time used to order cb_promise */
 	unsigned		cb_version;	/* callback version */
 	unsigned		cb_expiry;	/* callback expiry time */
 	afs_callback_type_t	cb_type;	/* type of callback */
-- 
2.2.0.rc0.207.ga3a616c

