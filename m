Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaDIBwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800AbaDIBwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:52:11 -0400
Date: Tue, 8 Apr 2014 21:52:05 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org
Subject: [PATCH] sym53c8xx_2: Set DID_REQUEUE return code when aborting
 squeue
Message-ID: <alpine.LRH.2.02.1404082146060.4864@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ the maintainer didn't respond, so I'm sending to Linus ]


This patch fixes I/O errors when the disk returns QUEUE FULL status.

When the controller encounters an error (including QUEUE FULL or BUSY status),
it aborts all not yet submitted requests in the function
sym_dequeue_from_squeue.

This function aborts them with DID_SOFT_ERROR.

If the disk has full tag queue, the request that caused the overflow is 
aborted with QUEUE FULL status (and the scsi midlayer properly retries it 
until it is accepted by the disk), but the sym53c8xx_2 driver aborts the 
following requests with DID_SOFT_ERROR --- for them, the midlayer does 
just a few retries and then signals the error up to sd.

The result is that disk returning QUEUE FULL causes request failures.

The error was reproduced on 53c895 with COMPAQ BD03685A24 disk (rebranded
ST336607LC) with command queue 48 or 64 tags. The disk has 64 tags, but
under some access patterns it return QUEUE FULL when there are less than
64 pending tags. The SCSI specification allows returning QUEUE FULL
anytime and it is up to the host to retry.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.36-rc5-fast/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- linux-2.6.36-rc5-fast.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-09-27 10:25:59.000000000 +0200
+++ linux-2.6.36-rc5-fast/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-09-27 10:26:27.000000000 +0200
@@ -3000,7 +3000,11 @@ sym_dequeue_from_squeue(struct sym_hcb *
 		if ((target == -1 || cp->target == target) &&
 		    (lun    == -1 || cp->lun    == lun)    &&
 		    (task   == -1 || cp->tag    == task)) {
+#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 			sym_set_cam_status(cp->cmd, DID_SOFT_ERROR);
+#else
+			sym_set_cam_status(cp->cmd, DID_REQUEUE);
+#endif
 			sym_remque(&cp->link_ccbq);
 			sym_insque_tail(&cp->link_ccbq, &np->comp_ccbq);
 		}
