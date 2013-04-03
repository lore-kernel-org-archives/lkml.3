Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762924Ab3DCRvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:51:05 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62535 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762748Ab3DCRvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:51:03 -0400
Message-ID: <515C6C01.9070905@linaro.org>
Date: Wed, 03 Apr 2013 10:50:57 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>  <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>  <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>  <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>  <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>  <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>  <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>  <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>  <5159D221.70304@linaro.org> <1364889256.16858.1.camel@laptop>  <515B0502.8070408@linaro.org> <1365009558.26858.19.camel@hornet>  <515C66FE.7030501@linaro.org> <1365010502.26858.32.camel@hornet>
In-Reply-To: <1365010502.26858.32.camel@hornet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 10:35 AM, Pawel Moll wrote:
> On Wed, 2013-04-03 at 18:29 +0100, John Stultz wrote:
>> On 04/03/2013 10:19 AM, Pawel Moll wrote:
>>> On Tue, 2013-04-02 at 17:19 +0100, John Stultz wrote:
>>>> But if we're going to have to do
>>>> this via a clockid, I'm going to want it to be done via a dynamic posix
>>>> clockid, so its clear its tightly tied with perf and not considered a
>>>> generic interface (and I can clearly point folks having problems to the
>>>> perf maintainers ;).
>>> Ok, so how about the code below?
>>>
>>> There are two distinct parts of the "solution":
>>>
>>> 1. The dynamic posix clock, as you suggested. Then one can get the perf
>>> timestamp by doing:
>>>
>>> 	clock_fd = open("/dev/perf-clock", O_RDONLY);
>>> 	clock_gettime(FD_TO_CLOCKID(clock_fd), &ts)
>>>
>>> 2. A sort-of-hack in the get_posix_clock() function making it possible
>>> to do the same using the perf event file descriptor, eg.:
>>>
>>> 	fd = sys_perf_event_open(&attr, -1, 0, -1, 0);
>>> 	clock_gettime(FD_TO_CLOCKID(fd), &ts)
>> #2 makes my nose wrinkle.
> To make myself clear: I consider the code as it is a hack.
>
>> Forgive me for being somewhat ignorant on the
>> perf interfaces, but why is the second portion necessary or beneficial?
> My thinking: the perf syscall returns a file descriptor already, so it
> would make sense to re-use it in the clock_gettime() call instead of
> jumping through loops to open a character device file, which may not
> exist at all (eg. no udev) or may be placed or named in a random way
> (eg. some local udev rule).
>
> I'm open for different opinions :-)

Cc'ing Richard for his thoughts here.


I get the reasoning around reusing the fd we already have, but is the 
possibility of a dynamic chardev pathname really a big concern?

I'm guessing the private_data on the perf file is already used?

Maybe can we extend the dynamic posix clock code to work on more then 
just the chardev? Although I worry about multiplexing too much 
functionality on the file.

thanks
-john

