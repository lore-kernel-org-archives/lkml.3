Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030902AbaGDWoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:44:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031129AbaGDWU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:20:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christophe Vu-Brugier <cvubrugier@yahoo.fr>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 03/46] iscsi-target: Explicily clear login response PDU in exception path
Date: Fri,  4 Jul 2014 15:19:07 -0700
Message-Id: <20140704221602.426008703@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_util.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1288,6 +1288,8 @@ int iscsit_tx_login_rsp(struct iscsi_con
 	login->login_failed = 1;
 	iscsit_collect_login_stats(conn, status_class, status_detail);
 
+	memset(&login->rsp[0], 0, ISCSI_HDR_LEN);
+
 	hdr	= (struct iscsi_login_rsp *)&login->rsp[0];
 	hdr->opcode		= ISCSI_OP_LOGIN_RSP;
 	hdr->status_class	= status_class;


