Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaF1SCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:02:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbaF1RxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.15 098/139] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Sat, 28 Jun 2014 10:47:39 -0700
Message-Id: <20140628174609.886972401@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 8846bab180fa2bcfe02d4ba5288fbaba12c8f4f3 upstream.

In case protection information exists on the wire
scsi transports should include it in the transfer
byte count (even if protection information does not
exist in the host memory space). This helper will
compute the total transfer length from the scsi
command data length and protection attributes.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/scsi/scsi_cmnd.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
+#include <scsi/scsi_device.h>
 
 struct Scsi_Host;
 struct scsi_device;
@@ -306,4 +307,20 @@ static inline void set_driver_byte(struc
 	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
 }
 
+static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
+{
+	unsigned int xfer_len = blk_rq_bytes(scmd->request);
+	unsigned int prot_op = scsi_get_prot_op(scmd);
+	unsigned int sector_size = scmd->device->sector_size;
+
+	switch (prot_op) {
+	case SCSI_PROT_NORMAL:
+	case SCSI_PROT_WRITE_STRIP:
+	case SCSI_PROT_READ_INSERT:
+		return xfer_len;
+	}
+
+	return xfer_len + (xfer_len >> ilog2(sector_size)) * 8;
+}
+
 #endif /* _SCSI_SCSI_CMND_H */


