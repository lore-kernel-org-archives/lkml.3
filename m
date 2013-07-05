Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab3GEKoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:44:24 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:56574 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757207Ab3GEKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:44:22 -0400
Message-ID: <51D6A370.7060604@st.com>
Date: Fri, 5 Jul 2013 16:14:00 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>, Mohit KUMAR <Mohit.KUMAR@st.com>
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: exynos: split into two parts such as Synopsys part
 and Exynos part
References: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
In-Reply-To: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/5/2013 1:59 PM, Jingoo Han wrote:
> Exynos PCIe IP consists of Synopsys specific part and Exynos
> specific part. Only core block is a Synopsys designware part;
> other parts are Exynos specific.
> Also, the Synopsys designware part can be shared with other
> platforms; thus, it can be split two parts such as Synopsys
> designware part and Exynos specific part.
>

A quick and nice job :)
Just few minor comments.

> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Pratyush Anand <pratyush.anand@st.com>
> Cc: Mohit KUMAR <Mohit.KUMAR@st.com>
> ---
>   drivers/pci/host/Makefile          |    1 +
>   drivers/pci/host/pcie-designware.c |  907 +++++++-----------------------------
>   drivers/pci/host/pcie-designware.h |   72 +++
>   drivers/pci/host/pcie-exynos.c     |  619 ++++++++++++++++++++++++
>   4 files changed, 862 insertions(+), 737 deletions(-)
>   create mode 100644 drivers/pci/host/pcie-designware.h
>   create mode 100644 drivers/pci/host/pcie-exynos.c
>

[...]


> -
> -struct pcie_port {
> -       struct device           *dev;
> -       u8                      controller;
> -       u8                      root_bus_nr;
> -       void __iomem            *dbi_base;
> -       void __iomem            *elbi_base;
> -       void __iomem            *phy_base;
> -       void __iomem            *purple_base;

Just for knowledge, what is the purple_base. It might not be needed by 
all vendors. Can we explain the name in comment or can give some generic 
name?

> -       u64                     cfg0_base;
> -       void __iomem            *va_cfg0_base;
> -       u64                     cfg1_base;
> -       void __iomem            *va_cfg1_base;
> -       u64                     io_base;
> -       u64                     mem_base;
> -       spinlock_t              conf_lock;
> -       struct resource         cfg;
> -       struct resource         io;
> -       struct resource         mem;
> -       struct pcie_port_info   config;
> -       struct clk              *clk;
> -       struct clk              *bus_clk;
> -       int                     irq;
> -       int                     reset_gpio;
> -};
> -

[...]

> -
> -static inline void readl_rc(struct pcie_port *pp, void *dbi_base, u32 *val)
> +static inline void dw_pcie_readl_rc(struct pcie_port *pp, void *dbi_base,
> +                               u32 *val)

dbi_base is part of pp. So why to pass 3 args?

>   {
> -       exynos_pcie_sideband_dbi_r_mode(pp, true);
> -       *val = readl(dbi_base);
> -       exynos_pcie_sideband_dbi_r_mode(pp, false);
> -       return;
> +       if (pp->ops->readl_rc)
> +               pp->ops->readl_rc(pp, dbi_base, val);

ditto

> +       else
> +               *val = readl(dbi_base);
>   }
>
> -static inline void writel_rc(struct pcie_port *pp, u32 val, void *dbi_base)
> +static inline void dw_pcie_writel_rc(struct pcie_port *pp, u32 val,
> +                               void *dbi_base)

ditto

>   {
> -       exynos_pcie_sideband_dbi_w_mode(pp, true);
> -       writel(val, dbi_base);
> -       exynos_pcie_sideband_dbi_w_mode(pp, false);
> -       return;
> +       if (pp->ops->writel_rc)
> +               pp->ops->writel_rc(pp, val, dbi_base);

ditto

> +       else
> +               writel(val, dbi_base);
>   }


Regards
Pratyush
