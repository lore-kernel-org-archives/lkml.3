Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbbAIKrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:47:00 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44537 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757424AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 43/78] scsi: correct return values for .eh_abort_handler implementations
Date: Fri,  9 Jan 2015 11:31:52 +0100
Message-Id: <d9927e47772f49909075b62a3c1cffcee35a687c.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b6c92b7e0af575e2b8b05bdf33633cf9e1661cbf upstream.

The .eh_abort_handler needs to return SUCCESS, FAILED, or
FAST_IO_FAIL. So fixup all callers to adhere to this requirement.

Reviewed-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/NCR5380.c            | 12 ++++++------
 drivers/scsi/aha1740.c            |  2 +-
 drivers/scsi/atari_NCR5380.c      |  2 +-
 drivers/scsi/esas2r/esas2r_main.c |  2 +-
 drivers/scsi/megaraid.c           |  8 ++++----
 drivers/scsi/sun3_NCR5380.c       | 10 +++++-----
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 1e9d6ad9302b..7563b3d9cc76 100644
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
index 0f3cdbc80ba6..30073d43d87b 100644
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
index 4abf1272e1eb..5718b1febd57 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1057,7 +1057,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 		cmd->scsi_done(cmd);
 
-		return 0;
+		return SUCCESS;
 	}
 
 	spin_lock_irqsave(&a->queue_lock, flags);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 816db12ef5d5..52587ceac099 100644
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
index 636bbe0ea84c..fc57c8aec2b3 100644
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
2.2.1

