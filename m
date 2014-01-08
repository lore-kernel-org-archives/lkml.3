Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbaAHGWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:22:42 -0500
Received: from mail.windriver.com ([147.11.1.11]:48942 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbaAHGWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:22:33 -0500
From: "wenlin.kang" <wenlin.kang@windriver.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] usb/gadget: fix printer deadlock
Date: Wed, 8 Jan 2014 14:22:11 +0800
Message-ID: <1389162132-17857-1-git-send-email-wenlin.kang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "wenlin.kang" <wenlin.kang@windriver.com>

The problem occurs in follow path.

printer_read()
	|
	+---setup_rx_reqs()
		|
		+---usb_ep_queue()
			|
			+---...
				|
				+---rx_complete()

Although it is clear from code, we can't get it normally.
only when we enable some spin_lock debug config option, we can find it.
eg:
BUG: spinlock lockup on CPU#0, g_printer_test_/584
 lock: bf05e158, .magic: dead4ead, .owner: g_printer_test_/584, .owner_cpu: 0
[<c0016e1c>] (unwind_backtrace+0x0/0x104) from [<c067aef8>] (dump_stack+0x20/0x24)
[<c067aef8>] (dump_stack+0x20/0x24) from [<c0680bec>] (spin_dump+0x8c/0x94)
[<c0680bec>] (spin_dump+0x8c/0x94) from [<c039071c>] (do_raw_spin_lock+0x128/0x154)
[<c039071c>] (do_raw_spin_lock+0x128/0x154) from [<c0685618>] (_raw_spin_lock_irqsave+0x64/0x70)
[<c0685618>] (_raw_spin_lock_irqsave+0x64/0x70) from [<bf05b4e8>] (rx_complete+0x54/0x10c [g_printer])
[<bf05b4e8>] (rx_complete+0x54/0x10c [g_printer]) from [<c0480478>] (musb_g_giveback+0x78/0x88)
[<c0480478>] (musb_g_giveback+0x78/0x88) from [<c048060c>] (rxstate+0xa0/0x10c)
[<c048060c>] (rxstate+0xa0/0x10c) from [<c0480d50>] (musb_ep_restart+0x44/0x70)
[<c0480d50>] (musb_ep_restart+0x44/0x70) from [<c0480fe4>] (musb_gadget_queue+0xe8/0xf8)
[<c0480fe4>] (musb_gadget_queue+0xe8/0xf8) from [<bf05b2b0>] (setup_rx_reqs+0xa4/0x178 [g_printer])
[<bf05b2b0>] (setup_rx_reqs+0xa4/0x178 [g_printer]) from [<bf05bb58>] (printer_read+0x9c/0x3f4 [g_printer])
[<bf05bb58>] (printer_read+0x9c/0x3f4 [g_printer]) from [<c01387f0>] (vfs_read+0xb4/0x144)
[<c01387f0>] (vfs_read+0xb4/0x144) from [<c01388d0>] (sys_read+0x50/0x124)
[<c01388d0>] (sys_read+0x50/0x124) from [<c000e900>] (ret_fast_syscall+0x0/0x3c)

The root cause is that we use the same lock two time in a path, so to avoid
the deadlock, we need to unlock in setup_rx_reqs(), and only unlock.

Signed-off-by: wenlin.kang <wenlin.kang@windriver.com>
---
 drivers/usb/gadget/printer.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 4e4dc1f..f4b4fa8 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -526,7 +526,10 @@ setup_rx_reqs(struct printer_dev *dev)
 		req->length = USB_BUFSIZE;
 		req->complete = rx_complete;
 
+		/* here, we unlock, and only unlock, to avoid deadlock. */
+		spin_unlock(&dev->lock);
 		error = usb_ep_queue(dev->out_ep, req, GFP_ATOMIC);
+		spin_lock(&dev->lock);
 		if (error) {
 			DBG(dev, "rx submit --> %d\n", error);
 			list_add(&req->list, &dev->rx_reqs);
-- 
1.7.9.5

