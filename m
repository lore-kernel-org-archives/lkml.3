Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaK1JKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:10:20 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:38232
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbaK1JKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:10:09 -0500
From: Tim Sander <tim@krieglstein.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace() using FIQ (if available)
Date: Fri, 28 Nov 2014 10:10:04 +0100
Message-ID: <13373554.4deCsZOMXS@dabox>
Organization: Sander and Lightning
User-Agent: KMail/4.14.2 (Linux/3.16.3; KDE/4.14.2; x86_64; ; )
In-Reply-To: <5475FD02.3030501@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <20141126131210.GI3836@n2100.arm.linux.org.uk> <5475FD02.3030501@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel, Russell

Am Mittwoch, 26. November 2014, 16:17:06 schrieb Daniel Thompson:
> On 26/11/14 13:12, Russell King - ARM Linux wrote:
> > On Wed, Nov 26, 2014 at 01:46:52PM +0100, Tim Sander wrote:
> >> Hi Daniel
> >> 
> >> Am Dienstag, 25. November 2014, 17:26:41 schrieb Daniel Thompson:
> >>> Previous changes have introduced both a replacement default FIQ handler
> >>> and an implementation of arch_trigger_all_cpu_backtrace for ARM but
> >>> these are currently independent of each other.
> >>> 
> >>> This patch plumbs together these features making it possible, on
> >>> platforms
> >>> that support it, to trigger backtrace using FIQ.
> >> 
> >> Does this ipi handler interfere in any way with set_fiq_handler?
> >> 
> >> As far as i know there is only one FIQ handler vector so i guess there is
> >> a
> >> potential conflict. But i have not worked with IPI's so i might be
> >> completley wrong.
> > 
> > First, the code in arch/arm/kernel/fiq.c should work with this new FIQ
> > code in that the new FIQ code is used as the "default" handler (as
> > opposed to the original handler which was a total no-op.)
> > 
> > Secondly, use of arch/arm/kernel/fiq.c in a SMP system is really not a
> > good idea: the FIQ registers are private to each CPU in the system, and
> > there is no infrastructure to allow fiq.c to ensure that it loads the
> > right CPU with the register information for the provided handler.
Well given the races in the GIC v1. i have seen in the chips on my desk 
initializing with for_each_possible_cpu(cpu) work_on_cpu(cpu,..) is rather 
easy. 
> > So, use of arch/arm/kernel/fiq.c and the IPI's use of FIQ /should/ be
> > mutually exclusive.
Yes but i digress on the assessment that this a decision between SMP and non-
SMP usage or the availbility of the GIC.

> Agree with the above. Just to add...
> 
> I am currently working to get NMI features from x86 land running on top
> of the new default FIQ handler: arch_trigger_all_cpu_backtrace (with
> Russell's patch), perf, hard lockup detector, kgdb.
> 
> However I don't think anything I'm doing makes it very much harder than
> it already is to use arch/arm/kernel/fiq.c . That said, other then
> setting the GIC up nicely, I am not doing anything to make it easier either.
> 
> I'd like to end up somewhere where if you want the NMI features (and
> have a suitable device) you just use the default handler and it all just
> works. If you need *Fast* Interrupt reQuests, proper old school "I want
> to write an overclocked I2C slave in software" craziness and you can
> pass on the improved debug features then set_fiq_handler() is still
> there and still need extremely careful handling.
Well i am not against these features as they assumably improve the backtrace,
but it would be nice to have a config option which switches between 
set_fiq_handler usage and the other conflicting usages of the fiq.

> The only thing I might have done to make your life worse is not provide
> the code to dynamically shunt all the debug and performance monitoring
> features back to group 1. All except the hard lockup detector will have
> logic to fall back statically. This means making it dynamic shouldn't be
> that hard. However since there is no code in the upstream kernel that
> would use the code I don't plan to go there myself.
I don't think this needs to by dynamic, but from a user perspective a config 
option would be really nice.

Tim
