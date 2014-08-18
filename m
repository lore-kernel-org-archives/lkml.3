Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaHRJfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:35:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42844 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaHRJfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Bottomley <JBottomley@Parallels.com>, Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 081/137] scsi: handle flush errors properly
Date: Mon, 18 Aug 2014 10:32:22 +0100
Message-Id: <1408354398-10226-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/scsi_lib.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 124392f3091e..96e537a8604d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -831,6 +831,14 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
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
-- 
1.9.1

