Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbaJIVLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:11:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871AbaJIVLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 079/163] spi: fsl: Don't use devm_kzalloc in master->setup callback
Date: Thu,  9 Oct 2014 14:01:44 -0700
Message-Id: <1412888588-26755-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit d9f26748128c73ec6bed2846ca52fb1c2edc3ced upstream.

device_add() expects that any memory allocated via devm_* API is only
done in the device's probe function.

Fix below boot warning:
[    3.092348] WARNING: at drivers/base/dd.c:286
[    3.096637] Modules linked in:
[    3.099697] CPU: 0 PID: 25 Comm: kworker/u2:1 Tainted: G W 3.16.1-s3k-drv-999-svn5771_knld-999 #158
[ 3.109610] Workqueue: deferwq deferred_probe_work_func
[    3.114736] task: c787f020 ti: c790c000 task.ti: c790c000
[    3.120062] NIP: c01df158 LR: c01df144 CTR: 00000000
[    3.124983] REGS: c790db30 TRAP: 0700   Tainted: G        W (3.16.1-s3k-drv-999-svn5771_knld-999)
[    3.134162] MSR: 00029032 <EE,ME,IR,DR,RI>  CR: 22002082 XER: 20000000
[    3.140703]
[    3.140703] GPR00: 00000001 c790dbe0 c787f020 00000044 00000054 00000308 c056da0e 20737069
[    3.140703] GPR08: 33323736 000ebfe0 00000308 000ebfdf 22002082 00000000 c046c5a0 c046c608
[    3.140703] GPR16: c046c614 c046c620 c046c62c c046c638 c046c648 c046c654 c046c68c c046c6c4
[    3.140703] GPR24: 00000000 00000000 00000003 c0401aa0 c0596638 c059662c c054e7a8 c7996800
[    3.170102] NIP [c01df158] driver_probe_device+0xf8/0x334
[    3.175431] LR [c01df144] driver_probe_device+0xe4/0x334
[    3.180633] Call Trace:
[    3.183093] [c790dbe0] [c01df144] driver_probe_device+0xe4/0x334 (unreliable)
[    3.190147] [c790dc10] [c01dd15c] bus_for_each_drv+0x7c/0xc0
[    3.195741] [c790dc40] [c01df5fc] device_attach+0xcc/0xf8
[    3.201076] [c790dc60] [c01dd6d4] bus_probe_device+0xb4/0xc4
[    3.206666] [c790dc80] [c01db9f8] device_add+0x270/0x564
[    3.211923] [c790dcc0] [c0219e84] spi_add_device+0xc0/0x190
[    3.217427] [c790dce0] [c021a79c] spi_register_master+0x720/0x834
[    3.223455] [c790dd40] [c021cb48] of_fsl_spi_probe+0x55c/0x614
[    3.229234] [c790dda0] [c01e0d2c] platform_drv_probe+0x30/0x74
[    3.234987] [c790ddb0] [c01df18c] driver_probe_device+0x12c/0x334
[    3.241008] [c790dde0] [c01dd15c] bus_for_each_drv+0x7c/0xc0
[    3.246602] [c790de10] [c01df5fc] device_attach+0xcc/0xf8
[    3.251937] [c790de30] [c01dd6d4] bus_probe_device+0xb4/0xc4
[    3.257536] [c790de50] [c01de9d8] deferred_probe_work_func+0x98/0xe0
[    3.263816] [c790de70] [c00305b8] process_one_work+0x18c/0x440
[    3.269577] [c790dea0] [c0030a00] worker_thread+0x194/0x67c
[    3.275105] [c790def0] [c0039198] kthread+0xd0/0xe4
[    3.279911] [c790df40] [c000c6d0] ret_from_kernel_thread+0x5c/0x64
[    3.285970] Instruction dump:
[    3.288900] 80de0000 419e01d0 3b7b0038 3c60c046 7f65db78 38635264 48211b99 813f00a0
[    3.296559] 381f00a0 7d290278 3169ffff 7c0b4910 <0f000000> 93df0044 7fe3fb78 4bfffd4d

Reported-by: leroy christophe <christophe.leroy@c-s.fr>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Mark Brown <broonie@kernel.org>
[ kamal: backport to 3.13-stable: was not using devm_kzalloc but did need
  the kfree fix. ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-fsl-espi.c | 15 ++++++++++++---
 drivers/spi/spi-fsl-spi.c  | 10 +++++++---
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
index 80d8f40..e9f6654 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -456,16 +456,16 @@ static int fsl_espi_setup(struct spi_device *spi)
 	int retval;
 	u32 hw_mode;
 	u32 loop_mode;
-	struct spi_mpc8xxx_cs *cs = spi->controller_state;
+	struct spi_mpc8xxx_cs *cs = spi_get_ctldata(spi);
 
 	if (!spi->max_speed_hz)
 		return -EINVAL;
 
 	if (!cs) {
-		cs = kzalloc(sizeof *cs, GFP_KERNEL);
+		cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 		if (!cs)
 			return -ENOMEM;
-		spi->controller_state = cs;
+		spi_set_ctldata(spi, cs);
 	}
 
 	mpc8xxx_spi = spi_master_get_devdata(spi->master);
@@ -500,6 +500,14 @@ static int fsl_espi_setup(struct spi_device *spi)
 	return 0;
 }
 
+static void fsl_espi_cleanup(struct spi_device *spi)
+{
+	struct spi_mpc8xxx_cs *cs = spi_get_ctldata(spi);
+
+	kfree(cs);
+	spi_set_ctldata(spi, NULL);
+}
+
 void fsl_espi_cpu_irq(struct mpc8xxx_spi *mspi, u32 events)
 {
 	struct fsl_espi_reg *reg_base = mspi->reg_base;
@@ -607,6 +615,7 @@ static struct spi_master * fsl_espi_probe(struct device *dev,
 
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 16);
 	master->setup = fsl_espi_setup;
+	master->cleanup = fsl_espi_cleanup;
 
 	mpc8xxx_spi = spi_master_get_devdata(master);
 	mpc8xxx_spi->spi_do_one_msg = fsl_espi_do_one_msg;
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 119f7af..a18cc09 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -420,16 +420,16 @@ static int fsl_spi_setup(struct spi_device *spi)
 	struct fsl_spi_reg *reg_base;
 	int retval;
 	u32 hw_mode;
-	struct spi_mpc8xxx_cs	*cs = spi->controller_state;
+	struct spi_mpc8xxx_cs *cs = spi_get_ctldata(spi);
 
 	if (!spi->max_speed_hz)
 		return -EINVAL;
 
 	if (!cs) {
-		cs = kzalloc(sizeof *cs, GFP_KERNEL);
+		cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 		if (!cs)
 			return -ENOMEM;
-		spi->controller_state = cs;
+		spi_set_ctldata(spi, cs);
 	}
 	mpc8xxx_spi = spi_master_get_devdata(spi->master);
 
@@ -491,9 +491,13 @@ static int fsl_spi_setup(struct spi_device *spi)
 static void fsl_spi_cleanup(struct spi_device *spi)
 {
 	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(spi->master);
+	struct spi_mpc8xxx_cs *cs = spi_get_ctldata(spi);
 
 	if (mpc8xxx_spi->type == TYPE_GRLIB && gpio_is_valid(spi->cs_gpio))
 		gpio_free(spi->cs_gpio);
+
+	kfree(cs);
+	spi_set_ctldata(spi, NULL);
 }
 
 static void fsl_spi_cpu_irq(struct mpc8xxx_spi *mspi, u32 events)
-- 
1.9.1

