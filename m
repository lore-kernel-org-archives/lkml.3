Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3LSL5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:57:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3LSL46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/208] [SCSI] Disable WRITE SAME for RAID and virtual host adapter drivers
Date: Thu, 19 Dec 2013 11:52:46 +0000
Message-Id: <1387454106-19326-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 54b2b50c20a61b51199bedb6e5d2f8ec2568fb43 upstream.

Some host adapters do not pass commands through to the target disk
directly. Instead they provide an emulated target which may or may not
accurately report its capabilities. In some cases the physical device
characteristics are reported even when the host adapter is processing
commands on the device's behalf. This can lead to adapter firmware hangs
or excessive I/O errors.

This patch disables WRITE SAME for devices connected to host adapters
that provide an emulated target. Driver writers can disable WRITE SAME
by setting the no_write_same flag in the host adapter template.

[jejb: fix up rejections due to eh_deadline patch]
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/libata-scsi.c                 | 1 +
 drivers/firewire/sbp2.c                   | 1 +
 drivers/scsi/3w-9xxx.c                    | 3 ++-
 drivers/scsi/3w-sas.c                     | 3 ++-
 drivers/scsi/3w-xxxx.c                    | 3 ++-
 drivers/scsi/aacraid/linit.c              | 1 +
 drivers/scsi/arcmsr/arcmsr_hba.c          | 1 +
 drivers/scsi/gdth.c                       | 1 +
 drivers/scsi/hosts.c                      | 1 +
 drivers/scsi/hpsa.c                       | 1 +
 drivers/scsi/ipr.c                        | 3 ++-
 drivers/scsi/ips.c                        | 1 +
 drivers/scsi/megaraid.c                   | 1 +
 drivers/scsi/megaraid/megaraid_mbox.c     | 1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 1 +
 drivers/scsi/pmcraid.c                    | 1 +
 drivers/scsi/sd.c                         | 6 ++++++
 drivers/scsi/storvsc_drv.c                | 1 +
 include/scsi/scsi_host.h                  | 6 ++++++
 19 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b1e880a..94d72f3c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3613,6 +3613,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		shost->max_lun = 1;
 		shost->max_channel = 1;
 		shost->max_cmd_len = 16;
+		shost->no_write_same = 1;
 
 		/* Schedule policy is determined by ->qc_defer()
 		 * callback and it needs to see every deferred qc.
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 281029d..b0bb056 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1623,6 +1623,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
+	.no_write_same		= 1,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 5e1e12c..0a73253 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2025,7 +2025,8 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= twa_host_attrs,
-	.emulated		= 1
+	.emulated		= 1,
+	.no_write_same		= 1,
 };
 
 /* This function will probe and initialize a card */
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index c845bdb..4de3460 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1600,7 +1600,8 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= twl_host_attrs,
-	.emulated		= 1
+	.emulated		= 1,
+	.no_write_same		= 1,
 };
 
 /* This function will probe and initialize a card */
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index b9276d1..752624e 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2279,7 +2279,8 @@ static struct scsi_host_template driver_template = {
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= tw_host_attrs,
-	.emulated		= 1
+	.emulated		= 1,
+	.no_write_same		= 1,
 };
 
 /* This function will probe and initialize a card */
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index f0d432c..4921ed1 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1081,6 +1081,7 @@ static struct scsi_host_template aac_driver_template = {
 #endif
 	.use_clustering			= ENABLE_CLUSTERING,
 	.emulated			= 1,
+	.no_write_same			= 1,
 };
 
 static void __aac_shutdown(struct aac_dev * aac)
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 33c52bc..278c9fa 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -137,6 +137,7 @@ static struct scsi_host_template arcmsr_scsi_host_template = {
 	.cmd_per_lun		= ARCMSR_MAX_CMD_PERLUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= arcmsr_host_attrs,
+	.no_write_same		= 1,
 };
 static struct pci_device_id arcmsr_device_id_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 6d55b4e..aec3d4d 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4686,6 +4686,7 @@ static struct scsi_host_template gdth_template = {
         .cmd_per_lun            = GDTH_MAXC_P_L,
         .unchecked_isa_dma      = 1,
         .use_clustering         = ENABLE_CLUSTERING,
+	.no_write_same		= 1,
 };
 
 #ifdef CONFIG_ISA
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index df0c3c7..3cafe0d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -388,6 +388,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	shost->no_write_same = sht->no_write_same;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f4f790..737af7e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -538,6 +538,7 @@ static struct scsi_host_template hpsa_driver_template = {
 	.sdev_attrs = hpsa_sdev_attrs,
 	.shost_attrs = hpsa_shost_attrs,
 	.max_sectors = 8192,
+	.no_write_same = 1,
 };
 
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 6601e03..ee17caa 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6305,7 +6305,8 @@ static struct scsi_host_template driver_template = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = ipr_ioa_attrs,
 	.sdev_attrs = ipr_dev_attrs,
