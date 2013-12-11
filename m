Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3LKR6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:58:39 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:42490 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3LKR6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:58:37 -0500
MIME-Version: 1.0
In-Reply-To: <52A8A1CA.6000407@infradead.org>
References: <1386753319-21500-1-git-send-email-jaganna@xilinx.com>
	<9e43a9a6-9883-45c5-aaf1-432ac06c7dce@AM1EHSMHS017.ehs.local>
	<52A8A1CA.6000407@infradead.org>
Date: Wed, 11 Dec 2013 23:28:36 +0530
Message-ID: <CAD6G_RRX4ZZfX0LNiUJCF-G585s6+t791tsxnXw2xi-GJHzC2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] Documentation: pci: Add pcie-howto.txt
From: Jagan Teki <jagannadh.teki@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jagannadha Sutradharudu Teki 
	<jagannadha.sutradharudu-teki@xilinx.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jagannadha Sutradharudu Teki <jaganna@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy

On Wed, Dec 11, 2013 at 11:02 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 12/11/13 01:15, Jagannadha Sutradharudu Teki wrote:
>> Added pcie-howto.txt for describing the information
>> on PCI Express basics and Root Complex driver.
>>
>> Signed-off-by: Jagannadha Sutradharudu Teki <jaganna@xilinx.com>
>> ---
>>  Documentation/PCI/00-INDEX       |   2 +
>>  Documentation/PCI/pcie-howto.txt | 184 +++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 186 insertions(+)
>>  create mode 100644 Documentation/PCI/pcie-howto.txt
>>
>> diff --git a/Documentation/PCI/00-INDEX b/Documentation/PCI/00-INDEX
>> index b8b7721..d61e7b9 100644
>> --- a/Documentation/PCI/00-INDEX
>> +++ b/Documentation/PCI/00-INDEX
>> @@ -6,6 +6,8 @@ pci-error-recovery.txt
>>       - Info on PCI error recovery
>>  MSI-HOWTO.txt
>>       - The Message Signaled Interrupts (MSI) Driver Guide HOWTO and FAQ
>> +pcie-howto.txt
>> +     - A guide describing the PCI Express basics and Root Complex driver
>>  pcie-portbus-howto.txt
>>       - A guide describing the PCI Express Port Bus driver
>>  pcie-aer-howto.txt
>> diff --git a/Documentation/PCI/pcie-howto.txt b/Documentation/PCI/pcie-howto.txt
>> new file mode 100644
>> index 0000000..963cb75
>> --- /dev/null
>> +++ b/Documentation/PCI/pcie-howto.txt
>> @@ -0,0 +1,184 @@
>> +     PCI Express HOWTO
>> +     Jagannadha Sutradharudu Teki <jagannadh.teki@gmail.com>
>> +     05/12/2013
>> +
>> +1. About this guide
>> +
>> +This guide describes the basics of the PCI Express and provides
>
>                                               Express bus and
>
>> +information on how Linux PCIe subsystem looks like and at last
>
>                   what the Linux                      and ends
>
>> +with brief description of PCI Host controller/Root complex driver
>
>    with a brief
>
>> +along with some sample code.
>> +
>> +2. Basic terminology and conventions
>> +
>> +PCI Express is
>> +- A high performance, IO interconnect for peripherals.
>
>                        ^drop comma
>
>> +- Low hardware design overhead compared to PCI, as it uses less pins.
>> +- A serial point-to-point interconnect between two devices.
>> +- Implements packet based protocol for data transfer.
>
>                 packet-based
>
>> +- Supports features like Advanced power management, Advanced error
>> +  reporting facility, and hot-plug.
>> +                                     _________
>> +                                    |         |
>> +                                    |   CPU   |
>> +                                    |_________|
>> +                                         |
>> +                      ___________________|___________________________
>> +                     |                                               |         ________
>> +                     |               ROOT COMPLEX                    |        |        |
>> +                     |                                               |--------| Memory |
>> +                     |   Switch Port                 Root port       |        |________|
>> +                     |_______________________________________________|
>> +                                         |                             PCIe Bus0
>> +             ____________________________|______________________________________
>> +                             |               |                 |
>> +           ____        ______|______         |             ____|____
>> +          |    |      /             \      __|__          |         |
>> +          | EP |-----|    SWITCH     |    |     |         | BRIDGE  |
>> +          |____|      \_____________/     | EP  |         | PCIe -  |
>> +                         |       |        |_____|         | PCI/PCIe|
>> +                       __|__   __|__                      |_________|
>> +                      |     | |     |                          |       PCIe Bus1
>> +                      | EP  | | EP  |                __________|________________
>> +                      |_____| |_____|                    |             |
>> +                                                       __|__         __|__
>> +                                                      |     |       |     |
>> +                                                      | EP  |       | EP  |
>> +                                                      |_____|       |_____|
>> +
>> +Root Complex (RC)
>> +Connects the CPU and memory subsystem to the PCIe fabric (A topology comprised of PCIe
>> +nodes like Root Complex, Endpoint, Bridge or a Switch)
>> +
>> +Port
>> +Interface between a PCIe component and the Link.
>> +
>> +Link
>> +PCIe interconnect is referred as a Link, and connects two devices.
>> +
>> +Lane
>> +A PCIe link consists of either 1, 2, 4, 8, 12, 16 or 32 signals in each direction
>> +(each signal needs two wires - one for Tx and other for Rx). these signals are
>
>                                                                 These
>
>> +referred to as Lanes.
>> +
>> +Upstream Port
>> +Port that points in the direction of RC.
>> +
>> +Downstream Port
>> +Port the points away from the RC.
>
>         that
>
>> +
>> +Root Port
>> +Whose upstream port is RC and dowstream port should be a EP or Bridge.
>
>                                                           an
>
>> +
>> +Switch Port
>> +Whose upstream port is RC and dowstream port is always be a switch.
>
>                                                    always a switch.
>
>> +
>> +Endpoint (EP)
>> +Devices other than RC, Switches and Bridges which either generates or terminates a PCIe
>
>                                                             generate or terminate
>
>> +transaction. These are peripheral devices such as Ethernet, USB and graphics devices.
>> +
>> +Switch
>> +PCIe device single upstream port as RC and multiple downstream ports as EP's,
>> +Switches or Bridges.
>> +
>> +Bridge
>> +Is for extending PCIe Bus segment - whose downstream port points to one more PCIe bus.
>> +
>> +3. Linux PCIe Subsystem
>> +
>> +                                       ifconfig      open()/close/read()/write()        /proc, /sys
>> +                                           ^              ^             ^                    ^
>> +                                           |              |             |                    |
>> +                                           |              |             |                    |
>> +                                           |              |             |                    V
>> +                                           |              |             |            PCIe Port Bus services
>> +                                           |              |             |            (AER, HP, PME, VC
>> +                                           |              |             |             drivers/pci/pcie/
>> +                                           |              |             |             drivers/pci/hotplug)
>> +                                           V              V             V                    ^
>> +                                         Socket          Block        Char                   |
>> +                                         layer        Subsystem      Subsystem               |
>> +                                           ^              ^             ^                    | pcie_port_service_register()
>> +                                           |              |             |                    |
>> +                                           |              |             |                    |
>> +                                           V              V             V                    V
>> +                                      Common net         USB          Input            PCIe Port Core
>> +                                      device layer       Core         Core    (drivers/pci/pcie/portdrv_core.c)
>> +                                           ^              ^             ^                    ^
>> +                                           |              |             |                    | pcie_port_bus_register()
>> +                                           |              |             |                    |
>> +                                      _____V_____     ____V____     ____V_____      _________V___________
>> +                                     |           |   |         |   |          |    |                     |
>> +                     All these are   | GEM       |   | USB HC  |   | Mouse/KB/|    | PCIe Port Bus driver|
>> +                     PCI endpoint    | Controller|   | driver  |   | TS HC    |    | (drivers/pci/pcie/  |
>> +                     drivers         | driver    |   |         |   | driver   |    |  portdrv_pci.c)     |
>> +                                     |___________|   |_________|   |__________|    |_____________________|
>> +                                           ^              ^             ^                    ^
>> +                                           |__________    |             |           _________|
>> +                                                      |   |             |          |          pci_register_driver()
>> +          ___________________  pci_bus_*()          __V___V_____________V__________V______
>> +         |                   | pci_scan_root_bus() |                                      |
>> +         |     PCI BIOS      |-------------------->|              PCI Core                |
>> +            | (arch/arm/kernel/ |<--------------------|          (drivers/pci/pci*        |
>> +      ----->|        bios32.c))      |<---     pcibios_*() |           drivers/pci/bus.c)         |
>> +      |     |___________________|   |                      |______________________________________|
>> +      |                   ^              |
>> +      |                   |              | pci_common_init_dev()
>> +      |                   |              |
>> +  ____V___    ____V___        ___V____
>> + |     |     |        |      |        |
>> + | Renesas|  | Tergra |      | Exynos |
>
>                   Tegra
>
>> + | PCI HC |  | PCIe HC|      | PCIe HC| drivers/pci/host/
>> + | driver |  | driver |      | driver | All these are
>> + |________|  |________|      |________| PCI Root Complex drivers
>> +     |                   |               |
>> +     |                   |               |
>> +     V                   V               V
>> +         platform_driver_register()
>> +
>> +Note:
>> +Linux PCI subsystem is like above one without have a PCIe port bus stack.
>
>                                                  having
>
>> +For more details abou this block see http://jagannadhteki.blog.com/2013/12/04/linux-pcie-subsystem/
>
>                     about
>
>> +
>> +PCI HC/RC driver
>> +- Low level initialization and configuration (board, soc)
>
>                                                         SOC or SoC, please
>
>> +- Invokes PCI-BIOS - for bus enumerations so-that the endpoints on bus is ready.
>
>                                              so that                      are
>
>> +- Supplies struct pci_ops to read/write config space.
>> +- Setup the resources like bus numbers, memory/IO space, Interrupt numbers, MSI.
>> +- Register PCI-BIOS as pci_common_init_dev()
>> +
>> +PCI BIOS
>> +- Architecture specific PCI
>> +- Bus enumeration - Lane, Bus, Device, Memory, Interrupt.
>> +- Enumeration ends up with scanning all endpoints on bus got discovered.
>
>                                                             ^^^ confusing
>
>> +- Register to PCI core for common accessing of endpoint drivers.
>> +- pci_scan_root_bus() and pci_bus_*()
>> +
>> +PCI Core
>> +- Provides services to Lower level BIOS and Upper level endpoint layers.
>> +- Creates device entries for proc/sysfs information.
>> +- Linux kernel pci bus and driver management code.
>
>                   PCI
>
>> +- Provides set of abstraction functions that endpoint drivers can used to
>
>                                                                      use
>
>> +  initiate pci communication with attached endpoints.
>
>               PCI
>
>> +- Calls BIOS codes with pcibios_*
>> +
>> +PCI Endpoint driver
>> +- Individual endpoint drivers from upper layer.
>> +- Accessing config space upon respective endpoint enumeration done.
>> +- Communicate over the endpoint for Tx/Rx transactions.
>> +- Register to PCI core as pci_driver_register()
>> +
>> +PCIe Port Bus driver
>> +- A logical PCI-PCI Bridge structure.
>> +- Root Port and the Switch Port.
>> +- See Documentation/PCI/pcie-busport-howto.txt
>                                 ~~~~~~~
>                                 portbus
>

Thanks for your comments will send the next version after fixing these.

-- 
Thanks,
Jagan.
--------
Jagannadha Sutradharudu Teki,
E: jagannadh.teki@gmail.com, P: +91-9676773388
Engineer - System Software Hacker
U-boot - SPI Custodian and Zynq APSOC
Ln: http://www.linkedin.com/in/jaganteki
