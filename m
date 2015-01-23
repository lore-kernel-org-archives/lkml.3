Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbbAWSFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:05:47 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59381 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbbAWSFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:05:44 -0500
Message-ID: <54C28D71.6040603@gmail.com>
Date: Fri, 23 Jan 2015 11:05:37 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
CC: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>	 <1415292718-19785-4-git-send-email-pawel.moll@arm.com>	 <20150105134514.GS30905@twins.programming.kicks-ass.net> <1422032767.14076.151.camel@arm.com>
In-Reply-To: <1422032767.14076.151.camel@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/15 10:06 AM, Pawel Moll wrote:
> As far as I understand (John?) POSIX timers can be used on any clockid?
> So it would be possible to obtain a dynamic clock id, for example for my
> exotic trace hardware (by any means necessary, like opening a char
> device) and create a timer firing every 1 ms (in the trace time domain).
> Than this event would be somehow associated with a perf session (for
> example, by passing the timerid via perf's ioctl) and then, every when
> timer fires, a perf record (something like PERF_RECORD_TIMER?)
> containing the timer/clock's value*and*  the normal perf timestamp,
> would be injected into the circular buffer.

Like this: https://lkml.org/lkml/2011/2/27/158 ? note the date -- 4 
years ago. This is has been dragging on for a long time.

A few problems with that approach:
1. I would like to see a sample generated immediately to get the 
perf_clock -> timeofday correlation immediately rather than have to wait 
N (milli)seconds and have perf scan forward through an M-(giga)byte file 
looking for the one sample that gives the correlation.

I tried to address that problem with an ioctl to force a sample into the 
stream:
    https://lkml.org/lkml/2011/2/27/159
it did not go over very well.

2. there is a risk that the realtime samples dominate a stream.

Another issue that has been raised is updates to xtime by ntp / user. I 
have suggested tracepoints to catch those:
     https://lkml.org/lkml/2011/6/7/636
I don't believe there were ever any comments on the tracepoints.

David
