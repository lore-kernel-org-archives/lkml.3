Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab3APQbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:31:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36415 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab3APQHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 150/222] inet_diag: validate port comparison byte code to prevent unsafe reads
Date: Wed, 16 Jan 2013 13:55:50 -0200
Message-Id: <1358351822-7675-151-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

commit 5e1f54201cb481f40a04bc47e1bc8c093a189e23 upstream.

Add logic to verify that a port comparison byte code operation
actually has the second inet_diag_bc_op from which we read the port
for such operations.

Previously the code blindly referenced op[1] without first checking
whether a second inet_diag_bc_op struct could fit there. So a
malicious user could make the kernel read 4 bytes beyond the end of
the bytecode array by claiming to have a whole port comparison byte
code (2 inet_diag_bc_op structs) when in fact the bytecode was not
long enough to hold both.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/inet_diag.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 5d57af1..232560a 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -548,6 +548,17 @@ static bool valid_hostcond(const struct inet_diag_bc_op *op, int len,
 	return true;
 }
 
+/* Validate a port comparison operator. */
+static inline bool valid_port_comparison(const struct inet_diag_bc_op *op,
+					 int len, int *min_len)
+{
+	/* Port comparisons put the port in a follow-on inet_diag_bc_op. */
+	*min_len += sizeof(struct inet_diag_bc_op);
+	if (len < *min_len)
+		return false;
+	return true;
+}
+
 static int inet_diag_bc_audit(const void *bytecode, int bytecode_len)
 {
 	const void *bc = bytecode;
@@ -563,24 +574,30 @@ static int inet_diag_bc_audit(const void *bytecode, int bytecode_len)
 		case INET_DIAG_BC_D_COND:
 			if (!valid_hostcond(bc, len, &min_len))
 				return -EINVAL;
-			/* fall through */
-		case INET_DIAG_BC_AUTO:
+			break;
 		case INET_DIAG_BC_S_GE:
 		case INET_DIAG_BC_S_LE:
 		case INET_DIAG_BC_D_GE:
 		case INET_DIAG_BC_D_LE:
-		case INET_DIAG_BC_JMP:
-			if (op->no < min_len || op->no > len + 4 || op->no & 3)
-				return -EINVAL;
-			if (op->no < len &&
-			    !valid_cc(bytecode, bytecode_len, len - op->no))
+			if (!valid_port_comparison(bc, len, &min_len))
 				return -EINVAL;
 			break;
+		case INET_DIAG_BC_AUTO:
+		case INET_DIAG_BC_JMP:
 		case INET_DIAG_BC_NOP:
 			break;
 		default:
 			return -EINVAL;
 		}
+
+		if (op->code != INET_DIAG_BC_NOP) {
+			if (op->no < min_len || op->no > len + 4 || op->no & 3)
+				return -EINVAL;
+			if (op->no < len &&
+			    !valid_cc(bytecode, bytecode_len, len - op->no))
+				return -EINVAL;
+		}
+
 		if (op->yes < min_len || op->yes > len + 4 || op->yes & 3)
 			return -EINVAL;
 		bc  += op->yes;
-- 
1.7.9.5

