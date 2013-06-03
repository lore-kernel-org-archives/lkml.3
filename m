Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab3FCPEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:04:51 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:42446 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758623Ab3FCPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:04:22 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Stefan Weinhuber <wein@de.ibm.com>
Subject: [PATCH 5/9] dasd: Reduce amount of messages for specific errors
Date: Mon,  3 Jun 2013 17:03:18 +0200
Message-Id: <1370271802-30019-6-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
References: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060314-5024-0000-0000-000006396336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Whenever a request has been aborted internally by the driver
there is no sense data to be had. And printing lots of messages
stalls the system, so better to print out a short one-liner.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/s390/block/dasd_erp.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/s390/block/dasd_erp.c b/drivers/s390/block/dasd_erp.c
index 3250cb4..8d11f77 100644
--- a/drivers/s390/block/dasd_erp.c
+++ b/drivers/s390/block/dasd_erp.c
@@ -159,6 +159,14 @@ dasd_log_sense(struct dasd_ccw_req *cqr, struct irb *irb)
 	struct dasd_device *device;
 
 	device = cqr->startdev;
+	if (cqr->intrc == -ETIMEDOUT) {
+		dev_err(&device->cdev->dev, "cqr %p timeout error", cqr);
+		return;
+	}
+	if (cqr->intrc == -ENOLINK) {
+		dev_err(&device->cdev->dev, "cqr %p transport error", cqr);
+		return;
+	}
 	/* dump sense data */
 	if (device->discipline && device->discipline->dump_sense)
 		device->discipline->dump_sense(device, cqr, irb);
-- 
1.7.9.5

