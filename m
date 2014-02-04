Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbaBDSP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:15:27 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:36128 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbaBDSPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:15:17 -0500
Date: Tue, 4 Feb 2014 11:15:14 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Message-ID: <20140204181514.GA25695@obsidianresearch.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqL+3S8w=_Fb-t0rVcq0sDiPSDM6nqn3mR2DHKw=VTffsg@mail.gmail.com>
 <20140203233137.GH2519@obsidianresearch.com>
 <13031998.NR888KZWhk@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13031998.NR888KZWhk@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 10:44:52AM +0100, Arnd Bergmann wrote:

>   Now I want to integrate the EHCI into my SoC and not waste one
>   of my precious PCIe root ports, so I have to create another PCI
>   domain with its own ECAM compliant config space to put it into.
>   Fortunately SBSA lets me add an arbitrary number of PCI domains,
>   as long as they are all strictly compliant. To software it will

Just to touch on this for others who might be reading..

IMHO any simple SOC that requires multiple domains is *broken*. A
single domain covers all reasonable needs until you get up to
mega-scale NUMA systems, encouraging people to design with multiple
domains only complicates the kernel :(

SOC internal peripherals should all show up in the bus 0 config space
of the only domain and SOC PCI-E physical ports should show up on bus
0 as PCI-PCI bridges. This is all covered in the PCI-E specs regarding
the root complex.

Generally I would expect the internal peripherals to still be
internally connected with AXI, but also connected through the ECAM
space for configuration, control, power management and address
assignment.

> 2. all address windows are set up by the boot loader, we only
>   need to know the location (IMHO this should be the
>   preferred way to do things regardless of SBSA).

Linux does a full address map re-assignment on boot, IIRC. You need
more magics to inhibit that if your BAR's and bridge windows don't
work.

Hot plug is a whole other thing..

> it's possible that the designware based ones get point 4 right.

The designware one's also appear to be re-purposed end point cores, so
their config handling is somewhat bonkers. Tegra got theirs sort of
close because they re-used knowledge/IP from their x86 south bridges -
but even then they didn't really implement ECAM properly for an ARM
environment.

Since config space is where everyone to date has fallen down, I think
the SBSA would have been wise to list dword by dword what a typical
ECAM config space should look like.

Jason
