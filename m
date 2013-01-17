Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3AQALV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 19:11:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab3AQALT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 19:11:19 -0500
Date: Wed, 16 Jan 2013 16:11:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-Id: <20130116161118.f6e2e6a4.akpm@linux-foundation.org>
In-Reply-To: <20130116235529.GA10251@quack.suse.cz>
References: <1358272714-23375-1-git-send-email-jack@suse.cz>
	<20130115233742.e8571f92.akpm@linux-foundation.org>
	<20130116101644.GA29162@quack.suse.cz>
	<20130116145005.e20f4e53.akpm@linux-foundation.org>
	<20130116235529.GA10251@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013 00:55:29 +0100
Jan Kara <jack@suse.cz> wrote:

> On Wed 16-01-13 14:50:05, Andrew Morton wrote:
> > > > > We fix the issue by printing at most 1 KB of messages (unless we are in an
> > > > > early boot stage or oops is happening) in one console_unlock() call. The rest
> > > > > of the buffer will be printed either by further callers to printk() or by a
> > > > > queued work.
> > > > 
> > > > Complex.  Did you try just putting a touch_nmi_watchdog() in the loop?
> > >   I didn't try that. I suppose touch_nmi_watchdog() +
> > > rcu_cpu_stall_reset() would make the messages go away (yes, RCU eventually
> > > freaks out as well). But is it really sane that we keep single CPU busy,
> > > unusable for anything else, for such a long time? There can be no RCU
> > > callbacks processed, no IPIs are processed (which is what triggers
> > > softlockup reports), etc.
> > 
> > What's not sane is doing large amounts of printk over a slow device.
>   Yeah, but serial consoles are handy... These sysadmins are pretty
> religious about them and when the machine doesn't boot with serial console
> enabled they complain. Nitpickers!

OK, so it's the boot-time message flood which is causing the problem.
Others may disagree, but I think that special case of message flooding
is quite justifiable.

> > > I agree that if we silence all the warnings, everything will eventually
> > > hang waiting for the stalled CPU, that will finish the printing and things
> > > start from the beginning (we tried silencing RCU with rcu_cpu_stall_reset()
> > > and that makes the machine boot eventually). But it seems like papering
> > > over a real problem?  
> > 
> > Well not really - we're doing what the printk() caller asked us to do -
> > to synchronously print stuff.  And simply sitting there pumping out the
> > characters is the simplest, most straightforward thing to do.  And
> > printk() should be simple and straightforward.
>   Except that printk() isn't always synchronous. It writes a message into
> the kernel buffer. If there is noone else pumping characters from the buffer
> into console at that moment, the printk caller starts doing so. But
> otherwise printk() just returns and pumping of characters is left on
> whoever started doing that thankless job. So that poor guy ends up doing
> the pumping for all the others...

Well yes; that's another of my hare-brained schemes, inflicted upon Linux
before everyone else was born.

> > If this is all a problem then the calling code should stop doing so
> > much printing!
>   It's mostly a device discovery that triggers the issues in practice. They
> have over thousand of SCSI disks attached (multipath in use) and when each
> disk prints ~400 bytes of messages (just check your dmesg) you end up with
> ~30s worth of printing over 115200 console.

OK.

If they're using 110 baud (nobody remembers what this word means) then
the 1000 chars will be too much.  More seriously, what happens if
they're using hardware flow control and someone kicks the cable out? 
Some people are going to want the kernel to just sit there waiting,
until the cable gets plugged in again.

> > And punting the operation to a kernel thread is a pretty radical change
> > - it surely adds significant risk that output will be lost.
>   I agree there is a higher chance the output will be lost.
> 
> > So hrm, I dunno.  Can we just put the touch_nmi_watchdog() in there
> > intially, see if it fixes things?  If people continue to hit problems
> > then we can take a second look?
>   OK, I'll see if I can get this tested on one of those machines...

Thanks.
