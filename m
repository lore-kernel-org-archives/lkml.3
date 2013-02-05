Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3BEW4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:56:13 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:48843 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab3BEW4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:56:12 -0500
MIME-Version: 1.0
In-Reply-To: <20130205123838.146a5371.akpm@linux-foundation.org>
References: <1360016230-26696-1-git-send-email-jack@suse.cz>
	<20130205123838.146a5371.akpm@linux-foundation.org>
Date: Tue, 5 Feb 2013 23:56:09 +0100
Message-ID: <CAFTL4hxGwUXmHs0venWANAkYs1CSwjDR1KEFF+waxqzSwup5TQ@mail.gmail.com>
Subject: Re: [PATCH v2] printk: Avoid softlockups in console_unlock()
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        jslaby@suse.cz, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/5 Andrew Morton <akpm@linux-foundation.org>:
> On Mon,  4 Feb 2013 23:17:10 +0100
> Jan Kara <jack@suse.cz> wrote:
>
>> A CPU can be caught in console_unlock() for a long time (tens of seconds are
>> reported by our customers) when other CPUs are using printk heavily and serial
>> console makes printing slow. Despite serial console drivers are calling
>> touch_nmi_watchdog() this triggers softlockup warnings because
>> interrupts are disabled for the whole time console_unlock() runs (e.g.
>> vprintk() calls console_unlock() with interrupts disabled). Thus IPIs
>> cannot be processed and other CPUs get stuck spinning in calls like
>> smp_call_function_many(). Also RCU eventually starts reporting lockups.
>>
>> In my artifical testing I also managed to trigger a situation when disk
>> disappeared from the system apparently because commands to / from it
>> could not be delivered for long enough. This is why just silencing
>> watchdogs isn't a reliable solution to the problem and we simply have to
>> avoid spending too long in console_unlock().
>>
>> We fix the issue by limiting the time we spend in console_unlock() to
>> watchdog_thresh() / 4 (unless we are in an early boot stage or oops is
>> happening). The rest of the buffer will be printed either by further
>> callers to printk() or by a queued work.
>
> I still hate the patch :(
>
>> ...
>>
>> +void console_unlock(void)
>> +{
>> +     if (__console_unlock()) {
>> +             /* Let worker do the rest of printing */
>> +             schedule_work(&printk_work);
>> +     }
>>  }
>
> This creates another place from where we cannot call printk(): anywhere
> where worker_pool.lock is held.
>
> And as schedule_work() can do a wakeup it creates a third reason why
> the sched code cannot call printk (along with rq->lock taken by
> wake_up(klogd) and rq->lock taken by up(&console_sem).  Hence
> printk_sched().  See the lkml thread "[GIT PULL] printk: Support for
> full dynticks mode".

Agreed, I really wish we avoid that workqueue solution.

>
> We already have machinery for doing async tickling in printk: the
> printk_pending stuff.  Did you consider adding another
> PRINTK_PENDING_foo in some fashion?

Yeah, that would delay until the next timer tick (small exception
after my patchset, if tick is stopped this will trigger as soon as
irqs are re-enabled through a self IPI) but we can probably improve
that behaviour. And that won't mess up with locking scenarios. The
printk tick (or irq work after my patchset) can also re-trigger itself
until the next tick if the batch to send to the console driver is too
big.
