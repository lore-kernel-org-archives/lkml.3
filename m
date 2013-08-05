Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3HEN6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:58:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3HEN57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:57:59 -0400
Date: Mon, 5 Aug 2013 06:57:41 -0700
From: tip-bot for Jason Wang <tipbot@zytor.com>
Message-ID: <tip-96e39ac0e9d18020c8c5a41b64b8fe86c26575ab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jasowang@redhat.com, gleb@redhat.com, pbonzini@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, gleb@redhat.com, pbonzini@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1374742475-2485-1-git-send-email-jasowang@redhat.com>
References: <1374742475-2485-1-git-send-email-jasowang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/paravirt] x86: Introduce hypervisor_cpuid_base()
Git-Commit-ID: 96e39ac0e9d18020c8c5a41b64b8fe86c26575ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 05 Aug 2013 06:57:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96e39ac0e9d18020c8c5a41b64b8fe86c26575ab
Gitweb:     http://git.kernel.org/tip/96e39ac0e9d18020c8c5a41b64b8fe86c26575ab
Author:     Jason Wang <jasowang@redhat.com>
AuthorDate: Thu, 25 Jul 2013 16:54:32 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 5 Aug 2013 06:33:54 -0700

x86: Introduce hypervisor_cpuid_base()

This patch introduce hypervisor_cpuid_base() which loop test the hypervisor
existence function until the signature match and check the number of leaves if
required. This could be used by Xen/KVM guest to detect the existence of
hypervisor.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: http://lkml.kernel.org/r/1374742475-2485-1-git-send-email-jasowang@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

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
 
