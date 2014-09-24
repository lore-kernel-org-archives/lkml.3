Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaIXMvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:51:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55501 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaIXMvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:51:18 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d2-5422be44aafc
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v3 03/13] x86_64: load_percpu_segment: read
 irq_stack_union.gs_base before load_segment
Date: Wed, 24 Sep 2014 16:43:59 +0400
Message-id: <1411562649-28231-4-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.1
In-reply-to: <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xy7ou+5RCDHZ+tLLY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0WLL9SYmi+cPH7JbTHjYxm4xbaO4xcruZjaL7c/eMlms
	7HzAanF51xw2i3tr/rNaXDqwgMli8ZHbzBbvnk1mtti8aSqzxdVVB9ktfmx4zOog6jF/50dG
	j52z7rJ7LNhU6rF4z0smj02rOtk8Nn2axO7R9fYKk8e7c+fYPU7M+M3i8eTKdCaPj09vsXi8
	33eVzaNvyypGj8+b5DxOtHxhDeCP4rJJSc3JLEst0rdL4MrYc/8+U8FG7orzq3vYGhhvcXYx
	cnJICJhIXF7RwwRhi0lcuLeerYuRi0NIYCmjxPZJK5ghnD4miSs3jrCBVLEJ6En8m7UdzBYR
	UJDY3PuMFaSIWeAOq8Thx9sYQRLCApkSK78fZQWxWQRUJX43/AVr4BVwk5hwYCEbxDo5ib2T
	V7OA2JwC7hIHfrxgh9jWxCixbO9vpgmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525i
	hMTR1x2MS49ZHWIU4GBU4uGdKK4UIsSaWFZcmXuIUYKDWUmEN2wPUIg3JbGyKrUoP76oNCe1
	+BAjEwenVAPjuUcsNa+UZI/2rzY2jvllcGZx4D2bn4Krfl78cWVKkmH4N/fsuh1//t816zyi
	MCf1GJMvU2uuxZ0Z8xm49DvyX1vOyMnSYXBcvdi/+N2cv7XvO1zDuiIW25bu0mBcdPjU12ol
	7ht22bxX/NYvNp+0LepDZXEmd9rh20xTduex2vQov/32ayWPEktxRqKhFnNRcSIAT5o+QIEC	AAA=
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
index fe52f2d..51d393f 100644
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
2.1.1

