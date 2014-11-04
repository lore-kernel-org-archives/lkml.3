Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaKDIZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:25:02 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:60349 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaKDIZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:25:00 -0500
Date: Tue, 4 Nov 2014 09:24:53 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Pawel Moll <pawel.moll@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Pawel Moll <mail@pawelmoll.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event
 generation
Message-ID: <20141104082453.GA4253@localhost.localdomain>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
 <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 05:11:53PM -0800, John Stultz wrote:
> On Mon, Nov 3, 2014 at 4:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > If you're going to add double-stamped packets, can you also add a
> > syscall to read multiple clocks at once, atomically?  Or can you
> > otherwise add a non-perf mechanism to get at this data?

Does not need to be "atomic". In fact it cannot be atomic in the
general case. Some clocks are read over memory mapped registers, but
others are read over slow and sleepy buses like PCIe or MDIO.

> > Because the realtime to monotonic offset is really quite useful for
> > things like this, and it seems silly to make people actually open a
> > perf_event to get at it.
> 
> So this comes up periodically, but I don't think I've seen a interface
> proposal that was decent yet.

We have ioctl PTP_SYS_OFFSET that alternately reads a dynamic clock
and CLOCK_REALTIME a given number of times. This is done without locks
or any kind of "atomic" guarantees, and it works quite well in
practice. The user can pick the number of repetitions to deal with
noisy run time environments, and usually it is a simple matter of
picking the reading with the shortest duration. However, the user is
free to do statistics over the readings in any way he wants.

It would be nice (and people have requested) a syscall that takes two
clockid_t arguments but otherwise works like PTP_SYS_OFFSET.

We really will never have to support more than two clocks. The
application will pick one clock as the reference and then measure each
of the other clocks relative to it, one at a time. The performance
should be perfectly adequate, even better than reading three or more
at once (with the understanding that these are "software" time
stamps).

Thanks,
Richard




