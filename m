Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3AaMqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:46:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab3AaMqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:46:37 -0500
Date: Thu, 31 Jan 2013 13:46:25 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-ID: <20130131124625.GB4612@quack.suse.cz>
References: <20130116145005.e20f4e53.akpm@linux-foundation.org>
 <20130116235529.GA10251@quack.suse.cz>
 <20130116161118.f6e2e6a4.akpm@linux-foundation.org>
 <20130117210442.GA23984@quack.suse.cz>
 <20130117133917.0f75728e.akpm@linux-foundation.org>
 <20130117234614.GB10127@quack.suse.cz>
 <20130117155029.cb70ec95.akpm@linux-foundation.org>
 <20130121210008.GB23041@quack.suse.cz>
 <20130129145424.GF32246@quack.suse.cz>
 <20130130160827.cadb3262.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130160827.cadb3262.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-13 16:08:27, Andrew Morton wrote:
> On Tue, 29 Jan 2013 15:54:24 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > >   So I was testing the attached patch which does what we discussed. The bad
> > > news is I was able to trigger a situation (twice) when suddently sda
> > > disappeared and thus all IO requests failed with EIO. There is no trace of
> > > what's happened in the kernel log. I'm guessing that disabled interrupts on
> > > the printing CPU caused scsi layer to time out for some request and fail the
> > > device. So where do we go from here?
> >   Andrew? I guess this fell off your radar via the "hrm, strange, need to
> > have a closer look later" path?
> 
> urgh.  I was hoping that if we left it long enough, one of both of us
> would die :(
  I'm too young for this strategy to work for me :)

> I fear we will rue the day when we changed printk() to bounce some of
> its work up to a kernel thread.
> 
> > Currently I'd be inclined to return to my original solution...
> 
> Can we make it smarter?  Say, take a peek at the current
> softlockup/nmi-watchdog intervals, work out how for how long we can
> afford to keep interrupts disabled and then use that period and
> sched_clock() to work out if we're getting into trouble?  IOW, remove
> the hard-wired "1000" thing which will always be too high or too low
> for all situations.
  Yes, I also thought that making offloading more clever (so that offload
doesn't happen unless we really have no choice) could make the approach
more acceptable. 

> Implementation-wise, that would probably end up adding a kernel-wide
> function along the lines of
> 
> /*
>  * Return the maximum number of nanosecond for which interrupts may be disabled
>  * on the current CPU
>  */
> u64 max_interrupt_disabled_duration(void)
> {
> 	return min(sortirq duration, nmi watchdog duration);
> }
  OK, that sounds good. So I'll write some patch...
 
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
