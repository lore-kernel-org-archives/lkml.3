Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaKYKk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58028 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaKYKkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 016/254] usb: Do not allow usb_alloc_streams on unconfigured devices
Date: Tue, 25 Nov 2014 10:36:06 +0000
Message-Id: <1416912004-5928-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 90a646c770c50cc206ceba0d7b50453c46c13c36 upstream.

This commit fixes the following oops:

[10238.622067] scsi host3: uas_eh_bus_reset_handler start
[10240.766164] usb 3-4: reset SuperSpeed USB device number 3 using xhci_hcd
[10245.779365] usb 3-4: device descriptor read/8, error -110
[10245.883331] usb 3-4: reset SuperSpeed USB device number 3 using xhci_hcd
[10250.897603] usb 3-4: device descriptor read/8, error -110
[10251.058200] BUG: unable to handle kernel NULL pointer dereference at  0000000000000040
[10251.058244] IP: [<ffffffff815ac6e1>] xhci_check_streams_endpoint+0x91/0x140
<snip>
[10251.059473] Call Trace:
[10251.059487]  [<ffffffff815aca6c>] xhci_calculate_streams_and_bitmask+0xbc/0x130
[10251.059520]  [<ffffffff815aeb5f>] xhci_alloc_streams+0x10f/0x5a0
[10251.059548]  [<ffffffff810a4685>] ? check_preempt_curr+0x75/0xa0
[10251.059575]  [<ffffffff810a46dc>] ? ttwu_do_wakeup+0x2c/0x100
[10251.059601]  [<ffffffff810a49e6>] ? ttwu_do_activate.constprop.111+0x66/0x70
[10251.059635]  [<ffffffff815779ab>] usb_alloc_streams+0xab/0xf0
[10251.059662]  [<ffffffffc0616b48>] uas_configure_endpoints+0x128/0x150 [uas]
[10251.059694]  [<ffffffffc0616bac>] uas_post_reset+0x3c/0xb0 [uas]
[10251.059722]  [<ffffffff815727d9>] usb_reset_device+0x1b9/0x2a0
[10251.059749]  [<ffffffffc0616f42>] uas_eh_bus_reset_handler+0xb2/0x190 [uas]
[10251.059781]  [<ffffffff81514293>] scsi_try_bus_reset+0x53/0x110
[10251.059808]  [<ffffffff815163b7>] scsi_eh_bus_reset+0xf7/0x270
<snip>

The problem is the following call sequence (simplified):

1) usb_reset_device
2)  usb_reset_and_verify_device
2)   hub_port_init
3)    hub_port_finish_reset
3)     xhci_discover_or_reset_device
        This frees xhci->devs[slot_id]->eps[ep_index].ring for all eps but 0
4)    usb_get_device_descriptor
       This fails
5)   hub_port_init fails
6)  usb_reset_and_verify_device fails, does not restore device config
7)  uas_post_reset
8)   xhci_alloc_streams
      NULL deref on the free-ed ring

This commit fixes this by not allowing usb_alloc_streams to continue if
the device is not configured.

Note that we do allow usb_free_streams to continue after a (logical)
disconnect, as it is necessary to explicitly free the streams at the xhci
controller level.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bec31e2efb88..23d44ac95cd6 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2061,6 +2061,8 @@ int usb_alloc_streams(struct usb_interface *interface,
 		return -EINVAL;
 	if (dev->speed != USB_SPEED_SUPER)
 		return -EINVAL;
+	if (dev->state < USB_STATE_CONFIGURED)
+		return -ENODEV;
 
 	for (i = 0; i < num_eps; i++) {
 		/* Streams only apply to bulk endpoints. */
-- 
2.1.0

