Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaKFVjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:39:05 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:50870 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaKFVjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:39:03 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christian Riesch <christian.riesch@omicron.at>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, stable@vger.kernel.org
Subject: Re: [PATCH] n_tty: Add memory barrier to fix race condition in receive path
References: <ef53eefc-6310-447e-bc8f-1ff05c0d7b8e@EXC02-ATKLA.omicron.at>
	<20141106203832.GB30170@kroah.com>
	<yw1xwq78jbr6.fsf@unicorn.mansr.com>
	<20141106205644.GA31435@kroah.com>
	<yw1xsihwjb67.fsf@unicorn.mansr.com>
	<20141106211754.GA32000@kroah.com>
Date: Thu, 06 Nov 2014 21:38:59 +0000
In-Reply-To: <20141106211754.GA32000@kroah.com> (Greg Kroah-Hartman's message
	of "Thu, 6 Nov 2014 13:17:54 -0800")
Message-ID: <yw1xoaskj9fw.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Thu, Nov 06, 2014 at 09:01:36PM +0000, Måns Rullgård wrote:
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> 
>> > On Thu, Nov 06, 2014 at 08:49:01PM +0000, Måns Rullgård wrote:
>> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> >> 
>> >> > On Thu, Nov 06, 2014 at 12:39:59PM +0100, Christian Riesch wrote:
>> >> >> The current implementation of put_tty_queue() causes a race condition
>> >> >> when re-arranged by the compiler.
>> >> >> 
>> >> >> On my build with gcc 4.8.3, cross-compiling for ARM, the line
>> >> >> 
>> >> >> 	*read_buf_addr(ldata, ldata->read_head++) = c;
>> >> >> 
>> >> >> was re-arranged by the compiler to something like
>> >> >> 
>> >> >> 	x = ldata->read_head
>> >> >> 	ldata->read_head++
>> >> >> 	*read_buf_addr(ldata, x) = c;
>> >> >> 
>> >> >> which causes a race condition. Invalid data is read if data is read
>> >> >> before it is actually written to the read buffer.
>> >> >
>> >> > Really?  A compiler can rearange things like that and expect things to
>> >> > actually work?  How is that valid?
>> >> 
>> >> This is actually required by the C spec.  There is a sequence point
>> >> before a function call, after the arguments have been evaluated.  Thus
>> >> all side-effects, such as the post-increment, must be complete before
>> >> the function is called, just like in the example.
>> >> 
>> >> There is no "re-arranging" here.  The code is simply wrong.
>> >
>> > Ah, ok, time to dig out the C spec...
>> >
>> > Anyway, because of this, no need for the wmb() calls, just rearrange the
>> > logic and all should be good, right?  Christian, can you test that
>> > instead?
>> 
>> Weakly ordered SMP systems probably need some kind of barrier.  I didn't
>> look at it carefully.
>
> It shouldn't need a barier, as it is a sequence point with the function
> call.  Well, it's an inline function, but that "shouldn't" matter here,
> right?

Sequence points say nothing about the order in which stores become
visible to other CPUs.  That's why there are barrier instructions.

-- 
Måns Rullgård
mans@mansr.com
