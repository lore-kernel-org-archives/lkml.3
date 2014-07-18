Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030803AbaGRNSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:18:09 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17941 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933787AbaGRNSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 010/170] iscsi-target: Explicily clear login response PDU in exception path
Date: Fri, 18 Jul 2014 14:10:15 +0200
Message-Id: <c411d69a1d72adbc882373daa209952210e97bbd.1405685481.git.jslaby@suse.cz>
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

commit 683497566d48f86e04d026de1ee658dd74fc1077 upstream.

This patch adds a explicit memset to the login response PDU
exception path in iscsit_tx_login_rsp().

This addresses a regression bug introduced in commit baa4d64b
where the initiator would end up not receiving the login
response and associated status class + detail, before closing
the login connection.

Reported-by: Christophe Vu-Brugier <cvubrugier@yahoo.fr>
Tested-by: Christophe Vu-Brugier <cvubrugier@yahoo.fr>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/target/iscsi/iscsi_target_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 1039de499bc6..658c9c77ec04 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1294,6 +1294,8 @@ int iscsit_tx_login_rsp(struct iscsi_conn *conn, u8 status_class, u8 status_deta
 	login->login_failed = 1;
 	iscsit_collect_login_stats(conn, status_class, status_detail);
 
+	memset(&login->rsp[0], 0, ISCSI_HDR_LEN);
+
 	hdr	= (struct iscsi_login_rsp *)&login->rsp[0];
 	hdr->opcode		= ISCSI_OP_LOGIN_RSP;
 	hdr->status_class	= status_class;
-- 
2.0.0

