Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaFCLmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:42:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43647 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbaFCLmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 086/138] iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
Date: Tue,  3 Jun 2014 12:38:52 +0100
Message-Id: <1401795584-22664-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 173094aa1a21..9c3852720bd1 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1591,7 +1591,9 @@ int iscsit_process_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
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

