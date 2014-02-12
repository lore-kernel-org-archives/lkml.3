Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaBLP2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:28:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:12332 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbaBLP23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:28:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,832,1384329600"; 
   d="scan'208";a="454243062"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, "chao.bi" <chao.bi@intel.com>,
        stable <stable@vger.kernel.org>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc] mei: set client's read_cb to NULL when flow control fails
Date: Wed, 12 Feb 2014 17:27:08 +0200
Message-Id: <1392218828-23208-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "chao.bi" <chao.bi@intel.com>

In mei_cl_read_start(), if it fails to send flow control request, it
will release "cl->read_cb" but forget to set pointer to NULL, leaving
"cl->read_cb" still pointing to random memory, next time this client is
operated like mei_release(), it has chance to refer to this wrong pointer.

Fixes:  PANIC at kfree in mei_release()

[228781.826904] Call Trace:
[228781.829737]  [<c16249b8>] ? mei_cl_unlink+0x48/0xa0
[228781.835283]  [<c1624487>] mei_io_cb_free+0x17/0x30
[228781.840733]  [<c16265d8>] mei_release+0xa8/0x180
[228781.845989]  [<c135c610>] ? __fsnotify_parent+0xa0/0xf0
[228781.851925]  [<c1325a69>] __fput+0xd9/0x200
[228781.856696]  [<c1325b9d>] ____fput+0xd/0x10
[228781.861467]  [<c125cae1>] task_work_run+0x81/0xb0
[228781.866821]  [<c1242e53>] do_exit+0x283/0xa00
[228781.871786]  [<c1a82b36>] ? kprobe_flush_task+0x66/0xc0
[228781.877722]  [<c124eeb8>] ? __dequeue_signal+0x18/0x1a0
[228781.883657]  [<c124f072>] ? dequeue_signal+0x32/0x190
[228781.889397]  [<c1243744>] do_group_exit+0x34/0xa0
[228781.894750]  [<c12517b6>] get_signal_to_deliver+0x206/0x610
[228781.901075]  [<c12018d8>] do_signal+0x38/0x100
[228781.906136]  [<c1626d1c>] ? mei_read+0x42c/0x4e0
[228781.911393]  [<c12600a0>] ? wake_up_bit+0x30/0x30
[228781.916745]  [<c16268f0>] ? mei_poll+0x120/0x120
[228781.922001]  [<c1324be9>] ? vfs_read+0x89/0x160
[228781.927158]  [<c16268f0>] ? mei_poll+0x120/0x120
[228781.932414]  [<c133ca34>] ? fget_light+0x44/0xe0
[228781.937670]  [<c1324e58>] ? SyS_read+0x68/0x80
[228781.942730]  [<c12019f5>] do_notify_resume+0x55/0x70
[228781.948376]  [<c1a7de5d>] work_notifysig+0x29/0x30
[228781.953827]  [<c1a70000>] ? bad_area+0x5/0x3e

Cc: stable <stable@vger.kernel.org> # 3.9+
Signed-off-by: Chao Bi <chao.bi@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 9b809cf..89a5579 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -666,7 +666,6 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 		goto err;
 
 	cb->fop_type = MEI_FOP_READ;
-	cl->read_cb = cb;
 	if (dev->hbuf_is_ready) {
 		dev->hbuf_is_ready = false;
 		if (mei_hbm_cl_flow_control_req(dev, cl)) {
@@ -678,6 +677,9 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 	} else {
 		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
 	}
+
+	cl->read_cb = cb;
+
 	return rets;
 err:
 	mei_io_cb_free(cb);
-- 
1.8.5.3

