Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab3GKOlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:41:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43090 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab3GKO01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 55/98] [SCSI] mpt2sas: Fix for issue Missing delay not getting set during system bootup
Date: Thu, 11 Jul 2013 15:24:25 +0100
Message-Id: <1373552708-15235-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>

commit b0df96a0068daee4f9c2189c29b9053eb6e46b17 upstream.

Missing delay is not getting set properly. The reason is that it is not
defined in the same file from where it is being invoked.  The fix is to move
the missing delay module parameter from mpt2sas_base.c to mpt2sas_scsh.c.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  | 14 +++-----------
 drivers/scsi/mpt2sas/mpt2sas_base.h  |  3 +++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  8 +++++++-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 9d5a56c..bf7a9e7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -80,10 +80,6 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
-static int missing_delay[2] = {-1, -1};
-module_param_array(missing_delay, int, NULL, 0);
-MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
-
 static int mpt2sas_fwfault_debug;
 MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fault "
 	"and halt firmware - (default=0)");
@@ -2175,7 +2171,7 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_update_missing_delay - change the missing delay timers
+ * mpt2sas_base_update_missing_delay - change the missing delay timers
  * @ioc: per adapter object
  * @device_missing_delay: amount of time till device is reported missing
  * @io_missing_delay: interval IO is returned when there is a missing device
@@ -2186,8 +2182,8 @@ _base_display_ioc_capabilities(struct MPT2SAS_ADAPTER *ioc)
  * delay, as well as the io missing delay. This should be called at driver
  * load time.
  */
-static void
-_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
+void
+mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
 	u16 device_missing_delay, u8 io_missing_delay)
 {
 	u16 dmd, dmd_new, dmd_orignal;
@@ -4383,10 +4379,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
-	if (missing_delay[0] != -1 && missing_delay[1] != -1)
-		_base_update_missing_delay(ioc, missing_delay[0],
-		    missing_delay[1]);
-
 	return 0;
 
  out_free_resources:
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index b6dd3a5..2fa7282 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -1048,6 +1048,9 @@ void mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_ty
 
 void mpt2sas_halt_firmware(struct MPT2SAS_ADAPTER *ioc);
 
+void mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
+	u16 device_missing_delay, u8 io_missing_delay);
+
 int mpt2sas_port_enable(struct MPT2SAS_ADAPTER *ioc);
 
 /* scsih shared API */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 76973e8..d672b64 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -101,6 +101,10 @@ static ushort max_sectors = 0xFFFF;
 module_param(max_sectors, ushort, 0);
 MODULE_PARM_DESC(max_sectors, "max sectors, range 64 to 32767  default=32767");
 
+static int missing_delay[2] = {-1, -1};
+module_param_array(missing_delay, int, NULL, 0);
+MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
+
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPT2SAS_MAX_LUN (16895)
 static int max_lun = MPT2SAS_MAX_LUN;
@@ -7297,7 +7301,9 @@ _firmware_event_work(struct work_struct *work)
 	case MPT2SAS_PORT_ENABLE_COMPLETE:
 		ioc->start_scan = 0;
 
-
+		if (missing_delay[0] != -1 && missing_delay[1] != -1)
+			mpt2sas_base_update_missing_delay(ioc, missing_delay[0],
+				missing_delay[1]);
 
 		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "port enable: complete "
 		    "from worker thread\n", ioc->name));
-- 
1.8.1.2

