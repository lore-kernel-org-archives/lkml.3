Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbaJCWrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:47:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252AbaJCWYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.10 091/143] SCSI: libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu
Date: Fri,  3 Oct 2014 14:34:46 -0700
Message-Id: <20141003213317.232462546@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/libiscsi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -717,11 +717,21 @@ __iscsi_conn_send_pdu(struct iscsi_conn
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
 


