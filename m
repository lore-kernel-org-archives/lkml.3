Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab3DBXO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:14:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab3DBWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        fanchaoting <fanchaoting@cn.fujitsu.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 036/124] pnfs-block: removing DM device maybe cause oops when call dev_remove
Date: Tue,  2 Apr 2013 15:10:18 -0700
Message-Id: <20130402221108.363473499@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/blocklayout/blocklayoutdm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/blocklayout/blocklayoutdm.c
+++ b/fs/nfs/blocklayout/blocklayoutdm.c
@@ -55,7 +55,8 @@ static void dev_remove(struct net *net,
 
 	bl_pipe_msg.bl_wq = &nn->bl_wq;
 	memset(msg, 0, sizeof(*msg));
-	msg->data = kzalloc(1 + sizeof(bl_umount_request), GFP_NOFS);
+	msg->len = sizeof(bl_msg) + bl_msg.totallen;
+	msg->data = kzalloc(msg->len, GFP_NOFS);
 	if (!msg->data)
 		goto out;
 
@@ -66,7 +67,6 @@ static void dev_remove(struct net *net,
 	memcpy(msg->data, &bl_msg, sizeof(bl_msg));
 	dataptr = (uint8_t *) msg->data;
 	memcpy(&dataptr[sizeof(bl_msg)], &bl_umount_request, sizeof(bl_umount_request));
-	msg->len = sizeof(bl_msg) + bl_msg.totallen;
 
 	add_wait_queue(&nn->bl_wq, &wq);
 	if (rpc_queue_upcall(nn->bl_device_pipe, msg) < 0) {


