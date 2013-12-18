Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3LRSPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:15:53 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:64209 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3LRSPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:15:51 -0500
Date: Wed, 18 Dec 2013 11:15:47 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jagannadha Sutradharudu Teki 
	<jagannadha.sutradharudu-teki@xilinx.com>
Cc: Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jagannadha Sutradharudu Teki <jaganna@xilinx.com>
Subject: Re: [PATCH v2 2/2] Documentation: pci: Add pcie-howto.txt
Message-ID: <20131218181547.GD15119@google.com>
References: <1386848325-21064-1-git-send-email-jaganna@xilinx.com>
 <ced64bc2-ba6c-4bfc-bbc3-53cda681789c@CH1EHSMHS035.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ced64bc2-ba6c-4bfc-bbc3-53cda681789c@CH1EHSMHS035.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 05:08:45PM +0530, Jagannadha Sutradharudu Teki wrote:
> Added pcie-howto.txt for describing the information
> on PCI Express basics and Root Complex driver.
> 
> Signed-off-by: Jagannadha Sutradharudu Teki <jaganna@xilinx.com>
> ---
> Changes for v2:
> 	- Fixed comments from "Randy Dunlap"
> 
>  Documentation/PCI/00-INDEX       |   2 +
>  Documentation/PCI/pcie-howto.txt | 186 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 188 insertions(+)
>  create mode 100644 Documentation/PCI/pcie-howto.txt
> 
> diff --git a/Documentation/PCI/00-INDEX b/Documentation/PCI/00-INDEX
> index b8b7721..d61e7b9 100644
> --- a/Documentation/PCI/00-INDEX
> +++ b/Documentation/PCI/00-INDEX
> @@ -6,6 +6,8 @@ pci-error-recovery.txt
>  	- Info on PCI error recovery
>  MSI-HOWTO.txt
>  	- The Message Signaled Interrupts (MSI) Driver Guide HOWTO and FAQ
> +pcie-howto.txt
> +	- A guide describing the PCI Express basics and Root Complex driver
>  pcie-portbus-howto.txt
>  	- A guide describing the PCI Express Port Bus driver
>  pcie-aer-howto.txt
> diff --git a/Documentation/PCI/pcie-howto.txt b/Documentation/PCI/pcie-howto.txt
> new file mode 100644
> index 0000000..df464b5
> --- /dev/null
> +++ b/Documentation/PCI/pcie-howto.txt
> @@ -0,0 +1,186 @@
> +	PCI Express HOWTO
> +	Jagannadha Sutradharudu Teki <jagannadh.teki@gmail.com>
> +	12/12/2013
> +
> +1. About this guide
> +
> +This guide describes the basics of the PCI Express bus and provides
> +information on what the Linux PCIe subsystem looks like and ends with
> +a brief description of PCI Host controller/Root complex driver along
> +with some sample code.
> +
> +2. Basic terminology and conventions

This section is basic PCIe hardware info, basically the sort of information
you'd find in the first chapter of the PCIe spec or the MindShare PCIe
books.  I'm not necessarily opposed to putting this in Documentation/PCI,
but you should include full references (not just URLs for extracts as you
have now).

> +PCI Express is
> +- A high performance IO interconnect for peripherals.
> +- Low hardware design overhead compared to PCI, as it uses less pins.
> +- A serial point-to-point interconnect between two devices.
> +- Implements packet-based protocol for data transfer.
> +- Supports features like Advanced power management, Advanced error
> +  reporting facility, and hot-plug.
> +					_________
> +				       |	 |
> +				       |   CPU   |
> +				       |_________|
> +					    |
> +			 ___________________|___________________________
> +			|						| 	  ________
> +			|		ROOT COMPLEX			|        |	  |
> +			|						|--------| Memory |
> +			|   Switch Port			Root port	|	 |________|
> +			|_______________________________________________|
> +					    |				  PCIe Bus0
> +		____________________________|______________________________________
> +				|		|		  |
> +	      ____	  ______|______		|	      ____|____
> +	     |	  |	 /	       \      __|__	     |	       |
> +	     | EP |-----|    SWITCH	|    |     |	     | BRIDGE  |
> +	     |____|	 \_____________/     | EP  |	     | PCIe -  |
> +			    |	    | 	     |_____|         | PCI/PCIe|
> +			  __|__   __|__ 		     |_________|
> +			 |     | |     |			  |	  PCIe Bus1
> +			 | EP  | | EP  | 		__________|________________
> +			 |_____| |_____| 		    |		  |
> +							  __|__		__|__
> +							 |     |       |     |
> +							 | EP  |       | EP  |
> +							 |_____|       |_____|

