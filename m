Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbaGPALW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:11:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822AbaGOXN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:13:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 3.10 34/44] Score: Implement the function csum_ipv6_magic
Date: Tue, 15 Jul 2014 16:17:32 -0700
Message-Id: <20140715231647.708322134@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231646.690728348@linuxfoundation.org>
References: <20140715231646.690728348@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennox Wu <lennox.wu@gmail.com>

commit 1ed62ca648557b884d117a4a8bbcf2ae4e2d1153 upstream.

Signed-off-by: Lennox Wu <lennox.wu@gmail.com>
Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/score/include/asm/checksum.h |   93 ++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 42 deletions(-)

--- a/arch/score/include/asm/checksum.h
+++ b/arch/score/include/asm/checksum.h
@@ -184,48 +184,57 @@ static inline __sum16 csum_ipv6_magic(co
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


