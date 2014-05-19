Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaESMqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:46:23 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53842 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaESMqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:46:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org, rogerq@ti.com,
        balajitk@ti.com, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Marek Vasut'" <marex@denx.de>
Subject: Re: [PATCH 06/17] pci: host: pcie-designware: Use *base-mask* for configuring the iATU
Date: Mon, 19 May 2014 14:45:47 +0200
Message-ID: <5193704.9YxYic1Nyf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5375D3C8.1060204@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <5281007.CFRjW0Yeu2@wuerfel> <5375D3C8.1060204@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SKUCaNZob9sLE1M5WIg3LySkejBFqTSo9zHwzWtxHBA
 DpN5r+03C7xvAXI+o4yKdtSMBVff1TSToVZvrk5OtsKkQHgtc9
 FJ9bm5eJmE9dlp0yrcVRtCAm/xdkl1X7YPVbiaGSqomsJnMyPQ
 8PGXwhlJF1wwieST6cXjbrIz4enJw/heQXT8NjFnZ6/cTmP6P1
 0u5CptXFfVsp/RieEHz9CTnklKGgv7EJ3z3N2tiCqb8YecRVbE
 4eIUmhn6RZu403Dy2DW0LA6bpvLOZt5nPXAROw5xlLajulOdX7
 bmK/9qNtGbYEopX5MLH/1l/YJVlasPzOrrBNfqQdfmlBD+/wBO
 DX4416tWbz/nX6X2aKqY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2014 14:30:56 Kishon Vijay Abraham I wrote:
> On Wednesday 14 May 2014 06:15 PM, Arnd Bergmann wrote:
> > On Wednesday 14 May 2014 11:14:45 Kishon Vijay Abraham I wrote:
> > / {
> >       #address-cells = <1>; // or <2> if you support > 4GB address space
> >       #size-cells = <1>;
> > 
> >       soc {
> >               #address-cells <1>;
> >               #size-cells = <1>;
> >               ranges;
> >               dma-ranges;
> > 
> >               ... // all normal devices
> > 
> >               axi@20000000 {
> >                       #size-cells = <1>;
> >                       #address-cells = <1>;
> >                       dma-ranges; // can access all 4GB outbound
> >                       ranges = <0 0x20000000 0x10000000>; // 28-bit bus
> > 
> >                       pci@0 {
> >                               reg = <0x0    0x1000>, // internal regs
> >                                     <0x1000 0x2000>; // config space
> 
> The internal reg address space starts at 0x51000000. By Using this <0
> 0x20000000 0x10000000>; as ranges, we are not able to get the memory resource
> properly. Can we use multiple ranges? how do we specify which ranges the *reg*
> property to use?

Yes, multiple ranges will work fine. You can make up a representation
yourself if you don't know what the hardware really does.

Two possible ways of doing this would be

a)

	/* two separate physical connections represented as one logical bus */
	axi@20000000 {
		#address-cells = <2>;
		#size-cells = <1>;
		ranges = <0 0 0x20000000 0x10000000>, /* configurable registers */
			 <1 0 0x51000000 0x01000000>; /* PCI host registers */

		pci@1.0 {
			reg = <1 0 0x01000000>, /* host registers */
				<0 0x1000 0x2000>; /* config space */
		}

	};

b) 

	/* one physical bus, with some address munging */
	axi@20000000 {
		#address-cells = <1>;
		#size-cells = <1>;
		ranges = <0 0x20000000 0x10000000>, /* configurable registers */
			 <0x51000000 0x51000000 0x01000000>; /* PCI host registers */

		pci@1.0 {
			reg = <0x51000000 0x01000000>, /* host registers */
				<0x1000 0x2000>; /* config space */
		}

	};


> Btw I was using *simple-bus* as compatible to *axi*. Or should I create a new
> *axi* driver to create the pcie memory resources myself?

simple-bus is best here, since you don't have a complex bus that needs to
be set up using register accesses or that generates interrupts.

	Arnd
