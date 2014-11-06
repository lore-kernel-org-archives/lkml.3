Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaKFWbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:31:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaKFWbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:31:15 -0500
Date: Thu, 6 Nov 2014 14:31:14 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Christian Riesch <christian.riesch@omicron.at>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] n_tty: Add memory barrier to fix race condition in
 receive path
Message-ID: <20141106223114.GA1701@kroah.com>
References: <ef53eefc-6310-447e-bc8f-1ff05c0d7b8e@EXC02-ATKLA.omicron.at>
 <20141106203832.GB30170@kroah.com>
 <yw1xwq78jbr6.fsf@unicorn.mansr.com>
 <20141106205644.GA31435@kroah.com>
 <yw1xsihwjb67.fsf@unicorn.mansr.com>
 <20141106211754.GA32000@kroah.com>
 <yw1xoaskj9fw.fsf@unicorn.mansr.com>
 <20141106220249.GA952@kroah.com>
 <yw1xk338j7vd.fsf@unicorn.mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw1xk338j7vd.fsf@unicorn.mansr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:12:54PM +0000, Måns Rullgård wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > On Thu, Nov 06, 2014 at 09:38:59PM +0000, Måns Rullgård wrote:
> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> >> 
> >> > On Thu, Nov 06, 2014 at 09:01:36PM +0000, Måns Rullgård wrote:
> >> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> >> >> 
> >> >> > On Thu, Nov 06, 2014 at 08:49:01PM +0000, Måns Rullgård wrote:
> >> >> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> >> >> >> 
> >> >> >> > On Thu, Nov 06, 2014 at 12:39:59PM +0100, Christian Riesch wrote:
> >> >> >> >> The current implementation of put_tty_queue() causes a race condition
> >> >> >> >> when re-arranged by the compiler.
> >> >> >> >> 
> >> >> >> >> On my build with gcc 4.8.3, cross-compiling for ARM, the line
> >> >> >> >> 
> >> >> >> >> 	*read_buf_addr(ldata, ldata->read_head++) = c;
> >> >> >> >> 
> >> >> >> >> was re-arranged by the compiler to something like
> >> >> >> >> 
> >> >> >> >> 	x = ldata->read_head
> >> >> >> >> 	ldata->read_head++
> >> >> >> >> 	*read_buf_addr(ldata, x) = c;
> >> >> >> >> 
> >> >> >> >> which causes a race condition. Invalid data is read if data is read
> >> >> >> >> before it is actually written to the read buffer.
> >> >> >> >
> >> >> >> > Really?  A compiler can rearange things like that and expect things to
> >> >> >> > actually work?  How is that valid?
> >> >> >> 
> >> >> >> This is actually required by the C spec.  There is a sequence point
> >> >> >> before a function call, after the arguments have been evaluated.  Thus
> >> >> >> all side-effects, such as the post-increment, must be complete before
> >> >> >> the function is called, just like in the example.
> >> >> >> 
> >> >> >> There is no "re-arranging" here.  The code is simply wrong.
> >> >> >
> >> >> > Ah, ok, time to dig out the C spec...
> >> >> >
> >> >> > Anyway, because of this, no need for the wmb() calls, just rearrange the
> >> >> > logic and all should be good, right?  Christian, can you test that
> >> >> > instead?
> >> >> 
> >> >> Weakly ordered SMP systems probably need some kind of barrier.  I didn't
> >> >> look at it carefully.
> >> >
> >> > It shouldn't need a barier, as it is a sequence point with the function
> >> > call.  Well, it's an inline function, but that "shouldn't" matter here,
> >> > right?
> >> 
> >> Sequence points say nothing about the order in which stores become
> >> visible to other CPUs.  That's why there are barrier instructions.
> >
> > Yes, but "order" matters.
> >
> > If I write code that does:
> >
> > 100	x = ldata->read_head;
> > 101	&ldata->read_head[x & SOME_VALUE] = y;
> > 102	ldata->read_head++;
> >
> > the compiler can not reorder lines 102 and 101 just because it feels
> > like it, right?  Or is it time to go spend some reading of the C spec
> > again...
> 
> The compiler can't.  The hardware can.  All the hardware promises is
> that at some unspecified time in the future, both memory locations will
> have the correct values.  Another CPU might see 'read_head' updated
> before it sees the corresponding data value.  A wmb() between the writes
> forces the CPU to complete preceding stores before it begins subsequent
> ones.

Yes, sorry, I'm not talking about other CPUs and what they see, I'm
talking about the local one.  I'm not assuming that this is SMP "safe"
at all.  If it is supposed to be, then yes, we do have problems, but
there should be a lock _somewhere_ protecting this.

Peter's emails seem to be bouncing horridly right now, otherwise he
would chime in and set me straight as to how this all should be
working...

> Documentation/memory-barriers.txt explains it all in detail.

In _great_ detail :)

thanks,

greg k-h
