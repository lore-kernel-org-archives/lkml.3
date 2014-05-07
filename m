Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaEGTwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:52:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:50221 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaEGTw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:52:27 -0400
Date: Wed, 7 May 2014 21:52:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: John Stultz <john.stultz@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>
Subject: Re: [PATCH V2] clocksource: register cpu notifier to remove timer
 from dying CPU
In-Reply-To: <CAKohpon3J7c1waqcN_sqOKw=2ahzF2tk4yT8+e8fndxKobtqiA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1405072149520.6261@ionos.tec.linutronix.de>
References: <f13134fea7e7658ae3dab90faca1e6578b8f82e7.1397017662.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1405071203150.6261@ionos.tec.linutronix.de> <CAKohpon3J7c1waqcN_sqOKw=2ahzF2tk4yT8+e8fndxKobtqiA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Viresh Kumar wrote:
> On 7 May 2014 15:38, Thomas Gleixner <tglx@linutronix.de> wrote:
> > And the timer itself is not pinned at all. add_timer_on() does
> > not set the pinned bit.
> 
> The perception I had is this:
> - mod_timer() is a more complicated form of add_timer() as it has to
> tackle with migration and removal of timers as well. Otherwise they
> should work in similar way.
> - There is no PINNED bit which can be set, its just a parameter to
> __mod_timer() to decide which CPU the timer should fire on.
> - And by the 'name add_timer_on()', we must guarantee that timer
> fires on the CPU its being added to, otherwise it may break things
> for many. There might be users which want to run the handler
> on a particular CPU due to some CPU-specific stuff they want to do.
> And have used add_timer_on()...
> 
> But looking at your reply, it looks that add_timer_on() doesn't
> guarantee that timer would fire on the CPU mentioned? Is that the
> case for mod_timer_pinned() as well ?
> 
> And if that's the case what do we want should we do with these
> timers (i.e. ones added with add_timer_on or mod_timer_pinned)
> when we try to quiesce a cpu using cpuset.quiesce [1]?

There is no general rule to that. The timers which are added to be per
cpu are the critical ones. But there a lots of other use cases like
the watchdog which do not care on which cpu they actually fire. They
prefer to fire on the one they were armed on.

We have no way to distinguish that right now and I still need to find
a few free cycles to finish the design of the timer_list
replacement. I keep that in mind.

Thanks,

	tglx
