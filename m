Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaKDKte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:49:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:58702 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaKDKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:49:29 -0500
Date: Tue, 4 Nov 2014 11:49:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, Pawel Moll <pawel.moll@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Pawel Moll <mail@pawelmoll.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event
 generation
In-Reply-To: <20141104082728.GB4253@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1411041111010.5308@nanos>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com> <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com> <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com> <3430954.VNaFmamXmP@wuerfel>
 <20141104082728.GB4253@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014, Richard Cochran wrote:

> On Tue, Nov 04, 2014 at 09:01:31AM +0100, Arnd Bergmann wrote:
> > On Monday 03 November 2014 17:11:53 John Stultz wrote:
> > > I've got some thoughts on what a possible interface that wouldn't be
> > > awful could look like, but I'm still hesitant because I don't really
> > > know if exposing this sort of data is actually a good idea long term.
> >  
> > I was also thinking (while working on an unrelated patch) we could use
> > a system call like
> > 
> > int clock_getoffset(clockid_t clkid, struct timespec *offs);

We might make *offs a timespec64 or u64 :)

> > that returns the current offset between CLOCK_REALTIME and the
> > requested timebase. It is of course racy, but so is every use
> > of CLOCK_REALTIME. We could also use a reference other than
> > CLOCK_REALTIME that might be more stable, but passing two arbitrary
> > clocks as input would make this much more complex to implement.
> 
> No, it is really easy to implement. Just drop the idea of "atomic". It
> really is not necessary or even possible.

If the two clocks have the same underlying hardware then you get an
'atomic' snapshot of their relationship. That's true for any
combination of CLOCK_REALTIME, CLOCK_MONOTONIC, CLOCK_BOOTTIME and
CLOCK_TAI. So we can and should expose these 'atomic' snapshots.

There is another reason why we want to support the notion of 'atomic'
snapshots: There exists hardware which gives you 'atomic' samples of
two different hardware clocks and there is more of that coming soon.

If that's not the case then you need two seperate readouts which of
course cannot provide any guarantee, but I agree that we could do
something like what you do in the PTP_SYS_OFFSET ioctl and let user
space analyze the samples. But that should be optional.

Thanks,

	tglx
