Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3IEU2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:28:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab3IEU23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 28/36] iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject
Date: Thu,  5 Sep 2013 13:27:57 -0700
Message-Id: <20130905202705.610439965@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1536,6 +1536,10 @@ int iscsit_handle_nop_out(struct iscsi_c
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
@@ -1545,6 +1549,10 @@ int iscsit_handle_nop_out(struct iscsi_c
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


