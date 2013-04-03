Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835Ab3DCRfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:35:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45266 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730Ab3DCRfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:35:06 -0400
Message-ID: <1365010502.26858.32.camel@hornet>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Pawel Moll <pawel.moll@arm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Date: Wed, 03 Apr 2013 18:35:02 +0100
In-Reply-To: <515C66FE.7030501@linaro.org>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	 <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>
	 <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>
	 <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>
	 <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
	 <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>
	 <5159D221.70304@linaro.org> <1364889256.16858.1.camel@laptop>
	 <515B0502.8070408@linaro.org> <1365009558.26858.19.camel@hornet>
	 <515C66FE.7030501@linaro.org>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 03 Apr 2013 17:35:02.0177 (UTC) FILETIME=[9236A910:01CE3091]
X-MC-Unique: 113040318350304601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 18:29 +0100, John Stultz wrote:
> On 04/03/2013 10:19 AM, Pawel Moll wrote:
> > On Tue, 2013-04-02 at 17:19 +0100, John Stultz wrote:
> >> But if we're going to have to do
> >> this via a clockid, I'm going to want it to be done via a dynamic posix
> >> clockid, so its clear its tightly tied with perf and not considered a
> >> generic interface (and I can clearly point folks having problems to the
> >> perf maintainers ;).
> > Ok, so how about the code below?
> >
> > There are two distinct parts of the "solution":
> >
> > 1. The dynamic posix clock, as you suggested. Then one can get the perf
> > timestamp by doing:
> >
> > 	clock_fd = open("/dev/perf-clock", O_RDONLY);
> > 	clock_gettime(FD_TO_CLOCKID(clock_fd), &ts)
> >
> > 2. A sort-of-hack in the get_posix_clock() function making it possible
> > to do the same using the perf event file descriptor, eg.:
> >
> > 	fd = sys_perf_event_open(&attr, -1, 0, -1, 0);
> > 	clock_gettime(FD_TO_CLOCKID(fd), &ts)
> 
> #2 makes my nose wrinkle. 

To make myself clear: I consider the code as it is a hack.

> Forgive me for being somewhat ignorant on the 
> perf interfaces, but why is the second portion necessary or beneficial?

My thinking: the perf syscall returns a file descriptor already, so it
would make sense to re-use it in the clock_gettime() call instead of
jumping through loops to open a character device file, which may not
exist at all (eg. no udev) or may be placed or named in a random way
(eg. some local udev rule).

I'm open for different opinions :-)

Pawel


