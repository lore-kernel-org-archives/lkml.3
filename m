Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaHDQzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:55:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56616 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matthew Wilcox" <matthew@wil.cx>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "James Bottomley" <JBottomley@Parallels.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.782701941@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 81/94] sym53c8xx_2: Set DID_REQUEUE return code when
 aborting squeue
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit fd1232b214af43a973443aec6a2808f16ee5bf70 upstream.

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
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index d92fe40..6b349e3 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -3000,7 +3000,11 @@ sym_dequeue_from_squeue(struct sym_hcb *np, int i, int target, int lun, int task
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

