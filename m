Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3AaHoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:44:08 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:41974 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3AaHoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:44:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130117133917.0f75728e.akpm@linux-foundation.org>
References: <1358272714-23375-1-git-send-email-jack@suse.cz>
	<20130115233742.e8571f92.akpm@linux-foundation.org>
	<20130116101644.GA29162@quack.suse.cz>
	<20130116145005.e20f4e53.akpm@linux-foundation.org>
	<20130116235529.GA10251@quack.suse.cz>
	<20130116161118.f6e2e6a4.akpm@linux-foundation.org>
	<20130117210442.GA23984@quack.suse.cz>
	<20130117133917.0f75728e.akpm@linux-foundation.org>
Date: Thu, 31 Jan 2013 13:14:05 +0530
Message-ID: <CAK7N6vptwoT+D4=Qs6D0a-vB8DbcHya_taJ6s7JxG7gQxEfwtw@mail.gmail.com>
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
From: anish singh <anish198519851985@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 3:09 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 17 Jan 2013 22:04:42 +0100
> Jan Kara <jack@suse.cz> wrote:
>
>> ...
>>
>>   So I played a bit with this. To make things easier for me I added
>> artificial mdelay(len*10) (effectively simulating console able to print 100
>> characters per second) just after call_console_drivers() so that I can
>> trigger issues even on a machine easily available to me. Booting actually
>> doesn't trigger any problems because there aren't enough things happening
>> in parallel on common machine during boot but
>>   echo t >/proc/sysrq-trigger &
>>   for i in /lib/modules/3.8.0-rc3-0-default/kernel/fs/*/*.ko; do
>>     name=`basename $i`; name=${name%.ko}; modprobe $name
>>   done
>> easily triggers the problem (as modprobe uses both RCU & IPIs to signal all
>> CPUs).
>>
>>   Adding
>>       touch_nmi_watchdog();
>>       touch_all_softlockup_watchdogs();
>>       rcu_cpu_stall_reset();
>
> I'm not sure that touch_all_softlockup_watchdogs() is needed?
> touch_nmi_watchdog() itself calls touch_softlockup_watchdog().
>
> If the rcu_cpu_stall_reset() is needed here then presumably it is
> needed elsewhere and we should put a call to rcu_cpu_stall_reset() into
> (the increasingly misnamed) touch_nmi_watchdog().
>
>>   into the printk loop did stop all the warnings and the machine eventually
>> came alive again after finishing printing sysrq-t output (while printing
>> the machine was responding to ping but ssh stopped working after a while -
>> not sure what was happening but apparently some IO requests weren't
>> completing and maybe networking started dropping packets because it
>> accumulated too much RCU work).
>>
>> So your suggestion seems certainly plausible. I was just wondering
>>   a) Above three lines can be pretty expensive on big machines as they
>> iterate over all CPUs. So we should probably limit it to once per jiffy or
>> something like that?
>
> I guess so - is it hard to test the effects of such a change?  Maybe do
> a few MB of printks with the output disabled with `dmesg -n' and see
> what effect such a patch has?
>
> If it does need ratelimiting, I'd worry about using jiffies for that.
> If the kernel is spending a long time with interrupts disabled, jiffies
> might not be incrementing.  Using the CPU timestamp would be better
> (eg, sched_clock()).

http://lxr.free-electrons.com/source/kernel/sched/clock.c#L75
I am puzzled because of this definition(above link).Sched_clock is
dependent on jiffies and jiffies is blocked so how sched_clock would
be better(I am 100% missing something very obvious)?

Is it that sched_clock is not dependent on jiffies?
>
>>   b) Above three lines can make softlockup detection pretty useless if
>> there's enough printk traffic (it would be enough to printk() something
>> every 10s or so which can happen with netfilter logging packets or so).
>
> Yes, that is a concern.
>
>> But if we touch the watchdogs only if we spend more than 1 jiffy in the
>> console_unlock() we should hopefully touch those watchdogs only in rare
>> cases of heavy printk traffic.
>
> yup.  Another option might be to do the touch_nmi_watchdog() only if
> there is a "large" amount of data being emitted within
> console_unlock().  Like your 1000 character threshold.
>
>> PS: sysrq-t was ~200 KB on that freshly booted machine so on a busy machine
>> that would trigger softlockups with 115200 serial console as well (I
>> actually do remember seeing it in some customer's reports). So it's not
>> just boot.
>
> Yes, we have hit this before.  Large printks over slow console devices.
> See the sad little touch_nmi_watchdog() in lib/show_mem.c, for
> example.  I actually thought we'd fixed this in printk itself but it
> seems not - the two touch_nmi_watchdog()s in there are for special
> cases.
>
> Actually, a bit of grepping for touch_nmi_watchdog() is interesting.  A
> number of serial drivers are doing it, which makes me wonder why your
> customers weren't saved by that - using the wrong driver, perhaps?  If
> we can get this fixed centrally then a lot of those calls should be
> removeable.
>
> The presence of all those touch_nmi_watchdog() calls around the place
> has implications for the testing of your patch, btw ;)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
