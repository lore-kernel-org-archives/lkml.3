Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaHQCG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 22:06:59 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:44160
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaHQCG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 22:06:58 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: hare@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that may have been removed.
Date: Sat, 16 Aug 2014 20:09:48 -0700
Message-Id: <1408244988-27456-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1408244988-27456-1-git-send-email-kys@microsoft.com>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host asks the guest to scan when a LUN is removed or added.
The only way a guest can identify the removed LUN is when an I/O is
attempted on a removed LUN - the SRB status code indicates that the LUN
is invalid. We currently handle this SRB status and remove the device.

Rather than waiting for an I/O to remove the device, force the discovery of
LUNs that may have been removed prior to discovering LUNs that may have
been added.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 02d1db6..fb38ca9 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -430,10 +430,36 @@ static void storvsc_host_scan(struct work_struct *work)
 {
 	struct storvsc_scan_work *wrk;
 	struct Scsi_Host *host;
+	struct scsi_device *sdev;
+	unsigned long flags;
 
 	wrk = container_of(work, struct storvsc_scan_work, work);
 	host = wrk->host;
 
+	/*
+	 * Before scanning the host, first check to see if any of the
+	 * currrently known devices have been hot removed. We issue a
+	 * "unit ready" command against all currently known devices.
+	 * This I/O will result in an error for devices that have been
+	 * removed. As part of handling the I/O error, we remove the device.
+	 *
+	 * When a LUN is added or removed, the host sends us a signal to
+	 * scan the host. Thus we are forced to discover the LUNs that
+	 * may have been removed this way.
+	 */
+	mutex_lock(&host->scan_mutex);
+	spin_lock_irqsave(host->host_lock, flags);
+	list_for_each_entry(sdev, &host->__devices, siblings) {
+		spin_unlock_irqrestore(host->host_lock, flags);
+		scsi_test_unit_ready(sdev, 1, 1, NULL);
+		spin_lock_irqsave(host->host_lock, flags);
+		continue;
+	}
+	spin_unlock_irqrestore(host->host_lock, flags);
+	mutex_unlock(&host->scan_mutex);
+	/*
+	 * Now scan the host to discover LUNs that may have been added.
+	 */
 	scsi_scan_host(host);
 
 	kfree(wrk);
-- 
1.7.4.1

