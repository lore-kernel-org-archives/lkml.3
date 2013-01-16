Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3APWuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:50:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab3APWuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:50:07 -0500
Date: Wed, 16 Jan 2013 14:50:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-Id: <20130116145005.e20f4e53.akpm@linux-foundation.org>
In-Reply-To: <20130116101644.GA29162@quack.suse.cz>
References: <1358272714-23375-1-git-send-email-jack@suse.cz>
	<20130115233742.e8571f92.akpm@linux-foundation.org>
	<20130116101644.GA29162@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 11:16:44 +0100
Jan Kara <jack@suse.cz> wrote:

> On Tue 15-01-13 23:37:42, Andrew Morton wrote:
> > On Tue, 15 Jan 2013 18:58:34 +0100 Jan Kara <jack@suse.cz> wrote:
> > 
> > > A CPU can be caught in console_unlock() for a long time (tens of seconds are
> > > reported by our customers) when other CPUs are using printk heavily and serial
> > > console makes printing slow.  This triggers softlockup warnings because
> > > interrupts are disabled for the whole time console_unlock() runs (e.g.
> > > vprintk() calls console_unlock() with interrupts disabled).
> > 
> > It should trigger the NMI watchdog in that case?
>   Yes. I see soft lockup reports like:
> BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u:126:791]

That's not an actual NMI watchdog expiry.  Doesn't matter.

> > > We fix the issue by printing at most 1 KB of messages (unless we are in an
> > > early boot stage or oops is happening) in one console_unlock() call. The rest
> > > of the buffer will be printed either by further callers to printk() or by a
> > > queued work.
> > 
> > Complex.  Did you try just putting a touch_nmi_watchdog() in the loop?
>   I didn't try that. I suppose touch_nmi_watchdog() +
> rcu_cpu_stall_reset() would make the messages go away (yes, RCU eventually
> freaks out as well). But is it really sane that we keep single CPU busy,
> unusable for anything else, for such a long time? There can be no RCU
> callbacks processed, no IPIs are processed (which is what triggers
> softlockup reports), etc.

What's not sane is doing large amounts of printk over a slow device.

> I agree that if we silence all the warnings, everything will eventually
> hang waiting for the stalled CPU, that will finish the printing and things
> start from the beginning (we tried silencing RCU with rcu_cpu_stall_reset()
> and that makes the machine boot eventually). But it seems like papering
> over a real problem?  

Well not really - we're doing what the printk() caller asked us to do -
to synchronously print stuff.  And simply sitting there pumping out the
characters is the simplest, most straightforward thing to do.  And
printk() should be simple and straightforward.

If this is all a problem then the calling code should stop doing so
much printing!

And punting the operation to a kernel thread is a pretty radical change
- it surely adds significant risk that output will be lost.


So hrm, I dunno.  Can we just put the touch_nmi_watchdog() in there
intially, see if it fixes things?  If people continue to hit problems
then we can take a second look?

