Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab3HMQDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:03:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab3HMP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:36 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=A6n_5wyJnRsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=u3yN8GNwfVYA:10 a=WTJdmG3rAAAA:8 a=ZUspVpn8AAAA:8 a=VwQbUJbxAAAA:8 a=z11f-joXAAAA:8 a=iYejp6s0V8yalAAUDJ8A:9 a=nsF78Xlgl7EA:10 a=GkFi8FPdP50A:10 a=CJVq-v20pXUA:10 a=jeBq3FmKZ4MA:10 a=hcM400ZAzD76oYkf:21 a=hok6I01T-b44ucXc:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155829.114867252@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roland Dreier <roland@purestorage.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [35/88] tcm_qla2xxx: Fix residual for underrun commands that fail
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0035-tcm_qla2xxx-Fix-residual-for-underrun-commands-that-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

[ Upstream commit b5aff3d2747bea08b386edd070941a45611ffe51 ]

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
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7fa0672..bda062d 100644
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
1.7.10.4