-	.proc_name = IPR_NAME
+	.proc_name = IPR_NAME,
+	.no_write_same = 1,
 };
 
 /**
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 8d5ea8a..52a216f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -374,6 +374,7 @@ static struct scsi_host_template ips_driver_template = {
 	.sg_tablesize		= IPS_MAX_SG,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.no_write_same		= 1,
 };
 
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 90c95a3..816db12 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4244,6 +4244,7 @@ static struct scsi_host_template megaraid_template = {
 	.eh_device_reset_handler	= megaraid_reset,
 	.eh_bus_reset_handler		= megaraid_reset,
 	.eh_host_reset_handler		= megaraid_reset,
+	.no_write_same			= 1,
 };
 
 static int
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index e6a1e0b..3316d80 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -367,6 +367,7 @@ static struct scsi_host_template megaraid_template_g = {
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.change_queue_depth		= megaraid_change_queue_depth,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.no_write_same			= 1,
 	.sdev_attrs			= megaraid_sdev_attrs,
 	.shost_attrs			= megaraid_shost_attrs,
 };
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 1f0ca68..97b4181 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2123,6 +2123,7 @@ static struct scsi_host_template megasas_template = {
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
 	.change_queue_depth = megasas_change_queue_depth,
+	.no_write_same = 1,
 };
 
 /**
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1eb7b028..a38f71b 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4314,6 +4314,7 @@ static struct scsi_host_template pmcraid_host_template = {
 	.this_id = -1,
 	.sg_tablesize = PMCRAID_MAX_IOADLS,
 	.max_sectors = PMCRAID_IOA_MAX_SECTORS,
+	.no_write_same = 1,
 	.cmd_per_lun = PMCRAID_MAX_CMD_PER_LUN,
 	.use_clustering = ENABLE_CLUSTERING,
 	.shost_attrs = pmcraid_host_attrs,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 83e9070..a873795 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2637,6 +2637,12 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdev = sdkp->device;
 
+	if (sdev->host->no_write_same) {
+		sdev->no_write_same = 1;
+
+		return;
+	}
+
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
 		sdev->no_report_opcodes = 1;
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 83ec1aa..93d0707 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1697,6 +1697,7 @@ static struct scsi_host_template scsi_driver = {
 	.use_clustering =	DISABLE_CLUSTERING,
 	/* Make sure we dont get a sg segment crosses a page boundary */
 	.dma_boundary =		PAGE_SIZE-1,
+	.no_write_same =	1,
 };
 
 enum {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7552435..50769a7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -475,6 +475,9 @@ struct scsi_host_template {
 	 */
 	unsigned ordered_tag:1;
 
+	/* True if the controller does not support WRITE SAME */
+	unsigned no_write_same:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -674,6 +677,9 @@ struct Scsi_Host {
 	/* Don't resume host in EH */
 	unsigned eh_noresume:1;
 
+	/* The controller does not support WRITE SAME */
+	unsigned no_write_same:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
1.8.3.2

