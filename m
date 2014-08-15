Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaHONAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:00:38 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60189 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaHONAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:00:37 -0400
From: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        George Spelvin <linux@horizon.com>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
Subject: [PATCH 1/1] GCD: add binary GCD algorithm
Date: Fri, 15 Aug 2014 20:49:16 +0800
Message-Id: <1408106956-12986-1-git-send-email-zhaoxiu.zeng@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because some architectures (alpha, armv6, etc.) don't provide hardware division,
the mod operation is slow! Binary GCD algorithm uses simple arithmetic operations,
it replaces division with arithmetic shifts, comparisons, and subtraction.

Signed-off-by: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
---
 lib/Kconfig | 15 +++++++++++++++
 lib/gcd.c   | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index a5ce0c7..80e8e54 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -177,6 +177,21 @@ config CRC8
 	  when they need to do cyclic redundancy check according CRC8
 	  algorithm. Module will be called crc8.
 
+#
+# GCD
+#
+choice
+	prompt "GCD implementation"
+	default GCD_ALGO_EUCLIDEAN
+
+config GCD_ALGO_EUCLIDEAN
+	bool "Euclidean algorithm"
+
+config GCD_ALGO_BINARY
+	bool "Binary GCD algorithm (Stein's algorithm)"
+
+endchoice
+
 config AUDIT_GENERIC
 	bool
 	depends on AUDIT && !AUDIT_ARCH
diff --git a/lib/gcd.c b/lib/gcd.c
index 3657f12..911ec7f 100644
--- a/lib/gcd.c
+++ b/lib/gcd.c
@@ -6,7 +6,7 @@
 unsigned long gcd(unsigned long a, unsigned long b)
 {
 	unsigned long r;
-
+#ifdef CONFIG_GCD_ALGO_EUCLIDEAN
 	if (a < b)
 		swap(a, b);
 
@@ -16,6 +16,35 @@ unsigned long gcd(unsigned long a, unsigned long b)
 		a = b;
 		b = r;
 	}
+#else
+	r = a | b;
+
+	if (!a || !b)
+		return r;
+
+	r = r ^ (r - 1);
+	if (!(a & r))
+		goto even_odd; /* a/c even, b/c odd */
+	if (!(b & r))
+		goto odd_even; /* a/c odd, b/c even */
+
+	/* a/c and b/c both odd */
+	while (a != b) {
+		if (a > b) {
+			a -= b;
+even_odd:
+			do
+				a >>= 1;
+			while (!(a & r));
+		} else {
+			b -= a;
+odd_even:
+			do
+				b >>= 1;
+			while (!(b & r));
+		}
+	}
+#endif
 	return b;
 }
 EXPORT_SYMBOL_GPL(gcd);
-- 
1.9.3

