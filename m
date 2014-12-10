Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaLJH24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:28:56 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:35540
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289AbaLJH2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:28:54 -0500
x-originating-ip: 72.167.245.219
From: Long Li <longli@microsoft.com>
To: kys@microsoft.com, haiyangz@microsoft.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>
Subject: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Date: Wed, 10 Dec 2014 00:38:25 -0800
Message-Id: <1418200705-488-1-git-send-email-longli@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSFT targets currently claim SPC-2 compliance while they implement post SPC-2 features. With this patch we can correctly handle WRITE_SAME_16 issues.

This patch fixes an issue where the flag is setup too late in drive initialization process.

Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/scsi_devinfo.c |  1 +
 drivers/scsi/storvsc_drv.c  | 10 ----------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c1d04d4..f6fe0b2 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -211,6 +211,7 @@ static struct {
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
 	{"MICROP", "4110", NULL, BLIST_NOTQ},
+	{"Msft", "Virtual Disk", "1.0", BLIST_TRY_VPD_PAGES},
 	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e3ba251..2452bb4 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -327,8 +327,6 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
  */
 static int storvsc_timeout = 180;
 
-static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
-
 #define STORVSC_MAX_IO_REQUESTS				200
 
 static void storvsc_on_channel_callback(void *context);
@@ -1439,14 +1437,6 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 
-	/*
-	 * Add blist flags to permit the reading of the VPD pages even when
-	 * the target may claim SPC-2 compliance. MSFT targets currently
-	 * claim SPC-2 compliance while they implement post SPC-2 features.
-	 * With this patch we can correctly handle WRITE_SAME_16 issues.
-	 */
-	sdevice->sdev_bflags |= msft_blist_flags;
-
 	return 0;
 }
 
-- 
2.1.0