The ROOT COMPLEX block should contain only one port (a Root Port).  A Root
Complex can contain several Root Port, but your drawing only shows one
(there's only one Link exiting your box).

I don't know if you mean something special by putting one EP block to the
left of the switch.  A detailed graphic would probably make it clear, but
for ASCII art, I think it would avoid confusion if you drew all the EP
blocks below the switch.

A Link only connects two components, so the Link exiting the ROOT COMPLEX,
i.e., the link from the Root Port, cannot connect to the SWITCH, the EP,
and the BRIDGE.  It could only connect to one of them.

A BRIDGE refers to a device with an Upstream Port on the primary (RC) side
and a conventional PCI or a PCI-X interface on the secondary side.  So your
BRIDGE box should say "BRIDGE PCIe - PCI/PCI-X", and the bus on the
downstream side would be PCI or PCI-X, not PCIe.  Obviously that means
there would not be PCIe Endpoints below it.

There is also such a thing as a PCI/PCI-X to PCIe Bridge, but these are
pretty rare.  In any case, a Switch has PCIe on both upstream and
downstream sides.  A Bridge has PCIe on one side and PCI/PCI-X on the
other.

> +Root Complex (RC)
> +Connects the CPU and memory subsystem to the PCIe fabric (A topology comprised of PCIe
> +nodes like Root Complex, Endpoint, Bridge or a Switch)
> +
> +Port
> +Interface between a PCIe component and the Link.
> +
> +Link
> +PCIe interconnect is referred as a Link, and connects two devices.
> +
> +Lane
> +A PCIe link consists of either 1, 2, 4, 8, 12, 16 or 32 signals in each direction
> +(each signal needs two wires - one for Tx and other for Rx). These signals are
> +referred to as Lanes.
> +
> +Upstream Port
> +Port that points in the direction of RC.
> +
> +Downstream Port
> +Port that points away from the RC.
> +
> +Root Port
> +Whose upstream port is RC and dowstream port should be an EP or Bridge.

A Root Port is a special kind of a Downstream Port, and it does not have an
Upstream Port at all.

> +Switch Port
> +Whose upstream port is RC and dowstream port is always a switch.

A Switch consists of one Upstream Port and one or more Downstream Ports.
It can be anywhere in the hierarchy, so its Upstream Port may lead to a
Root Port or to a Downstream Port of another Switch.  A Switch Downstream
Port may lead to an Endpoint, a Bridge, or to the Upstream Port of another
Switch.

> +Endpoint (EP)
> +Devices other than RC, Switches and Bridges which either generate or terminate a PCIe
> +transaction. These are peripheral devices such as Ethernet, USB and graphics devices.
> +
> +Switch
> +PCIe device single upstream port as RC and multiple downstream ports as EP's,
> +Switches or Bridges.
> +
> +Bridge
> +Is for extending PCIe Bus segment - whose downstream port points to one more PCIe bus.

Nope, as described above.

> +3. Linux PCIe Subsystem

Section 3 is really not PCIe-specific; with the exception of the PCIe Port
Bus driver, everything is generic across conventional PCI, PCI-X, and PCIe.
So this should not go in a file named "pcie-howto.txt".

> +
> +					  ifconfig	open()/close/read()/write()	   /proc, /sys
> +					      ^		     ^		   ^			^
> +					      |		     |		   |			|
> +					      |		     |		   |			|
> +					      |              |		   |			V
> +					      |		     |		   |		PCIe Port Bus services
> +					      |		     |		   |		(AER, HP, PME, VC
> +					      |		     |		   |		 drivers/pci/pcie/
> +					      |		     |		   |		 drivers/pci/hotplug)
> +					      V		     V		   V			^
> +					    Socket 	    Block	 Char		        |
> +					    layer	 Subsystem	Subsystem		|
> +					      ^		     ^		   ^			| pcie_port_service_register()
> +					      |		     |		   |			|
> +					      |		     |		   |			|
> +					      V		     V		   V			V
> +					 Common net	    USB		 Input		  PCIe Port Core
> +					 device layer       Core	 Core    (drivers/pci/pcie/portdrv_core.c)
> +					      ^		     ^		   ^			^
> +					      |		     |		   |			| pcie_port_bus_register()
> +					      |		     |		   |			|
> +					 _____V_____	 ____V____     ____V_____      _________V___________
> +					|	    |	|         |   |		 |    | 		    |
> +			All these are	| GEM 	    |	| USB HC  |   | Mouse/KB/|    | PCIe Port Bus driver|
> +			PCI endpoint	| Controller|	| driver  |   | TS HC	 |    | (drivers/pci/pcie/  |
> +			drivers		| driver    |	|	  |   |	driver	 |    |	 portdrv_pci.c)     |
> +					|___________|	|_________|   |__________|    |_____________________|
> +					      ^	             ^             ^			^
> +					      |__________    |		   |	       _________|
> +							 |   |		   |	      |		 pci_register_driver()
> +	     ___________________  pci_bus_*()	       __V___V_____________V__________V______
> +	    |			| pci_scan_root_bus() |					     |
> +	    |	  PCI BIOS	|-------------------->|     	     PCI Core		     |
> +            | (arch/arm/kernel/ |<--------------------|          (drivers/pci/pci*	     |
> +      ----->|        bios32.c))	|<---     pcibios_*() |           drivers/pci/bus.c)	     |
> +      |     |___________________|   |		      |______________________________________|
> +      |		     ^		    |
> +      |		     |		    | pci_common_init_dev()
> +      |		     |		    |
> +  ____V___	 ____V___	 ___V____
> + | 	  |     |	 |	|	 |
> + | Renesas|	| Tegra  |	| Exynos |
> + | PCI HC | 	| PCIe HC|	| PCIe HC| drivers/pci/host/
> + | driver |	| driver |	| driver | All these are
> + |________|	|________|	|________| PCI Root Complex drivers
> +     |		    |		    |
> +     |		    |		    |
> +     V		    V		    V
> +         platform_driver_register()

