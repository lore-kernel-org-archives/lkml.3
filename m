Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaJ0Qro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:47:44 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35421 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaJ0Qrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:47:42 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-db-544e772c1dca
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
Subject: [PATCH v5 03/12] x86_64: load_percpu_segment: read
 irq_stack_union.gs_base before load_segment
Date: Mon, 27 Oct 2014 19:46:50 +0300
Message-id: <1414428419-17860-4-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xa7o65X4hBvM7hSy2/XrEZvF770xW
	iznr17BZHLn2nd3i+rc3jBafXj5gtNhyvYnJ4vnDh+wWEx62sVtM2yhusbK7mc1i+7O3TBYr
	Ox+wWlzeNYfN4t6a/6wWlw4sYLJYfOQ2s8W7Z5OZLTZvmspscXXVQXaLHxseszqIeszf+ZHR
	Y+esu+weCzaVeize85LJY9OqTjaPTZ8msXt0vb3C5PHu3Dl2jxMzfrN4PLkyncnj49NbLB7v
	911l8+jbsorR4/MmOY8TLV9YA/ijuGxSUnMyy1KL9O0SuDKu9Z1jLdjIXXGyMa6B8RZnFyMn
	h4SAicSN6V2MELaYxIV769m6GLk4hASWMkq0vXjFBOH0MUk8nfecCaSKTUBP4t+s7WwgtoiA
	rsSq57uYQYqYBc6ySvz5swssISyQKdE0ZRtYA4uAqsTlmwdYQGxeATeJfbP7WSHWyUlM33sX
	LM4p4C7Rc2kaC8S2JkaJvinLmScw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJF
	X3YwLj5mdYhRgINRiYd3xzTfECHWxLLiytxDjBIczEoivAfS/EKEeFMSK6tSi/Lji0pzUosP
	MTJxcEo1MLr9WsnpnerRetv7z7azvRxWmxd//xP3/iTT9FebCtMXJz1Ycl2q/sb8PDdlNsOX
	e26FSJqeusscvOSrpuTVhzN9HsecW3v23OvzC6V9dJmMmua4JZuXTU33ifY6rfW42UFASGGm
	lH49w7kLvxIN/kyb8/7e+poTs3x33g0VP9xxuF+g+eXctKtKLMUZiYZazEXFiQAhwEWtgAIA	AA==
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
index 4b4f78c..ee5c286 100644
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
2.1.2

