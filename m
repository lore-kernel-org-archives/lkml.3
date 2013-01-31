Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3AaAIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:08:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3AaAI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:08:28 -0500
Date: Wed, 30 Jan 2013 16:08:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-Id: <20130130160827.cadb3262.akpm@linux-foundation.org>
In-Reply-To: <20130129145424.GF32246@quack.suse.cz>
References: <20130115233742.e8571f92.akpm@linux-foundation.org>
	<20130116101644.GA29162@quack.suse.cz>
	<20130116145005.e20f4e53.akpm@linux-foundation.org>
	<20130116235529.GA10251@quack.suse.cz>
	<20130116161118.f6e2e6a4.akpm@linux-foundation.org>
	<20130117210442.GA23984@quack.suse.cz>
	<20130117133917.0f75728e.akpm@linux-foundation.org>
	<20130117234614.GB10127@quack.suse.cz>
	<20130117155029.cb70ec95.akpm@linux-foundation.org>
	<20130121210008.GB23041@quack.suse.cz>
	<20130129145424.GF32246@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 15:54:24 +0100
Jan Kara <jack@suse.cz> wrote:

> >   So I was testing the attached patch which does what we discussed. The bad
> > news is I was able to trigger a situation (twice) when suddently sda
> > disappeared and thus all IO requests failed with EIO. There is no trace of
> > what's happened in the kernel log. I'm guessing that disabled interrupts on
> > the printing CPU caused scsi layer to time out for some request and fail the
> > device. So where do we go from here?
>   Andrew? I guess this fell off your radar via the "hrm, strange, need to
> have a closer look later" path?

urgh.  I was hoping that if we left it long enough, one of both of us
would die :(

I fear we will rue the day when we changed printk() to bounce some of
its work up to a kernel thread.

> Currently I'd be inclined to return to my original solution...

Can we make it smarter?  Say, take a peek at the current
softlockup/nmi-watchdog intervals, work out how for how long we can
afford to keep interrupts disabled and then use that period and
sched_clock() to work out if we're getting into trouble?  IOW, remove
the hard-wired "1000" thing which will always be too high or too low
for all situations.

Implementation-wise, that would probably end up adding a kernel-wide
function along the lines of

/*
 * Return the maximum number of nanosecond for which interrupts may be disabled
 * on the current CPU
 */
u64 max_interrupt_disabled_duration(void)
{
	return min(sortirq duration, nmi watchdog duration);
}

Thinking ahead...

Other kernel sites which know they can disable interrupts for a long
time can perhaps use this.

Later, realtimeish systems (for example machine controllers) might want
to add a kernel tunable so they can set the
max_interrupt_disabled_duration() return value much lower.

To make that more accurate, we could add per-cpu, per-irq variables to
record sched_clock() when each CPU enters the interrupt, so the comment
becomes

/*
 * Return the remaining maximum number of nanosecond for which interrupts may
 * be disabled on the current CPU
 */

This may all be crazy and hopefully we'll never do it, but the design
should permit such things from day one if practical.

