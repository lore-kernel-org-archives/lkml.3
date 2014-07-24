Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934338AbaGXH47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:56:59 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63333 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934045AbaGXH45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:56:57 -0400
Date: Thu, 24 Jul 2014 08:56:53 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 2/3] [SCSI] storvsc: Add Hyper-V logical block provisioning
 tests
Message-ID: <20140724075653.GC15127@sucs.org>
References: <1405983961-18782-1-git-send-email-kys@microsoft.com>
 <20140723141028.GA22724@sucs.org>
 <20140723141558.GA9705@infradead.org>
 <20140723201341.GA10292@sucs.org>
 <20140724074739.GA15127@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724074739.GA15127@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microsoft Hyper-V targets currently only claim SPC-2 compliance / no
compliance indicated even though they implement post SPC-2 features
which means those features are not tested for. Add a blacklist flag to
Hyper-V devices that forces said testing.

See https://lkml.org/lkml/2014/7/21/627 for the previous version of this
patch and https://lkml.org/lkml/2014/7/23/615 for example devices.

Original-patch-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 drivers/scsi/storvsc_drv.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5ad2810..88b7173 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -326,8 +326,6 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
  */
 static int storvsc_timeout = 180;
 
-static int msft_blist_flags = BLIST_TRY_VPD_PAGES;
-
 #define STORVSC_MAX_IO_REQUESTS				200
 
 static void storvsc_on_channel_callback(void *context);
@@ -1444,12 +1442,10 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	sdevice->no_write_same = 1;
 
 	/*
-	 * Add blist flags to permit the reading of the VPD pages even when
-	 * the target may claim SPC-2 compliance. MSFT targets currently
-	 * claim SPC-2 compliance while they implement post SPC-2 features.
-	 * With this patch we can correctly handle WRITE_SAME_16 issues.
+	 * Forcefully enable logical block provisioning testing.
 	 */
-	sdevice->sdev_bflags |= msft_blist_flags;
+	sdevice->sdev_bflags |= BLIST_TRY_LBP;
+	sdevice->try_lbp = 1;
 
 	return 0;
 }
-- 
1.9.3
