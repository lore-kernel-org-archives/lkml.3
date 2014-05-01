Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaEAWrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:47:51 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33466 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEAWru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:47:50 -0400
Date: Thu, 1 May 2014 15:47:44 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohua Li <shli@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
Message-ID: <20140501224744.GA2285@kmo-pixel>
References: <535676A1.3070706@kernel.dk>
 <5356916F.4000205@kernel.dk>
 <CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>
 <535716A5.6050108@kernel.dk>
 <CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>
 <535AD235.90604@kernel.dk>
 <CACVXFVPkiQT6yxse=sX1yuX8wLbr1sgbT4chQycbbPDR_A6hqA@mail.gmail.com>
 <535B13D7.4050202@kernel.dk>
 <CACVXFVORX_qgJNXcB3OFpscVx0eQAbLPv2Jr1N3_yBKrPsGXFA@mail.gmail.com>
 <53601602.5060306@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53601602.5060306@kernel.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 03:13:38PM -0600, Jens Axboe wrote:
> On 04/29/2014 05:35 AM, Ming Lei wrote:
> > On Sat, Apr 26, 2014 at 10:03 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >> On 2014-04-25 18:01, Ming Lei wrote:
> >>>
> >>> Hi Jens,
> >>>
> >>> On Sat, Apr 26, 2014 at 5:23 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 04/25/2014 03:10 AM, Ming Lei wrote:
> >>>>
> >>>> Sorry, I did run it the other day. It has little to no effect here, but
> >>>> that's mostly because there's so much other crap going on in there. The
> >>>> most effective way to currently make it work better, is just to ensure
> >>>> the caching pool is of a sane size.
> >>>
> >>>
> >>> Yes, that is just what the patch is doing, :-)
> >>
> >>
> >> But it's not enough.
> > 
> > Yes, the patch is only for cases of mutli hw queue and having
> > offline CPUs existed.
> > 
> >> For instance, my test case, it's 255 tags and 64 CPUs.
> >> We end up in cross-cpu spinlock nightmare mode.
> > 
> > IMO, the scaling problem for the above case might be
> > caused by either current percpu ida design or blk-mq's
> > usage on it.
> 
> That is pretty much my claim, yes. Basically I don't think per-cpu tag
> caching is ever going to be the best solution for the combination of
> modern machines and the hardware that is out there (limited tags).

Sorry for not being more active in the discussion earlier, but anyways - I'm in
100% agreement with this.

Percpu freelists are _fundamentally_ only _useful_ when you don't need to be
using all your available tags, because percpu sharding requires wasting your tag
space. I could write a mathematical proof of this if I cared enough.

Otherwise what happens is on alloc failure you're touching all the other
cachelines every single time and now you're bouncing _more_ cachelines than if
you just had a single global freelist.

So yeah, for small tag spaces just use a single simple bit vector on a single
cacheline.

BTW, Shaohua Li's patch d835502f3dacad1638d516ab156d66f0ba377cf5 that changed
when steal_tags() runs was fundamentally wrong and broken in this respect, and
should be reverted, whatever usage it was that was expecting to be able to
allocate the entire tag space was the problem.
