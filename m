Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaCBMMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 07:12:20 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35385 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751674AbaCBMMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 07:12:18 -0500
Date: Sun, 2 Mar 2014 12:11:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 07/14] ARM: Remove use of struct kprobe from generic
	probes code
Message-ID: <20140302121133.GF21483@n2100.arm.linux.org.uk>
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org> <1392017945-4507-8-git-send-email-dave.long@linaro.org> <20140228101226.GO21483@n2100.arm.linux.org.uk> <531309D9.6050708@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531309D9.6050708@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 05:37:13AM -0500, David Long wrote:
> On 02/28/14 05:12, Russell King - ARM Linux wrote:
>> On Mon, Feb 10, 2014 at 02:38:58AM -0500, David Long wrote:
>>> diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
>>> index 7cd1763..179deac 100644
>>> --- a/arch/arm/kernel/probes.c
>>> +++ b/arch/arm/kernel/probes.c
>>> @@ -12,11 +12,9 @@
>>>    */
>>>
>>>   #include <linux/kernel.h>
>>> -#include <linux/kprobes.h>
>>>   #include <asm/system_info.h>
>>
>> How well has this code been tested?  This file doesn't even build because
>> (I suspect) the above change:
>>
>> arch/arm/kernel/probes.c: In function 'test_alu_write_pc_interworking':
>> arch/arm/kernel/probes.c:68:2: error: implicit declaration of function 'BUG_ON' [-Werror=implicit-function-declaration]
>> make[2]: *** [arch/arm/kernel/probes.o] Error 1
>>
>> This is because linux/kprobes.h includes linux/bug.h, which would provide
>> the requirements for BUG_ON().
>>
>
> It was tested by building and running on Panda with all four  
> permutations of uprobes and kprobes enabled/disabled.  x86 was also test  
> built and run to verify no regressions, and other testing was done  
> inside Linaro for arm64 endianess correctness.  Very recently daily  
> build testing has been added and this config problem has shown up, and  
> our test configs adjusted accordingly.  I think the problem was masked  
> on panda by CONFIG_PROFILING being set for that (and many other)  
> platform(s).  On x86 it looks like the problem is avoided by  
> CONFIG_PERF_EVENTS always being set in arch/x86/Kconfig.
>
> I was not aware of the use/requirement (or existence even) of randconfig  
> for validation testing, nor did I know a config dependency issue like  
> this one would be considered a showstopper problem.

The point of randconfig is to find those combinations which you haven't
tested.  For example, you say above that you tested on a Panda board.
However, there's dependencies in this code for ARMv5, ARMv6 and ARMv7 as
well, which you haven't tested for by only targetting Panda.

For example, the failure above is caused if you try and build this code
with support for ARMv6 enabled.  This causes test_alu_write_pc_interworking()
to be built, which finds the problem with BUG_ON().

What the overall requirement here is that we avoid new regressions - in
this case, it's a missing include file indirectly included via
linux/kprobes.h.

One of my biggest gripes is that people like reducing the include files
in their sources to the barest minimum, relying on indirect includes to
give them what their .c file requires.  This is - as is demonstrated
above - very fragile, and leads to these kinds of unexpected build failures.
If people thought about it properly, they'd realise that this is no way to
behave.  Instead, a .c file should always include the headers that it has
a direct requirement for.  In this case, that's linux/bug.h.  This problem
is compounded by ARM having a multitude of configuration options which
directly affect compiled code.

Again, this is not your fault, but the author of kprobes.c who made a
rather poor decision in only including (originally) six headers:

+#include <linux/kernel.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/stringify.h>
+#include <asm/traps.h>
+#include <asm/cacheflush.h>

despite requiring more.

However, this is not the reason I dropped your patch series - I dropped
them because of the other problem I mailed about, caused by the Kconfig
dependencies.  That needs fixing first to avoid the problem your changes
have uncovered - it's no good fixing it afterwards because it can end
up breaking git bisect.  The precise time where you don't want git bisect
to break is during a merge window, and that's when this code will be going
in.

Now that I look closer at this, the UPROBES Kconfig stuff is totally
insane - this commit:

commit f3f096cfedf8113380c56fc855275cc75cd8cf55
Author: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date:   Wed Apr 11 16:00:43 2012 +0530

    tracing: Provide trace events interface for uprobes

introduced this madness:

config UPROBES
        bool "Transparent user-space probes (EXPERIMENTAL)"
        depends on UPROBE_EVENT && PERF_EVENTS
        default n
        select PERCPU_RWSEM

config UPROBE_EVENT
        bool "Enable uprobes-based dynamic events"
        depends on ARCH_SUPPORTS_UPROBES
        depends on MMU
        select UPROBES
        select PROBE_EVENTS
        select TRACING

What this expresses is that UPROBES can't be enabled unless UPROBE_EVENT
is enabled.  If UPROBE_EVENT is enabled, then UPROBES is force-enabled
irrespective of its dependencies.  Hence, this forces UPROBES to *always*
have the same value as UPROBE_EVENT, it can never be anything different.

I'm at a loss to understand why we have these two configuration options.
The above commit just looks totally wrong from the Kconfig perspective.

Maybe Srikar Dronamraju can comment about what the original intention
was here - but it looks like one or other should just be killed off.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
