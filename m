Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbaKGGuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:50:51 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61540 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaKGGus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:50:48 -0500
MIME-Version: 1.0
In-Reply-To: <yw1xfvdwj5yi.fsf@unicorn.mansr.com>
References: <ef53eefc-6310-447e-bc8f-1ff05c0d7b8e@EXC02-ATKLA.omicron.at>
	<20141106203832.GB30170@kroah.com>
	<yw1xwq78jbr6.fsf@unicorn.mansr.com>
	<20141106205644.GA31435@kroah.com>
	<yw1xsihwjb67.fsf@unicorn.mansr.com>
	<20141106211754.GA32000@kroah.com>
	<yw1xoaskj9fw.fsf@unicorn.mansr.com>
	<20141106220249.GA952@kroah.com>
	<yw1xk338j7vd.fsf@unicorn.mansr.com>
	<20141106223114.GA1701@kroah.com>
	<yw1xfvdwj5yi.fsf@unicorn.mansr.com>
Date: Fri, 7 Nov 2014 07:50:46 +0100
X-Google-Sender-Auth: u9j7Z3IpI9OXni8O-fXWMnOOdMU
Message-ID: <CABkLObpCAaQm1Lro9aNYHk=SV1w_uETm835j6F-uNGyGSWPnxA@mail.gmail.com>
Subject: Re: [PATCH] n_tty: Add memory barrier to fix race condition in
 receive path
From: Christian Riesch <christian.riesch@omicron.at>
To: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[sent again due to stupid HTML mail problems, sorry]

On Thu, Nov 6, 2014 at 11:54 PM, Måns Rullgård <mans@mansr.com> wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>
>> On Thu, Nov 06, 2014 at 10:12:54PM +0000, Måns Rullgård wrote:
>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>>
>>> > On Thu, Nov 06, 2014 at 09:38:59PM +0000, Måns Rullgård wrote:
>>> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>> >>
>>> >> > On Thu, Nov 06, 2014 at 09:01:36PM +0000, Måns Rullgård wrote:
>>> >> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>> >> >>
>>> >> >> > On Thu, Nov 06, 2014 at 08:49:01PM +0000, Måns Rullgård wrote:
>>> >> >> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>> >> >> >>
>>> >> >> >> > On Thu, Nov 06, 2014 at 12:39:59PM +0100, Christian Riesch wrote:
>>> >> >> >> >> The current implementation of put_tty_queue() causes a race condition
>>> >> >> >> >> when re-arranged by the compiler.
>>> >> >> >> >>
>>> >> >> >> >> On my build with gcc 4.8.3, cross-compiling for ARM, the line
>>> >> >> >> >>
>>> >> >> >> >>  *read_buf_addr(ldata, ldata->read_head++) = c;
>>> >> >> >> >>
>>> >> >> >> >> was re-arranged by the compiler to something like
>>> >> >> >> >>
>>> >> >> >> >>  x = ldata->read_head
>>> >> >> >> >>  ldata->read_head++
>>> >> >> >> >>  *read_buf_addr(ldata, x) = c;
>>> >> >> >> >>
>>> >> >> >> >> which causes a race condition. Invalid data is read if data is read
>>> >> >> >> >> before it is actually written to the read buffer.
>>> >> >> >> >
>>> >> >> >> > Really?  A compiler can rearange things like that and expect things to
>>> >> >> >> > actually work?  How is that valid?
>>> >> >> >>
>>> >> >> >> This is actually required by the C spec.  There is a sequence point
>>> >> >> >> before a function call, after the arguments have been evaluated.  Thus
>>> >> >> >> all side-effects, such as the post-increment, must be complete before
>>> >> >> >> the function is called, just like in the example.
>>> >> >> >>
>>> >> >> >> There is no "re-arranging" here.  The code is simply wrong.
>>> >> >> >
>>> >> >> > Ah, ok, time to dig out the C spec...
>>> >> >> >
>>> >> >> > Anyway, because of this, no need for the wmb() calls, just rearrange the
>>> >> >> > logic and all should be good, right?  Christian, can you test that
>>> >> >> > instead?
>>> >> >>
>>> >> >> Weakly ordered SMP systems probably need some kind of barrier.  I didn't
>>> >> >> look at it carefully.
>>> >> >
>>> >> > It shouldn't need a barier, as it is a sequence point with the function
>>> >> > call.  Well, it's an inline function, but that "shouldn't" matter here,
>>> >> > right?
>>> >>
>>> >> Sequence points say nothing about the order in which stores become
>>> >> visible to other CPUs.  That's why there are barrier instructions.
>>> >
>>> > Yes, but "order" matters.
>>> >
>>> > If I write code that does:
>>> >
>>> > 100        x = ldata->read_head;
>>> > 101        &ldata->read_head[x & SOME_VALUE] = y;
>>> > 102        ldata->read_head++;
>>> >
>>> > the compiler can not reorder lines 102 and 101 just because it feels
>>> > like it, right?  Or is it time to go spend some reading of the C spec
>>> > again...
>>>
>>> The compiler can't.  The hardware can.  All the hardware promises is
>>> that at some unspecified time in the future, both memory locations will
>>> have the correct values.  Another CPU might see 'read_head' updated
>>> before it sees the corresponding data value.  A wmb() between the writes
>>> forces the CPU to complete preceding stores before it begins subsequent
>>> ones.
>>
>> Yes, sorry, I'm not talking about other CPUs and what they see, I'm
>> talking about the local one.  I'm not assuming that this is SMP "safe"
>> at all.  If it is supposed to be, then yes, we do have problems, but
>> there should be a lock _somewhere_ protecting this.
>
> Within the confines of a single CPU + memory, barriers are never needed.
> The moment another CPU or master-capable peripheral enters the mix,
> proper ordering must be enforced somehow.
>
> If the buffer is already protected by a lock of some kind, this will
> provide the necessary barriers, so nothing further is necessary.  If
> it's a lock-less design, there will need to be barriers somewhere.

It was changed to lock-less with 3.12 in commit
6d76bd2618535c581f1673047b8341fd291abc67 ("n_tty: Make N_TTY ldisc
receive
path lockless"). So I will try to read the memory barrier docs again.

Of course my little ARM system is no SMP system, but I guess this
should also be fixed for the SMP case, right?

Thanks,
Christian
