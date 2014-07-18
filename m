Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaGRNLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:11:30 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17554 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030671AbaGRNLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Matthew Wilcox <matthew@wil.cx>,
        James Bottomley <JBottomley@Parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 125/170] sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue
Date: Fri, 18 Jul 2014 14:12:10 +0200
Message-Id: <87aa8b9addd2fda5cff81ea099822831c225c86f.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/sym53c8xx_2/sym_hipd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index d92fe4037e94..6b349e301869 100644
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
-- 
2.0.0

