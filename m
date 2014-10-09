Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbaJIVJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbaJIVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 110/163] [SCSI] libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu
Date: Thu,  9 Oct 2014 14:02:15 -0700
Message-Id: <1412888588-26755-111-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit db9bfd64b14a3a8f1868d2164518fdeab1b26ad1 upstream.

This patches fixes a potential buffer overrun in __iscsi_conn_send_pdu.
This function is used by iscsi drivers and userspace to send iscsi PDUs/
commands. For login commands, we have a set buffer size. For all other
commands we do not support data buffers.

This was reported by Dan Carpenter here:
http://www.spinics.net/lists/linux-scsi/msg66838.html

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/libiscsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e399561..b69b233 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -717,11 +717,21 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			return NULL;
 		}
 
+		if (data_size > ISCSI_DEF_MAX_RECV_SEG_LEN) {
+			iscsi_conn_printk(KERN_ERR, conn, "Invalid buffer len of %u for login task. Max len is %u\n", data_size, ISCSI_DEF_MAX_RECV_SEG_LEN);
+			return NULL;
+		}
+
 		task = conn->login_task;
 	} else {
 		if (session->state != ISCSI_STATE_LOGGED_IN)
 			return NULL;
 
+		if (data_size != 0) {
+			iscsi_conn_printk(KERN_ERR, conn, "Can not send data buffer of len %u for op 0x%x\n", data_size, opcode);
+			return NULL;
+		}
+
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
-- 
1.9.1

