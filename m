Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3KKVgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:36:38 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37741 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3KKVgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:36:31 -0500
Date: Mon, 11 Nov 2013 13:36:19 -0800
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH v3] x86, kaslr: mix entropy sources together as needed
Message-ID: <20131111213619.GA3230@www.outflux.net>
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
used for entropy is masked elsewhere, drop the needless masking in
the get_random_long(). Similarly, use the entire TSC, not just the low
32 bits.

Finally, to improve the starting entropy, do a simple hashing of a
build-time versions string and the boot-time boot_params structure for
some additional level of unpredictability.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3:
 - do not limit ourself to the low 32 bits of TSC; Ingo Molnar.
v2:
 - added build-time string to add to starting entropy; Ingo Molnar.
---
 arch/x86/Kconfig                |   14 +++++---
 arch/x86/boot/compressed/aslr.c |   73 ++++++++++++++++++++++++++++++---------
 2 files changed, 65 insertions(+), 22 deletions(-)

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
index 05957986d123..0981227bc3f0 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -5,6 +5,17 @@
 #include <asm/archrandom.h>
 #include <asm/e820.h>
 
+#include <generated/compile.h>
+#include <linux/module.h>
+#include <linux/uts.h>
+#include <linux/utsname.h>
+#include <generated/utsrelease.h>
+#include <linux/version.h>
+
+/* Simplified build-specific string for starting entropy. */
+static const char *build_str = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
+		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
+
 #define I8254_PORT_CONTROL	0x43
 #define I8254_PORT_COUNTER0	0x40
 #define I8254_CMD_READBACK	0xC0
@@ -25,34 +36,62 @@ static inline u16 i8254(void)
 	return timer;
 }
 
+static unsigned long rotate_xor(unsigned long hash, const void *area,
+				size_t size)
+{
+	size_t i;
+	unsigned long *ptr = (unsigned long *)area;
+
+	for (i = 0; i < size / sizeof(hash); i++) {
+		/* Rotate and XOR */
+		hash = (hash << ((sizeof(hash) - 1) * 8)) | (hash >> 8);
+		hash ^= ptr[i];
+	}
+
+	return hash;
+}
+
+/* Attempt to create a simple but unpredictable starting entropy. */
+static unsigned long get_random_boot(void)
+{
+	unsigned long hash = 0;
+
+	hash = rotate_xor(hash, build_str, sizeof(build_str));
+	hash = rotate_xor(hash, real_mode, sizeof(*real_mode));
+
+	return hash;
+}
+
 static unsigned long get_random_long(void)
 {
-	unsigned long random;
+	unsigned long raw, random = get_random_boot();
+	bool use_i8254 = true;
+
+	debug_putstr("KASLR using");
 
 	if (has_cpuflag(X86_FEATURE_RDRAND)) {
-		debug_putstr("KASLR using RDRAND...\n");
-		if (rdrand_long(&random))
-			return random;
+		debug_putstr(" RDRAND");
+		if (rdrand_long(&raw)) {
+			random ^= raw;
+			use_i8254 = false;
+		}
 	}
 
 	if (has_cpuflag(X86_FEATURE_TSC)) {
-		uint32_t raw;
+		debug_putstr(" RDTSC");
+		rdtscll(raw);
 
-		debug_putstr("KASLR using RDTSC...\n");
-		rdtscl(raw);
+		random ^= raw;
+		use_i8254 = false;
+	}
 
-		/* Only use the low bits of rdtsc. */
-		random = raw & 0xffff;
-	} else {
-		debug_putstr("KASLR using i8254...\n");
-		random = i8254();
+	if (use_i8254) {
+		debug_putstr(" i8254");
+		random ^= i8254();
 	}
 
-	/* Extend timer bits poorly... */
-	random |= (random << 16);
-#ifdef CONFIG_X86_64
-	random |= (random << 32);
-#endif
+	debug_putstr("...\n");
+
 	return random;
 }
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
