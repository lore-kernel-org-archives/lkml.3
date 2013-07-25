Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3GYJGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:06:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab3GYJFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:05:42 -0400
From: Jason Wang <jasowang@redhat.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: [PATCH V2 1/4] x86: introduce hypervisor_cpuid_base()
Date: Thu, 25 Jul 2013 16:54:32 +0800
Message-Id: <1374742475-2485-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce hypervisor_cpuid_base() which loop test the hypervisor
existence function until the signature match and check the number of leaves if
required. This could be used by Xen/KVM guest to detect the existence of
hypervisor.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- use memcpy() and uint32_t instead of strcmp()
---
 arch/x86/include/asm/processor.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 24cf5ae..7763307 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -971,6 +971,21 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
 	return ratio;
 }
 
+static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
+{
+	uint32_t base, eax, signature[3];
+
+	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
+		cpuid(base, &eax, &signature[0], &signature[1], &signature[2]);
+
+		if (!memcmp(sig, signature, 12) &&
+		    (leaves == 0 || ((eax - base) >= leaves)))
+			return base;
+	}
+
+	return 0;
+}
+
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
-- 
1.7.1

