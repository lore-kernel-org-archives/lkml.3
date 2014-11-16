Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaKPWH4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:07:56 -0500
Received: from 1wt.eu ([62.212.114.60]:47954 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaKPWBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:07 -0500
Message-Id: <20141116215329.226860291@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:42 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>
Subject: [ 14/48] sym53c8xx_2: Set DID_REQUEUE return code when aborting
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 squeue

From: Mikulas Patocka <mpatocka@redhat.com>

Hi

This is backport of commit fd1232b214af43a973443aec6a2808f16ee5bf70. It is
suitable for all stable branches up to and including 3.14.*

Mikulas

commit fd1232b214af43a973443aec6a2808f16ee5bf70
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Tue Apr 8 21:52:05 2014 -0400

    sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

    This patch fixes I/O errors with the sym53c8xx_2 driver when the disk
    returns QUEUE FULL status.

    When the controller encounters an error (including QUEUE FULL or BUSY
    status), it aborts all not yet submitted requests in the function
    sym_dequeue_from_squeue.

    This function aborts them with DID_SOFT_ERROR.

    If the disk has full tag queue, the request that caused the overflow is
    aborted with QUEUE FULL status (and the scsi midlayer properly retries
    it until it is accepted by the disk), but the sym53c8xx_2 driver aborts
    the following requests with DID_SOFT_ERROR --- for them, the midlayer
    does just a few retries and then signals the error up to sd.

    The result is that disk returning QUEUE FULL causes request failures.

    The error was reproduced on 53c895 with COMPAQ BD03685A24 disk
    (rebranded ST336607LC) with command queue 48 or 64 tags.  The disk has
    64 tags, but under some access patterns it return QUEUE FULL when there
    are less than 64 pending tags.  The SCSI specification allows returning
    QUEUE FULL anytime and it is up to the host to retry.

    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Cc: Matthew Wilcox <matthew@wil.cx>
    Cc: James Bottomley <JBottomley@Parallels.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 297deb8..3bbc10b 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -3003,7 +3003,11 @@ sym_dequeue_from_squeue(struct sym_hcb *np, int i, int target, int lun, int task
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
-- 
1.7.12.2.21.g234cd45.dirty



