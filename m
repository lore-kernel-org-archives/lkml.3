Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaKXSGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:06:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50052 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaKXSCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:02:36 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-88-547372bbe859
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
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v7 02/12] x86_64: load_percpu_segment: read
 irq_stack_union.gs_base before load_segment
Date: Mon, 24 Nov 2014 21:02:15 +0300
Message-id: <1416852146-9781-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xK7q7i4pDDG5dkbTY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0WLL9SYmi+cPH7JbTHjYxm4xbaO4xcruZjaL7c/eMlms
	7HzAanF51xw2i3tr/rNaXDqwgMli8ZHbzBbvnk1mtti8aSqzxdVVB9ktfmx4zOog6jF/50dG
	j52z7rJ7LNhU6rF4z0smj02rOtk8Nn2axO7R9fYKk8e7c+fYPU7M+M3i8eTKdCaPj09vsXi8
	33eVzaNvyypGj8+b5DxOtHxhDeCP4rJJSc3JLEst0rdL4Mpom3KavWAjd8XuTztYGxhvcXYx
	cnJICJhI9JyawAhhi0lcuLeerYuRi0NIYCmjxJLGtWAJIYE+JomJbX4gNpuAnsS/WdvZQGwR
	AV2JVc93MYM0MAucZZX482cXWEJYIFNi1cG9rCA2i4CqxOU/vewgNq+Aq0Tv2rtANRxA2+Qk
	tq7zBjE5Bdwkfjwtg9jbyCjRM2sz2wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcx
	QiLoyw7GxcesDjEKcDAq8fD+6CkMEWJNLCuuzD3EKMHBrCTCm5ZfHCLEm5JYWZValB9fVJqT
	WnyIkYmDU6qB0fLstvK36xXnrTQ0m94k/fOif8XRXIYzp/fYZ2lIx6/prcpiL9wuUuv3wujZ
	R2NfZ3aRrorZC7krL0Ry256dUbz6j5U+5/wZM851Tb68tnG7hZpBfN9bq660i6JM0ckhfH+2
	hrxm6O/0akqTuLlZs/xmAW/snSr7OXJ7v657PI3X9aGox6ZbSizFGYmGWsxFxYkAgN2gW34C	AAA=
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
index 8779d63..97f56f6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -389,8 +389,10 @@ void load_percpu_segment(int cpu)
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

