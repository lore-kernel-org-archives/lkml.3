Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbaC0Rcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:32:43 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59429 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbaC0Rcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:32:41 -0400
X-Auth-Info: 5XaLIFnuuivEXD8W+12ZSw2RNOfRIIs2nnWtnxAaM4c=
From: Marek Vasut <marex@denx.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [RFC PATCH 03/12] pci: host: pcie-designware: Use *base-mask* for configuring the iATU
Date: Thu, 27 Mar 2014 18:32:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Mohit Kumar'" <mohit.kumar@st.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, tony@atomide.com, rnayak@ti.com,
        paul@pwsan.com, "'Richard Zhu'" <r65037@freescale.com>
References: <1395842272-15267-1-git-send-email-kishon@ti.com> <1395842272-15267-4-git-send-email-kishon@ti.com> <000001cf49b1$fcd8a810$f689f830$%han@samsung.com>
In-Reply-To: <000001cf49b1$fcd8a810$f689f830$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201403271832.11425.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 27, 2014 at 12:45:01 PM, Jingoo Han wrote:
> On Wednesday, March 26, 2014 10:58 PM, Kishon Vijay Abraham I wrote:
> > In DRA7, the cpu sees 32bit address, but the pcie controller can see only
> > 28bit address. So whenever the cpu issues a read/write request, the 4
> > most significant bits are used by L3 to determine the target controller.
> > For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe
> > controller but the PCIe controller will see only (0x000_0000 -
> > 0xFFF_FFF). So for programming the outbound translation window the
> > *base* should be programmed as 0x000_0000. Whenever we try to write to
> > say 0x2000_0000, it will be translated to whatever we have programmed in
> > the translation window with base as 0x000_0000.
> > 
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> (+cc Pratyush Anand, Marek Vasut, Richard Zhu)

Thanks.

> Acked-by: Jingoo Han <jg1.han@samsung.com>

This patch has no impact on MX6, the mask on MX6 is ~0 . A few comments below 
...
[...]

> > diff --git a/drivers/pci/host/pcie-designware.c
> > b/drivers/pci/host/pcie-designware.c index 17ce88f..98b661c 100644
> > --- a/drivers/pci/host/pcie-designware.c
> > +++ b/drivers/pci/host/pcie-designware.c
> > @@ -464,6 +464,9 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
> > 
> >  		return -EINVAL;
> >  	
> >  	}
> > 
> > +	if (of_property_read_u64(np, "base-mask", &pp->base_mask))
> > +		pp->base_mask = ~(0x0ULL);

You can just use ~0x0ULL without the () I believe.

[...]

> > diff --git a/drivers/pci/host/pcie-designware.h
> > b/drivers/pci/host/pcie-designware.h index 3063b35..3fa12a6 100644
> > --- a/drivers/pci/host/pcie-designware.h
> > +++ b/drivers/pci/host/pcie-designware.h
> > @@ -35,6 +35,7 @@ struct pcie_port {
> > 
> >  	struct device		*dev;
> >  	u8			root_bus_nr;
> >  	void __iomem		*dbi_base;
> > 
> > +	u64			base_mask;
> > 
> >  	u64			cfg0_base;
> >  	void __iomem		*va_cfg0_base;
> >  	u64			cfg1_base;

This structure contains a lot of slop, check [1] please. We really should be 
more careful about the structures. I think a separate patch to clean this up 
would be fine though.

[1] http://www.catb.org/esr/structure-packing/
