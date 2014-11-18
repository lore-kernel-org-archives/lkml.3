Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaKRP3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:29:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbaKROJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:23 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Reyad Attiyat <reyad.attiyat@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 018/206] HID: usbhid: Use flag HID_DISCONNECTED when a usb device is removed
Date: Tue, 18 Nov 2014 15:06:13 +0100
Message-Id: <4c1e006db378eca8181f7e0dd90918c7b40e0f5b.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Reyad Attiyat <reyad.attiyat@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 46df9dedabc1541f9c45f94ecd2c3c7ab0c3bf23 upstream.

Set disconnected flag in struct usbhid when a usb device is removed. Check for
disconnected flag before sending urb requests. This prevents a kernel panic
when a hid driver calls hid_hw_request() after removing a usb device.

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
 IP: [<ffffffff8161746f>] hid_submit_ctrl+0x7f/0x290
 PGD 0
 Oops: 0002 [#1] PREEMPT SMP
 CPU: 2 PID: 39 Comm: khubd Tainted: G          IO  3.16.0-rc5+ #112
 Hardware name: Microsoft Corporation Surface Pro 2/Surface Pro 2, BIOS 2.03.0250 09/06/2013
 task: ffff880118aba6e0 ti: ffff8800daf80000 task.ti: ffff8800daf80000
 RIP: 0010:[<ffffffff8161746f>]  [<ffffffff8161746f>] hid_submit_ctrl+0x7f/0x290
 RSP: 0018:ffff8800daf83750  EFLAGS: 00010086
 RAX: 0000000080000300 RBX: ffff88003f60c000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff880117f78000
 RBP: ffff8800daf83788 R08: 0000000000000001 R09: 0000000000000001
 R10: 0000000000000001 R11: 0000000000000000 R12: ffff880117f78000
 R13: ffff88003f11a290 R14: 000000000000000c R15: ffff880091cb3ab8
 FS:  0000000000000000(0000) GS:ffff88011b000000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000058 CR3: 0000000001c11000 CR4: 00000000001407e0
 Stack:
  ffff880117f3dcd0 ffff880117f78000 ffff88003f60c000 ffff880117f78000
  ffff880117f78000 ffff88003f11a290 0000000000000000 ffff8800daf837b0
  ffffffff81617707 ffff880117f78000 ffff88003f60c000 0000000000000013
 Call Trace:
  [<ffffffff81617707>] usbhid_restart_ctrl_queue+0x87/0x140
  [<ffffffff81617a88>] usbhid_submit_report+0x2c8/0x370
  [<ffffffff81617b4a>] usbhid_request+0x1a/0x30
  [<ffffffffa020edfb>] sensor_hub_set_feature+0x8b/0xd0 [hid_sensor_hub]
  [<ffffffffa02d9084>] hid_sensor_power_state+0x84/0x110 [hid_sensor_trigger]
  [<ffffffffa02d9129>] hid_sensor_data_rdy_trigger_set_state+0x19/0x20 [hid_sensor_trigger]
  [<ffffffffa034d5b7>] iio_triggered_buffer_predisable+0xa7/0xb0 [industrialio]
  [<ffffffffa034cc4a>] iio_disable_all_buffers+0x3a/0xc0 [industrialio]
  [<ffffffffa03487d3>] iio_device_unregister+0x53/0x80 [industrialio]
  [<ffffffffa026c06a>] hid_accel_3d_remove+0x2a/0x50 [hid_sensor_accel_3d]
  [<ffffffff814f433d>] platform_drv_remove+0x1d/0x40
  [<ffffffff814f18bf>] __device_release_driver+0x7f/0xf0
  [<ffffffff814f1955>] device_release_driver+0x25/0x40
  [<ffffffff814f121c>] bus_remove_device+0x11c/0x1a0
  [<ffffffff814ed7d6>] device_del+0x136/0x1e0
  [<ffffffff81512190>] ? mfd_cell_disable+0x80/0x80
  [<ffffffff814f41d1>] platform_device_del+0x21/0xc0
  [<ffffffff814f4282>] platform_device_unregister+0x12/0x30
  [<ffffffff815121d3>] mfd_remove_devices_fn+0x43/0x50
  [<ffffffff814ed3e3>] device_for_each_child+0x43/0x70
  [<ffffffff81512105>] mfd_remove_devices+0x25/0x30
  [<ffffffffa020ebd7>] sensor_hub_remove+0x87/0x140 [hid_sensor_hub]
  [<ffffffff81607c5b>] hid_device_remove+0x6b/0xd0
  [<ffffffff814f18bf>] __device_release_driver+0x7f/0xf0
  [<ffffffff814f1955>] device_release_driver+0x25/0x40
  [<ffffffff814f121c>] bus_remove_device+0x11c/0x1a0
  [<ffffffff814ed7d6>] device_del+0x136/0x1e0
  [<ffffffff81607d47>] hid_destroy_device+0x27/0x60
  [<ffffffff81616972>] usbhid_disconnect+0x22/0x50
  [<ffffffff81568597>] usb_unbind_interface+0x77/0x2b0
  [<ffffffff814f18bf>] __device_release_driver+0x7f/0xf0
  [<ffffffff814f1955>] device_release_driver+0x25/0x40
  [<ffffffff814f121c>] bus_remove_device+0x11c/0x1a0
  [<ffffffff814ed7d6>] device_del+0x136/0x1e0
  [<ffffffff81565cd1>] usb_disable_device+0x91/0x2a0
  [<ffffffff8155b046>] usb_disconnect+0x96/0x2e0
  [<ffffffff8155d74a>] hub_thread+0xb5a/0x1840

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/usbhid/hid-core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 44df131d390a..63a2bb96e5cd 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -536,7 +536,8 @@ static void __usbhid_submit_report(struct hid_device *hid, struct hid_report *re
 	int head;
 	struct usbhid_device *usbhid = hid->driver_data;
 
-	if ((hid->quirks & HID_QUIRK_NOGET) && dir == USB_DIR_IN)
+	if (((hid->quirks & HID_QUIRK_NOGET) && dir == USB_DIR_IN) ||
+		test_bit(HID_DISCONNECTED, &usbhid->iofl))
 		return;
 
 	if (usbhid->urbout && dir == USB_DIR_OUT && report->type == HID_OUTPUT_REPORT) {
@@ -1338,6 +1339,9 @@ static void usbhid_disconnect(struct usb_interface *intf)
 		return;
 
 	usbhid = hid->driver_data;
+	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
+	set_bit(HID_DISCONNECTED, &usbhid->iofl);
+	spin_unlock_irq(&usbhid->lock);
 	hid_destroy_device(hid);
 	kfree(usbhid);
 }
-- 
2.1.3

