Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbaKTSqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:46:46 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37405 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbaKTSqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:46:44 -0500
Message-ID: <546E370C.7000708@linaro.org>
Date: Thu, 20 Nov 2014 18:46:36 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Lucas Stach <l.stach@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC PATCH] arm: imx: Workaround i.MX6 PMU interrupts muxed to
 one SPI
References: <1416483757-24165-1-git-send-email-daniel.thompson@linaro.org> <1416484332.2769.1.camel@pengutronix.de> <546DF9AB.3080300@linaro.org> <20141120164835.GQ4042@n2100.arm.linux.org.uk>
In-Reply-To: <20141120164835.GQ4042@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/14 16:48, Russell King - ARM Linux wrote:
> On Thu, Nov 20, 2014 at 02:24:43PM +0000, Daniel Thompson wrote:
>> On 20/11/14 11:52, Lucas Stach wrote:
>>> I've sent almost the same patch a while ago. At this time it was shot
>>> down due to fears of the measurements being too flaky to be useful with
>>> all that IRQ dance. While I don't think this is true (I did some
>>> measurements on a SOLO and a QUAD variants of the i.MX6 with the same
>>> workload, that were only minimally apart), I believe the IRQ affinity
>>> dance isn't the best way to handle this.
>>
>> Cumulative statistics and time based sampling profilers should be fine
>> either way since a delay before the interrupt the asserted on the
>> affected core should have a low impact here.
> 
> One thing you're missing is that the interrupt latency for this can be
> horrific.
>
> Firstly, remember that Linux processes one interrupt (per core) at a time.
> What this means is that if we have two cores running interrupts (eg, CPU 2
> and CPU 3), and we raise a PMU interrupt on CPU 1 which is supposed to be
> for CPU 0, then we'll process the interrupt on CPU 1, and forward it to
> CPU 2.  CPU 2 will then have it pending, but has to wait for the interrupt
> handler to complete before it can service it, where upon it forwards it to
> CPU 3.  CPU 3 then goes through the same before forwarding it to CPU 0.

Agreed. Rotating the affinity is an obviously linear approach so
naturally the worst case interrupt latency grows linearly with the
number of cores.

However unpredictable interrupt responses times should not prevent the
results of a time based sampling profiler from being useful.

A mentioned before such latencies are certainly of significant concern
when we profile multiple cores at once and we are reacting to specific
events within the core rather than simply the passing of time.


> I also wonder how this works when you use perf record -a (from all CPUs.)
> If the sampling rate is high enough, will the interrupt be forwarded to
> the other CPUs?  Has perf record -a been tested?

It has now... (mostly I've been using perf top since its easier decide
if the profile "feels" right given the workload).

Anyhow I ran three CPU burn programs (two in C, one in shell) alongside
"watch cat /proc/interrupts" and stopped the test when all the CPUs had
taken a million PMU interrupts.

At the end we have recorded ~3288483 samples and the relevant line in
/proc/interrupts looks like this:
           CPU0       CPU1       CPU2       CPU3
126:    1283127    1025955    1328177    1328159       GIC 126

Perhaps I'm reading it wrong but I was quite pleasantly surprised by
that. The sum of all PMU interrupts taken is 4965418 and that means ~66%
of the interrupts did useful work *without* rotating the affinity. With
four cores sharing an interrupt I was expecting much worse than that.

BTW *without* the patch "perf record -a" causes CPU #0 to immediately
lock up handling interrupts. If we are lucky the spurious IRQ logic
triggers and disables the interrupt but in most cases the volume of
"good" PMU interrupts is sufficient to prevent the spurious IRQ detector
from firing at all so leaving the system dead in the water.
