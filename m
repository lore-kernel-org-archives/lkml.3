Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3F1S5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:57:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab3F1S5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roland Dreier <roland@purestorage.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 048/105] tcm_qla2xxx: Fix residual for underrun commands that fail
Date: Fri, 28 Jun 2013 11:51:10 -0700
Message-Id: <1372445527-24414-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index d182c96..0c58bd1 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -688,8 +688,12 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
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
-- 
1.8.1.2

