Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaC0HJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 03:09:31 -0400
Received: from shell.v3.sk ([195.168.3.45]:54205 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbaC0HJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 03:09:29 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH RESEND] gadgetfs: Initialize CHIP to NULL before UDC probe
Date: Thu, 27 Mar 2014 08:09:21 +0100
Message-Id: <1395904161-6865-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise the value from the last probe would be retained that possibly is
freed since (the UDC is removed) and therefore no longer relevant. Reproducible
with the dummy UDC:

  modprobe dummy_hcd
  mount -t gadgetfs gadgetfs /dev/gadget
  umount /dev/gadget
  rmmod dummy_hcd
  mount -t gadgetfs gadgetfs /dev/gadget

BUG: unable to handle kernel paging request at ffffffffa066fd9d
Call Trace:
 [<ffffffff811d0cd2>] ? d_alloc_name+0x22/0x50
 [<ffffffff812b74dc>] ? selinux_d_instantiate+0x1c/0x20
 [<ffffffffa067d687>] gadgetfs_create_file+0x27/0xa0 [gadgetfs]
 [<ffffffffa067da70>] ? setup_req.isra.4+0x80/0x80 [gadgetfs]
 [<ffffffffa067dbac>] gadgetfs_fill_super+0x13c/0x180 [gadgetfs]
 [<ffffffff811bc832>] mount_single+0x92/0xc0
 [<ffffffffa067d0f8>] gadgetfs_mount+0x18/0x20 [gadgetfs]
 [<ffffffff811bc8f9>] mount_fs+0x39/0x1b0
 [<ffffffff8116b220>] ? __alloc_percpu+0x10/0x20
 [<ffffffff811d6da3>] vfs_kern_mount+0x63/0xf0
 [<ffffffff811d93be>] do_mount+0x23e/0xac0
 [<ffffffff811660eb>] ? strndup_user+0x4b/0xf0
 [<ffffffff811d9f63>] SyS_mount+0x83/0xc0
 [<ffffffff81695b69>] system_call_fastpath+0x16/0x1b

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/usb/gadget/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index b94c049..ee15628 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -2046,6 +2046,7 @@ gadgetfs_fill_super (struct super_block *sb, void *opts, int silent)
 		return -ESRCH;
 
 	/* fake probe to determine $CHIP */
+	CHIP = NULL;
 	usb_gadget_probe_driver(&probe_driver);
 	if (!CHIP)
 		return -ENODEV;
-- 
1.8.5.3