I would not say "All these are PCI endpoint drivers" because "Endpoint" is
specific to PCIe and doesn't mean anything in conventional PCI.  "PCI
drivers" is sufficient.  There is no special driver registration interface
for PCIe; the same driver can claim either PCI or PCIe devices with no
PCIe-specific code (if it needs PCIe-specific features, may have code for
those, of course).

> +Note:
> +Linux PCI subsystem is like above one without having a PCIe port bus stack.
> +For more details about this block see http://jagannadhteki.blog.com/2013/12/04/linux-pcie-subsystem/

I don't really want to include URLs outside of kernel.org things, because
we can't tell how long they will last.  You're already reproduced almost
everything from that drawing above, anyway.

> +PCI HC/RC driver
> +- Low level initialization and configuration (board, SoC)
> +- Invokes PCI-BIOS - for bus enumerations so that the endpoints on bus are ready.

Enumeration isn't really done by PCIBIOS; the PCI core does it by calling
the config space accessors supplied in struct pci_ops.  In general,
enumeration is the same for PCI and PCIe, so it finds "devices," not
"endpoints."

> +- Supplies struct pci_ops to read/write config space.
> +- Setup the resources like bus numbers, memory/IO space, Interrupt numbers, MSI.
> +- Register PCI-BIOS as pci_common_init_dev()

pci_common_init_dev() is an arch-specific function only used by ARM, as far
as I can tell.

> +PCI BIOS
> +- Architecture specific PCI
> +- Bus enumeration - Lane, Bus, Device, Memory, Interrupt.

Lanes really aren't visible in the core.  They're only relevant if you have
host bridge code that needs to initialize them or something.

> +- Successful completion of BIOS assures that all the endpoints in bus are
> +  assigned parts of available PCI resources and their respective Endpoint drivers
> +  can take control of them using the functionalities provided by PCI Core.

I don't know what "completion of BIOS" means -- there isn't a single phase
of "BIOS execution."

> +- Register to PCI core for common accessing of endpoint drivers.
> +- pci_scan_root_bus() and pci_bus_*()

I think pci_bus_add_devices() is the only relevant interface we talked
about here.  When necessary, it would logically be called by the host
bridge driver.

> +PCI Core
> +- Provides services to Lower level BIOS and Upper level endpoint layers.
> +- Creates device entries for proc/sysfs information.
> +- Linux kernel PCI bus and driver management code.
> +- Provides set of abstraction functions that endpoint drivers can use to
> +  initiate PCI communication with attached endpoints.
> +- Calls BIOS codes with pcibios_*
> +
> +PCI Endpoint driver
> +- Individual endpoint drivers from upper layer.
> +- Accessing config space upon respective endpoint enumeration done.
> +- Communicate over the endpoint for Tx/Rx transactions.
> +- Register to PCI core as pci_driver_register()
> +
> +PCIe Port Bus driver
> +- A logical PCI-PCI Bridge structure.
> +- Root Port and the Switch Port.
> +- See Documentation/PCI/pcie-portbus-howto.txt
> +
> +4. PCI HC/RC driver
> +
> +4.1 Description
> +
> +4.2 Sample code
> +
> +5. References
> +http://www.mindshare.com/files/ebooks/pci%20express%20system%20architecture.pdf
> +http://www.pcisig.com/developers/main/training_materials/
> -- 
> 1.8.3
> 
> 
