Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaCFQuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:50:24 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35779 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaCFQuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:50:22 -0500
Date: Thu, 6 Mar 2014 16:51:37 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: "linux-kernel@lists.codethink.co.uk" 
	<linux-kernel@lists.codethink.co.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, grant.likely@linaro.org, robh+dt@kernel.org
Subject: Re: [Linux-kernel] [PATCH] ARM: kernel: respect device tree status
 of cpu nodes
Message-ID: <20140306165137.GC13346@red-moon>
References: <1393240960-31846-1-git-send-email-j@bitron.ch>
 <53178A03.3090004@codeaurora.org>
 <5318472A.5060700@codethink.co.uk>
MIME-Version: 1.0
In-Reply-To: <5318472A.5060700@codethink.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 06 Mar 2014 16:50:18.0167 (UTC) FILETIME=[27A0FC70:01CF395C]
X-MC-Unique: 114030616502004801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'in BenH and Grant to check how this is handled in powerPC]

On Thu, Mar 06, 2014 at 10:00:10AM +0000, Ben Dooks wrote:
> On 05/03/14 20:33, Stephen Boyd wrote:
> > +Lorenzo
> >
> > On 02/24/14 03:22, Jürg Billeter wrote:
> >> Skip 'disabled' cpu nodes when building the cpu logical map. This avoids
> >> booting cpus that have been disabled in the device tree.
> >>
> >> Signed-off-by: Jürg Billeter <j@bitron.ch>
> >> Reviewed-by: Ben Dooks <ben.dooks@codethink.co.uk>
> >> ---
> >>   arch/arm/kernel/devtree.c | 4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> >> index 739c3df..9aed299 100644
> >> --- a/arch/arm/kernel/devtree.c
> >> +++ b/arch/arm/kernel/devtree.c
> >> @@ -95,6 +95,10 @@ void __init arm_dt_init_cpu_maps(void)
> >>   		if (of_node_cmp(cpu->type, "cpu"))
> >>   			continue;
> >>
> >> +		/* Check if CPU is enabled */
> >> +		if (!of_device_is_available(cpu))
> >> +			continue;
> >> +
> >>   		pr_debug(" * %s...\n", cpu->full_name);
> >>   		/*
> >>   		 * A device tree containing CPU nodes with missing "reg"
> >
> > This doesn't follow the ePAPR spec. According to ePAPR status="disabled"
> > in a cpu node means "the cpu is in a quiescent state" and one can enable
> > it by using the "enable-method". At the least, we should document this
> > in bindings/arm/cpus.txt if we can all agree that we want this
> > definition of disabled.
> 
> My view was that disabled should be the same as for the device case
> as it makes sense that way.

Ok, it has been brought up before.

ePAPR v1.1, 2.3.4 "status"

"disabled" - Indicates that the device is not presently operational, but
             it might become operational in the future (for example,
             something is not plugged in, or switched off).
             Refer to the device binding for details on what disabled means
             for a given device.

So "disabled" for devices does not read that different to me to what
Stephen mentioned for a CPU.

After all you just want the CPU node to be ignored, and that's not a CPU
status, it is a DT trick to use one .dtsi for multiple boot scenarios.

I wonder how the status property has been used on powerPC.

By grepping the sources, it is checked in arch/powerpc/kernel/prom_init.c
and that's just to check CPU that are already in status =="okay", so
they can be put in a holding loop (I guess).

It should be fine to deviate from the ePAPR and consider using:

status = "disabled"

for your aim (it has been ignored so far on all ARM platforms I am aware
of, so this should not break the kernel).

We need to update cpus.txt accordingly and override it for ARM.

> We have a position where we want to use the .dtsi files but not all
> cpus are available to the Linux. If we cannot use disabled then we
> need some other method to say this cpu node is not available, so
> please do not try and bring it online (saves boot time waiting for
> CPU nodes that cannot online)

Understood, see above.

Lorenzo

