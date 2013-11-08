Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab3KHXKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:10:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141Ab3KHXKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:10:22 -0500
Date: Fri, 8 Nov 2013 15:10:11 -0800
From: tip-bot for Seiji Aguchi <tipbot@zytor.com>
Message-ID: <tip-ac7956e2699380b8b10146ec2ba8cbe43a03ff7a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <52716E1B.7090205@hds.com>
References: <52716E1B.7090205@hds.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trace] x86, trace: Delete __trace_alloc_intr_gate()
Git-Commit-ID: ac7956e2699380b8b10146ec2ba8cbe43a03ff7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 08 Nov 2013 15:10:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac7956e2699380b8b10146ec2ba8cbe43a03ff7a
Gitweb:     http://git.kernel.org/tip/ac7956e2699380b8b10146ec2ba8cbe43a03ff7a
Author:     Seiji Aguchi <seiji.aguchi@hds.com>
AuthorDate: Wed, 30 Oct 2013 16:37:47 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 8 Nov 2013 14:15:47 -0800

x86, trace: Delete __trace_alloc_intr_gate()

Currently irq vector handlers for tracing are registered in both set_intr_gate()
 and __trace_alloc_intr_gate() in alloc_intr_gate().
But, we don't need to do that twice.
So, let's delete __trace_alloc_intr_gate().

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Link: http://lkml.kernel.org/r/52716E1B.7090205@hds.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
