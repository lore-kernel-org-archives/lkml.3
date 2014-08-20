Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaHTLoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:44:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58865 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 007/104] scsi: handle flush errors properly
Date: Wed, 20 Aug 2014 13:42:30 +0200
Message-Id: <ca519c15876ef6cdb6ccede7fc6832868ee09494.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <JBottomley@Parallels.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 89fb4cd1f717a871ef79fa7debbe840e3225cd54 upstream.

Flush commands don't transfer data and thus need to be special cased
in the I/O completion handler so that we can propagate errors to
the block layer and filesystem.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Reported-by: Steven Haber <steven@qumulo.com>
Tested-by: Steven Haber <steven@qumulo.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/scsi_lib.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1549b74e2d1..ad43b987bc57 100644
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
2.0.4

