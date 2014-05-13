Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbaEMJ6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:58:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60836 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760080AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 075/182] iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug
Date: Tue, 13 May 2014 11:27:07 +0200
Message-Id: <45a659d832cacddb605a0c82758cebc96840b820.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d444edc679e7713412f243b792b1f964e5cff1e1 upstream.

This patch fixes a long-standing bug in iscsit_build_conn_drop_async_message()
where during ERL=2 connection recovery, a bogus conn_p pointer could
end up being used to send the ISCSI_OP_ASYNC_EVENT + DROPPING_CONNECTION
notifying the initiator that cmd->logout_cid has failed.

The bug was manifesting itself as an OOPs in iscsit_allocate_cmd() with
a bogus conn_p pointer in iscsit_build_conn_drop_async_message().

Reported-by: Arshad Hussain <arshad.hussain@calsoftinc.com>
Reported-by: santosh kulkarni <santosh.kulkarni@calsoftinc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b5e574659785..b47c2be1c427 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2476,6 +2476,7 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
 {
 	struct iscsi_cmd *cmd;
 	struct iscsi_conn *conn_p;
+	bool found = false;
 
 	/*
 	 * Only send a Asynchronous Message on connections whos network
@@ -2484,11 +2485,12 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
 	list_for_each_entry(conn_p, &conn->sess->sess_conn_list, conn_list) {
 		if (conn_p->conn_state == TARG_CONN_STATE_LOGGED_IN) {
 			iscsit_inc_conn_usage_count(conn_p);
+			found = true;
 			break;
 		}
 	}
 
-	if (!conn_p)
+	if (!found)
 		return;
 
 	cmd = iscsit_allocate_cmd(conn_p, GFP_ATOMIC);
-- 
1.9.3

