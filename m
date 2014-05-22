Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaEVUnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:43:09 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42134 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaEVUmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:42:54 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: btrfs: volumes.c:  Fix for possible null pointer dereference
Date: Thu, 22 May 2014 22:43:43 +0200
Message-Id: <1400791423-11935-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/btrfs/volumes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 49d7fab..d85a225 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1674,11 +1674,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		struct btrfs_fs_devices *fs_devices;
 		fs_devices = root->fs_info->fs_devices;
 		while (fs_devices) {
-			if (fs_devices->seed == cur_devices)
+			if (fs_devices->seed == cur_devices) {
+				fs_devices->seed = cur_devices->seed;
 				break;
+			}
 			fs_devices = fs_devices->seed;
 		}
-		fs_devices->seed = cur_devices->seed;
 		cur_devices->seed = NULL;
 		lock_chunks(root);
 		__btrfs_close_devices(cur_devices);
-- 
1.7.10.4

