Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762141AbaGRTuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:50:21 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:61807 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246AbaGRTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:50:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v6 4/5] PCI: add PCI controller for keystone PCIe h/w
Date: Fri, 18 Jul 2014 21:50:08 +0200
Message-ID: <5467203.eMVRoNeSx1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com>
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com> <1405696469-7172-5-git-send-email-m-karicheri2@ti.com> <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:s1cPDv0OzrouZKC9/zCIVEkAwd192HebqWpaO/ZXw40
 9i4VdQT9cqxptZtv25fdsShqi1UFk6Qas2DwdbN1pxofL7bZ1W
 P90M50//sIqDgO5HzrjgScKAV/kkweQO7DoJ2NwFfguF5MiKD/
 P6sIzuidwQRHeT3H8jJXVlyjdyIrcTdfMlLZmIOz1g8cpYIFpV
 b7PBvBl5eqlpnRnN/krmeLCsudXz7kA2+ZOxl+7jqDfU4iLQBd
 JUlIB0oxOzz0FPfMzmO57UcOXG7nVR0OwtI1h7HEJB/RtBVd/I
 QL2wmXg9PM1dqAJeJTxZegSaDxiaxolp3HyYXGNwDg8cWR58jN
 8oN+9DtYmIzHFsViX/3U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 14:31:39 Rob Herring wrote:
> > +
> > + Example:
> > +       pcie_msi_intc: msi-interrupt-controller {
> > +                       interrupt-controller;
> > +                       #interrupt-cells = <1>;
> > +                       interrupt-parent = <&gic>;
> > +                       interrupts = <GIC_SPI 30 IRQ_TYPE_EDGE_RISING>,
> > +                                       <GIC_SPI 31 IRQ_TYPE_EDGE_RISING>,
> > +                                       <GIC_SPI 32 IRQ_TYPE_EDGE_RISING>,
> > +                                       <GIC_SPI 33 IRQ_TYPE_EDGE_RISING>,
> > +                                       <GIC_SPI 34 IRQ_TYPE_EDGE_RISING>,
> > +                                       <GIC_SPI 35 IRQ_TYPE_EDGE_RISING>,
> > +                                       <GIC_SPI 36 IRQ_TYPE_EDGE_RISING>,
> > +                                       <GIC_SPI 37 IRQ_TYPE_EDGE_RISING>;
> > +       };
> > +
> > +pcie_intc: Interrupt controller device node for Legacy irq chip
> > +       interrupt-cells: should be set to 1
> > +       interrupt-parent: Parent interrupt controller phandle
> > +       interrupts: GIC interrupt lines connected to PCI Legacy interrupt lines
> > +
> > + Example:
> > +       pcie_intc: legacy-interrupt-controller {
> > +               interrupt-controller;
> > +               #interrupt-cells = <1>;
> > +               interrupt-parent = <&gic>;
> > +               interrupts = <GIC_SPI 26 IRQ_TYPE_EDGE_RISING>,
> > +                       <GIC_SPI 27 IRQ_TYPE_EDGE_RISING>,
> > +                       <GIC_SPI 28 IRQ_TYPE_EDGE_RISING>,
> > +                       <GIC_SPI 29 IRQ_TYPE_EDGE_RISING>;
> > +       };
> 
> This seems wrong. Legacy interrupts should be described with
> interrupt-map and then PCI child devices have a standard interrupt
> specifier.
> 
> I'm not sure about MSIs, but I would think they would have a standard
> format too.
> 

IIRC, it's actually the correct way to do this here: the problem is that
the PCI IRQs are not directly connected to the GIC, but instead there is
a nested irqchip that has each PCI IRQ routed to it and that requires
an extra EOI for each interrupt.

The interrupt-map in the PCI host points to this special irqchip rather
than to the GIC.

	Arnd
