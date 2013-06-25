Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3FYSzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:55:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3FYSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 87/95] tcm_qla2xxx: Fix residual for underrun commands that fail
Date: Tue, 25 Jun 2013 11:33:14 -0700
Message-Id: <20130625182203.464726177@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit b5aff3d2747bea08b386edd070941a45611ffe51 upstream.

Suppose an initiator sends a DATA IN command with an allocation length
shorter than the FC transfer length -- we get a target message like

    TARGET_CORE[qla2xxx]: Expected Transfer Length: 256 does not match SCSI CDB Length: 0 for SAM Opcode: 0x12

In that case, the target core adjusts the data_length and sets
se_cmd->residual_count for the underrun.  But now suppose that command
fails and we end up in tcm_qla2xxx_queue_status() -- that function
unconditionally overwrites residual_count with the already adjusted
data_length, and the initiator will burp with a message like

    qla2xxx [0000:00:06.0]-301d:0: Dropped frame(s) detected (0x100 of 0x100 bytes).

Fix this by adding on to the existing underflow residual count instead.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -688,8 +688,12 @@ static int tcm_qla2xxx_queue_status(stru
 		 * For FCP_READ with CHECK_CONDITION status, clear cmd->bufflen
 		 * for qla_tgt_xmit_response LLD code
 		 */
+		if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
+			se_cmd->se_cmd_flags &= ~SCF_OVERFLOW_BIT;
+			se_cmd->residual_count = 0;
+		}
 		se_cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-		se_cmd->residual_count = se_cmd->data_length;
+		se_cmd->residual_count += se_cmd->data_length;
 
 		cmd->bufflen = 0;
 	}


