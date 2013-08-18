Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3HRXwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 19:52:23 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:32897 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab3HRXwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 19:52:10 -0400
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 4/4] iser-target: Updates for login negotiation multi-plexing support
Date: Sun, 18 Aug 2013 23:36:25 +0000
Message-Id: <1376868985-23190-5-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376868985-23190-1-git-send-email-nab@linux-iscsi.org>
References: <1376868985-23190-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates iser-target code to support login negotiation
multi-plexing.  This includes only using isert_conn->conn_login_comp
for the first login request PDU, pushing the subsequent processing
to iscsi_conn->login_work -> iscsi_target_do_login_rx(), and turning
isert_get_login_rx() into a NOP.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 3f62041..d17ff13 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -869,7 +869,14 @@ isert_rx_login_req(struct iser_rx_desc *rx_desc, int rx_buflen,
 		 size, rx_buflen, MAX_KEY_VALUE_PAIRS);
 	memcpy(login->req_buf, &rx_desc->data[0], size);
 
-	complete(&isert_conn->conn_login_comp);
+	if (login->first_request) {
+		complete(&isert_conn->conn_login_comp);
+		return;
+	}
+	if (test_and_set_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags))
+		return;
+
+	schedule_delayed_work(&conn->login_work, 0);
 }
 
 static void
@@ -2224,6 +2231,14 @@ isert_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
 	int ret;
 
 	pr_debug("isert_get_login_rx before conn_login_comp conn: %p\n", conn);
+	/*
+	 * For login requests after the first PDU, isert_rx_login_req() will
+	 * kick schedule_delayed_work(&conn->login_work) as the packet is
+	 * received, which turns this callback from iscsi_target_do_login_rx()
+	 * into a NOP.
+	 */
+	if (!login->first_request)
+		return 0;
 
 	ret = wait_for_completion_interruptible(&isert_conn->conn_login_comp);
 	if (ret)
-- 
1.7.2.5

