Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030403AbaLLOoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:44:08 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:55495 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968078AbaLLOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:44:04 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] lib: string_get_size: Use 32 bit arithmetic when possible
Date: Fri, 12 Dec 2014 15:43:47 +0100
Message-Id: <1418395428-25980-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418395428-25980-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418395428-25980-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remainder from do_div is always a u32, and after size has been
reduced to be below 1000 (or 1024), it certainly fits in u32. So both
remainder and sf_cap can be made u32s, the format specifiers can be
simplified (%lld wasn't the right thing to use for _unsigned_ long
long anyway), and we can replace a do_div with an ordinary 32/32 bit
division.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/string_helpers.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 0d25f7aa732c..2b3757f84b3b 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -42,7 +42,7 @@ int string_get_size(u64 size, const enum string_size_units units,
 		[STRING_UNITS_2] = 1024,
 	};
 	int i, j;
-	u64 remainder = 0, sf_cap;
+	u32 remainder = 0, sf_cap;
 	char tmp[8];
 
 	tmp[0] = '\0';
@@ -59,14 +59,13 @@ int string_get_size(u64 size, const enum string_size_units units,
 
 		if (j) {
 			remainder *= 1000;
-			do_div(remainder, divisor[units]);
-			snprintf(tmp, sizeof(tmp), ".%03lld",
-				 (unsigned long long)remainder);
+			remainder /= divisor[units];
+			snprintf(tmp, sizeof(tmp), ".%03u", remainder);
 			tmp[j+1] = '\0';
 		}
 	}
 
-	snprintf(buf, len, "%lld%s %s", (unsigned long long)size,
+	snprintf(buf, len, "%u%s %s", (u32)size,
 		 tmp, units_str[units][i]);
 
 	return 0;
-- 
2.1.3

