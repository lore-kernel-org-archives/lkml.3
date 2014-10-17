Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaJQNNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:13:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37861 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaJQNNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:13:11 -0400
From: Kumar Gala <galak@codeaurora.org>
To: gregkh@linuxfoundation.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] tty: serial: msm: Fix lock init issue with earlycon
Date: Fri, 17 Oct 2014 08:13:08 -0500
Message-Id: <1413551588-14877-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_DEBUG_SPINLOCK enabled we see:

BUG: spinlock bad magic on CPU#0, swapper/0
 lock: early_console_dev+0x8/0x160, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
CPU: 0 PID: 0 Comm: swapper Not tainted 3.17.0-09733-gb446b33-dirty #18
Call trace:
[<c0087ba0>] dump_backtrace+0x0/0x140
[<c0087cf0>] show_stack+0x10/0x1c
[<c0598be0>] dump_stack+0x74/0xb8
[<c00cb720>] spin_dump+0x78/0x88
[<c00cb754>] spin_bug+0x24/0x34
[<c00cb7e4>] do_raw_spin_lock+0x30/0x158
[<c059ea2c>] _raw_spin_lock+0x1c/0x2c
[<c02e0e30>] __msm_console_write+0x68/0x154
[<c02e0f50>] msm_serial_early_write_dm+0x14/0x20
[<c00cf040>] call_console_drivers.constprop.23+0xa4/0xc4
[<c00d00c4>] console_unlock+0x2a8/0x330
[<c00d121c>] register_console+0x26c/0x338
[<c0805af4>] setup_earlycon+0x2c0/0x300
[<c0805c48>] msm_serial_dm_setup_earlycon+0x18/0x24
[<c07ed158>] do_early_param+0x84/0xd0
[<c00aec18>] parse_args+0x2b4/0x3ec
[<c07ed588>] parse_early_options+0x2c/0x38
[<c07ed5c8>] parse_early_param+0x34/0x50
[<c07f03c0>] setup_arch+0x290/0x604
[<c07ed67c>] start_kernel+0x94/0x38c

As the earlycon write function for msm requires a lock, we need to init
it as part of the setup call.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 4b6c783..8ab27c9 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -973,6 +973,8 @@ msm_serial_early_console_setup(struct earlycon_device *device, const char *opt)
 	if (!device->port.membase)
 		return -ENODEV;
 
+	spin_lock_init(&device->port.lock);
+
 	device->con->write = msm_serial_early_write;
 	return 0;
 }
@@ -995,6 +997,8 @@ msm_serial_early_console_setup_dm(struct earlycon_device *device,
 	if (!device->port.membase)
 		return -ENODEV;
 
+	spin_lock_init(&device->port.lock);
+
 	device->con->write = msm_serial_early_write_dm;
 	return 0;
 }
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

