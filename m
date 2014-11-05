Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaKEOy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:54:28 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25008 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaKEOyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:22 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-16-545a3a1b01d8
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
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
Subject: [PATCH v6 02/11] x86_64: load_percpu_segment: read
 irq_stack_union.gs_base before load_segment
Date: Wed, 05 Nov 2014 17:53:52 +0300
Message-id: <1415199241-5121-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t/xq7rSVlEhBgunK1ls+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtbi8aw6bxb01/1ktLh1YwGSx+MhtZot3zyYzW2zeNJXZ4uqqg+wWPzY8ZnUQ9Zi/8yOj
	x85Zd9k9Fmwq9Vi85yWTx6ZVnWwemz5NYvfoenuFyePduXPsHidm/GbxeHJlOpPHx6e3WDze
	77vK5tG3ZRWjx+dNch4nWr6wBvBHcdmkpOZklqUW6dslcGUs7j7LWLCRu+Ll/q2sDYy3OLsY
	OTkkBEwkXv4+zQphi0lcuLeerYuRi0NIYCmjxNT/h8ESQgJ9TBJr70iB2GwCehL/Zm1nA7FF
	BGQlpv49zwLSwCxwllXiz59dYAlhgUyJi7tbmbsYOThYBFQlrn4NBTF5BVwljtwMBzElBOQk
	tq7zBinmFHCTONK/iAVibSOjxOdbnSwTGHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/d
	xAiJn687GJceszrEKMDBqMTD69EUGSLEmlhWXJl7iFGCg1lJhLdJOypEiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA6Plj+d/a2/8fiL+Tm1H3RfZwgXF5plBugEJsWFFfPmpJzxrmjRu2hYdE5d+
	y/Poekv0XtfvmiLhsiKGnGGCjt6yWyzmy+s2VfXcjT4tvy9wQQcPS1Hz5cPMSzbz/JPZzpfk
	GCqyji0gUnhpf1PENtYtCz4flnjQHeVWf6/O+WGNuuDNRQlCSizFGYmGWsxFxYkAQWPAm30C	AAA=
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
2.1.3

