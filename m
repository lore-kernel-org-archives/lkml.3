Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936653Ab3DHKX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:23:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42635 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935425Ab3DHJvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: fanchaoting <fanchaoting@cn.fujitsu.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 009/102] pnfs-block: removing DM device maybe cause oops when call dev_remove
Date: Mon,  8 Apr 2013 10:49:24 +0100
Message-Id: <1365414657-29191-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: fanchaoting <fanchaoting@cn.fujitsu.com>

commit 4376c94618c26225e69e17b7c91169c45a90b292 upstream.

when pnfs block using device mapper,if umounting later,it maybe
cause oops. we apply "1 + sizeof(bl_umount_request)" memory for
msg->data, the memory maybe overflow when we do "memcpy(&dataptr
[sizeof(bl_msg)], &bl_umount_request, sizeof(bl_umount_request))",
because the size of bl_msg is more than 1 byte.

Signed-off-by: fanchaoting<fanchaoting@cn.fujitsu.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/blocklayout/blocklayoutdm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayoutdm.c b/fs/nfs/blocklayout/blocklayoutdm.c
index 737d839..6fc7b5c 100644
--- a/fs/nfs/blocklayout/blocklayoutdm.c
+++ b/fs/nfs/blocklayout/blocklayoutdm.c
@@ -55,7 +55,8 @@ static void dev_remove(struct net *net, dev_t dev)
 
 	bl_pipe_msg.bl_wq = &nn->bl_wq;
 	memset(msg, 0, sizeof(*msg));
-	msg->data = kzalloc(1 + sizeof(bl_umount_request), GFP_NOFS);
+	msg->len = sizeof(bl_msg) + bl_msg.totallen;
+	msg->data = kzalloc(msg->len, GFP_NOFS);
 	if (!msg->data)
 		goto out;
 
@@ -66,7 +67,6 @@ static void dev_remove(struct net *net, dev_t dev)
 	memcpy(msg->data, &bl_msg, sizeof(bl_msg));
 	dataptr = (uint8_t *) msg->data;
 	memcpy(&dataptr[sizeof(bl_msg)], &bl_umount_request, sizeof(bl_umount_request));
-	msg->len = sizeof(bl_msg) + bl_msg.totallen;
 
 	add_wait_queue(&nn->bl_wq, &wq);
 	if (rpc_queue_upcall(nn->bl_device_pipe, msg) < 0) {
-- 
1.8.1.2

