Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab3DYVzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:55:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53057 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759836Ab3DYVza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:55:30 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5/6] x86: kaslr: select memory region from e820 maps
Date: Thu, 25 Apr 2013 14:54:19 -0700
Message-Id: <1366926860-26776-6-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366926860-26776-1-git-send-email-keescook@chromium.org>
References: <1366926860-26776-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This chooses the largest contiguous RAM region for the KASLR offset
to live in.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c |   43 +++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 11a91c6..8f21ebe 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -1,6 +1,7 @@
 #include "misc.h"
 
 #ifdef CONFIG_RANDOMIZE_BASE
+#include <asm/e820.h>
 
 #include <asm/archrandom.h>
 static inline int rdrand(unsigned long *v)
@@ -56,28 +57,58 @@ static unsigned long get_random_long(void)
 	return 0;
 }
 
+int largest_ram_region(unsigned long *start, unsigned long *size)
+{
+	int i, rc = 0;
+
+	*size = 0;
+	for (i = 0; i < real_mode->e820_entries; i++) {
+		struct e820entry *entry = &real_mode->e820_map[i];
+
+		if (entry->type != E820_RAM)
+			continue;
+
+		if (entry->size > *size) {
+			*size = entry->size;
+			*start = entry->addr;
+			rc = 1;
+		}
+	}
+	return rc;
+}
+
 unsigned char *choose_kernel_location(unsigned char *hint, unsigned long size)
 {
 	unsigned char *choice = hint;
 	unsigned long random, mask;
+	unsigned long addr, length;
 
 	if (cmdline_find_option_bool("noaslr")) {
 		debug_putstr("KASLR disabled...\n");
 		goto out;
 	}
 
+	/* Find an appropriate E820 entry. */
+	if (!largest_ram_region(&addr, &length)) {
+		debug_putstr("KASLR could not find suitable E820 region...\n");
+		goto out;
+	}
+
 	random = get_random_long();
 
-	/* Clip off top of the range. */
+	/* XXX: Rework page tables to handle arbitrary physical location. */
 	mask = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1;
 	random &= mask;
 
-	/* XXX: Find an appropriate E820 hole, instead of adding hint. */
-	random += (unsigned long)hint;
+	/* Clip to E820 entry size. */
+	while (random > length)
+		random >>= 1;
+
+	/* Offset the target. */
+	random += addr;
 
-	/* XXX: Clip to E820 hole, instead of just using hint. */
-	mask = (unsigned long)hint + CONFIG_RANDOMIZE_BASE_MAX_OFFSET;
-	while (random + size > mask)
+	/* Clip end to E820 entry size. */
+	while (random + size > addr + length)
 		random >>= 1;
 
 	/* Clip off bottom of range (via alignment). */
-- 
1.7.9.5

