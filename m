Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaCCTJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:09:54 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:54381 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468AbaCCTJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:09:51 -0500
Date: Mon, 3 Mar 2014 12:09:46 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2] pcie: Add Xilinx PCIe Host Bridge IP driver
Message-ID: <20140303190946.GA28341@obsidianresearch.com>
References: <1393854036-5244-1-git-send-email-sthokal@xilinx.com>
 <20140303174325.GB31062@obsidianresearch.com>
 <CA+mB=1JmRVzpz=32AbdN8W+2RrsxkPUb+s0zLUQXBrsj2Cdiwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+mB=1JmRVzpz=32AbdN8W+2RrsxkPUb+s0zLUQXBrsj2Cdiwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 12:21:55AM +0530, Srikanth Thokala wrote:

> >> +     pci_express: axi-pcie@50000000 {
> >> +             #address-cells = <3>;
> >> +             #size-cells = <2>;
> >> +             compatible = "xlnx,axi-pcie-host-1.00.a";
> >> +             reg = < 0x50000000 0x10000000 >;
> >> +             interrupts = < 0 52 4 >;
> >> +             ranges = < 0x02000000 0 0x60000000 0x60000000 0 0x10000000 >;
> >> +     };

> >  - How are INTA/B/C/D handled? Typically I'd like to see an
> >    interrupt-mapping block describing them.
> >
> >    There are a few options here, if the HW can decode A/B/C/D then
> >    it probably needs another irq_domain for INTx, and have the IRQ
> >    handler decode like it does for MSI.
> 
> The core provides a single interrupt for both INTx/MSI messages.  The
> core decodes the TLP messages and accordingly assert the INTx/MSI
> bits.  It provides two registers Interrupt FIFO Read 1 and Read 2 to get
> more information of these.
> 
>    | CPU |  <------  | PCIe IP |   <--  MSI/INTx Message (INTA, INTB,
> INTC, INTD)
> 
>    Reading Interrupt Status Reg -> MSI/INTx bit set/not set
>    Reading Root Port FIFO Read Register1 -> Mentions which interrupt
> (INTx) is received
>    Reading Root Port FIFO Read Register2 -> MSI Data

Okay, that matches my guess based on the code.

You probably want to do something like this:

     pci_express: axi-pcie@50000000 {
             #address-cells = <3>;
             #size-cells = <2>;
	     device_type ="pci";
             compatible = "xlnx,axi-pcie-host-1.00.a";
             reg = < 0x50000000 0x10000000 >;
             interrupts = < 0 52 4 >;
             ranges = < 0x02000000 0 0x60000000 0x60000000 0 0x10000000 >;

	     pcie_intc: interrupt-controller {
    		interrupt-controller;
		#address-cells = <0>;
		#interrupt-cells = <1>;
	     }

	     interrupt-map-mask = <0 0 0 7>;
	     interrupt-map = <0 0 0 1 &pcie_intc 0>, // INT A
	                     <0 0 0 2 &pcie_intc 2>, // INT B
	                     <0 0 0 3 &pcie_intc 3>, // INT C
	                     <0 0 0 4 &pcie_intc 4>; // INT D
     };

(similar to what ralink,rt3883 does for their binding)

Setup a interrupt domain like for MSI, except attach it to the
nested interrupt-controller DT node. Decode the 4 interrutps from
the core in the ISR and route them into the domain.

The generic code will take care of the rest.

This way all the interrupts are decoded and the interrupt-map DT
functionality is supported, which is important in a number of
board-specific corner cases.

> > You may want to work with Liviu to use his patch set which provides
> > more generic support. Also, the driver needs to put every one of these
> > ports in a PCI domain, Liviu is working on generic support for that
> > too.
> 
> I will check and come back to you.

Will's latest patch that was just posted is a very good example of how
the resource stuff should work correctly.

> > Don't forget to think about hot plug
> 
> Did you mean using 'rescan' (from sysfs), correct?

Yes

Jason
