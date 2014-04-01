Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaDAEPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:15:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaDAEPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:15:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.13 18/22] dont bother with propagate_mnt() unless the target is shared
Date: Mon, 31 Mar 2014 21:08:48 -0700
Message-Id: <20140401040707.692779002@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040703.045139933@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 0b1b901b5a98bb36943d10820efc796f7cd45ff3 upstream.

If the dest_mnt is not shared, propagate_mnt() does nothing -
there's no mounts to propagate to and thus no copies to create.
Might as well don't bother calling it in that case.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namespace.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1653,16 +1653,14 @@ static int attach_recursive_mnt(struct m
 		err = invent_group_ids(source_mnt, true);
 		if (err)
 			goto out;
-	}
-	err = propagate_mnt(dest_mnt, dest_mp, source_mnt, &tree_list);
-	if (err)
-		goto out_cleanup_ids;
-
-	lock_mount_hash();
-
-	if (IS_MNT_SHARED(dest_mnt)) {
+		err = propagate_mnt(dest_mnt, dest_mp, source_mnt, &tree_list);
+		if (err)
+			goto out_cleanup_ids;
+		lock_mount_hash();
 		for (p = source_mnt; p; p = next_mnt(p, source_mnt))
 			set_mnt_shared(p);
+	} else {
+		lock_mount_hash();
 	}
 	if (parent_path) {
 		detach_mnt(source_mnt, parent_path);
@@ -1685,8 +1683,7 @@ static int attach_recursive_mnt(struct m
 	return 0;
 
  out_cleanup_ids:
-	if (IS_MNT_SHARED(dest_mnt))
-		cleanup_group_ids(source_mnt, NULL);
+	cleanup_group_ids(source_mnt, NULL);
  out:
 	return err;
 }


