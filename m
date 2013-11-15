Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3KOWBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:01:44 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:46154 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3KOWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:01:37 -0500
MIME-Version: 1.0
In-Reply-To: <1383833644-27091-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1383833644-27091-1-git-send-email-kirill.shutemov@linux.intel.com>
Date: Fri, 15 Nov 2013 14:01:36 -0800
Message-ID: <CA+8MBbL-WpcC6_wfZeFW6Buqq0p1PStH5ScF-USHae40H3MXfg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Properly separate the bloated ptl from the
 regular case
From: Tony Luck <tony.luck@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 6:14 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:

> diff --git a/kernel/bounds.c b/kernel/bounds.c
> index e8ca97b5c386..578782ef6ae1 100644
> --- a/kernel/bounds.c
> +++ b/kernel/bounds.c
> @@ -11,6 +11,7 @@
>  #include <linux/kbuild.h>
>  #include <linux/page_cgroup.h>
>  #include <linux/log2.h>
> +#include <linux/spinlock.h>
>
>  void foo(void)
>  {
> @@ -21,5 +22,6 @@ void foo(void)
>  #ifdef CONFIG_SMP
>         DEFINE(NR_CPUS_BITS, ilog2(CONFIG_NR_CPUS));
>  #endif
> +       DEFINE(BLOATED_SPINLOCKS, sizeof(spinlock_t) > sizeof(int));
>         /* End of constants */
>  }

This patch arrived in Linus' tree today - and broke the ia64 build :-(

  CC      kernel/bounds.s
In file included from
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h:9,
                 from include/linux/thread_info.h:54,
                 from include/asm-generic/preempt.h:4,
                 from arch/ia64/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from kernel/bounds.c:14:
/home/aegl/generic-smp/arch/ia64/include/asm/asm-offsets.h:1:35:
error: generated/asm-offsets.h: No such file or directory
In file included from include/linux/thread_info.h:54,
                 from include/asm-generic/preempt.h:4,
                 from arch/ia64/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from kernel/bounds.c:14:
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h: In
function 'set_restore_sigmask':
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h:138: error:
'IA64_TASK_SIZE' undeclared (first use in this function)
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h:138: error:
(Each undeclared identifier is reported only once
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h:138: error:
for each function it appears in.)
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h: In
function 'clear_restore_sigmask':
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h:144: error:
'IA64_TASK_SIZE' undeclared (first use in this function)
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h: In
function 'test_restore_sigmask':
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h:148: error:
'IA64_TASK_SIZE' undeclared (first use in this function)
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h: In
function 'test_and_clear_restore_sigmask':
/home/aegl/generic-smp/arch/ia64/include/asm/thread_info.h:152: error:
'IA64_TASK_SIZE' undeclared (first use in this function)
In file included from arch/ia64/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from kernel/bounds.c:14:
include/asm-generic/preempt.h: In function 'preempt_count':
include/asm-generic/preempt.h:12: error: 'IA64_TASK_SIZE' undeclared
(first use in this function)
include/asm-generic/preempt.h: In function 'preempt_count_ptr':
include/asm-generic/preempt.h:17: error: 'IA64_TASK_SIZE' undeclared
(first use in this function)
make[1]: *** [kernel/bounds.s] Error 1
make: *** [prepare0] Error 2
make: *** Waiting for unfinished jobs....

The problem is somewhat circular: IA64_TASK_SIZE will later be defined
by asm-offsets.h,
but we haven't even tried to generate that yet.

My "grep" skills are failing to find the Makefile that decides it wants to build
kernel/bounds.s so early :-(

-Tony
