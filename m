Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaLPULf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:11:35 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:50317
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbaLPULK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:11:10 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/4] Drivers: scsi: storvsc: Force SPC-3 compliance on win8 and win8 r2 hosts
Date: Tue, 16 Dec 2014 13:21:45 -0800
Message-Id: <1418764905-11250-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1418764905-11250-1-git-send-email-kys@microsoft.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On win8 and win8 r2 hosts force SPC-3 compliance for MSFT virtual disks.
Ubuntu has been carrying a similar patch outside the tree for a while now.
Starting with win10, the host will support SPC-3 compliance. Based on all
the testing that has been done on win8 and win8 r2 hosts, we are comfortable
claiming SPC-3 compliance on these hosts as well. This will enable TRIM
support on these hosts.

Suggested by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index fdc5164..7487e07 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1468,6 +1468,19 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	 */
 	sdevice->sdev_bflags |= msft_blist_flags;
 
+	/*
+	 * If the host is WIN8 or WIN8 R2, claim conformance to SPC-3
+	 * if the device is a MSFT virtual device.
+	 */
+	if (!strncmp(sdevice->vendor, "Msft", 4)) {
+		switch (vmbus_proto_version) {
+		case VERSION_WIN8:
+		case VERSION_WIN8_1:
+			sdevice->scsi_level = SCSI_SPC_3;
+			break;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.4.1

