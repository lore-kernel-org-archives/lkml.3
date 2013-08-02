Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab3HBKRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:17:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3HBKRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:17:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Hill <jackhill@jackhill.us>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 06/39] SCSI: qla2xxx: Properly set the tagging for commands.
Date: Fri,  2 Aug 2013 18:18:16 +0800
Message-Id: <20130802101457.676693498@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_iocb.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -423,6 +423,8 @@ qla2x00_start_scsi(srb_t *sp)
 			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
 			break;
 		}
+	} else {
+		cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
 	}
 
 	/* Load SCSI command packet. */
@@ -1331,11 +1333,11 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp
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
@@ -1541,7 +1543,12 @@ qla24xx_start_scsi(srb_t *sp)
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


