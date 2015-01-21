Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbbAUUUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:20:30 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61028 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbbAUUUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:20:23 -0500
Message-ID: <54C00A07.1000305@linaro.org>
Date: Wed, 21 Jan 2015 20:20:23 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>, Patch Tracking <patches@linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] sched_clock: Avoid tearing during read from NMI
References: <1421859236-19782-1-git-send-email-daniel.thompson@linaro.org> <CALAqxLUmf_TNvTG2-=uavXjXk3040-MQ73V5z7S1UiGa+7c29Q@mail.gmail.com>
In-Reply-To: <CALAqxLUmf_TNvTG2-=uavXjXk3040-MQ73V5z7S1UiGa+7c29Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/15 17:29, John Stultz wrote:
> On Wed, Jan 21, 2015 at 8:53 AM, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
>> Currently it is possible for an NMI (or FIQ on ARM) to come in and
>> read sched_clock() whilst update_sched_clock() has half updated the
>> state. This results in a bad time value being observed.
>>
>> This patch fixes that problem in a similar manner to Thomas Gleixner's
>> 4396e058c52e("timekeeping: Provide fast and NMI safe access to
>> CLOCK_MONOTONIC").
>>
>> Note that ripping out the seqcount lock from sched_clock_register() and
>> replacing it with a large comment is not nearly as bad as it looks! The
>> locking here is actually pretty useless since most of the variables
>> modified within the write lock are not covered by the read lock. As a
>> result a big comment and the sequence bump implicit in the call
>> to update_epoch() should work pretty much the same.
> 
> It still looks pretty bad, even with the current explanation.

I'm inclined to agree. Although to be clear, the code I proposed should
not more broken than the code we have today (and arguably more honest).

>> -       raw_write_seqcount_begin(&cd.seq);
>> +       /*
>> +        * sched_clock will report a bad value if it executes
>> +        * concurrently with the following code. No locking exists to
>> +        * prevent this; we rely mostly on this function being called
>> +        * early during kernel boot up before we have lots of other
>> +        * stuff going on.
>> +        */
>>         read_sched_clock = read;
>>         sched_clock_mask = new_mask;
>>         cd.rate = rate;
>>         cd.wrap_kt = new_wrap_kt;
>>         cd.mult = new_mult;
>>         cd.shift = new_shift;
>> -       cd.epoch_cyc = new_epoch;
>> -       cd.epoch_ns = ns;
>> -       raw_write_seqcount_end(&cd.seq);
>> +       update_epoch(new_epoch, ns);
> 
> 
> So looking at this, the sched_clock_register() function may not be
> called super early, so I was looking to see what prevented bad reads
> prior to registration.

Certainly not super early, but, from the WARN_ON() at the top of the
function I thought it was intended to be called before start_kernel()
unmasks interrupts...

> And from quick inspection, its nothing. I
> suspect the undocumented trick that makes this work is that the mult
> value is initialzied to zero, so sched_clock returns 0 until things
> have been registered.
> 
> So it does seem like it would be worth while to do the initialization
> under the lock, or possibly use the suspend flag to make the first
> initialization safe.

As mentioned the existing write lock doesn't really do very much at the
moment.

The simple and (I think) strictly correct approach is to duplicate the
whole of the clock_data (minus the seqcount) and make the read lock in
sched_clock cover all accesses to the structure.

This would substantially enlarge the critical section in sched_clock()
meaning we might loop round the seqcount fractionally more often.
However if that causes any real problems it would be a sign the epoch
was being updated too frequently.

Unless I get any objections (or you really want me to look closely at
using suspend) then I'll try this approach in the next day or two.


Daniel.


