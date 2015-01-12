Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbbALTM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:12:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbbALSFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 027/216] scsi: correct return values for .eh_abort_handler implementations
Date: Mon, 12 Jan 2015 18:02:24 +0000
Message-Id: <1421085933-32536-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit b6c92b7e0af575e2b8b05bdf33633cf9e1661cbf upstream.

The .eh_abort_handler needs to return SUCCESS, FAILED, or
FAST_IO_FAIL. So fixup all callers to adhere to this requirement.

Reviewed-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/NCR5380.c            | 12 ++++++------
 drivers/scsi/aha1740.c            |  2 +-
 drivers/scsi/atari_NCR5380.c      |  2 +-
 drivers/scsi/esas2r/esas2r_main.c |  2 +-
 drivers/scsi/megaraid.c           |  8 ++++----
 drivers/scsi/sun3_NCR5380.c       | 10 +++++-----
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 93d13fc9a293..a3d06ae2a631 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2646,14 +2646,14 @@ static void NCR5380_dma_complete(NCR5380_instance * instance) {
  *
  * Purpose : abort a command
  *
- * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the 
- *      host byte of the result field to, if zero DID_ABORTED is 
+ * Inputs : cmd - the Scsi_Cmnd to abort, code - code to set the
+ *      host byte of the result field to, if zero DID_ABORTED is
  *      used.
  *
- * Returns : 0 - success, -1 on failure.
+ * Returns : SUCCESS - success, FAILED on failure.
  *
- *	XXX - there is no way to abort the command that is currently 
- *	connected, you have to wait for it to complete.  If this is 
+ *	XXX - there is no way to abort the command that is currently
+ *	connected, you have to wait for it to complete.  If this is
  *	a problem, we could implement longjmp() / setjmp(), setjmp()
  *	called where the loop started in NCR5380_main().
  *
@@ -2703,7 +2703,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
  * aborted flag and get back into our main loop.
  */
 
-		return 0;
+		return SUCCESS;
 	}
 #endif
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 5f3101797c93..31ace4bef8fe 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -531,7 +531,7 @@ static int aha1740_eh_abort_handler (Scsi_Cmnd *dummy)
  * quiet as possible...
  */
 
-	return 0;
+	return SUCCESS;
 }
 
 static struct scsi_host_template aha1740_template = {
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 1814aa20b724..cccc98d674b1 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -2603,7 +2603,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
  *	host byte of the result field to, if zero DID_ABORTED is
  *	used.
  *
- * Returns : 0 - success, -1 on failure.
+ * Returns : SUCCESS - success, FAILED on failure.
  *
  * XXX - there is no way to abort the command that is currently
  *	 connected, you have to wait for it to complete.  If this is
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 6504a195c874..45aa684f8b74 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1057,7 +1057,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 		cmd->scsi_done(cmd);
 
-		return 0;
+		return SUCCESS;
 	}
 
 	spin_lock_irqsave(&a->queue_lock, flags);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index b7770516f4c2..716c3c05fc7c 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1945,7 +1945,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 	     cmd->device->id, cmd->device->lun);
 
 	if(list_empty(&adapter->pending_list))
-		return FALSE;
+		return FAILED;
 
 	list_for_each_safe(pos, next, &adapter->pending_list) {
 
@@ -1968,7 +1968,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					scb->idx);
 
-				return FALSE;
+				return FAILED;
 			}
 			else {
 
@@ -1993,12 +1993,12 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 				list_add_tail(SCSI_LIST(cmd),
 						&adapter->completed_list);
 
-				return TRUE;
+				return SUCCESS;
 			}
 		}
 	}
 
-	return FALSE;
+	return FAILED;
 }
 
 static inline int
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 88220794cc98..85e2292ba151 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2587,15 +2587,15 @@ static void NCR5380_reselect (struct Scsi_Host *instance)
  * Purpose : abort a command
  *
  * Inputs : cmd - the struct scsi_cmnd to abort, code - code to set the
- * 	host byte of the result field to, if zero DID_ABORTED is 
+ *	host byte of the result field to, if zero DID_ABORTED is
  *	used.
  *
- * Returns : 0 - success, -1 on failure.
+ * Returns : SUCCESS - success, FAILED on failure.
  *
- * XXX - there is no way to abort the command that is currently 
- * 	 connected, you have to wait for it to complete.  If this is 
+ * XXX - there is no way to abort the command that is currently
+ *	 connected, you have to wait for it to complete.  If this is
  *	 a problem, we could implement longjmp() / setjmp(), setjmp()
- * 	 called where the loop started in NCR5380_main().
+ *	 called where the loop started in NCR5380_main().
  */
 
 static int NCR5380_abort(struct scsi_cmnd *cmd)
-- 
2.1.4

