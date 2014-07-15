Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbaGOVfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:35:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54292 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933725AbaGOVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:35:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 197/198] iscsi-target: Avoid rejecting incorrect ITT for Data-Out
Date: Tue, 15 Jul 2014 14:31:07 -0700
Message-Id: <1405459868-15089-198-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 97c99b47ac58bacb7c09e1f47d5d184434f6b06a upstream.

This patch changes iscsit_check_dataout_hdr() to dump the incoming
Data-Out payload when the received ITT is not associated with a
WRITE, instead of calling iscsit_reject_cmd() for the non WRITE
ITT descriptor.

This addresses a bug where an initiator sending an Data-Out for
an ITT associated with a READ would end up generating a reject
for the READ, eventually resulting in list corruption.

Reported-by: Santosh Kulkarni <santosh.kulkarni@calsoftinc.com>
Reported-by: Arshad Hussain <arshad.hussain@calsoftinc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 711dff4..6c727b9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1289,7 +1289,7 @@ iscsit_check_dataout_hdr(struct iscsi_conn *conn, unsigned char *buf,
 	if (cmd->data_direction != DMA_TO_DEVICE) {
 		pr_err("Command ITT: 0x%08x received DataOUT for a"
 			" NON-WRITE command.\n", cmd->init_task_tag);
-		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR, buf);
+		return iscsit_dump_data_payload(conn, payload_length, 1);
 	}
 	se_cmd = &cmd->se_cmd;
 	iscsit_mod_dataout_timer(cmd);
-- 
1.9.1

