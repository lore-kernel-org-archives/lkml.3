Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaJ1E2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:28:22 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44202 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaJ1E2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <007e01cff264$bce6afc0$36b40f40$@alibaba-inc.com>
References: <00cd01cff1b5$fda5a660$f8f0f320$@alibaba-inc.com>
 <CALCETrX7-OzQrOr3+TXy8NB8LS8aYwLN_A-vAeicwoQHsUH_yw@mail.gmail.com>
 <007d01cff260$3c69e9b0$b53dbd10$@alibaba-inc.com> <CALCETrW5iJWd65Ems6F3RZL+CxYrQ75nDyFFmgA52ky--pzwTQ@mail.gmail.com>
 <007e01cff264$bce6afc0$36b40f40$@alibaba-inc.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 27 Oct 2014 21:27:56 -0700
Message-ID: <CALCETrUPMSPdf_AwhskirnKkED4NcbJ+Lxw+Fdq6ZTxUEUcVxw@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] x86, perf: Only allow rdpmc if a perf_event is mapped
To: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vince Weaver <vince@deater.net>, Paul Mackerras <paulus@samba.org>,
        Kees Cook <keescook@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 9:07 PM, Hillf Danton <hillf.zj@alibaba-inc.com> wrote:
>> >> Subject: Re: [PATCH v2 7/8] x86, perf: Only allow rdpmc if a perf_event is mapped
>> >>
>> > CPU D                   CPU A
>> > switch_mm
>> > load_mm_cr4
>> >                         x86_pmu_event_unmapped
>> >
>> > I wonder if the X86_CR4_PCE set on CPU D is
>> > cleared by CPU A by broadcasting IPI.
>> >
>>
>> It should be okay.  The IPI does:
>>
>> +       if (current->mm)
>> +               load_mm_cr4(current->mm);
>>
>> which refers to the current task running on the targetted CPU, not to
>> the IPI sender's task.  So, if it happens after a context switch, it
>> will harmlessly reload the new task's cr4.
>>
> Right, but prev != next is checked in switch_mm.

If that happens and !cpumask_test_cpu(cpu, mm_cpumask(next)), then cr4
will be reloaded.  So, in the case you described, we should still be
okay.

It's worth checking whether a more complicated race could be a
problem.  I think it's okay.  Here's my argument.

In x86_pmu_event_mapped / x86_pmu_event_unmapped, for each cpu, either
that cpu is set in mm_cpumask or it's clear.  If it's set, then we'll
send the IPI and that cpu is guaranteed to be updated.  If it's clear,
then it must become set before any user code in this mm can be
executed.  There are no paths through switch_mm that set the bit in
mm_cpumask without reloading cr4, so we should be safe.

Is that convincing?

--Andy

>
> Hillf
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
