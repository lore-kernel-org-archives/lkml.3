Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaITQfD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:35:03 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:57263 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaITQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:35:00 -0400
Date: Sat, 20 Sep 2014 18:34:57 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140920163457.GA302@x4>
References: <20140916170709.73ef2993@gandalf.local.home>
 <20140916212250.GI1205@quack.suse.cz>
 <20140916173328.6306a5c2@gandalf.local.home>
 <20140917141816.GO2840@worktop.localdomain>
 <20140917102255.5cd03071@gandalf.local.home>
 <20140917223633.GE2848@worktop.localdomain>
 <20140917203135.6db2ee5e@gandalf.local.home>
 <20140918173414.GU2840@worktop.localdomain>
 <20140920051224.GA5573@quack.suse.cz>
 <20140920113220.26e7434a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140920113220.26e7434a@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.09.20 at 11:32 -0400, Steven Rostedt wrote:
> On Sat, 20 Sep 2014 07:12:24 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Thu 18-09-14 19:34:14, Peter Zijlstra wrote:
> > > On Wed, Sep 17, 2014 at 08:31:35PM -0400, Steven Rostedt wrote:
> > > > I totally didn't get what you wrote.
> > > 
> > > :-)
> > > 
> > > > We don't want to know if it got delayed, then the patch to remove that
> > > > print seems correct.
> > > 
> > > Why would you not want to know that? Also was that the actual argument?
> > > Lemme go check the earlier emails -- I cannot find that argument in the
> > > first few emails.
> >   Well, so what gets delayed is printing from kernel buffer to console.
> > So this is the same as when you do printk() when console lock is taken by
> > someone else. So it seems a bit strange to prepend [delayed] in some cases
> > and not in others.
> > 
> > Another question is what the [delayed] prefix would be useful for? If the
> > message eventually gets printed to console I don't see why you would care
> > it was printed few ms after it entered the kernel buffer (after all the
> > time stamp before the line will be the time when it entered the kernel
> > buffer). And if the kernel crashes in such a way that the message doesn't
> > get printed, then bad luck but prefix in the kernel log buffer isn't going
> > to make that any better :)
> > 
> > This all feels like bikeshedding, I don't deeply care what gets done but I
> > wanted to point out I don't really see a use for [delayed]...
> > 
> 
> I pretty much agree with this assessment. I don't really care if
> there's a "[delayed]" message or not. I now agree that it isn't really
> that useful. Now what I do care about is that there's a bug with the
> current code, and the non bikeshed argument is how to fix this bug.
> 
> The bug is that there's users of printk_deferred() that use KERN_WARN
> in the format. This ends up showing "[delayed]<whacky-characters>
> message". The fix needs to remove those whacky characters.
> 
> There's three ways to fix this bug.
> 
> 1) change printk() to check for whacky characters before adding
> "[delayed]" and either move them before it or remove them all together.
> 
> 2) change all users of printk_deferred() to not add the KERN_WARN.
> 
> 3) just get rid of adding the "[delayed]" message and make printk()
> itself a bit cleaner.
> 
> I'm leaning towards #3 as I don't see the usefulness of that
> "[delayed]" message if there's other cases that can also delay printk.
> Remember, the code has been changed since the delayed message was added
> to make sure that the printk_deferred() message gets into the printk
> message in sequence of other printk's happening. The original way (when
> the "delayed" message was added) used its own buffer and would write to
> the log buffer at a later time, where the printk_deferred() could
> actually come out of sequence with other printk()s, and the "[delayed]"
> message would be useful for that case. But it's not useful anymore.
> 
> #1 of above will just makes printk more complex, and being such a
> critical function which is already complex enough, I would like to not
> do so.
> 
> #2 can fix the issue for now, until someone else adds a
> printk_deferred() with another KERN_WARN. Worse yet, someone may add
> one of the other KERN_* log levels and it will be ignored.

There are already two "printk_deferred(KERN_ERR" in kernel/time/ntp.c,
that get currently transformed to KERN_WARN.

> Getting beyond the bikeshedding, there's a real bug that should be
> fixed. We just need to figure out what's the best way to do so.

I agree that 3) is the best solution. Feel free to just add the
description of why it now makes sense to the patch.

-- 
Markus
