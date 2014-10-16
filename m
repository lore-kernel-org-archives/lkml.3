Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaJPFuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:50:07 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54183 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaJPFuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:50:05 -0400
Message-ID: <543F5C84.7090005@hitachi.com>
Date: Thu, 16 Oct 2014 14:49:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] s390 vs. kprobes on ftrace
References: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
In-Reply-To: <1413387978-984-1-git-send-email-heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

(2014/10/16 0:46), Heiko Carstens wrote:
> Hi all,
> 
> we would like to implement an architecture specific variant of "kprobes
> on ftrace" without using the current HAVE_KPROBES_ON_FTRACE infrastructure
> which is currently only used by x86.
> 
> The rationale for these two patches is:
> - we want to patch the first instruction of the mcount code block to
>   reduce the overhead of the function tracer
> - we'd like to keep the ftrace_caller function as simple as possible and
>   not require it to generate a 100% valid pt_regs structure as required
>   by the combination of DYNAMIC_FTRACE_WITH_REGS and HAVE_KPROBES_ON_FTRACE.
>   This allows us to not generate the psw mask field in the pt_regs
>   structure on each function tracer enabled function, which otherwise would
>   be very expensive. Besides that program check generated pt_regs contents
>   are "more" accurate than program generated ones and don't require any
>   maintenance.
>   And also we can keep the ftrace and kprobes backends quite separated.

I'm not sure about s390 nor have the machine, so it is very helpful if you
give us a command line level test and show us the result with this patch :)
Fortunately, we already have ftracetest under tools/tesitng/selftest/ftrace/.
You can add the testcase for checking co-existence of kprobes and ftrace on
an entry of a function.

And also, since ftrace is now supporting assembly trampoline code for each
handler, performance overhead can be reduced if we save registers only when
the kprobes enabled on the function. I'm not sure it can implement on s390,
but your requirement looks similar. What would you think about that?

Thank you,

> 
> In order to make this work a small common code change is necessary which
> removes a check if kprobe is being placed on an ftrace location (see
> first patch).
> 
> If possible, I'd like to have an ACK from at least one of the kprobes
> maintainers for the first patch and bring it upstream via the s390 tree.
> 
> Thanks,
> Heiko
> 
> Heiko Carstens (2):
>   kprobes: introduce ARCH_HANDLES_KPROBES_ON_FTRACE
>   s390/ftrace,kprobes: allow to patch first instruction
> 
>  arch/Kconfig                    |   8 +++
>  arch/s390/Kconfig               |   1 +
>  arch/s390/include/asm/ftrace.h  |  52 ++++++++++++++--
>  arch/s390/include/asm/kprobes.h |   1 +
>  arch/s390/include/asm/lowcore.h |   4 +-
>  arch/s390/include/asm/pgtable.h |  12 ++++
>  arch/s390/kernel/asm-offsets.c  |   1 -
>  arch/s390/kernel/early.c        |   4 --
>  arch/s390/kernel/ftrace.c       | 132 +++++++++++++++++++++++++---------------
>  arch/s390/kernel/kprobes.c      |  87 ++++++++++++++++++--------
>  arch/s390/kernel/mcount.S       |   1 +
>  arch/s390/kernel/setup.c        |   2 -
>  arch/s390/kernel/smp.c          |   1 -
>  kernel/kprobes.c                |   3 +-
>  scripts/recordmcount.c          |   2 +-
>  scripts/recordmcount.pl         |   2 +-
>  16 files changed, 220 insertions(+), 93 deletions(-)
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


