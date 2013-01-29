Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3A2BdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:33:18 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:59098
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342Ab3A2BdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:33:16 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
Date: Mon, 28 Jan 2013 19:30:33 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Santos <daniel.santos@pobox.com>, Borislav Petkov <bp@alien8.de>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Woodhouse <David.Woodhouse@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC] arm: use built-in byte swap function
Message-ID: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the compiler intrinsic for byte swapping on arch ARM.  This
allows the compiler to detect and be able to optimize out byte
swappings, e.g. in big endian to big endian moves.

AFAICT, arm gcc got __builtin_bswap{32,64} support in 4.6,
and for the 16-bit version in 4.8.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
akin to: http://comments.gmane.org/gmane.linux.kernel.cross-arch/16016

based on linux-next.  Depends on commit "compiler-gcc{3,4}.h: Use
GCC_VERSION macro" by Daniel Santos <daniel.santos@pobox.com>,
currently in the akpm branch.

RFC because of unfamiliarity with arch ARM, and that at91sam9rl,
at91rm9200, and lpd270 (so far, at least) builds fail with:

include/uapi/linux/swab.h:60: undefined reference to `__bswapsi2'

I'm using eldk-5.2.1/armv7a's arm-linux-gnueabi-gcc (GCC) 4.6.4
20120303 (prerelease)

 arch/arm/Kconfig              |    1 +
 include/linux/compiler-gcc4.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index eda8711..437d11a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -3,6 +3,7 @@ config ARM
 	default y
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT if MMU
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 68b162d..da5f728 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -67,7 +67,8 @@
 
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
-#if GCC_VERSION >= 40400
+#if (!defined(__arm__) && GCC_VERSION >= 40400) || \
+    (defined(__arm__) && GCC_VERSION >= 40600)
 #define __HAVE_BUILTIN_BSWAP32__
 #define __HAVE_BUILTIN_BSWAP64__
 #endif
-- 
1.7.9.7


