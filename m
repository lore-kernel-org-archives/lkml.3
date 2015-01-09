Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbbAIDsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:48:41 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60819 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbbAIDsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:48:40 -0500
From: Gigi Joseph <gigi.joseph@gmail.com>
X-Google-Original-From: Gigi Joseph <gigi.joseph@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Enric Balletbo i Serra <eballetbo@iseebcn.com>,
        Robin van der Gracht <robin@protonic.nl>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Cc: Gigi Joseph <gigi.joseph@ti.com>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH 5/6] drivers: misc: ti-st: fix null pointer exception in st_kim_ref()
Date: Fri,  9 Jan 2015 03:48:29 +0000
Message-Id: <1420775309-24828-1-git-send-email-gigi.joseph@ti.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

st_kim_ref() does not take care of the fact that platform_get_drvdata() might return NULL. On AM437x EVM, this causes the platform to stop booting as soon as the module is inserted.

This patch fixes the issue by checking for NULL return value. Oops log follows.

I have not tested BT functionality after this patch. But at least the platform boots now.

[   12.675697] Unable to handle kernel NULL pointer dereference at virtual address 0000005c
[   12.684310] pgd = c0004000
[   12.687157] [0000005c] *pgd=00000000
[   12.690927] Internal error: Oops: 17 [#1] SMP ARM
[   12.695873] Modules linked in: btwilink bluetooth ti_vpfe dwc3(+) ov2659 videobuf2_core v4l2_common videodev ti_am335x_adc 6lowpan_iphc matrix_keypad panel_dpi kfifo_buf pixcir_i2c_ts media industrialio videobuf2_dma_contig c_can_platform videobuf2_memops dwc3_omap c_can can_dev
[   12.721969] CPU: 0 PID: 1235 Comm: kworker/u3:0 Not tainted 3.14.25-02445-g9036ac6daed6 #128
[   12.730937] Workqueue: hci0 hci_power_on [bluetooth]
[   12.736165] task: ebd93b40 ti: ecd7c000 task.ti: ecd7c000
[   12.741856] PC is at st_kim_ref+0x30/0x40
[   12.746071] LR is at st_kim_ref+0x30/0x40
[   12.750289] pc : [<c03caf58>]    lr : [<c03caf58>]    psr: a0000013
[   12.750289] sp : ecd7de08  ip : ecd7de08  fp : ecd7de1c
[   12.762365] r10: bf1e710c  r9 : bf1e70ec  r8 : bf1e7964
[   12.767858] r7 : ebd2fd50  r6 : bf1e7964  r5 : 00000000  r4 : ecd7de24
[   12.774723] r3 : c0957208  r2 : 00000000  r1 : c0957208  r0 : 00000000
[   12.781589] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[   12.789274] Control: 10c5387d  Table: abde4059  DAC: 00000015
[   12.795315] Process kworker/u3:0 (pid: 1235, stack limit = 0xecd7c248)

Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Gigi Joseph <gigi.joseph@ti.com>
---
 drivers/misc/ti-st/st_kim.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 878956a..7109d28 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -691,12 +691,16 @@ void st_kim_ref(struct st_data_s **core_data, int id)
 	struct kim_data_s	*kim_gdata;
 	/* get kim_gdata reference from platform device */
 	pdev = st_get_plat_device(id);
-	if (!pdev) {
-		*core_data = NULL;
-		return;
-	}
+	if (!pdev)
+		goto err;
 	kim_gdata = platform_get_drvdata(pdev);
+	if (!kim_gdata)
+		goto err;
+
 	*core_data = kim_gdata->core_data;
+	return;
+err:
+	*core_data = NULL;
 }
 
 static int kim_version_open(struct inode *i, struct file *f)
-- 
1.9.1

