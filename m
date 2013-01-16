Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab3APQbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:31:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab3APQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 148/222] inet_diag: validate byte code to prevent oops in inet_diag_bc_run()
Date: Wed, 16 Jan 2013 13:55:48 -0200
Message-Id: <1358351822-7675-149-git-send-email-herton.krzesinski@canonical.com>
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

commit 405c005949e47b6e91359159c24753519ded0c67 upstream.

Add logic to validate INET_DIAG_BC_S_COND and INET_DIAG_BC_D_COND
operations.

Previously we did not validate the inet_diag_hostcond, address family,
address length, and prefix length. So a malicious user could make the
kernel read beyond the end of the bytecode array by claiming to have a
whole inet_diag_hostcond when the bytecode was not long enough to
contain a whole inet_diag_hostcond of the given address family. Or
they could make the kernel read up to about 27 bytes beyond the end of
a connection address by passing a prefix length that exceeded the
length of addresses of the given family.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/inet_diag.c |   48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index d780fca..efeca3b 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -504,6 +504,44 @@ static int valid_cc(const void *bc, int len, int cc)
 	return 0;
 }
 
+/* Validate an inet_diag_hostcond. */
+static bool valid_hostcond(const struct inet_diag_bc_op *op, int len,
+			   int *min_len)
+{
+	int addr_len;
+	struct inet_diag_hostcond *cond;
+
+	/* Check hostcond space. */
+	*min_len += sizeof(struct inet_diag_hostcond);
+	if (len < *min_len)
+		return false;
+	cond = (struct inet_diag_hostcond *)(op + 1);
+
+	/* Check address family and address length. */
+	switch (cond->family) {
+	case AF_UNSPEC:
+		addr_len = 0;
+		break;
+	case AF_INET:
+		addr_len = sizeof(struct in_addr);
+		break;
+	case AF_INET6:
+		addr_len = sizeof(struct in6_addr);
+		break;
+	default:
+		return false;
+	}
+	*min_len += addr_len;
+	if (len < *min_len)
+		return false;
+
+	/* Check prefix length (in bits) vs address length (in bytes). */
+	if (cond->prefix_len > 8 * addr_len)
+		return false;
+
+	return true;
+}
+
 static int inet_diag_bc_audit(const void *bytecode, int bytecode_len)
 {
 	const void *bc = bytecode;
@@ -511,18 +549,22 @@ static int inet_diag_bc_audit(const void *bytecode, int bytecode_len)
 
 	while (len > 0) {
 		const struct inet_diag_bc_op *op = bc;
+		int min_len = sizeof(struct inet_diag_bc_op);
 
 //printk("BC: %d %d %d {%d} / %d\n", op->code, op->yes, op->no, op[1].no, len);
 		switch (op->code) {
-		case INET_DIAG_BC_AUTO:
 		case INET_DIAG_BC_S_COND:
 		case INET_DIAG_BC_D_COND:
+			if (!valid_hostcond(bc, len, &min_len))
+				return -EINVAL;
+			/* fall through */
+		case INET_DIAG_BC_AUTO:
 		case INET_DIAG_BC_S_GE:
 		case INET_DIAG_BC_S_LE:
 		case INET_DIAG_BC_D_GE:
 		case INET_DIAG_BC_D_LE:
 		case INET_DIAG_BC_JMP:
-			if (op->no < 4 || op->no > len + 4 || op->no & 3)
+			if (op->no < min_len || op->no > len + 4 || op->no & 3)
 				return -EINVAL;
 			if (op->no < len &&
 			    !valid_cc(bytecode, bytecode_len, len - op->no))
@@ -533,7 +575,7 @@ static int inet_diag_bc_audit(const void *bytecode, int bytecode_len)
 		default:
 			return -EINVAL;
 		}
-		if (op->yes < 4 || op->yes > len + 4 || op->yes & 3)
+		if (op->yes < min_len || op->yes > len + 4 || op->yes & 3)
 			return -EINVAL;
 		bc  += op->yes;
 		len -= op->yes;
-- 
1.7.9.5

