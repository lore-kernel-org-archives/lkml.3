Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3ILSTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:19:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab3ILSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 04/16] iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject
Date: Thu, 12 Sep 2013 11:14:56 -0700
Message-Id: <20130912181156.693793385@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 28aaa950320fc7b8df3f6d2d34fa7833391a9b72 upstream.

This patch addresses a potential NULL pointer dereference regression in
iscsit_setup_nop_out() code, specifically for two cases when a solicited
NOPOUT triggers a ISCSI_REASON_PROTOCOL_ERROR reject to be generated.

This is because iscsi_cmd is expected to be NULL for solicited NOPOUT
case before iscsit_process_nop_out() locates the descriptor via TTT
using iscsit_find_cmd_from_ttt().

This regression was originally introduced in:

commit ba159914086f06532079fc15141f46ffe7e04a41
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed Jul 3 03:48:24 2013 -0700

    iscsi-target: Fix iscsit_add_reject* usage for iser

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1522,6 +1522,10 @@ int iscsit_setup_nop_out(struct iscsi_co
 	if (hdr->itt == RESERVED_ITT && !(hdr->opcode & ISCSI_OP_IMMEDIATE)) {
 		pr_err("NOPOUT ITT is reserved, but Immediate Bit is"
 			" not set, protocol error.\n");
+		if (!cmd)
+			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
+						 (unsigned char *)hdr);
+
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR,
 					 (unsigned char *)hdr);
 	}
@@ -1531,6 +1535,10 @@ int iscsit_setup_nop_out(struct iscsi_co
 			" greater than MaxXmitDataSegmentLength: %u, protocol"
 			" error.\n", payload_length,
 			conn->conn_ops->MaxXmitDataSegmentLength);
+		if (!cmd)
+			return iscsit_add_reject(conn, ISCSI_REASON_PROTOCOL_ERROR,
+						 (unsigned char *)hdr);
+
 		return iscsit_reject_cmd(cmd, ISCSI_REASON_PROTOCOL_ERROR,
 					 (unsigned char *)hdr);
 	}


