Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbbAWRGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:06:18 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42126 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbbAWRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:06:16 -0500
Message-ID: <1422032767.14076.151.camel@arm.com>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Fri, 23 Jan 2015 17:06:07 +0000
In-Reply-To: <20150105134514.GS30905@twins.programming.kicks-ass.net>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-4-git-send-email-pawel.moll@arm.com>
	 <20150105134514.GS30905@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.10-0ubuntu1~14.10.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 13:45 +0000, Peter Zijlstra wrote:
> Also, one would expect something like:
> 
> 	default: {
> 		struct k_clock *kc = clockid_to_kclock(event->attr.clock);
> 		struct timespec ts;
> 		if (kc) {
> 			kc->clock_get(event->attr.clock, &ts);
> 			data->clock = ktime_to_ns(timespec_to_ktime(ts));
> 		} else {
> 			data->clock = 0;
> 		}
> 	}
> 
> Albeit preferably slightly less horrible -- of course, one would first
> need to deal with the NMI issue.

I was thinking about it... Maybe the solution is approaching the problem
in a completely different way.

As far as I understand (John?) POSIX timers can be used on any clockid?
So it would be possible to obtain a dynamic clock id, for example for my
exotic trace hardware (by any means necessary, like opening a char
device) and create a timer firing every 1 ms (in the trace time domain).
Than this event would be somehow associated with a perf session (for
example, by passing the timerid via perf's ioctl) and then, every when
timer fires, a perf record (something like PERF_RECORD_TIMER?)
containing the timer/clock's value *and* the normal perf timestamp,
would be injected into the circular buffer.

No issue with NMI, no issue with passing clockid through
perf_event_attr...

Does it make any sense to anyone else but me? ;-)

Pawel

