Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaK0QEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:04:46 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26919 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaK0QBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:01:25 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-7d-54774ad2c9bc
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v8 02/12] x86_64: load_percpu_segment: read
 irq_stack_union.gs_base before load_segment
Date: Thu, 27 Nov 2014 19:00:46 +0300
Message-id: <1417104057-20335-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xa7qXvMpDDM5+1LPY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0eL5w4fsFhMetrFbTNsobrGyu5nNYvuzt0wWKzsfsFpc
	3jWHzeLemv+sFpcOLGCyWHzkNrPFu2eTmS02b5rKbPFjw2NWB2GP+Ts/MnrsnHWX3WPBplKP
	xXteMnlsWtXJ5rHp0yR2j663V5g83p07x+5xYsZvFo8nV6YzeXx8eovF4/2+q2wefVtWMXp8
	3iTncaLlC2sAfxSXTUpqTmZZapG+XQJXRv+PjWwFG7kr9l/uYmlgvMXZxcjJISFgIjH7xykW
	CFtM4sK99WxdjFwcQgJLGSW2LtrNCOH0MUkc+X6dEaSKTUBP4t+s7WwgtoiArsSq57uYuxg5
	OJgFmlklvoqChIUFMiUaP6wAG8oioCpx8HwfmM0r4CbRc2oOE0i5hICcxNZ13iBhTgF3ifbz
	36BWNTFKtLRfY5nAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRki0fNnBuPiY1SFG
	AQ5GJR7ehMdlIUKsiWXFlbmHGCU4mJVEeJtsy0OEeFMSK6tSi/Lji0pzUosPMTJxcEo1MDpM
	ehfr7KtuIPVuh3lU2upLU4oT7l1UeXNgp2PSc/Pzb8xNY3eEbTf+e3bZQudvJzydd7DUzpzv
	ejSPeeG+7R8lxGYvj1B3WPF3+cvu3SwtSu78EmW3fUNOs3z3CmkueFD1c0L4HzEXFrEtjs3F
	31MX8nTVrw452LUq1X6iuqOTsSXftfK4E0osxRmJhlrMRcWJADGppmJ0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading irq_stack_union.gs_base after load_segment creates troubles for kasan.
Compiler inserts __asan_load in between load_segment and wrmsrl. If kernel
built with stackprotector this will result in boot failure because __asan_load
has stackprotector.

To avoid this irq_stack_union.gs_base stored to temporary variable before
load_segment, so __asan_load will be called before load_segment().

There are two alternative ways to fix this:
 a) Add __attribute__((no_sanitize_address)) to load_percpu_segment(),
    which tells compiler to not instrument this function. However this
    will result in build failure with CONFIG_KASAN=y and CONFIG_OPTIMIZE_INLINING=y.

 b) Add -fno-stack-protector for mm/kasan/kasan.c

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/x86/kernel/cpu/common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5475f67..1291d69 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -391,8 +391,10 @@ void load_percpu_segment(int cpu)
 #ifdef CONFIG_X86_32
 	loadsegment(fs, __KERNEL_PERCPU);
 #else
+	void *gs_base = per_cpu(irq_stack_union.gs_base, cpu);
+
 	loadsegment(gs, 0);
-	wrmsrl(MSR_GS_BASE, (unsigned long)per_cpu(irq_stack_union.gs_base, cpu));
+	wrmsrl(MSR_GS_BASE, (unsigned long)gs_base);
 #endif
 	load_stack_canary_segment();
 }
-- 
2.1.3

