Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3LQWTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:19:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:52262 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab3LQWTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:19:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,503,1384329600"; 
   d="scan'208";a="426273187"
From: Andi Kleen <andi@firstfloor.org>
To: Dmitry Mikushin <dmitry@kernelgen.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ia32 emulation on Pentium I
References: <52AB522F.8000703@kernelgen.org>
Date: Tue, 17 Dec 2013 14:19:38 -0800
In-Reply-To: <52AB522F.8000703@kernelgen.org> (Dmitry Mikushin's message of
	"Fri, 13 Dec 2013 19:30:07 +0100")
Message-ID: <871u1bxgqt.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Mikushin <dmitry@kernelgen.org> writes:
>
> So, it seems ia32 emulation assumes Pentium II+. Do you see a quick
> way to make it Pentium I -compatible?

The SYSENTER code path should be never executed, so you could either hack the
assembler to allow it, or just open code it.

Something like (totally untested):

From: Andi Kleen <ak@linux.intel.com>

use .byte to implement SYSEXIT for k1om assembler

diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index bba3cf8..1ad2378 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -130,6 +130,8 @@ static inline notrace unsigned long arch_local_irq_save(void)
 #define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
 
 #define INTERRUPT_RETURN	iretq
+#define SYSEXIT			.byte 0x0f,0x35
+
 #define USERGS_SYSRET64				\
 	swapgs;					\
 	sysretq;
@@ -139,7 +141,7 @@ static inline notrace unsigned long arch_local_irq_save(void)
 #define ENABLE_INTERRUPTS_SYSEXIT32		\
 	swapgs;					\
 	sti;					\
-	sysexit
+	SYSEXIT	
 
 #else
 #define INTERRUPT_RETURN		iret

-- 
ak@linux.intel.com -- Speaking for myself only
