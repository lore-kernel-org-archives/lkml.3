Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3GaVSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:18:38 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:38250 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3GaVSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:18:35 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH linux-next] hid/logitech-dj: Fix non-atomic kmalloc in logi_dj_ll_input_event()
Date: Wed, 31 Jul 2013 17:17:58 -0400
Message-Id: <1375305478-26754-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ll_driver's .hidinput_input_event() method is called from
atomic context [1]. Use GFP_ATOMIC for allocation of the
synthesized hid report.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

[1]
BUG: sleeping function called from invalid context at /home/peter/src/kernels/next/mm/slub.c:941
in_atomic(): 1, irqs_disabled(): 1, pid: 2095, name: Xorg
INFO: lockdep is turned off.
irq event stamp: 1502178
hardirqs last  enabled at (1502177): [<ffffffff81785e55>] _raw_spin_unlock_irqrestore+0x65/0x80
hardirqs last disabled at (1502178): [<ffffffff8178632a>] common_interrupt+0x6a/0x6f
softirqs last  enabled at (1501802): [<ffffffff81051ed3>] __do_softirq+0x183/0x420
softirqs last disabled at (1501799): [<ffffffff81052315>] irq_exit+0xb5/0xc0
CPU: 3 PID: 2095 Comm: Xorg Not tainted 3.11-next-20130725-xeon+lockdep #20130725
Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
 ffffffff81a662e0 ffff8802adcf9ca8 ffffffff8177c330 0000000000000000
 ffff8802a76d2440 ffff8802adcf9cd8 ffffffff810867d0 ffff8802a7ac8000
 0000000000000010 00000000ffffffff 00000000000000d0 ffff8802adcf9d38
Call Trace:
 [<ffffffff8177c330>] dump_stack+0x4f/0x84
 [<ffffffff810867d0>] __might_sleep+0x140/0x1f0
 [<ffffffff811ad93b>] __kmalloc+0x6b/0x2e0
 [<ffffffffa026cb08>] ? hid_alloc_report_buf+0x28/0x30 [hid]
 [<ffffffffa026cb08>] hid_alloc_report_buf+0x28/0x30 [hid]
 [<ffffffffa00700b0>] logi_dj_ll_input_event+0xb0/0x1b0 [hid_logitech_dj]
 [<ffffffff815a559e>] input_handle_event+0x8e/0x540
 [<ffffffff815a5aad>] ? input_inject_event+0x5d/0x220
 [<ffffffff815a5c10>] input_inject_event+0x1c0/0x220
 [<ffffffff815a5a94>] ? input_inject_event+0x44/0x220
 [<ffffffff81181660>] ? might_fault+0xa0/0xb0
 [<ffffffff81181617>] ? might_fault+0x57/0xb0
 [<ffffffff815a909e>] evdev_write+0xde/0x160
 [<ffffffff811c0ad8>] vfs_write+0xc8/0x1f0
 [<ffffffff811c0fe5>] SyS_write+0x55/0xa0
 [<ffffffff8178e682>] system_call_fastpath+0x16/0x1b
---
 drivers/hid/hid-logitech-dj.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 510fa8f..e7ad88e 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -591,7 +591,7 @@ static int logi_dj_ll_input_event(struct input_dev *dev, unsigned int type,
 	}
 	hid_set_field(field, offset, value);
 
-	data = hid_alloc_report_buf(field->report, GFP_KERNEL);
+	data = hid_alloc_report_buf(field->report, GFP_ATOMIC);
 	if (!data) {
 		dev_warn(&dev->dev, "failed to allocate report buf memory\n");
 		return -1;
-- 
1.8.1.2

