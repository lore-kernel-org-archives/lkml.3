Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaEAF3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 01:29:04 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:49663 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaEAF3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 01:29:02 -0400
Message-ID: <5361DB14.7010406@synopsys.com>
Date: Thu, 1 May 2014 10:56:44 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <mingo@kernel.org>, <torvalds@linux-foundation.org>,
        <rusty@rustcorp.com.au>, <rdunlap@infradead.org>, <jeremy@goop.org>,
        <arnd@arndb.de>, <dl9pf@gmx.de>, <akpm@linux-foundation.org>,
        <sparse@chrisli.org>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <linux-kernel@vger.kernel.org>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>,
        <masami.hiramatsu.pt@hitachi.com>, <chrisw@sous-sol.org>,
        <akataria@vmware.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        anton Kolesov <Anton.Kolesov@synopsys.com>,
        linux-next <linux-next@vger.kernel.org>
Subject: kprobes broken in linux-next (was Re: [tip:perf/kprobes] kprobes:
 Introduce NOKPROBE_SYMBOL()  macro to maintain kprobes blacklist)
References: <20140417081705.26341.96719.stgit@ltc230.yrl.intra.hitachi.co.jp> <tip-376e242429bf8539ef39a080ac113c8799840b13@git.kernel.org>
In-Reply-To: <tip-376e242429bf8539ef39a080ac113c8799840b13@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2014 04:28 PM, tip-bot for Masami Hiramatsu wrote:
> Commit-ID:  376e242429bf8539ef39a080ac113c8799840b13
> Gitweb:     http://git.kernel.org/tip/376e242429bf8539ef39a080ac113c8799840b13
> Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> AuthorDate: Thu, 17 Apr 2014 17:17:05 +0900
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 24 Apr 2014 10:02:56 +0200
> 
> kprobes: Introduce NOKPROBE_SYMBOL() macro to maintain kprobes blacklist
> 
> Introduce NOKPROBE_SYMBOL() macro which builds a kprobes
> blacklist at kernel build time.
> 
....

> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 146e4ff..40ceb3c 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -109,6 +109,14 @@
>  #define BRANCH_PROFILE()
>  #endif
>  
> +#ifdef CONFIG_KPROBES
> +#define KPROBE_BLACKLIST()	VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
> +				*(_kprobe_blacklist)			      \
> +				VMLINUX_SYMBOL(__stop_kprobe_blacklist) = .;
> +#else
> +#define KPROBE_BLACKLIST()
> +#endif
> +
>  #ifdef CONFIG_EVENT_TRACING
>  #define FTRACE_EVENTS()	. = ALIGN(8);					\
>  			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
> @@ -507,6 +515,7 @@
>  	*(.init.rodata)							\
>  	FTRACE_EVENTS()							\
>  	TRACE_SYSCALLS()						\
> +	KPROBE_BLACKLIST()						\
>  	MEM_DISCARD(init.rodata)					\
>  	CLK_OF_TABLES()							\
>  	RESERVEDMEM_OF_TABLES()						\

Linux-next fails to boot on ARC due to misaligned __start_kprobe_blacklist. Patch
below fixes it.

------------------------>
>From c5afc4ebf9c1c094a260e2aaff6c5b3106063039 Mon Sep 17 00:00:00 2001
From: Vineet Gupta <vgupta@synopsys.com>
Date: Thu, 1 May 2014 10:47:29 +0530
Subject: [PATCH] kprobes: Ensure blacklist data is aligned

ARC Linux (not supporting native unaligned access) was failing to boot
because __start_kprobe_blacklist was not aligned.

This was because per generated vmlinux.lds it was emitted right next
to .rodata with strings etc hence could be randomly unaligned.

Fix that by ensuring a word alignment. While 4 would suffice for 32bit
arches and problem at hand, it is probably better to put 8.

| Path: (null) CPU: 0 PID: 1 Comm: swapper Not tainted
| 3.15.0-rc3-next-20140430 #2
| task: 8f044000 ti: 8f01e000 task.ti: 8f01e000
|
| [ECR   ]: 0x00230400 => Misaligned r/w from 0x800fb0d3
| [EFA   ]: 0x800fb0d3
| [BLINK ]: do_one_initcall+0x86/0x1bc
| [ERET  ]: init_kprobes+0x52/0x120

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 include/asm-generic/vmlinux.lds.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 40ceb3ceba79..8e0204a68c74 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -110,7 +110,8 @@
 #endif

 #ifdef CONFIG_KPROBES
-#define KPROBE_BLACKLIST()	VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
+#define KPROBE_BLACKLIST()	. = ALIGN(8);				      \
+				VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
 				*(_kprobe_blacklist)			      \
 				VMLINUX_SYMBOL(__stop_kprobe_blacklist) = .;
 #else
-- 
1.8.3.2



