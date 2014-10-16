Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaJPPiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:38:23 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36926 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaJPPiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <20141016084227.GI7369@worktop.fdxtended.com>
References: <cover.1413323611.git.luto@amacapital.net> <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <20141016084227.GI7369@worktop.fdxtended.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Oct 2014 08:37:59 -0700
Message-ID: <CALCETrUtwbw8LKxaO6AeOAJTNEkjDh7faXFTi85J99y=x9P3fA@mail.gmail.com>
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 1:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Oct 14, 2014 at 03:57:39PM -0700, Andy Lutomirski wrote:
>> We currently allow any process to use rdpmc.  This significantly
>> weakens the protection offered by PR_TSC_DISABLED, and it could be
>> helpful to users attempting to exploit timing attacks.
>>
>> Since we can't enable access to individual counters, use a very
>> coarse heuristic to limit access to rdpmc: allow access only when
>> a perf_event is mmapped.  This protects seccomp sandboxes.
>>
>> There is plenty of room to further tighen these restrictions.  For
>> example, on x86, *all* perf_event mappings set cap_user_rdpmc.  This
>> should probably be changed to only apply to perf_events that are
>> accessible using rdpmc.
>
> So I suppose this patch is a little over engineered,

:)  I won't argue.

>
>> @@ -1852,10 +1865,26 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
>>       if (x86_pmu.attr_rdpmc_broken)
>>               return -ENOTSUPP;
>>
>> +     mutex_lock(&rdpmc_enable_mutex);
>>       if (!!val != !!x86_pmu.attr_rdpmc) {
>> -             x86_pmu.attr_rdpmc = !!val;
>> -             on_each_cpu(change_rdpmc, (void *)val, 1);
>> +             if (val) {
>> +                     static_key_slow_inc(&rdpmc_enabled);
>> +                     on_each_cpu(refresh_pce, NULL, 1);
>> +                     smp_wmb();
>> +                     x86_pmu.attr_rdpmc = 1;
>> +             } else {
>> +                     /*
>> +                      * This direction can race against existing
>> +                      * rdpmc-capable mappings.  Try our best regardless.
>> +                      */
>> +                     x86_pmu.attr_rdpmc = 0;
>> +                     smp_wmb();
>> +                     static_key_slow_dec(&rdpmc_enabled);
>> +                     WARN_ON(static_key_true(&rdpmc_enabled));
>> +                     on_each_cpu(refresh_pce, NULL, 1);
>> +             }
>>       }
>> +     mutex_unlock(&rdpmc_enable_mutex);
>>
>>       return count;
>>  }
>
> why do you care about that rdpmc_enabled static key thing? Also you
> should not expose static key control to userspace like this, they can
> totally wreck the system. At the very least it should be
> static_key_slow_dec_deferred() -- gawd I hate the static_key API.

This particular control is only available to root, so I don't think it
matters too much.  I did it this way to avoid hitting an extra dcache
line on every switch_mm.

A nicer solution might be to track whether rdpmc is allowed for each
perf_event and to count the number that allow rdpmc.  That would cause
'echo 0 > rdpmc' to only work for new perf_events, but it fixes a
race.

Doing this will require passing more info to
arch_perf_update_userpage, I think.  Should I do that?  It'll probably
get a better result, but this patchset will get even longer and even
more overengineered.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
