Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab3EBOd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:33:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:39897 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740Ab3EBOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:33:56 -0400
Date: Thu, 2 May 2013 16:33:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jonas Gorski <jogo@openwrt.org>, eunb.song@samsung.com,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] MIPS: Enable interrupts in arch_cpu_idle()
In-Reply-To: <CAOiHx=mA-htk_2daeE9WpbEVV9YLvfLc1NYZZR=JeDdibchCnw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1305021527010.3972@ionos>
References: <20522420.158691367384219315.JavaMail.weblogic@epml17> <CAOiHx=mBPHmDse4EwL-+Fgmpz0=XhcgF_0nWdyvErFO4NU7E0Q@mail.gmail.com> <alpine.LFD.2.02.1305021241040.3972@ionos> <CAOiHx=mA-htk_2daeE9WpbEVV9YLvfLc1NYZZR=JeDdibchCnw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit cdbedc61c8 (mips: Use generic idle loop) broke MIPS as I did
not realize that MIPS wants to invoke the wait instructions with
interrupts enabled. Don't ask why that works correctly; Ralf suggested
to get thoroughly drunk before even thinking about it. Looking sober
at commit c65a5480 ([MIPS] Fix potential latency problem due to
non-atomic cpu_wait) is not recommended.

Enable interrupts in arch_cpu_idle() on mips to repair the issue.

Reported-and-tested-by: Jonas Gorski <jogo@openwrt.org>
Reported-by: EunBong Song <eunb.song@samsung.com>
Booze-recommended-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Index: linux-2.6/arch/mips/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/process.c
+++ linux-2.6/arch/mips/kernel/process.c
@@ -50,13 +50,18 @@ void arch_cpu_idle_dead(void)
 }
 #endif
 
-void arch_cpu_idle(void)
+static void smtc_idle_hook(void)
 {
 #ifdef CONFIG_MIPS_MT_SMTC
 	extern void smtc_idle_loop_hook(void);
-
 	smtc_idle_loop_hook();
 #endif
+}
+
+void arch_cpu_idle(void)
+{
+	local_irq_enable();
+	smtc_idle_hook();
 	if (cpu_wait)
 		(*cpu_wait)();
 	else
