Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab3KLHJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:09:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3KLHJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:09:50 -0500
Date: Mon, 11 Nov 2013 23:09:35 -0800
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-a653f3563c51c7bb7de63d607bef09d3baddaeb8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de
In-Reply-To: <20131111222839.GA28616@www.outflux.net>
References: <20131111222839.GA28616@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, kaslr:
  Mix entropy sources together as needed
Git-Commit-ID: a653f3563c51c7bb7de63d607bef09d3baddaeb8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 11 Nov 2013 23:09:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a653f3563c51c7bb7de63d607bef09d3baddaeb8
Gitweb:     http://git.kernel.org/tip/a653f3563c51c7bb7de63d607bef09d3baddaeb8
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Mon, 11 Nov 2013 14:28:39 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 11 Nov 2013 22:29:44 -0800

x86, kaslr: Mix entropy sources together as needed

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
Link: http://lkml.kernel.org/r/20131111222839.GA28616@www.outflux.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig                | 14 +++++---
 arch/x86/boot/compressed/aslr.c | 73 +++++++++++++++++++++++++++++++----------
 2 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 51f4399..596cd9e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1735,13 +1735,17 @@ config RANDOMIZE_BASE
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
index 0595798..8746487 100644
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
+		/* Rotate by odd number of bits and XOR. */
+		hash = (hash << ((sizeof(hash) * 8) - 7)) | (hash >> 7);
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
 
