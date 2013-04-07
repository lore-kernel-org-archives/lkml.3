Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028Ab3DGXdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:33:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46861 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934983Ab3DGXdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:33:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "fanchaoting" <fanchaoting@cn.fujitsu.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.457631868@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [23/74] pnfs-block: removing DM device maybe cause oops when call
 dev_remove
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - In dev_remove(), msg is a structure not a pointer to it]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/blocklayout/blocklayoutdm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/blocklayout/blocklayoutdm.c
+++ b/fs/nfs/blocklayout/blocklayoutdm.c
@@ -52,7 +52,8 @@ static void dev_remove(dev_t dev)
 	dprintk("Entering %s\n", __func__);
 
 	memset(&msg, 0, sizeof(msg));
-	msg.data = kzalloc(1 + sizeof(bl_umount_request), GFP_NOFS);
+	msg.len = sizeof(bl_msg) + bl_msg.totallen;
+	msg.data = kzalloc(msg.len, GFP_NOFS);
 	if (!msg.data)
 		goto out;
 
@@ -63,7 +64,6 @@ static void dev_remove(dev_t dev)
 	memcpy(msg.data, &bl_msg, sizeof(bl_msg));
 	dataptr = (uint8_t *) msg.data;
 	memcpy(&dataptr[sizeof(bl_msg)], &bl_umount_request, sizeof(bl_umount_request));
-	msg.len = sizeof(bl_msg) + bl_msg.totallen;
 
 	add_wait_queue(&bl_wq, &wq);
 	if (rpc_queue_upcall(bl_device_pipe->d_inode, &msg) < 0) {

