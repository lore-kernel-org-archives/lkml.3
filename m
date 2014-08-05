Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbaHESx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:53:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaHESOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Bottomley <JBottomley@Parallels.com>,
        Steven Haber <steven@qumulo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.15 12/42] scsi: handle flush errors properly
Date: Tue,  5 Aug 2014 11:13:26 -0700
Message-Id: <20140805181321.393391622@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit 89fb4cd1f717a871ef79fa7debbe840e3225cd54 upstream.

Flush commands don't transfer data and thus need to be special cased
in the I/O completion handler so that we can propagate errors to
the block layer and filesystem.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Reported-by: Steven Haber <steven@qumulo.com>
Tested-by: Steven Haber <steven@qumulo.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_lib.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -806,6 +806,14 @@ void scsi_io_completion(struct scsi_cmnd
 			scsi_next_command(cmd);
 			return;
 		}
+	} else if (blk_rq_bytes(req) == 0 && result && !sense_deferred) {
+		/*
+		 * Certain non BLOCK_PC requests are commands that don't
+		 * actually transfer anything (FLUSH), so cannot use
+		 * good_bytes != blk_rq_bytes(req) as the signal for an error.
+		 * This sets the error explicitly for the problem case.
+		 */
+		error = __scsi_error_from_host_byte(cmd, result);
 	}
 
 	/* no bidi support for !REQ_TYPE_BLOCK_PC yet */


