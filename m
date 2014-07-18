Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161212AbaGRNRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:17:12 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17905 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965827AbaGRNRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:17:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 009/170] iscsi-target: Avoid rejecting incorrect ITT for Data-Out
Date: Fri, 18 Jul 2014 14:10:14 +0200
Message-Id: <aec80fa7f28ed7e28e1799aac6a25ad31f51d1d4.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index f99162542df2..d2ff40680208 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1305,7 +1305,7 @@ iscsit_check_dataout_hdr(struct iscsi_conn *conn, unsigned char *buf,
 	if (cmd->data_direction != DMA_TO_DEVICE) {
 		pr_err("Command ITT: 0x%08x received DataOUT for a"
 			" NON-WRITE command.\n", cmd->init_task_tag);
-		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR, buf);
+		return iscsit_dump_data_payload(conn, payload_length, 1);
 	}
 	se_cmd = &cmd->se_cmd;
 	iscsit_mod_dataout_timer(cmd);
-- 
2.0.0

