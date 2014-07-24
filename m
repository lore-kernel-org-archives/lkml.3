Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935112AbaGXKTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:19:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934274AbaGXJrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 039/128] iscsi-target: Avoid rejecting incorrect ITT for Data-Out
Date: Thu, 24 Jul 2014 10:44:48 +0100
Message-Id: <1406195177-8656-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a5825ea2488e..5283359ef299 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1317,7 +1317,7 @@ iscsit_check_dataout_hdr(struct iscsi_conn *conn, unsigned char *buf,
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

