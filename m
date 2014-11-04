Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaKDQE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:04:27 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:34039 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaKDQEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:04:21 -0500
MIME-Version: 1.0
In-Reply-To: <3430954.VNaFmamXmP@wuerfel>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	<CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
	<CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
	<3430954.VNaFmamXmP@wuerfel>
Date: Tue, 4 Nov 2014 08:04:20 -0800
Message-ID: <CALAqxLWf9KVmSh2WHPi-RjERex2UvFXf2A3yuP44dLJ8ucbTBw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event generation
From: John Stultz <john.stultz@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Pawel Moll <pawel.moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 12:01 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 03 November 2014 17:11:53 John Stultz wrote:
>> I've got some thoughts on what a possible interface that wouldn't be
>> awful could look like, but I'm still hesitant because I don't really
>> know if exposing this sort of data is actually a good idea long term.
>
> I was also thinking (while working on an unrelated patch) we could use
> a system call like
>
> int clock_getoffset(clockid_t clkid, struct timespec *offs);
>
> that returns the current offset between CLOCK_REALTIME and the
> requested timebase. It is of course racy, but so is every use
> of CLOCK_REALTIME. We could also use a reference other than
> CLOCK_REALTIME that might be more stable, but passing two arbitrary
> clocks as input would make this much more complex to implement.

Yea, this is too racy for me, at least for it to be useful. You get an
offset, but you don't get any sense of what it was actually valid for.

I think to be at all useful, you'll have to return both a timestamp
for a given clockid, and an offset to the second clockid. That way you
can generate a valid point in time on two clocks (as best as possible,
given possible non-atomic reads of separately backed clockids).

But again, I'm not totally sure exposing this provides that much value
over userspace reading the two clocks itself (in ABA fashion) to sort
this out.

And I also don't see it as particularly related to this perf extension
that Pawel is doing (since we are trying to avoid making the perf
clock a directly accessible clockid).

thanks
-john
