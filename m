Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaIWPQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:16:52 -0400
Received: from forward18.mail.yandex.net ([95.108.253.143]:45412 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbaIWPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:16:50 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
In-Reply-To: <20140923150641.GH3312@worktop.programming.kicks-ass.net>
References: <20140922183612.11015.64200.stgit@localhost>
	 <20140922183618.11015.95007.stgit@localhost> <20140923150641.GH3312@worktop.programming.kicks-ass.net>
Subject: Re: [RFC][PATCH] sched,mips,ia64: Remove __ARCH_WANT_UNLOCKED_CTXSW
MIME-Version: 1.0
Message-Id: <32571411485404@web24g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 23 Sep 2014 19:16:44 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23.09.2014, 19:06, "Peter Zijlstra" <peterz@infradead.org>:
> On Mon, Sep 22, 2014 at 10:36:18PM +0400, Kirill Tkhai wrote:
>> šFrom: Kirill Tkhai <ktkhai@parallels.com>
>>
>> šArchitectures, which define __ARCH_WANT_UNLOCKED_CTXSW,
>> šmay pull a task when it's in the middle of schedule().
>>
>> šCPU1(task1 calls schedule) šššššššššššCPU2
>> š... ššššššššššššššššššššššššššššššššššschedule()
>> š... šššššššššššššššššššššššššššššššššššššidle_balance()
>> š... ššššššššššššššššššššššššššššššššššššššššload_balance()
>> š... ššššššššššššššššššššššššššššššššššššššššššš...
>> šschedule() šššššššššššššššššššššššššššššššššššš...
>> ššššprepare_lock_switch() šššššššššššššššššššššš...
>> šššššššraw_spin_unlock(&rq1->lock) ššššššššššššš...
>> ššššššš... šššššššššššššššššššššššššššššššššššššraw_spin_lock(&rq1->lock)
>> ššššššš... ššššššššššššššššššššššššššššššššššššššššdetach_tasks();
>> ššššššš... šššššššššššššššššššššššššššššššššššššššššššcan_migrate_task(task1)
>> ššššššš... ššššššššššššššššššššššššššššššššššššššššattach_tasks(); <--- move task1 to rq2
>> ššššššš... šššššššššššššššššššššššššššššššššššššraw_spin_unlock(&rq1->lock)
>> ššššššš... šššššššššššššššššššššššššššššššcontext_switch() <--- switch to task1's stack
>> ššššššš... ššššššššššššššššššššššššššššššš...
>> šššš(using task1's stack) šššššššššššššššš(using task1's stack)
>> šššš... šššššššššššššššššššššššššššššššššš...
>> ššššcontext_switch() ššššššššššššššššššššš...
>>
>> šParallel use of a single stack is not a good idea.
>
> Indeed it is, but how about we do this instead?

Completely agree, looks good for me.

> ---
> Subject: sched,mips,ia64: Remove __ARCH_WANT_UNLOCKED_CTXSW
>
> Kirill found that there's a subtle race in the
> __ARCH_WANT_UNLOCKED_CTXSW code, and instead of fixing it, remove the
> entire exception because neither arch that uses it seems to actually
> still require it.
>
> Boot tested on mips64el (qemu) only.
>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Reviewed-by: Kirill Tkhai <ktkhai@parallels.com> (one more review of ia64 part)
