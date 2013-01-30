Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3A3J1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:27:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab3A3J0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:26:25 -0500
From: Hannes Reinecke <hare@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stefan Weinhuber <wein@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/9] dasd: Reduce amount of messages for specific errors
Date: Wed, 30 Jan 2013 10:26:15 +0100
Message-Id: <1359537979-39483-6-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1359537979-39483-1-git-send-email-hare@suse.de>
References: <1359537979-39483-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever a request has been aborted internally by the driver
there is no sense data to be had. And printing lots of messages
stalls the system, so better to print out a short one-liner.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/s390/block/dasd_erp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/s390/block/dasd_erp.c b/drivers/s390/block/dasd_erp.c
index d01ef82..908b9a0 100644
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
1.7.4.2

