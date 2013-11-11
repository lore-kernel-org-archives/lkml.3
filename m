Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3KKUtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:49:24 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41457 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3KKUtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:49:16 -0500
Date: Mon, 11 Nov 2013 12:48:53 -0800
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: [PATCH] x86, kaslr: mix entropy sources together as needed
Message-ID: <20131111204853.GA24459@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on availability, mix the RDRAND and RDTSC entropy together with
XOR. Only when neither is available should the i8254 be used. Update
the Kconfig documentation to reflect this. Additionally, since bits
used for entropy is masked elsewhere, drop the needless masking in the
get_random_long().

Finally, to improve the starting entropy, do a simple hashing of the
boot_params structure for some additional level of unpredictability.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig                |   14 +++++++----
 arch/x86/boot/compressed/aslr.c |   52 ++++++++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ee3b38363063..119455802d57 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1736,13 +1736,17 @@ config RANDOMIZE_BASE
 	   deters exploit attempts relying on knowledge of the location
 	   of kernel internals.
 
-	   Entropy is generated using the RDRAND instruction if it
-	   is supported.  If not, then RDTSC is used, if supported. If
-	   neither RDRAND nor RDTSC are supported, then no randomness
-	   is introduced.
+	   Entropy is generated using the RDRAND instruction if it is
+	   supported. If RDTSC is supported, it is used as well. If
+	   neither RDRAND nor RDTSC are supported, then randomness is
+	   read from the i8254 timer.
 
 	   The kernel will be offset by up to RANDOMIZE_BASE_MAX_OFFSET,
-	   and aligned according to PHYSICAL_ALIGN.
+	   and aligned according to PHYSICAL_ALIGN. Since the kernel is
+	   built using 2GiB addressing, and PHYSICAL_ALGIN must be at a
+	   minimum of 2MiB, only 10 bits of entropy is theoretically
+	   possible. At best, due to page table layouts, 64-bit can use
+	   9 bits of entropy and 32-bit uses 8 bits.
 
 config RANDOMIZE_BASE_MAX_OFFSET
 	hex "Maximum ASLR offset allowed"
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 05957986d123..41386b655acd 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -25,34 +25,56 @@ static inline u16 i8254(void)
 	return timer;
 }
 
+/* Simple way to create an alternate starting entropy. */
+static unsigned long get_boot_hash(void)
+{
+	int i;
+	unsigned long hash = 0;
+	unsigned long *ptr = (unsigned long *)real_mode;
+
+	for (i = 0; i < sizeof(*real_mode) / sizeof(hash); i++) {
+		/* Rotate and XOR */
+		hash = (hash << ((sizeof(hash) - 1) * 8)) | (hash >> 8);
+		hash ^= ptr[i];
+	}
+
+	return hash;
+}
+
 static unsigned long get_random_long(void)
 {
-	unsigned long random;
+	unsigned long random = get_boot_hash();
+	bool use_i8254 = true;
+
+	debug_putstr("KASLR using");
 
 	if (has_cpuflag(X86_FEATURE_RDRAND)) {
-		debug_putstr("KASLR using RDRAND...\n");
-		if (rdrand_long(&random))
-			return random;
+		unsigned long raw;
+
+		debug_putstr(" RDRAND");
+		if (rdrand_long(&raw)) {
+			random ^= raw;
+			use_i8254 = false;
+		}
 	}
 
 	if (has_cpuflag(X86_FEATURE_TSC)) {
 		uint32_t raw;
 
-		debug_putstr("KASLR using RDTSC...\n");
+		debug_putstr(" RDTSC");
 		rdtscl(raw);
 
-		/* Only use the low bits of rdtsc. */
-		random = raw & 0xffff;
-	} else {
-		debug_putstr("KASLR using i8254...\n");
-		random = i8254();
+		random ^= raw;
+		use_i8254 = false;
 	}
 
-	/* Extend timer bits poorly... */
-	random |= (random << 16);
-#ifdef CONFIG_X86_64
-	random |= (random << 32);
-#endif
+	if (use_i8254) {
+		debug_putstr(" i8254");
+		random ^= i8254();
+	}
+
+	debug_putstr("...\n");
+
 	return random;
 }
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
