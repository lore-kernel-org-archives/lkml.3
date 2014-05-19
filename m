Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaESR5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:57:31 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:33241 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaESR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:57:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140519101439.GE4060@localhost>
References: <1400288204-414-1-git-send-email-john.stultz@linaro.org>
	<20140519101439.GE4060@localhost>
Date: Mon, 19 May 2014 10:57:29 -0700
Message-ID: <CALAqxLUyCGJeYDwzXKN0zCBdmYuapo1iYJX4nvR7Sru+ySkesQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering (v2)
From: John Stultz <john.stultz@linaro.org>
To: Miroslav Lichvar <mlichvar@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 3:14 AM, Miroslav Lichvar <mlichvar@redhat.com> wrote:
> On Fri, May 16, 2014 at 05:56:41PM -0700, John Stultz wrote:
>> This version of the patch set corrects a few issues Miroslav pointed
>> out, as well as adapts his approach almost completely for the last
>> patch. This pulls the results in to be very close to his original
>> patch.
>
> Ok, so it seems to be almost identical to my patch now. The only two
> differences seem to be the removal of the ntp_error correction to
> change the effective clock frequency at the current time instead of
> aligning it to the start of the tick and the flag to handle the xtime
> underflow.
>
> Can we get them in too?

So as for the ntp_error correction when we adjust the multiplier, I
believe that is still needed, since when we adjust the freq we move
the xtime_nsec value, which means we need to adjust the error from
that xtime_nsec value to the ideal value at that point.  But if you
can provide a better rational as to why it can be safely dropped, I'd
be happy to listen.

As for the xtime underflow handling, I'm still hesitant here since its
just a bit ugly. :)   So I'm trying to think of a cleaner way.

> I think both are necessary to avoid having large steps in ntp_error
> which take long time to correct. You can see this in the nohz off
> freq100 result from the simulator, for example.

So one part of my concern is I'm not as comfortable bending over
backwards all the time to avoid ntp_error. Sure, if we can avoid it in
the common case, that makes things better, but having occasional
bursts for good reason (like the underflow issue) I think is important
so we can ensure that the logic to converge does actually function
with larger errors. If we constrain all the cases where error can be
added, I worry it will make the correction logic fragile in the end.
But I'm not totally settled on this.

Another area we have to be careful with is there are still
architectures (powerpc and ia64) which haven't switched from the old
vsyscall rounding logic (CONFIG_GENERIC_TIME_VSYSCALL_OLD). In these
cases we add up to 1ns of error each tick/update as we round up the
sub-nanoseconds to ensure we don't see inconsistencies.  If the
adjustment logic can't handle this, I don't want to regress those
arches.

>> I'm not 100% sure we need the last patch in this series, as
>> it has additional computational cost and testing on real
>> hardware has shown NOHZ=y performance matching NOHZ=n with a
>> earlier version of just the first patch:
>>       https://lkml.org/lkml/2014/1/13/501
>> (though admittedly, the patch has changed since Richard's testing,
>> so the results are a bit stale).
>
> If I could get a sufficiently low update rate on real HW or a more
> accurate reference clock, I think I would be able to show you a
> difference. But even if we can't at this time, the removal of the
> complex feedback loop, which as you saw is difficult to keep working
> well in all cases (and we have tested only a very small number of
> them), is probably worth the extra computational cost.

 I do like the straightforward aspect of calculating the freq
adjustment, but I still am worried about particularly 32bit systems
where the extra 64bit divide and multiplies may add quite a bit of
overhead in the irq path (even if it is only done ~once a second).
But I'm going to try to get some measurement numbers to validate that.

thanks
-john
