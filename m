Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbbAUTga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:36:30 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:64318 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbbAUTgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:36:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>, linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/5] PCI: st: Provide support for the sti PCIe controller
Date: Wed, 21 Jan 2015 20:35:41 +0100
Message-ID: <6574269.bTBzFhcnBx@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAG374jCRByNZuuYxi5+-mKvV7p5-tCf2G+8mTYfzU4rRV4yfYQ@mail.gmail.com>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org> <1682713.ac5OoTJoOr@wuerfel> <CAG374jCRByNZuuYxi5+-mKvV7p5-tCf2G+8mTYfzU4rRV4yfYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:hB2czjyreURXRsKqRhMK3tknPZKg/pR7RV6Vs7TAlgEzC9fPtMT
 Xs5B4tTRQ8JO/PanfiGTfVW707canYSbNlT757nE/lP9HVVpwlamm7sGtCPZtGkkdXxAZSF
 mLZCxYk2kCSNQLs7rz1xAsSHK822hp1ppZ9MbyI5LbAQLIuD8LYqEx3wiBsTQal39D6JSW6
 JoP3gUbmaL6Z4OCBcM/Kw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2015 16:47:36 Gabriel Fernandez wrote:
> On 19 January 2015 at 14:49, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 19 January 2015 13:37:33 Gabriel Fernandez wrote:
> >> On 17 December 2014 at 23:14, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Wednesday 17 December 2014 11:34:44 Gabriel FERNANDEZ wrote:
> >> > > +/*
> >> > > + * On ARM platforms, we actually get a bus error returned when the PCIe
> >> > IP
> >> > > + * returns a UR or CRS instead of an OK.
> >> > > + */
> >> > > +static int st_pcie_abort_
> >> >
> >> > handler(unsigned long addr, unsigned int fsr,
> >> > > +                              struct pt_regs *regs)
> >> > > +{
> >> > > +     return 0;
> >> > > +}
> >> >
> >> > You should check that it's actually PCI that caused the abort. Don't
> >> > just ignore a hard error condition.
> >> >
> >> > Usually there are registers in the PCI core that let you identify what
> >> > happened.
> >> >
> >>
> >>
> >> We return 0 because abort handler is not activated during boot.
> >>
> >
> > Can you just remove the handler then? We should never have exception
> > handlers that unconditionally return 0.
> >
> 
> Ah sorry, we need the handler because we can received aborts from
> user-land after the boot.
> 
> I have 2 solutions, the first to simplify we can only return 0.
> The second is to manage handler during boot. Then i need for that a
> new patch from Fabrice
> https://lkml.org/lkml/2014/2/7/631

I still don't get it. What is causing the abort? Is that something
user space does, or is it just a condition that gets stuck the pcie
device after probing that gets delivered once as soon as the aborts
are enabled?

> >>
> >> msi_data is a virtual address, it's obtained through a   __get_free_pages()
> >> function in dw_pcie_msi_init() procedure.
> >
> > I guess you need dma_map_single() then, or use dma_alloc_coherent instead
> > of __get_free_pages(). There is no guarantee that the page you allocate
> > there is actually visible to the PCI host at the same address that the CPU
> > uses, so you need to map from a CPU address to a DMA address that the PCI
> > host bridge uses.
> >
> >         Arnd
> 
> This is only to check the msi magic address given to ip, we never read
> or write in this area.
> this code is only a check

But doesn't the hardware access the pointer?

	Arnd
