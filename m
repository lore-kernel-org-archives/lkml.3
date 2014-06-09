Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936490AbaFIJ25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:28:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936424AbaFIJ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:37 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 117/146] iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
Date: Mon,  9 Jun 2014 10:50:52 +0200
Message-Id: <62f64757ef8f757a22e8fedcf5d4ee1e08dc5b79.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b47c2be1c427..004e484a71cd 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1579,7 +1579,9 @@ int iscsit_process_nop_out(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
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
1.9.3

