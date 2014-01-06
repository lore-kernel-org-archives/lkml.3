Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbaAFWmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:42:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbaAFWl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 120/129] arm64: virt: ensure visibility of __boot_cpu_mode
Date: Mon,  6 Jan 2014 14:39:09 -0800
Message-Id: <20140106223903.027778160@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 82b2f495fba338d1e3098dde1df54944a9c19751 upstream.

Secondary CPUs write to __boot_cpu_mode with caches disabled, and thus a
cached value of __boot_cpu_mode may be incoherent with that in memory.
This could lead to a failure to detect mismatched boot modes.

This patch adds flushing to ensure that writes by secondaries to
__boot_cpu_mode are made visible before we test against it.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/virt.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -21,6 +21,7 @@
 #define BOOT_CPU_MODE_EL2	(0x0e12b007)
 
 #ifndef __ASSEMBLY__
+#include <asm/cacheflush.h>
 
 /*
  * __boot_cpu_mode records what mode CPUs were booted in.
@@ -36,9 +37,20 @@ extern u32 __boot_cpu_mode[2];
 void __hyp_set_vectors(phys_addr_t phys_vector_base);
 phys_addr_t __hyp_get_vectors(void);
 
+static inline void sync_boot_mode(void)
+{
+	/*
+	 * As secondaries write to __boot_cpu_mode with caches disabled, we
+	 * must flush the corresponding cache entries to ensure the visibility
+	 * of their writes.
+	 */
+	__flush_dcache_area(__boot_cpu_mode, sizeof(__boot_cpu_mode));
+}
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
+	sync_boot_mode();
 	return (__boot_cpu_mode[0] == BOOT_CPU_MODE_EL2 &&
 		__boot_cpu_mode[1] == BOOT_CPU_MODE_EL2);
 }
@@ -46,6 +58,7 @@ static inline bool is_hyp_mode_available
 /* Check if the bootloader has booted CPUs in different modes */
 static inline bool is_hyp_mode_mismatched(void)
 {
+	sync_boot_mode();
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
 }
 


