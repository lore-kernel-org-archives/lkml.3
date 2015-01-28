Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbbA2D1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:27:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46921 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783AbbA2CfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 033/139] scsi: correct return values for .eh_abort_handler implementations
Date: Wed, 28 Jan 2015 14:19:36 -0800
Message-Id: <1422483682-15393-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit b6c92b7e0af575e2b8b05bdf33633cf9e1661cbf upstream.

The .eh_abort_handler needs to return SUCCESS, FAILED, or
FAST_IO_FAIL. So fixup all callers to adhere to this requirement.

Reviewed-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/NCR5380.c            | 12 ++++++------
 drivers/scsi/aha1740.c            |  2 +-
 drivers/scsi/atari_NCR5380.c      |  2 +-
 drivers/scsi/esas2r/esas2r_main.c |  2 +-
 drivers/scsi/megaraid.c           |  8 ++++----
 drivers/scsi/sun3_NCR5380.c       | 10 +++++-----
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 1e9d6ad..7563b3d 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2655,14 +2655,14 @@ static void NCR5380_dma_complete(NCR5380_instance * instance) {
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
@@ -2712,7 +2712,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
  * aborted flag and get back into our main loop.
  */
 
-		return 0;
+		return SUCCESS;
 	}
 #endif
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 5f31017..31ace4b 100644
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
index 0f3cdbc..30073d4 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -2613,7 +2613,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
  *	host byte of the result field to, if zero DID_ABORTED is
  *	used.
  *
- * Returns : 0 - success, -1 on failure.
+ * Returns : SUCCESS - success, FAILED on failure.
  *
  * XXX - there is no way to abort the command that is currently
  *	 connected, you have to wait for it to complete.  If this is
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index f37f3e3..28fe6fe 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1057,7 +1057,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 		cmd->scsi_done(cmd);
 
-		return 0;
+		return SUCCESS;
 	}
 
 	spin_lock_irqsave(&a->queue_lock, flags);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 816db12..52587ce 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1967,7 +1967,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 	     cmd->device->id, cmd->device->lun);
 
 	if(list_empty(&adapter->pending_list))
-		return FALSE;
+		return FAILED;
 
 	list_for_each_safe(pos, next, &adapter->pending_list) {
 
@@ -1990,7 +1990,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					scb->idx);
 
-				return FALSE;
+				return FAILED;
 			}
 			else {
 
@@ -2015,12 +2015,12 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
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
index 636bbe0..fc57c8a 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2597,15 +2597,15 @@ static void NCR5380_reselect (struct Scsi_Host *instance)
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
1.9.1

