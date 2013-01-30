Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab3A3J0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:26:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab3A3J0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:26:24 -0500
From: Hannes Reinecke <hare@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stefan Weinhuber <wein@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/9] dasd: process all requests in the device tasklet
Date: Wed, 30 Jan 2013 10:26:13 +0100
Message-Id: <1359537979-39483-4-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1359537979-39483-1-git-send-email-hare@suse.de>
References: <1359537979-39483-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally the DASD device tasklet would process the entries on
the ccw_queue until the first non-final request was found.
Which was okay as long as all requests have the same retries and
expires parameter.
However, as we're now allowing to modify both it is possible to
have requests _after_ the first request which already have expired.
So we need to check all requests in the device tasklet.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/s390/block/dasd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 09ddf70..20b7517 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1778,11 +1778,11 @@ static void __dasd_device_process_ccw_queue(struct dasd_device *device,
 	list_for_each_safe(l, n, &device->ccw_queue) {
 		cqr = list_entry(l, struct dasd_ccw_req, devlist);
 
-		/* Stop list processing at the first non-final request. */
+		/* Skip any non-final request. */
 		if (cqr->status == DASD_CQR_QUEUED ||
 		    cqr->status == DASD_CQR_IN_IO ||
 		    cqr->status == DASD_CQR_CLEAR_PENDING)
-			break;
+			continue;
 		if (cqr->status == DASD_CQR_ERROR) {
 			__dasd_device_recovery(device, cqr);
 		}
-- 
1.7.4.2

