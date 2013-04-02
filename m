Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab3DBQTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:19:19 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51970 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab3DBQTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:19:17 -0400
Message-ID: <515B0502.8070408@linaro.org>
Date: Tue, 02 Apr 2013 09:19:14 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Ahern <dsahern@gmail.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>   <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>   <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>   <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>   <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>   <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>   <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>  <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>  <5159D221.70304@linaro.org> <1364889256.16858.1.camel@laptop>
In-Reply-To: <1364889256.16858.1.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 12:54 AM, Peter Zijlstra wrote:
> On Mon, 2013-04-01 at 11:29 -0700, John Stultz wrote:
>> I'm still not sold on the CLOCK_PERF posix clock. The semantics are
>> still too hand-wavy and implementation specific.
> How about we define the semantics as: match whatever comes out of perf
> (and preferably ftrace by default) stuff?

That's not a sane interface. We've already been bitten by semantic 
changes in sched_clock affecting in-kernel users. How are we going to 
handle this with userland in the future? What happens when applications 
depend on "what comes out of perf" on one system and that ends up being 
different on another? "Oh, its just broken, the application shouldn't be 
using that."

I'm sort of amazed that folks are so careful and hesitant to add an 
ioctl to inject a timestamp fence into perf, but then so cavalier about 
adding a ill-defined clockid as a generic interface.


> Since that stuff is already exposed to userspace, doesn't it make sense
> to have a user accessible time source that generates the same time-line
> so that people can create logs that can be properly interleaved?

Its exposed to userspace as timestamps correlated with specific data, 
not timestamps for any purpose. We export kernel function addresses via 
WARN_ON messages to dmesg, it doesn't mean we might as well allow 
userland to jump and execute those addresses. ;)

I still think exposing the perf clock to userland is a bad idea, and 
would much rather the kernel provide timestamp data in the logs 
themselves to make the logs useful. But if we're going to have to do 
this via a clockid, I'm going to want it to be done via a dynamic posix 
clockid, so its clear its tightly tied with perf and not considered a 
generic interface (and I can clearly point folks having problems to the 
perf maintainers ;).


thanks
-john

