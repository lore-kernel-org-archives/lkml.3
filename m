Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389AbaKMWXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:23:48 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:62815 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMWXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:23:45 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292CB9A@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com> <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F3292CB9A@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Nov 2014 14:23:24 -0800
Message-ID: <CALCETrVx7hGZodWfAoU1oee1SW7XXSn3Lr8Vs9JTOUMNtLXY4A@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:43 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> printk seems to work just fine in do_machine_check.  Any chance you
>> can instrument, for each cpu, all entries to do_machine_check, all
>> calls to do_machine_check, all returns, and everything that tries to
>> do memory_failure?
>
> I first added a printk() just for the cpu that calls do_machine_check()
>
>    printk("MCE: regs = %p\n", regs);
>
> to see if something went wonky when jumping to the kernel stack.
> But that printed the same value every time (same process is consuming
> and recovering from errors).  Maybe this took longer to hit the problem
> case - I ran to 1500ish errors instead of just 400 in the previous two tests.
> But not sure if that is a significant change.
>
> Then I added printk() for every entry/return on all cpus.  This just locked
> up on the third injection.  Serial console looked to have stopped printing
> after the first - so I put in bigger delays into my test program between injection
> and consumption, and before looping around for the next cycle to give
> time for all the messages (4-socket HSW-EX  ... there are a lot of cpus
> printing messages). But now it is taking a lot longer to get through
> injection/consumption iterations. At 226 now and counting.
>
>> Also, shouldn't there be a local_irq_enable before memory_failure and
>> a local_irq_disable after it?  It wouldn't surprise me if you've
>> deadlocked somewhere.  Lockdep could also have something interesting
>> to say.
> Added enable/disable.
>
>> should still be deliverable.  Is it possible that we really need an
>> IRET to unmask NMIs?  This seems unlikely.)
>
> If that were the problem, wouldn't we fail on iteration 2, instead of
> 400+ ?
>
> -Tony

There could be a timer interrupt or something.  But I agree, it seems
implausible.

Are you sure that this works in an unmodified kernel?  The timeout
code seems highly questionable to me.  For example, there's this:

        if ((c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xe)) &&
            cfg->monarch_timeout < 0)
            cfg->monarch_timeout = USEC_PER_SEC;

which presumably determines monarch_timeout on your system and sets it
to 1000000.  But then there's this:

#define SPINUNIT 100    /* 100ns */

which smells like unit error to me.  On top of that, it seems likely
to me that the cpu could execute a loop iteration in much less than
100ns, since the only thing that should be anything other than an L1
hit or a correctly predicted branch is the rmb(), which is lfence,
which is probably just a few ns.  So you have 10k iterations at, say,
10ns each, allowing about 100µs to synchronize, and if an SMI hits at
an inopportune time, boom.

Also, rmb, seriously?  I would understand smp_rmb() or cpu_relax() or
even barrier(), but rmb() seems completely bogus if harmless.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
