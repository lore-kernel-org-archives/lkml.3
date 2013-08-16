Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab3HPWxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:53:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51853 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab3HPWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 021/133] [SCSI] qla2xxx: Properly set the tagging for commands.
Date: Fri, 16 Aug 2013 15:32:43 -0700
Message-Id: <1376692475-28413-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

commit c3ccb1d7cf4c4549151876dd37c0944a682fd9e1 upstream.

This fixes a regression where Xyratex controllers and disks were lost by the
driver:

https://bugzilla.kernel.org/show_bug.cgi?id=59601

Reported-by: Jack Hill <jackhill@jackhill.us>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index a481684..01bb80f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -418,6 +418,8 @@ qla2x00_start_scsi(srb_t *sp)
 			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
 			break;
 		}
+	} else {
+		cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
 	}
 
 	/* Load SCSI command packet. */
@@ -1316,11 +1318,11 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 		    fcp_cmnd->task_attribute = TSK_ORDERED;
 		    break;
 		default:
-		    fcp_cmnd->task_attribute = 0;
+		    fcp_cmnd->task_attribute = TSK_SIMPLE;
 		    break;
 		}
 	} else {
-		fcp_cmnd->task_attribute = 0;
+		fcp_cmnd->task_attribute = TSK_SIMPLE;
 	}
 
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
@@ -1536,7 +1538,12 @@ qla24xx_start_scsi(srb_t *sp)
 		case ORDERED_QUEUE_TAG:
 			cmd_pkt->task = TSK_ORDERED;
 			break;
+		default:
+		    cmd_pkt->task = TSK_SIMPLE;
+		    break;
 		}
+	} else {
+		cmd_pkt->task = TSK_SIMPLE;
 	}
 
 	/* Load SCSI command packet. */
-- 
1.8.1.2

