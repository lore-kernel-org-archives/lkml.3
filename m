Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbaF3MOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:14:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51970 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 072/181] lzo: properly check for overruns
Date: Mon, 30 Jun 2014 13:51:33 +0200
Message-Id: <8a3ee4e18e5b3def7f4645db4eb62ca3131cacb7.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 206a81c18401c0cde6e579164f752c4b147324ce upstream.

The lzo decompressor can, if given some really crazy data, possibly
overrun some variable types.  Modify the checking logic to properly
detect overruns before they happen.

Reported-by: "Don A. Bailey" <donb@securitymouse.com>
Tested-by: "Don A. Bailey" <donb@securitymouse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib/lzo/lzo1x_decompress_safe.c | 62 +++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_safe.c
index 569985d522d5..8563081e8da3 100644
--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -19,11 +19,31 @@
 #include <linux/lzo.h>
 #include "lzodefs.h"
 
-#define HAVE_IP(x)      ((size_t)(ip_end - ip) >= (size_t)(x))
-#define HAVE_OP(x)      ((size_t)(op_end - op) >= (size_t)(x))
-#define NEED_IP(x)      if (!HAVE_IP(x)) goto input_overrun
-#define NEED_OP(x)      if (!HAVE_OP(x)) goto output_overrun
-#define TEST_LB(m_pos)  if ((m_pos) < out) goto lookbehind_overrun
+#define HAVE_IP(t, x)					\
+	(((size_t)(ip_end - ip) >= (size_t)(t + x)) &&	\
+	 (((t + x) >= t) && ((t + x) >= x)))
+
+#define HAVE_OP(t, x)					\
+	(((size_t)(op_end - op) >= (size_t)(t + x)) &&	\
+	 (((t + x) >= t) && ((t + x) >= x)))
+
+#define NEED_IP(t, x)					\
+	do {						\
+		if (!HAVE_IP(t, x))			\
+			goto input_overrun;		\
+	} while (0)
+
+#define NEED_OP(t, x)					\
+	do {						\
+		if (!HAVE_OP(t, x))			\
+			goto output_overrun;		\
+	} while (0)
+
+#define TEST_LB(m_pos)					\
+	do {						\
+		if ((m_pos) < out)			\
+			goto lookbehind_overrun;	\
+	} while (0)
 
 int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 			  unsigned char *out, size_t *out_len)
@@ -58,14 +78,14 @@ int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 					while (unlikely(*ip == 0)) {
 						t += 255;
 						ip++;
-						NEED_IP(1);
+						NEED_IP(1, 0);
 					}
 					t += 15 + *ip++;
 				}
 				t += 3;
 copy_literal_run:
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-				if (likely(HAVE_IP(t + 15) && HAVE_OP(t + 15))) {
+				if (likely(HAVE_IP(t, 15) && HAVE_OP(t, 15))) {
 					const unsigned char *ie = ip + t;
 					unsigned char *oe = op + t;
 					do {
@@ -81,8 +101,8 @@ copy_literal_run:
 				} else
 #endif
 				{
-					NEED_OP(t);
-					NEED_IP(t + 3);
+					NEED_OP(t, 0);
+					NEED_IP(t, 3);
 					do {
 						*op++ = *ip++;
 					} while (--t > 0);
@@ -95,7 +115,7 @@ copy_literal_run:
 				m_pos -= t >> 2;
 				m_pos -= *ip++ << 2;
 				TEST_LB(m_pos);
-				NEED_OP(2);
+				NEED_OP(2, 0);
 				op[0] = m_pos[0];
 				op[1] = m_pos[1];
 				op += 2;
@@ -119,10 +139,10 @@ copy_literal_run:
 				while (unlikely(*ip == 0)) {
 					t += 255;
 					ip++;
-					NEED_IP(1);
+					NEED_IP(1, 0);
 				}
 				t += 31 + *ip++;
-				NEED_IP(2);
+				NEED_IP(2, 0);
 			}
 			m_pos = op - 1;
 			next = get_unaligned_le16(ip);
@@ -137,10 +157,10 @@ copy_literal_run:
 				while (unlikely(*ip == 0)) {
 					t += 255;
 					ip++;
-					NEED_IP(1);
+					NEED_IP(1, 0);
 				}
 				t += 7 + *ip++;
-				NEED_IP(2);
+				NEED_IP(2, 0);
 			}
 			next = get_unaligned_le16(ip);
 			ip += 2;
@@ -154,7 +174,7 @@ copy_literal_run:
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 		if (op - m_pos >= 8) {
 			unsigned char *oe = op + t;
-			if (likely(HAVE_OP(t + 15))) {
+			if (likely(HAVE_OP(t, 15))) {
 				do {
 					COPY8(op, m_pos);
 					op += 8;
@@ -164,7 +184,7 @@ copy_literal_run:
 					m_pos += 8;
 				} while (op < oe);
 				op = oe;
-				if (HAVE_IP(6)) {
+				if (HAVE_IP(6, 0)) {
 					state = next;
 					COPY4(op, ip);
 					op += next;
@@ -172,7 +192,7 @@ copy_literal_run:
 					continue;
 				}
 			} else {
-				NEED_OP(t);
+				NEED_OP(t, 0);
 				do {
 					*op++ = *m_pos++;
 				} while (op < oe);
@@ -181,7 +201,7 @@ copy_literal_run:
 #endif
 		{
 			unsigned char *oe = op + t;
-			NEED_OP(t);
+			NEED_OP(t, 0);
 			op[0] = m_pos[0];
 			op[1] = m_pos[1];
 			op += 2;
@@ -194,15 +214,15 @@ match_next:
 		state = next;
 		t = next;
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-		if (likely(HAVE_IP(6) && HAVE_OP(4))) {
+		if (likely(HAVE_IP(6, 0) && HAVE_OP(4, 0))) {
 			COPY4(op, ip);
 			op += t;
 			ip += t;
 		} else
 #endif
 		{
-			NEED_IP(t + 3);
-			NEED_OP(t);
+			NEED_IP(t, 3);
+			NEED_OP(t, 0);
 			while (t > 0) {
 				*op++ = *ip++;
 				t--;
-- 
2.0.0

