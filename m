Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967065AbaFQVwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:52:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966997AbaFQVwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 131/212] iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
Date: Tue, 17 Jun 2014 14:43:45 -0700
Message-Id: <1403041506-13646-132-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 7cbfcc953789ff864c2bf8365a82a3fba4869649 upstream.

This patch changes an incorrect use of BUG_ON to instead generate a
REJECT + PROTOCOL_ERROR in iscsit_process_nop_out() code.  This case
can occur with traditional TCP where a flood of zeros in the data
stream can reach this block for what is presumed to be a NOP-OUT with
a solicited reply, but without a valid iscsi_cmd pointer.

This incorrect BUG_ON was introduced during the v3.11-rc timeframe
with the following commit:

commit 778de368964c5b7e8100cde9f549992d521e9c89
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Fri Jun 14 16:07:47 2013 -0700

    iscsi/isert-target: Refactor ISCSI_OP_NOOP RX handling

Reported-by: Arshad Hussain <arshad.hussain@calsoftinc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 55e5a03..9ab2b91 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1564,7 +1564,9 @@ int iscsit_process_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	 * Initiator is expecting a NopIN ping reply..
 	 */
 	if (hdr->itt != RESERVED_ITT) {
-		BUG_ON(!cmd);
+		if (!cmd)
+			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
+						(unsigned char *)hdr);
 
 		spin_lock_bh(&conn->cmd_lock);
 		list_add_tail(&cmd->i_conn_node, &conn->conn_cmd_list);
-- 
1.9.1

