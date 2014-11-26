Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaKZQRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:17:17 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55262 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaKZQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:17:15 -0500
Message-ID: <5475FD02.3030501@linaro.org>
Date: Wed, 26 Nov 2014 16:17:06 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tim Sander <tim@krieglstein.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace()
 using FIQ (if available)
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-1-git-send-email-daniel.thompson@linaro.org> <1416936401-5147-6-git-send-email-daniel.thompson@linaro.org> <2744845.J3XUj2a9bM@dabox> <20141126131210.GI3836@n2100.arm.linux.org.uk>
In-Reply-To: <20141126131210.GI3836@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 13:12, Russell King - ARM Linux wrote:
> On Wed, Nov 26, 2014 at 01:46:52PM +0100, Tim Sander wrote:
>> Hi Daniel
>>
>> Am Dienstag, 25. November 2014, 17:26:41 schrieb Daniel Thompson:
>>> Previous changes have introduced both a replacement default FIQ handler
>>> and an implementation of arch_trigger_all_cpu_backtrace for ARM but
>>> these are currently independent of each other.
>>>
>>> This patch plumbs together these features making it possible, on platforms
>>> that support it, to trigger backtrace using FIQ.
>> Does this ipi handler interfere in any way with set_fiq_handler?
>>
>> As far as i know there is only one FIQ handler vector so i guess there is a 
>> potential conflict. But i have not worked with IPI's so i might be completley
>> wrong.
> 
> First, the code in arch/arm/kernel/fiq.c should work with this new FIQ
> code in that the new FIQ code is used as the "default" handler (as
> opposed to the original handler which was a total no-op.)
> 
> Secondly, use of arch/arm/kernel/fiq.c in a SMP system is really not a
> good idea: the FIQ registers are private to each CPU in the system, and
> there is no infrastructure to allow fiq.c to ensure that it loads the
> right CPU with the register information for the provided handler.
> 
> So, use of arch/arm/kernel/fiq.c and the IPI's use of FIQ /should/ be
> mutually exclusive.

Agree with the above. Just to add...

I am currently working to get NMI features from x86 land running on top
of the new default FIQ handler: arch_trigger_all_cpu_backtrace (with
Russell's patch), perf, hard lockup detector, kgdb.

However I don't think anything I'm doing makes it very much harder than
it already is to use arch/arm/kernel/fiq.c . That said, other then
setting the GIC up nicely, I am not doing anything to make it easier either.

I'd like to end up somewhere where if you want the NMI features (and
have a suitable device) you just use the default handler and it all just
works. If you need *Fast* Interrupt reQuests, proper old school "I want
to write an overclocked I2C slave in software" craziness and you can
pass on the improved debug features then set_fiq_handler() is still
there and still need extremely careful handling.

The only thing I might have done to make your life worse is not provide
the code to dynamically shunt all the debug and performance monitoring
features back to group 1. All except the hard lockup detector will have
logic to fall back statically. This means making it dynamic shouldn't be
that hard. However since there is no code in the upstream kernel that
would use the code I don't plan to go there myself.


Daniel.

