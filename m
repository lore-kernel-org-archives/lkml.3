Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaJ2CIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:08:38 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:33975 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaJ2CIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:08:37 -0400
Date: Wed, 29 Oct 2014 11:08:33 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: non-Multiplatform APE6EVM broken in v3.18-rc1
Message-ID: <20141029020833.GA29787@verge.net.au>
References: <20141028004131.GA8280@verge.net.au>
 <CAMuHMdXmOeJowF9FSQtoUzNK4zohvSYm+r3qp41-JigAOJ=+fg@mail.gmail.com>
 <20141028092305.GA11937@verge.net.au>
 <CAMuHMdUnwT7a1Gewz3AW-R9EaQBfYkJ2y7ZQ6uW4GaxBAHXzXg@mail.gmail.com>
 <20141029001258.GE20702@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029001258.GE20702@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CC Sudeep Holla, Daniel Lezcano, LKML ]

On Wed, Oct 29, 2014 at 09:12:58AM +0900, Simon Horman wrote:
> On Tue, Oct 28, 2014 at 10:32:32AM +0100, Geert Uytterhoeven wrote:
> > Hi Simon,
> > 
> > On Tue, Oct 28, 2014 at 10:23 AM, Simon Horman <horms@verge.net.au> wrote:
> > > On Tue, Oct 28, 2014 at 08:59:28AM +0100, Geert Uytterhoeven wrote:
> > >> On Tue, Oct 28, 2014 at 1:41 AM, Simon Horman <horms@verge.net.au> wrote:
> > >> > I have noticed that there appears to be a regression between v3.17 and
> > >> > v3.18-rc1 such that non-multiplatform APE6EVM (ape6evm_defconfig) no longer
> > >> > boots.  This appears to be the case using both reference DT (MACH_APE6EVM)
> > >>
> > >> How does it manifest itself?
> > >> If you don't get any console output, have you tried my early debug patch?
> > >
> > > IIRC, there was no console output.
> > > I have not tried any out-of tree debug code :)
> > 
> > Perhaps it should just move in-tree?
> 
> Yes, perhaps it should :)
> 
> Regardless, I will try to give it a spin and report back.

Thanks that seems to work well on the ape6evm.

It seems that the boot stops here:

...
smsc911x smsc911x eth0: MAC Address: 00:08:f7:00:02:4b
rcar_thermal rcar_thermal: Runtime PM disabled, clock forced on.
rcar_thermal rcar_thermal: 3 sensor probed
sh_mobile_sdhi sh_mobile_sdhi.0: Runtime PM disabled, clock forced on.
sh_mobile_sdhi sh_mobile_sdhi.0: No vqmmc regulator found

I re-ran my bisection and this time the following showed up as the culprit.

I suspect that the initialisation of mmcif, which is usually the next
device to be initialised, sleeps and never wakes up because the timer is
disabled.

commit c387f07e6205cc13f57c1def5f885bf0a20e1c2d
Author: Sudeep Holla <sudeep.holla@arm.com>
Date:   Mon Sep 29 01:50:05 2014 +0200

    clocksource: arm_arch_timer: Discard unavailable timers correctly
    
    Currently we wait until both cp15 and mem timers are probed if we
    have both timer device nodes present in the device tree without
    checking if the device is actually available. If one of the timer
    device node present is disabled, the system locks up on the boot
    as no timer gets registered.
    
    This patch adds the check for the availability of the timer device
    so that unavailable timers are discarded correctly. It also adds
    the missing of_node_put.
    
    Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
    Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
    Acked-by: Mark Rutland <mark.rutland@arm.com>
    Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5163ec1..7e267e3 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -616,17 +616,29 @@ static const struct of_device_id arch_timer_mem_of_match[] __initconst = {
 	{},
 };
 
+static bool __init
+arch_timer_probed(int type, const struct of_device_id *matches)
+{
+	struct device_node *dn;
+	bool probed = false;
+
+	dn = of_find_matching_node(NULL, matches);
+	if (dn && of_device_is_available(dn) && (arch_timers_present & type))
+		probed = true;
+	of_node_put(dn);
+
+	return probed;
+}
+
 static void __init arch_timer_common_init(void)
 {
 	unsigned mask = ARCH_CP15_TIMER | ARCH_MEM_TIMER;
 
 	/* Wait until both nodes are probed if we have two timers */
 	if ((arch_timers_present & mask) != mask) {
-		if (of_find_matching_node(NULL, arch_timer_mem_of_match) &&
-				!(arch_timers_present & ARCH_MEM_TIMER))
+		if (!arch_timer_probed(ARCH_MEM_TIMER, arch_timer_mem_of_match))
 			return;
-		if (of_find_matching_node(NULL, arch_timer_of_match) &&
-				!(arch_timers_present & ARCH_CP15_TIMER))
+		if (!arch_timer_probed(ARCH_CP15_TIMER, arch_timer_of_match))
 			return;
 	}
 
