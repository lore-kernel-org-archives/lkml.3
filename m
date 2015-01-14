Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbbANHbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:31:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbbANHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:31:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.18 135/150] Btrfs: dont delay inode ref updates during log replay
Date: Tue, 13 Jan 2015 23:23:26 -0800
Message-Id: <20150114072101.962065526@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 6f8960541b1eb6054a642da48daae2320fddba93 upstream.

Commit 1d52c78afbb (Btrfs: try not to ENOSPC on log replay) added a
check to skip delayed inode updates during log replay because it
confuses the enospc code.  But the delayed processing will end up
ignoring delayed refs from log replay because the inode itself wasn't
put through the delayed code.

This can end up triggering a warning at commit time:

WARNING: CPU: 2 PID: 778 at fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empty+0x32/0x34()

Which is repeated for each commit because we never process the delayed
inode ref update.

The fix used here is to change btrfs_delayed_delete_inode_ref to return
an error if we're currently in log replay.  The caller will do the ref
deletion immediately and everything will work properly.

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/delayed-inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1857,6 +1857,14 @@ int btrfs_delayed_delete_inode_ref(struc
 {
 	struct btrfs_delayed_node *delayed_node;
 
+	/*
+	 * we don't do delayed inode updates during log recovery because it
+	 * leads to enospc problems.  This means we also can't do
+	 * delayed inode refs
+	 */
+	if (BTRFS_I(inode)->root->fs_info->log_root_recovering)
+		return -EAGAIN;
+
 	delayed_node = btrfs_get_or_create_delayed_node(inode);
 	if (IS_ERR(delayed_node))
 		return PTR_ERR(delayed_node);


