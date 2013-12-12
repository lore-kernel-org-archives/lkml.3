Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab3LLJwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:52:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3LLJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:52:25 -0500
Date: Thu, 12 Dec 2013 01:51:51 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-be5e610c0fd6ef772cafb9e0bd4128134804aef3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] math64: Add mul_u64_u32_shr()
Git-Commit-ID: be5e610c0fd6ef772cafb9e0bd4128134804aef3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 12 Dec 2013 01:51:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be5e610c0fd6ef772cafb9e0bd4128134804aef3
Gitweb:     http://git.kernel.org/tip/be5e610c0fd6ef772cafb9e0bd4128134804aef3
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 18 Nov 2013 18:27:06 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 11 Dec 2013 15:52:34 +0100

math64: Add mul_u64_u32_shr()

Introduce mul_u64_u32_shr() as proposed by Andy a while back; it
allows using 64x64->128 muls on 64bit archs and recent GCC
which defines __SIZEOF_INT128__ and __int128.

(This new method will be used by the scheduler.)

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: fweisbec@gmail.com
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-hxjoeuzmrcaumR0uZwjpe2pv@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig       |  1 +
 include/linux/math64.h | 30 ++++++++++++++++++++++++++++++
 init/Kconfig           |  6 ++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e903c71..0952ecd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,6 +26,7 @@ config X86
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select ARCH_SUPPORTS_INT128 if X86_64
 	select ARCH_WANTS_PROT_NUMA_PROT_NONE
 	select HAVE_IDE
 	select HAVE_OPROFILE
diff --git a/include/linux/math64.h b/include/linux/math64.h
index 69ed5f5..c45c089 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -133,4 +133,34 @@ __iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
 	return ret;
 }
 
+#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+
+#ifndef mul_u64_u32_shr
+static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+{
+	return (u64)(((unsigned __int128)a * mul) >> shift);
+}
+#endif /* mul_u64_u32_shr */
+
+#else
+
+#ifndef mul_u64_u32_shr
+static inline u64 mul_u64_u32_shr(u64 a, u32 mul, unsigned int shift)
+{
+	u32 ah, al;
+	u64 ret;
+
+	al = a;
+	ah = a >> 32;
+
+	ret = ((u64)al * mul) >> shift;
+	if (ah)
+		ret += ((u64)ah * mul) << (32 - shift);
+
+	return ret;
+}
+#endif /* mul_u64_u32_shr */
+
+#endif
+
 #endif /* _LINUX_MATH64_H */
diff --git a/init/Kconfig b/init/Kconfig
index 79383d3..4e5d96a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -809,6 +809,12 @@ config GENERIC_SCHED_CLOCK
 config ARCH_SUPPORTS_NUMA_BALANCING
 	bool
 
+#
+# For architectures that know their GCC __int128 support is sound
+#
+config ARCH_SUPPORTS_INT128
+	bool
+
 # For architectures that (ab)use NUMA to represent different memory regions
 # all cpu-local but of different latencies, such as SuperH.
 #
