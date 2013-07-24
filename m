Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3GXOKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:10:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45764 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116Ab3GXOG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.200415022@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [35/85] [SCSI] mpt2sas: Fix for issue Missing delay not getting
 set during system bootup
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>

commit b0df96a0068daee4f9c2189c29b9053eb6e46b17 upstream.

Missing delay is not getting set properly. The reason is that it is not
defined in the same file from where it is being invoked.  The fix is to move
the missing delay module parameter from mpt2sas_base.c to mpt2sas_scsh.c.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  | 13 +++----------
 drivers/scsi/mpt2sas/mpt2sas_base.h  |  3 +++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |  8 +++++++-
 3 files changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -79,10 +79,6 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
-static int missing_delay[2] = {-1, -1};
-module_param_array(missing_delay, int, NULL, 0);
-MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
-
 static int mpt2sas_fwfault_debug;
 MODULE_PARM_DESC(mpt2sas_fwfault_debug, " enable detection of firmware fault "
 	"and halt firmware - (default=0)");
@@ -2104,7 +2100,7 @@ _base_display_ioc_capabilities(struct MP
 }
 
 /**
- * _base_update_missing_delay - change the missing delay timers
+ * mpt2sas_base_update_missing_delay - change the missing delay timers
  * @ioc: per adapter object
  * @device_missing_delay: amount of time till device is reported missing
  * @io_missing_delay: interval IO is returned when there is a missing device
@@ -2115,8 +2111,8 @@ _base_display_ioc_capabilities(struct MP
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
@@ -4302,9 +4298,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPT
 	if (r)
 		goto out_free_resources;
 
-	if (missing_delay[0] != -1 && missing_delay[1] != -1)
-		_base_update_missing_delay(ioc, missing_delay[0],
-		    missing_delay[1]);
 
 	return 0;
 
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -1029,6 +1029,9 @@ void mpt2sas_base_validate_event_type(st
 
 void mpt2sas_halt_firmware(struct MPT2SAS_ADAPTER *ioc);
 
+void mpt2sas_base_update_missing_delay(struct MPT2SAS_ADAPTER *ioc,
+	u16 device_missing_delay, u8 io_missing_delay);
+
 int mpt2sas_port_enable(struct MPT2SAS_ADAPTER *ioc);
 
 /* scsih shared API */
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -101,6 +101,10 @@ static ushort max_sectors = 0xFFFF;
 module_param(max_sectors, ushort, 0);
 MODULE_PARM_DESC(max_sectors, "max sectors, range 64 to 8192  default=8192");
 
+static int missing_delay[2] = {-1, -1};
+module_param_array(missing_delay, int, NULL, 0);
+MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
+
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPT2SAS_MAX_LUN (16895)
 static int max_lun = MPT2SAS_MAX_LUN;
@@ -7206,7 +7210,9 @@ _firmware_event_work(struct work_struct
 	case MPT2SAS_PORT_ENABLE_COMPLETE:
 		ioc->start_scan = 0;
 
-
+		if (missing_delay[0] != -1 && missing_delay[1] != -1)
+			mpt2sas_base_update_missing_delay(ioc, missing_delay[0],
+				missing_delay[1]);
 
 		dewtprintk(ioc, printk(MPT2SAS_INFO_FMT "port enable: complete "
 		    "from worker thread\n", ioc->name));

