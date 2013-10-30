Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab3J3Um0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:42:26 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:35888 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3J3UmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:42:23 -0400
Message-ID: <52716E1B.7090205@hds.com>
Date: Wed, 30 Oct 2013 16:37:47 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org
CC: hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu, bp@alien8.de,
        tglx@linutronix.de, fdeslaur@gmail.com, raphael.beamonte@gmail.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: [PATCH v4 3/4] Delete __trace_alloc_intr_gate()
References: <52716D74.3070201@hds.com>
In-Reply-To: <52716D74.3070201@hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-30_06:2013-10-30,2013-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310300176
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently irq vector handlers for tracing are registered in both set_intr_gate()
 and __trace_alloc_intr_gate() in alloc_intr_gate().
But, we don't need to do that twice.
So, let's delete __trace_alloc_intr_gate().

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/include/asm/desc.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 3d73437..50d033a 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -392,32 +392,10 @@ static inline void alloc_system_vector(int vector)
 	}
 }
 
-#ifdef CONFIG_TRACING
-static inline void trace_set_intr_gate(unsigned int gate, void *addr)
-{
-	gate_desc s;
-
-	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
-	write_idt_entry(trace_idt_table, gate, &s);
-}
-
-static inline void __trace_alloc_intr_gate(unsigned int n, void *addr)
-{
-	trace_set_intr_gate(n, addr);
-}
-#else
-static inline void trace_set_intr_gate(unsigned int gate, void *addr)
-{
-}
-
-#define __trace_alloc_intr_gate(n, addr)
-#endif
-
 #define alloc_intr_gate(n, addr)				\
 	do {							\
 		alloc_system_vector(n);				\
 		set_intr_gate(n, addr);				\
-		__trace_alloc_intr_gate(n, trace_##addr);	\
 	} while (0)
 
 /*
-- 
1.8.3.1


