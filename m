Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaJFQFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:05:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51411 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaJFQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:01:20 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d5-5432bccd5300
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
Subject: [PATCH v4 03/13] x86_64: load_percpu_segment: read
 irq_stack_union.gs_base before load_segment
Date: Mon, 06 Oct 2014 19:53:57 +0400
Message-id: <1412610847-27671-4-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xy7rn9hiFGOy+xGix7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8WW601MFs8fPmS3mPCwjd1i2kZxi5XdzWwW25+9ZbJY
	2fmA1eLyrjlsFvfW/Ge1uHRgAZPF4iO3mS3ePZvMbLF501Rmi6urDrJb/NjwmNVB1GP+zo+M
	Hjtn3WX3WLCp1GPxnpdMHptWdbJ5bPo0id2j6+0VJo93586xe5yY8ZvF48mV6UweH5/eYvF4
	v+8qm0ffllWMHp83yXmcaPnCGsAfxWWTkpqTWZZapG+XwJWxbMMZ9oKN3BUnL+1la2C8xdnF
	yMEhIWAicWRVQhcjJ5ApJnHh3no2EFtIYCmjxJz3YV2MXEB2H5PE+T1drCAJNgE9iX+ztoMV
	iQgoSGzufcYKUsQscIdV4vDjbYwgCWGBTIkjO/+zgCxgEVCVmDO9ACTMK+AmMfv8bDaIZXIS
	0/feZQGxOQXcJaZdmckOsayJUeLQlx1sExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P
	3cQIiaCvOxiXHrM6xCjAwajEwxu5wzBEiDWxrLgy9xCjBAezkgiv+TyjECHelMTKqtSi/Pii
	0pzU4kOMTBycUg2MUcbrGr2+Pj9lm/BOc7dq6vMn/X90d2wo0We/OvU59+pJBg6uHerBt9c+
	O7qxWO0vb4W+jMYRhZNhj2t+nO08Ehjgdvy+93XnBUteZjHGXKjJzrivqPm/piT/V0KadOS+
	/JDiL3GW//O25tgvSWOvecZ0YNlUg/PCb6T6Jk3SVv1wwenfinOzlFiKMxINtZiLihMBvDJn
	jn4CAAA=
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
index ea51f2c..8d9a3c6 100644
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

