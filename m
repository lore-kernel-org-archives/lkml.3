Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422661Ab3DKVFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:05:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935731Ab3DKUtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:16 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=kXhdACzluyoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Jw3m3LiMyfoA:10 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=JDjsHSkAAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=Hf6muOzgCGQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202602.651696131@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: fanchaoting <fanchaoting@cn.fujitsu.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 101/171 ] pnfs-block: removing DM device maybe cause oops when call dev_remove
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0101-pnfs-block-removing-DM-device-maybe-cause-oops-when-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: fanchaoting <fanchaoting@cn.fujitsu.com>

[ Upstream commit 4376c94618c26225e69e17b7c91169c45a90b292 ]

when pnfs block using device mapper,if umounting later,it maybe
cause oops. we apply "1 + sizeof(bl_umount_request)" memory for
msg->data, the memory maybe overflow when we do "memcpy(&dataptr
[sizeof(bl_msg)], &bl_umount_request, sizeof(bl_umount_request))",
because the size of bl_msg is more than 1 byte.

Signed-off-by: fanchaoting<fanchaoting@cn.fujitsu.com>
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfs/blocklayout/blocklayoutdm.c |    4 ++--
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
1.7.10.4


