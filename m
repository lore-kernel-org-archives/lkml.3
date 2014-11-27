Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaK0JCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:02:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:42128 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbaK0Is3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:48:29 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <JBottomley@Parallels.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 50/91] libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu
Date: Thu, 27 Nov 2014 16:42:33 +0800
Message-Id: <1417077794-9299-50-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/scsi/libiscsi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4..1243d2f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -718,11 +718,21 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
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

