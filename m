Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaGGXxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:53:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaGGXxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.15 001/122] SCSI: use the scsi data buffer length to extract transfer size
Date: Mon,  7 Jul 2014 16:56:03 -0700
Message-Id: <20140707235734.280071211@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 5616b0a46ed82eb9a093f752fc4d7bd3cc688583 upstream.

Commit 8846bab180fa introduced a helper that can be used to query the
wire transfer size for a SCSI command taking protection information into
account.

However, some commands do not have a 1:1 mapping between the block range
they work on and the payload size (discard, write same). After the
scatterlist has been set up these requests use __data_len to store the
number of bytes to report completion on. This means that callers of
scsi_transfer_length() would get the wrong byte count for these types of
requests.

To overcome this we make scsi_transfer_length() use the scatterlist
length in the scsi_data_buffer as basis for the wire transfer
calculation instead of __data_len.

Reported-by: Christoph Hellwig <hch@infradead.org>
Debugged-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Fixes: d77e65350f2d82dfa0557707d505711f5a43c8fd
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/scsi/scsi_cmnd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -309,7 +309,7 @@ static inline void set_driver_byte(struc
 
 static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 {
-	unsigned int xfer_len = blk_rq_bytes(scmd->request);
+	unsigned int xfer_len = scsi_out(scmd)->length;
 	unsigned int prot_op = scsi_get_prot_op(scmd);
 	unsigned int sector_size = scmd->device->sector_size;
 


