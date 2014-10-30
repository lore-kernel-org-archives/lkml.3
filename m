Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796AbaJ3Uto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:49:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:37264 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbaJ3Utn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:49:43 -0400
Date: Thu, 30 Oct 2014 21:49:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        xen-devel@lists.xenproject.org, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v2 03/11] time: Add rtc_tm_to_time64() safe version(using
 time64_t)
In-Reply-To: <CADcy93WzP-y8HXNrfx-vOCkruEdXVOhP2Up=KqW=vLuxHM7_YQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410302118170.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-4-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1410301444100.5308@nanos> <CADcy93WzP-y8HXNrfx-vOCkruEdXVOhP2Up=KqW=vLuxHM7_YQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, pang.xunlei wrote:
> On 30 October 2014 21:55, Thomas Gleixner <tglx@linutronix.de> wrote:
> > What's wrong with changing it to:
> >
> > time64_t rtc_tm_to_time64(struct rtc_time *tm)
> > {
> >         return mktime64(......);
> > }
> 
> Thank you for reminding me of this, and also a valuable principle when
> doing things.
> 
> I wanna change it to:
> void rtc_tm_to_time64(struct rtc_time *tm, time64_t *time)
> {
>     time = mktime64(......);
> }
> 
> Just keep it the similar format as rtc_time64_to_tm(), is this acceptable?

Why on earth want you do that? Just because it looks the same or what?

Come on, it's not that hard and this is not the CS 'Java for dummies'
course where you get an A for implementing 'looks the same' nonsense.

For rtc_time64_to_tm() you really want to hand in the pointer for the
result because returning the full structure is overkill as it involves
heavy stack operations.

But for rtc_tm_to_time64() this is a different story. All relevant
32bit architectures can deal with a u64 return value very well and in
most cases it creates better code.

Just do the simple experiment of implementing both, converting a dozen
drivers and comparing the resulting assembler code on the call sites
and the function itself. That should give you an objective decision
criteria instead of "wanna change just because I feel it looks better".

Another valuable principle of doing things to remember, right?

Thanks,

	tglx






