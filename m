Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935103AbaGXKRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:17:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54796 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934395AbaGXJrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lennox Wu <lennox.wu@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 047/128] Score: Implement the function csum_ipv6_magic
Date: Thu, 24 Jul 2014 10:44:56 +0100
Message-Id: <1406195177-8656-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennox Wu <lennox.wu@gmail.com>

commit 1ed62ca648557b884d117a4a8bbcf2ae4e2d1153 upstream.

Signed-off-by: Lennox Wu <lennox.wu@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/score/include/asm/checksum.h | 93 +++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 42 deletions(-)

diff --git a/arch/score/include/asm/checksum.h b/arch/score/include/asm/checksum.h
index f909ac3144a4..961bd64015a8 100644
--- a/arch/score/include/asm/checksum.h
+++ b/arch/score/include/asm/checksum.h
@@ -184,48 +184,57 @@ static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 				__wsum sum)
 {
 	__asm__ __volatile__(
-		".set\tnoreorder\t\t\t# csum_ipv6_magic\n\t"
-		".set\tnoat\n\t"
-		"addu\t%0, %5\t\t\t# proto (long in network byte order)\n\t"
-		"sltu\t$1, %0, %5\n\t"
-		"addu\t%0, $1\n\t"
-		"addu\t%0, %6\t\t\t# csum\n\t"
-		"sltu\t$1, %0, %6\n\t"
-		"lw\t%1, 0(%2)\t\t\t# four words source address\n\t"
-		"addu\t%0, $1\n\t"
-		"addu\t%0, %1\n\t"
-		"sltu\t$1, %0, %1\n\t"
-		"lw\t%1, 4(%2)\n\t"
-		"addu\t%0, $1\n\t"
-		"addu\t%0, %1\n\t"
-		"sltu\t$1, %0, %1\n\t"
-		"lw\t%1, 8(%2)\n\t"
-		"addu\t%0, $1\n\t"
-		"addu\t%0, %1\n\t"
-		"sltu\t$1, %0, %1\n\t"
-		"lw\t%1, 12(%2)\n\t"
-		"addu\t%0, $1\n\t"
-		"addu\t%0, %1\n\t"
-		"sltu\t$1, %0, %1\n\t"
-		"lw\t%1, 0(%3)\n\t"
-		"addu\t%0, $1\n\t"
-		"addu\t%0, %1\n\t"
-		"sltu\t$1, %0, %1\n\t"
-		"lw\t%1, 4(%3)\n\t"
-		"addu\t%0, $1\n\t"
-		"addu\t%0, %1\n\t"
-		"sltu\t$1, %0, %1\n\t"
-		"lw\t%1, 8(%3)\n\t"
-		"addu\t%0, $1\n\t"
-		"addu\t%0, %1\n\t"
-		"sltu\t$1, %0, %1\n\t"
-		"lw\t%1, 12(%3)\n\t"
-		"addu\t%0, $1\n\t"
-		"addu\t%0, %1\n\t"
-		"sltu\t$1, %0, %1\n\t"
-		"addu\t%0, $1\t\t\t# Add final carry\n\t"
-		".set\tnoat\n\t"
-		".set\tnoreorder"
+		".set\tvolatile\t\t\t# csum_ipv6_magic\n\t"
+		"add\t%0, %0, %5\t\t\t# proto (long in network byte order)\n\t"
+		"cmp.c\t%5, %0\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0, %6\t\t\t# csum\n\t"
+		"cmp.c\t%6, %0\n\t"
+		"lw\t%1, [%2, 0]\t\t\t# four words source address\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0, %1\n\t"
+		"cmp.c\t%1, %0\n\t"
+		"1:lw\t%1, [%2, 4]\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0, %1\n\t"
+		"cmp.c\t%1, %0\n\t"
+		"lw\t%1, [%2,8]\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0, %1\n\t"
+		"cmp.c\t%1, %0\n\t"
+		"lw\t%1, [%2, 12]\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0,%1\n\t"
+		"cmp.c\t%1, %0\n\t"
+		"lw\t%1, [%3, 0]\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0, %1\n\t"
+		"cmp.c\t%1, %0\n\t"
+		"lw\t%1, [%3, 4]\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0, %1\n\t"
+		"cmp.c\t%1, %0\n\t"
+		"lw\t%1, [%3, 8]\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0, %1\n\t"
+		"cmp.c\t%1, %0\n\t"
+		"lw\t%1, [%3, 12]\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:add\t%0, %0, %1\n\t"
+		"cmp.c\t%1, %0\n\t"
+		"bleu 1f\n\t"
+		"addi\t%0, 0x1\n\t"
+		"1:\n\t"
+		".set\toptimize"
 		: "=r" (sum), "=r" (proto)
 		: "r" (saddr), "r" (daddr),
 		  "0" (htonl(len)), "1" (htonl(proto)), "r" (sum));
-- 
1.9.1

