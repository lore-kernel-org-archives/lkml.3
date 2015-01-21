Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbbAUT1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:27:06 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34997 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbbAUT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:26:57 -0500
From: Anshul Garg <aksgarg1989@gmail.com>
X-Google-Original-From: Anshul Garg
To: akpm@linux-foundation.org, levex@linux.com, felipe.contreras@gmail.com,
        linux-kernel@vger.kernel.org
Cc: aksgarg1989@gmail.com, anshul.g@samsung.com
Subject: [PATCH] lib/kstrtox.c break if overflow is detected
Date: Wed, 21 Jan 2015 11:26:26 -0800
Message-Id: <1421868386-77010-1-git-send-email-aksgarg1989@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <aksgarg1989@gmail.com>
References: <aksgarg1989@gmail.com>
X-Antivirus: avast! (VPS 150121-0, 01/21/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anshul Garg <aksgarg1989@gmail.com>

1. While converting string representation to integer
break the loop if overflow is detected.
2. Clean kstrtoll function

Signed-off-by: Anshul Garg <aksgarg1989@gmail.com>
---
 lib/kstrtox.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index ec8da78..8cbe5ca 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -70,8 +70,10 @@ unsigned int _parse_integer(const char *s, unsigned int base, unsigned long long
 		 * it in the max base we support (16)
 		 */
 		if (unlikely(res & (~0ull << 60))) {
-			if (res > div_u64(ULLONG_MAX - val, base))
+			if (res > div_u64(ULLONG_MAX - val, base)) {
 				overflow = 1;
+				break;
+			}
 		}
 		res = res * base + val;
 		rv++;
@@ -146,23 +148,19 @@ EXPORT_SYMBOL(kstrtoull);
 int kstrtoll(const char *s, unsigned int base, long long *res)
 {
 	unsigned long long tmp;
-	int rv;
+	int rv, sign = 1;
 
 	if (s[0] == '-') {
-		rv = _kstrtoull(s + 1, base, &tmp);
-		if (rv < 0)
-			return rv;
-		if ((long long)(-tmp) >= 0)
-			return -ERANGE;
-		*res = -tmp;
-	} else {
-		rv = kstrtoull(s, base, &tmp);
-		if (rv < 0)
-			return rv;
-		if ((long long)tmp < 0)
-			return -ERANGE;
-		*res = tmp;
+		sign = -1;
+		s++;
 	}
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if ((long long)tmp < 0)
+		return -ERANGE;
+	*res = sign * tmp;
 	return 0;
 }
 EXPORT_SYMBOL(kstrtoll);
-- 
1.7.9.5


---
This email has been checked for viruses by Avast antivirus software.
http://www.avast.com

