Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaJ0TAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:00:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52495 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbaJ0TAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:00:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Borislav Petkov <bp@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 069/105] mpc85xx_edac: Make L2 interrupt shared too
Date: Mon, 27 Oct 2014 11:56:44 -0700
Message-Id: <1414436240-13879-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit a18c3f16a907b8977ef65fc8dd71ed3f7b751748 upstream.

The other two interrupt handlers in this driver are shared, except this
one. When loading the driver, it fails like this.

So make the IRQ line shared.

Freescale(R) MPC85xx EDAC driver, (C) 2006 Montavista Software
mpc85xx_mc_err_probe: No ECC DIMMs discovered
EDAC DEVICE0: Giving out device to module MPC85xx_edac controller mpc85xx_l2_err: DEV mpc85xx_l2_err (INTERRUPT)
genirq: Flags mismatch irq 16. 00000000 ([EDAC] L2 err) vs. 00000080 ([EDAC] PCI err)
mpc85xx_l2_err_probe: Unable to request irq 16 for MPC85xx L2 err
remove_proc_entry: removing non-empty directory 'irq/16', leaking at least 'aerdrv'
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:521
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc5-dirty #1
task: ee058000 ti: ee046000 task.ti: ee046000
NIP: c016c0c4 LR: c016c0c4 CTR: c037b51c
REGS: ee047c10 TRAP: 0700 Not tainted (3.17.0-rc5-dirty)
MSR: 00029000 <CE,EE,ME> CR: 22008022 XER: 20000000

GPR00: c016c0c4 ee047cc0 ee058000 00000053 00029000 00000000 c037c744 00000003
GPR08: c09aab28 c09aab24 c09aab28 00000156 20008028 00000000 c0002ac8 00000000
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000139 c0950394
GPR24: c09f0000 ee5585b0 ee047d08 c0a10000 ee047d08 ee15f808 00000002 ee03f660
NIP [c016c0c4] remove_proc_entry
LR [c016c0c4] remove_proc_entry
Call Trace:
remove_proc_entry (unreliable)
unregister_irq_proc
free_desc
irq_free_descs
mpc85xx_l2_err_probe
platform_drv_probe
really_probe
__driver_attach
bus_for_each_dev
bus_add_driver
driver_register
mpc85xx_mc_init
do_one_initcall
kernel_init_freeable
kernel_init
ret_from_kernel_thread
Instruction dump: ...

Reported-and-tested-by: <lpb_098@163.com>
Acked-by: Johannes Thumshirn <johannes.thumshirn@men.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/edac/mpc85xx_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index fd46b0b..8d017ec 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -557,7 +557,7 @@ static int mpc85xx_l2_err_probe(struct platform_device *op)
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_l2_isr, IRQF_DISABLED,
+				       mpc85xx_l2_isr, IRQF_SHARED,
 				       "[EDAC] L2 err", edac_dev);
 		if (res < 0) {
 			printk(KERN_ERR
-- 
1.9.1

