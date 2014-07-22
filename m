Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaGVVL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:11:27 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60227 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaGVVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:11:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        jg1.han@samsung.com, mohit.kumar@st.com, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v3 1/4] PCI: designware: Configuration space should be specified in 'reg'
Date: Tue, 22 Jul 2014 23:11:14 +0200
Message-ID: <5462407.z4eX3u12aQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140722205326.GA25432@google.com>
References: <1405587643-13808-1-git-send-email-kishon@ti.com> <1405587643-13808-2-git-send-email-kishon@ti.com> <20140722205326.GA25432@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U4SUU668xXYH7R/nfI3IixQNMDDeeF6laZTKYoLJ0A8
 RX66kf8QBDHPb4u9o9mpr2g3COWcrlnXhRBTYi5C1Gwgtdsl/H
 YCQHASc43xuY0yNBObF3gp2U26lpFb3HUOU/JDoxY7AvM1WWo5
 dhXCC3+U4kx+LQoUmNLwKGg/rE9AUEPX7tQFddYD9HLYByTaTT
 v3fDght+sYPAsCt51TP2/0hVUjgJMZ66CYw2imYt31dXzn8rb+
 OQKWrjPZHtYcCEmpmf3kVMeNVWo1X8gGS5wn6QaX5mKkdJ1jYw
 VEkUlxj3xRZEw3+ALFHjM3paa28icxNQYWaAdPCcgCcs/WRbQm
 AgB02HkXVLdMe3ZKrqt0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 14:53:26 Bjorn Helgaas wrote:
> > @@ -2,6 +2,10 @@
> >  
> >  Required properties:
> >  - compatible: should contain "snps,dw-pcie" to identify the core.
> > +- reg: Should contain the configuration address space.
> > +- reg-names: Must be "config" for the PCIe configuration space.
> > +    (The old way of getting the configuration address space from "ranges"
> > +    is deprecated and should be avoided.)
> 
> I'm not a devicetree person, so please excuse my floundering here.
> There doesn't seem to be consistent usage of "reg" or "reg-names".

I think the above is ok, given the constraints we hae.

> Here's what I found in the existing Documentation/devicetree/bindings/pci
> stuff:
>
>   83xx-512x-pci.txt
>     - reg: should contain two address length tuples
>         The first is for the internal pci bridge registers
>         The second is for the pci config space access registers

This is fine

>   fsl,imx6q-pcie.txt
>     - reg: base addresse and length of the pcie controller

This should have included an entry for the config space, it was a
mistake

>   host-generic-pci.txt
>     - reg            : The Configuration Space base address and size, as accessed
>                        from the parent bus.

This is fine.

>   nvidia,tegra20-pcie.txt
>     - reg: A list of physical base address and length for each set of controller
>       registers. Must contain an entry for each entry in the reg-names property.
>     - reg-names: Must include the following entries:
>       "pads": PADS registers
>       "afi": AFI registers
>       "cs": configuration space region

The names are a bit strange, but it's also ok. In general we should mandate
the order of the entries as well.

>   pci-rcar-gen2.txt
>     - reg:  A list of physical regions to access the device: the first is
>             the operational registers for the OHCI/EHCI controllers and the
>             second is for the bridge configuration and control registers.

This one is wrong, as previously discussed. The first region should
have been listed in the 'ranges' property, because these are the registers
of the child nodes (the actual PCI devices) rather than the host controller
itself.

>   ralink,rt3883-pci.txt
>      - reg: specifies the physical base address of the controller and
>        the length of the memory mapped region.

The wording is a bit strange but it seems otherwise correct.

>   rcar-pci.txt
>     - reg: base address and length of the pcie controller registers.

This is ok

>   samsung,exynos5440-pcie.txt
>     - reg: base addresses and lengths of the pcie controller,
>           the phy controller, additional register for the phy controller.

Could be a bit more verbose, but is not wrong. In order to work
with the "snps,dw-pcie" binding, this will need a reg-names property.

>   v3-v360epc-pci.txt
>     - reg: should contain the base address of the V3 adapter.

This has the same mistake that the pcie-dw driver has and should
be fixed by putting the config space in there.

> So my questions are:
> 
> 1) Is "reg" the right place for configuration space?  I assume this is
> CAM or ECAM.  Only 83xx-512x-pci.txt, host-generic-pci.txt, and
> nvidia,tegra20-pcie.txt mention using "reg" for config space; all the
> others use "reg" for register space for the PCIe controller itself.

We had long debates about this. The conclusion was that we should
have put them in 'reg' from the start and not used 'ranges' here.

> 2) Is "config" the correct value for "reg-names"?  Only
> nvidia,tegra20-pcie.txt has something similar, and it wants "cs".
> Should these be the same?

It would be better if they were the same, but it's not important.
The names are private to the device driver, and the register layout
within this region is driver specific, so we can't use common code
to parse them anyway.

> 3) Doesn't this add a revlock (kernels with this patch require a new
> device tree that adds "reg" and "reg-names"?  I know both Mohit and
> Jingoo acked this [1,2], so I'm just double-checking that this is
> expected and desired.

My understanding is that the patch still allows the old method as
a fallback if no reg with the name "config" is present.

	Arnd
