Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaATPv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:51:56 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:60293 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaATPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:51:53 -0500
Date: Mon, 20 Jan 2014 16:51:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linaro Networking <linaro-networking@linaro.org>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
Message-ID: <20140120155145.GB9436@localhost.localdomain>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
 <20140115171704.GB21574@localhost.localdomain>
 <CAKohponEZydR1OmP2xziA9bc3OJPgP3bFmuWFQmrmeQFZccMVQ@mail.gmail.com>
 <alpine.DEB.2.02.1401161043350.4207@ionos.tec.linutronix.de>
 <CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpond3wY25H_tsJQ9xs_D2dP2_wGGU5J8fBteyfB=7wmAdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 05:00:20PM +0530, Viresh Kumar wrote:
> On 16 January 2014 15:16, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Just do the math.
> >
> >      max reload value / timer freq = max time span
> 
> Thanks.
> 
> > So:
> >
> >      0x7fffffff / 24MHz = 89.478485 sec
> >
> > Nothing to do here except to get rid of the requirement to arm the
> > timer at all.
> 
> @Frederic: Any inputs on how to get rid of this timer here?

I fear you can't. If you schedule a timer in 4 seconds away and your clockdevice
can only count up to 2 seconds, you can't help much the interrupt in the middle to
cope with the overflow.

So you need to act on the source of the timer:

* identify what cause this timer
* try to turn that feature off
* if you can't then move the timer to the housekeeping CPU

I'll have a look into the latter point to affine global timers to the
housekeeping CPU. Per cpu timers need more inspection though. Either we rework
them to be possibly handled by remote/housekeeping CPUs, or we let the associate feature
to be turned off. All in one it's a case by case work.
