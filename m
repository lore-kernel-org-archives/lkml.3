Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838AbaGOVfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:35:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933801AbaGOVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:35:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 194/198] iscsi-target: Explicily clear login response PDU in exception path
Date: Tue, 15 Jul 2014 14:31:04 -0700
Message-Id: <1405459868-15089-195-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 5477eca..ffa0eba 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1296,6 +1296,8 @@ int iscsit_tx_login_rsp(struct iscsi_conn *conn, u8 status_class, u8 status_deta
 	login->login_failed = 1;
 	iscsit_collect_login_stats(conn, status_class, status_detail);
 
+	memset(&login->rsp[0], 0, ISCSI_HDR_LEN);
+
 	hdr	= (struct iscsi_login_rsp *)&login->rsp[0];
 	hdr->opcode		= ISCSI_OP_LOGIN_RSP;
 	hdr->status_class	= status_class;
-- 
1.9.1

