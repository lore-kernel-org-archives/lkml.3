Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaLPULe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:11:34 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53708
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaLPULK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:11:10 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/4] Drivers: scsi: storvsc: In responce to a scan event, scan the host
Date: Tue, 16 Dec 2014 13:21:42 -0800
Message-Id: <1418764905-11250-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1418764880-11183-1-git-send-email-kys@microsoft.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtual HBA that storvsc implements can support multiple channels and
targets. So, scan the host when the host notifies that a scan is needed.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e3ba251..0a96fef 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -426,21 +426,16 @@ done:
 	kfree(wrk);
 }
 
-static void storvsc_bus_scan(struct work_struct *work)
+static void storvsc_host_scan(struct work_struct *work)
 {
 	struct storvsc_scan_work *wrk;
-	int id, order_id;
+	struct Scsi_Host *host;
 
 	wrk = container_of(work, struct storvsc_scan_work, work);
-	for (id = 0; id < wrk->host->max_id; ++id) {
-		if (wrk->host->reverse_ordering)
-			order_id = wrk->host->max_id - id - 1;
-		else
-			order_id = id;
-
-		scsi_scan_target(&wrk->host->shost_gendev, 0,
-				order_id, SCAN_WILD_CARD, 1);
-	}
+	host = wrk->host;
+
+	scsi_scan_host(host);
+
 	kfree(wrk);
 }
 
@@ -1198,7 +1193,7 @@ static void storvsc_on_receive(struct hv_device *device,
 		if (!work)
 			return;
 
-		INIT_WORK(&work->work, storvsc_bus_scan);
+		INIT_WORK(&work->work, storvsc_host_scan);
 		work->host = stor_device->host;
 		schedule_work(&work->work);
 		break;
-- 
1.7.4.1

