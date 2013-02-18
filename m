Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3BRS73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:59:29 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:62905 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab3BRS72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:59:28 -0500
Message-ID: <51227A07.5020508@gmail.com>
Date: Mon, 18 Feb 2013 11:59:19 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Pawel Moll <pawel.moll@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet> <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com> <51118797.9080800@linaro.org> <1360113595.2621.30.camel@gandalf.local.home> <1360174657.4045.33.camel@hornet> <CABPqkBR=R_xnM1j8J_+vXHniqfBzJQRr8oUZz05YVzhbSW777w@mail.gmail.com> <1360838032.4045.126.camel@hornet> <CABPqkBRaMUOz6MsJRzCu2wcvGoYasdnZCnneyzrUstYTWRJnqA@mail.gmail.com>
In-Reply-To: <CABPqkBRaMUOz6MsJRzCu2wcvGoYasdnZCnneyzrUstYTWRJnqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/18/13 8:16 AM, Stephane Eranian wrote:
> Hi,
>
>
> I think the advantage of the ioctl() is that is reuses existing infrastructure.
> The downside is that to get the timestamp you need at a minimum:
>
> uint64_t get_perf_timestamp(void)
> {
>     struct perf_event_attr attr;
>     uint64_t ts = 0;
>     int fd;
>
>     memset(&attr, 0, sizeof(attr));
>
>     /* pick a dummy SW event (no PMU HW resource allocated), keep it disabled */
>     attr.type = PERF_TYPE_SOFTWARE;
>     attr.config =  PERF_COUNT_SW_CPU_CLOCK; /* dummy event */
>     attr.disabled = 1;
>
>     /* attach to self in per-thread mode */
>     fd = perf_event_open(&attr, 0, -1, -1, 0);
>     if (fd == -1)
>         return 0;
>
>    ioctl(fd, PERF_EVENT_IOC_GET_TIME, &ts);
>    close(fd);
>
>    return ts;
> }
>

That's the approach I took with an update to my perf_clock to 
time-of-day series. Specific patch:
 
https://github.com/dsahern/linux/commit/7e6f40fca5f8cdbee1cd46d42b11aee71d0ffd34

and series:
https://github.com/dsahern/linux/commits/perf-time-of-day-3.7

David
