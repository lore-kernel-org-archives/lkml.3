Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaLACvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 21:51:00 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:38893 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaLACu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 21:50:58 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <timur@tabi.org>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <jiada_wang@mentor.com>
Subject: [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
Date: Mon, 1 Dec 2014 11:50:51 +0900
Message-ID: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_dispose_mapping() in turns calls unregister_irq_proc(),
which will remove irq proc entry, if IRQ is not freed
before calling of irq_dispose_mapping(), then it will cause
kernel warning.

By free IRQ before irq_dispose_mapping(), this patch fix
the following kernel warning found when remove of fsl_ssi driver:

[   31.515336] ------------[ cut here ]------------
[   31.520091] WARNING: CPU: 2 PID: 434 at fs/proc/generic.c:521 remove_proc_entry+0x14c/0x16c()
[   31.528708] remove_proc_entry: removing non-empty directory 'irq/79', leaking at least '202c000.ss'
[   31.537911] Modules linked in: snd_soc_wm8962 snd_soc_imx_wm8962 snd_soc_fsl_ssi(-) evbug
[   31.546249] CPU: 2 PID: 434 Comm: rmmod Not tainted 3.18.0-rc6-00028-g3314bf6-dirty #1
[   31.554235] Backtrace:
[   31.556816] [<80011ea8>] (dump_backtrace) from [<80012044>] (show_stack+0x18/0x1c)
[   31.564416]  r6:80142c88 r5:00000000 r4:00000000 r3:00000000
[   31.570267] [<8001202c>] (show_stack) from [<806980ec>] (dump_stack+0x88/0xa4)
[   31.577588] [<80698064>] (dump_stack) from [<80029d78>] (warn_slowpath_common+0x70/0x94)
[   31.585711]  r5:00000009 r4:bb61fd90
[   31.589423] [<80029d08>] (warn_slowpath_common) from [<80029e40>] (warn_slowpath_fmt+0x38/0x40)
[   31.598187]  r8:bb61fdfe r7:be05d76d r6:be05d9a8 r5:00000002 r4:be05d700
[   31.605054] [<80029e0c>] (warn_slowpath_fmt) from [<80142c88>] (remove_proc_entry+0x14c/0x16c)
[   31.613709]  r3:806a79c0 r2:808229a0
[   31.617371] [<80142b3c>] (remove_proc_entry) from [<80070380>] (unregister_irq_proc+0x94/0xb8)
[   31.625989]  r10:00000000 r8:8000ede4 r7:80955f2c r6:0000004f r5:8118e738 r4:be00af00
[   31.633952] [<800702ec>] (unregister_irq_proc) from [<80069dac>] (free_desc+0x2c/0x64)
[   31.641898]  r6:0000004f r5:80955f38 r4:be00af00
[   31.646604] [<80069d80>] (free_desc) from [<80069e68>] (irq_free_descs+0x4c/0x8c)
[   31.654092]  r7:00000081 r6:00000001 r5:0000004f r4:00000001
[   31.659863] [<80069e1c>] (irq_free_descs) from [<8006fc3c>] (irq_dispose_mapping+0x40/0x5c)
[   31.668247]  r6:be17b844 r5:be17b800 r4:0000004f r3:802c5ec0
[   31.673998] [<8006fbfc>] (irq_dispose_mapping) from [<7f004ea4>] (fsl_ssi_remove+0x58/0x70 [snd_so)
[   31.683948]  r4:bb5bba10 r3:00000001
[   31.687618] [<7f004e4c>] (fsl_ssi_remove [snd_soc_fsl_ssi]) from [<803720a0>] (platform_drv_remove)
[   31.697564]  r5:7f0064f8 r4:be17b810
[   31.701195] [<80372080>] (platform_drv_remove) from [<80370494>] (__device_release_driver+0x78/0xc)
[   31.710361]  r5:7f0064f8 r4:be17b810
[   31.713987] [<8037041c>] (__device_release_driver) from [<80370d20>] (driver_detach+0xbc/0xc0)
[   31.722631]  r5:7f0064f8 r4:be17b810
[   31.726259] [<80370c64>] (driver_detach) from [<80370304>] (bus_remove_driver+0x54/0x98)
[   31.734382]  r6:00000800 r5:00000000 r4:7f0064f8 r3:bb67f500
[   31.740149] [<803702b0>] (bus_remove_driver) from [<80371398>] (driver_unregister+0x30/0x50)
[   31.748617]  r4:7f0064f8 r3:bd9f7080
[   31.752245] [<80371368>] (driver_unregister) from [<80371f3c>] (platform_driver_unregister+0x14/0x)
[   31.761498]  r4:7f00655c r3:7f005a70
[   31.765130] [<80371f28>] (platform_driver_unregister) from [<7f005a84>] (fsl_ssi_driver_exit+0x14/)
[   31.776147] [<7f005a70>] (fsl_ssi_driver_exit [snd_soc_fsl_ssi]) from [<8008ed80>] (SyS_delete_mod)
[   31.786553] [<8008ec64>] (SyS_delete_module) from [<8000ec20>] (ret_fast_syscall+0x0/0x48)
[   31.794824]  r6:00c46d18 r5:00000800 r4:00c46d18
[   31.799530] ---[ end trace 954e8a3a15379e52 ]---

Moreover replace devm_request_irq() with request_irq() since there is
no need to use it as now driver always frees IRQ manually.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 sound/soc/fsl/fsl_ssi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index e695517..cfdb337 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1400,9 +1400,8 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 	}
 
 	if (ssi_private->use_dma) {
-		ret = devm_request_irq(&pdev->dev, ssi_private->irq,
-					fsl_ssi_isr, 0, dev_name(&pdev->dev),
-					ssi_private);
+		ret = request_irq(ssi_private->irq, fsl_ssi_isr, 0,
+					dev_name(&pdev->dev), ssi_private);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "could not claim irq %u\n",
 					ssi_private->irq);
@@ -1412,7 +1411,7 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 
 	ret = fsl_ssi_debugfs_create(&ssi_private->dbg_stats, &pdev->dev);
 	if (ret)
-		goto error_asoc_register;
+		goto error_debugfs_create;
 
 	/*
 	 * If codec-handle property is missing from SSI node, we assume
@@ -1453,6 +1452,10 @@ done:
 error_sound_card:
 	fsl_ssi_debugfs_remove(&ssi_private->dbg_stats);
 
+error_debugfs_create:
+	if (ssi_private->use_dma)
+		free_irq(ssi_private->irq, ssi_private);
+
 error_irq:
 	snd_soc_unregister_component(&pdev->dev);
 
@@ -1473,6 +1476,9 @@ static int fsl_ssi_remove(struct platform_device *pdev)
 
 	fsl_ssi_debugfs_remove(&ssi_private->dbg_stats);
 
+	if (ssi_private->use_dma)
+		free_irq(ssi_private->irq, ssi_private);
+
 	if (ssi_private->pdev)
 		platform_device_unregister(ssi_private->pdev);
 	snd_soc_unregister_component(&pdev->dev);
-- 
1.9.3

