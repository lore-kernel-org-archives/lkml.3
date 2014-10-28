Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959AbaJ1D6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:58:00 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49478 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbaJ1D56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:57:58 -0400
MIME-Version: 1.0
In-Reply-To: <007d01cff260$3c69e9b0$b53dbd10$@alibaba-inc.com>
References: <00cd01cff1b5$fda5a660$f8f0f320$@alibaba-inc.com>
 <CALCETrX7-OzQrOr3+TXy8NB8LS8aYwLN_A-vAeicwoQHsUH_yw@mail.gmail.com> <007d01cff260$3c69e9b0$b53dbd10$@alibaba-inc.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 27 Oct 2014 20:57:36 -0700
Message-ID: <CALCETrW5iJWd65Ems6F3RZL+CxYrQ75nDyFFmgA52ky--pzwTQ@mail.gmail.com>
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

On Mon, Oct 27, 2014 at 8:35 PM, Hillf Danton <hillf.zj@alibaba-inc.com> wrote:
>> -----Original Message-----
>> From: Andy Lutomirski [mailto:luto@amacapital.net]
>> Sent: Monday, October 27, 2014 11:45 PM
>> To: Hillf Danton
>> Cc: Peter Zijlstra; Ingo Molnar; Vince Weaver; Paul Mackerras; Kees Cook; Arnaldo Carvalho de Melo; Andrea Arcangeli; linux-
>> kernel@vger.kernel.org; Valdis Kletnieks
>> Subject: Re: [PATCH v2 7/8] x86, perf: Only allow rdpmc if a perf_event is mapped
>>
> CPU D                   CPU A
> switch_mm
> load_mm_cr4
>                         x86_pmu_event_unmapped
>
> I wonder if the X86_CR4_PCE set on CPU D is
> cleared by CPU A by broadcasting IPI.
>

It should be okay.  The IPI does:

+       if (current->mm)
+               load_mm_cr4(current->mm);

which refers to the current task running on the targetted CPU, not to
the IPI sender's task.  So, if it happens after a context switch, it
will harmlessly reload the new task's cr4.

refresh_pce can't happen in between switch_mm and updating current,
since irqs are off for the entire duration of the context switch.

--Andy
