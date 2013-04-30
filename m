Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919Ab3D3Pye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:54:34 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:35882 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881Ab3D3Pyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:54:32 -0400
Message-ID: <517FE934.60501@intel.com>
Date: Tue, 30 Apr 2013 08:54:28 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        dirk.brandewie@gmail.com
Subject: Re: CONFIG_X86_INTEL_PSTATE disables CPU frequency transition stats,
 many governors and other standard features
References: <475427035.74642.1367038733183.JavaMail.mail@webmail08> <1843018.F0kGJi5K1v@vostro.rjw.lan> <517F2A9E.9040209@amacapital.net>
In-Reply-To: <517F2A9E.9040209@amacapital.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 07:21 PM, Andy Lutomirski wrote:
>
> Out of curiosity, what is this driver doing?
>
> It uses aperf/mperf magic to (I think) estimate how busy the CPU has
> been recently.  (This is clearly somewhat Intel-specific, but a similar
> estimate could be made using knowledge of the programmed frequency and
> the scheduler's idle time on any CPU.)
>

Not really magic aperf/mperf gives you the a ratio of how busy the core
is. From section 14-2 of vol 3 of the software developers manual.

   IA32_MPERF MSR (0xE7) increments in proportion to a fixed frequency, which is
   configured when the processor is booted.

   IA32_APERF MSR (0xE8) increments in proportion to actual performance, while
   accounting for hardware coordination of P-state and TM1/TM2; or software
   initiated throttling.

   The MSRs are per logical processor; they measure performance only when the
   targeted processor is in the C0 state.

   Only the IA32_APERF/IA32_MPERF ratio is architecturally defined; software
   should not attach meaning to the content of the individual of IA32_APERF or
   IA32_MPERF MSRs.



> It samples that estimate every 10 ms (why is this even remotely
> acceptable in a driver that's supposed to save power?).

The goal of the driver as to have better power efficiency that the
existing governors with out breaking anything including performance.

The 10 ms interval was chosen because that is what the ondemand governor
uses as a sample time.

In my testing I did not see a significant power benefit by increasing
the sample time and the impact on performance was noticeable since
the driver reacted slower to changes in load.

The timer is a deferrable timer so we are not waking idle cores to find
out how busy they are.  Also the amount of work done in the timer is pretty
small.

The 10 ms number is likely not the optimal number but is good enough to
not break anything (that I know of) and should be a good starting point
for real world use/testing/tuning.

The sample time can be adjusted via /sys/kernel/debug/pstate_snb/sample_rate_ms
if you would like to play with it.

>
> Using that sample, it updates one of two PID controllers to bring the
> busy or idle fraction (which one depends on the choice of controller) to
> a target value of 109/256 or 75/256.  In practice, it seems like once it
> starts using the busy controller, it never goes back unless XPERF_FIX is
> #defined, which it isn't.
>

The busy PID is the only one being used and idle PID will be removed in an 
upcoming patch removing the code associated with idle_mode. This code was
there to deal with a situation where you have two threads on separate cores
that depend on the progress of the thread on the other core to make progress
and ping-pong much faster than the sample time.  So it appears that neither
thread is very busy and is getting all the cpu that they want but they are not.
This was not completely solid that is why it is in the #ifdef block.

The new patch fixes the issue and is much easier to see what is going
on by looking at the code.

> It then adjusts the pstate as decreed by the PID controller.
>
> At least this has the property that, the busier the CPU, the higher the
> pstate.
>
Correct (mostly).

Each sample time the core is sampled to see how busy it is (aperf/mperf),
this is scaled to current requested p-state to get the scaled_busy value
which is handed to the PID that calculates the amount the pstate needs to be 
adjusted *UP/DOWN* based on the difference between the scaled busy value
and the setpoint of the PID.

>
>
>
> Not to sidetrack the discussion, but (wearing my HFT hat for a moment)
> has anyone else noticed that C1E is an absolute disaster for
> performance?  IMO the kernel should turn off C1E in case the BIOS is
> malicious enough to turn it on, and then the kernel should treat
> all-cores-idle as an extra, kind of strange idle state with very high
> exit latency and use it (and adjust frequency) accordingly?
>

I will let Len take this one :-)
--Dirk
> --Andy
>

