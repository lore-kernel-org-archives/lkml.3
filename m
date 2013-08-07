Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3HGKZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:25:43 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56284 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab3HGKXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:23:06 -0400
Date: Wed, 7 Aug 2013 12:16:18 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 00/26] STA2X11 devicetree support for amba/pci
Message-ID: <cover.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[DISCLAIMER : both of us (Alessandro and Davide) are not devicetree
experts, so please understand how our issues and our dislike of the
approach may result from some lack of knowledge. (any pointer is
welcome).]


As some of you may remember, we're submitting patches adding support
for the STA2X11 (aka Connext) ST chip. The device is a pci-express I/O
HUB containing a number of AMBA peripherals (gpios, uarts, mmc/sd,
dma, ST msps, spi, i2c).  Being a PCI device, it's fully autoprobed:
we can even plug two evaluation boards in the same PC, and all devices
in there are expected to work (and they do, with some of our
patch-sets).

A first set of drivers for this chip was written by Wind River, by
simply copying AMBA drivers and turning them into pci drivers. This of
course worked, but implied tons of duplicated code. Our attempt was to
recycle existing AMBA drivers by instantiating AMBA devices at
runtime. This was done by a rather simple pci to amba "bridge" module,
submitted several times, up to https://lkml.org/lkml/2013/2/20/698

The problem was that AMBA devices need platform data with some
instance information.  Platform code (under arch/x86/sta2x11/) was
submitted for some Connext based boards, but it was rejected as "ARM
shit" by Peter Anvin (https://lkml.org/lkml/2012/5/28/266). We agree
the tables are not beautiful, so we didn't submit such stuff any more.
Peter suggested that "the firmware should provide ACPI tables", but
this is not possible for plug-in pci boards, or we should use
devicetree (Peter's message: https://lkml.org/lkml/2012/5/29/38).

So we turned to devicetree, mostly because AMBA drivers usually
already have devicetree support.  Davide took over the effort, which
turned out to be really big.

Some of the problems he found are:

     * Passing a dtb to the kernel: we use a modified kexec at present
       because x86 boot loaders can't pass the DT blob, to our knowledge.

     * Passing correct irq numbers to the AMBA drivers, because PCI MSI
       irq numbers are dynamically allocated (we solved this by using
       of_update_property() at runtime). We also had to register a new
       irq domain for msi irqs, otherwise of_irq_map_one() would complain
       about irqs lacking a corresponding domain.

     * Switching to a new gpio driver with devicetree support (we took the
       Nomadik gpio/pinctrl because our device apparently has more or less
       the same gpio cell as the Nomadik chip). This requires implementation
       of writel_relaxed() and IRQF_VALID on x86: we hacked them internally
       but the patches are not part of this set. We're willing to solve
       these incompatibilities first, if there's interest.

     * Writing a suitable dts: at present, a dts only exists for one
       of the STA2X11 based boards (Intel Northville). This includes a
       copy of all the physical addresses for the devices, as dts requires
       that, even if such addresses are automatically assigned by PCI.
       Clearly, with this approach we kill PCI autodetect: if you plug
       to a different slot you need a different dts.

This got us a more or less working kernel on the Northville board
(where the device is soldered on the motherboard and acts as main chipset).
The plug-in PCIe board cannot be supported by device tree, as far as
we know, which in our opinion is a strong downside of device tree in favor
of the platform data "shit".

Here's the list of amba devices after boot (we used a kernel
with a common clock framework implementation for the Connext, patches
to be (re)submitted shortly):

[root@localhost ~]# for d in `ls /sys/bus/amba/devices/` ; \
do cat /sys/bus/amba/devices/$d/id ; done
00280080 # -> amba pl080
00380802 # -> amba pl011
00380802 # -> amba pl011
00380802 # -> amba pl011
00380802 # -> amba pl011
10480180 # -> amba mmci
10480180 # -> amba mmci
10480180 # -> amba mmci
10480180 # -> amba mmci
00080023 # -> amba pl023
00080023 # -> amba pl023
00080023 # -> amba pl023
00280080 # -> amba pl080

And the platform devices:

[root@localhost ~]# for d in `ls /sys/bus/platform/devices/` ; \
do cat /sys/bus/platform/devices/$d/modalias ; done
platform:alarmtimer
platform:apb-regs.3		# Connext apb-regs
platform:apb-soc-regs.3		# Connext apb-soc-regs
platform:gpio-0000:03:00.0-0	# Connext gpios 0..3
platform:gpio-0000:03:00.0-1
platform:gpio-0000:03:00.0-2
platform:gpio-0000:03:00.0-3
platform:microcode
platform:mmio-0000:05:00.5-0	# Connext esram memory
platform:pcspkr
platform:regulatory
platform:scr.3			# Connext scr (OTP)
platform:sctl.3			# Connext sysctl
platform:serial8250
platform:sta2x11-clock-regs	# Connext virtual clock regs platform dev


But this awful pile of dts data will not work for he pluggable PCIe card.
We need to regenerate the dts file at each and every boot, because PCI
assignment may change according to what other cards are present.

So this devicetree stuff is killing all the autodetection of PCI,
and is very difficult to pass over in the x86 world. On the other
hand platform data is denied by x86 maintainers.

So the question is: what is the right way (and the right dts
structure) to deal with a hotplug bus that instantiates AMBA
devices, without killing del self-detection features?

Thanks
/alessandro


Alessandro Rubini (5):
  x86: fix warning for sta2x11
  DMA: PL330: use prefix in reg names to build under x86
  mmc: Use the new <linux/sizes.h>
  x86: add CONFIG_ARM_AMBA, selected by STA2X11
  drivers/amba: add support for a PCI bridge

Davide Ciminaghi (21):
  x86 STA2X11: select devicetree related config items.
  OF platform: export of_amba_device_create()
  OF platform, of_amba_device_create(): add parent resource to parameters.
  kernel irqdomain: export irq_domain_disassociate()
  x86 devicetree: add irq domain for msi irqs
  x86 devicetree: add functions for handling setup/teardown of MSI irqs
  x86 kernel apic: notify MSI irqdomain(s) on setup/teardown of MSI IRQs
  drivers/amba/pci-amba.c: use devicetree for amba device creation.
  gpio: remove sta2x11-gpio
  x86 STA2X11: remove the sta2x11-mfd driver.
  x86 STA2X11 platform: add sta2x11_platform_init()
  x86 STA2X11 platform: add sta2x11_instance_data helpers
  x86 STA2X11 platform: add a common probe function for platform devices
  x86 STA2X11 platform: create sta2x11-clock-regs device
  x86 STA2X11 platform: remove useless pr_info()'s
  AMBA: pci-amba bridge: improve code readability
  AMBA: pci-amba bridge: extend number of amba devs per pci device
  AMBA: pci-amba bridge: export function creating pci-amba device names
  x86 STA2X11: add dts for Intel's Northville board
  drivers/clk: sta2x11 common clock framework implementation
  pinctrl: add support for sta2x11 (via pinctrl-nomadik)

 .../devicetree/bindings/pinctrl/ste,nomadik.txt    |    2 +-
 .../devicetree/bindings/x86/interrupt.txt          |   14 +
 arch/x86/Kconfig                                   |   10 +
 arch/x86/include/asm/prom.h                        |    9 +
 arch/x86/include/asm/sta2x11.h                     |  358 ++++++++-
 arch/x86/kernel/apic/io_apic.c                     |    5 +
 arch/x86/kernel/devicetree.c                       |   60 ++
 arch/x86/pci/sta2x11-fixup.c                       |    9 +-
 arch/x86/platform/Makefile                         |    1 +
 arch/x86/platform/sta2x11/Makefile                 |    1 +
 arch/x86/platform/sta2x11/northville.dts           |  941 ++++++++++++++++++++
 arch/x86/platform/sta2x11/sta2x11.c                |  522 +++++++++++
 drivers/Kconfig                                    |    2 +
 drivers/amba/Kconfig                               |   10 +
 drivers/amba/Makefile                              |    1 +
 drivers/amba/pci-amba.c                            |  298 +++++++
 drivers/clk/Makefile                               |    1 +
 drivers/clk/sta2x11/Makefile                       |    1 +
 drivers/clk/sta2x11/clk-audio-pll.c                |  149 +++
 drivers/clk/sta2x11/clk-soc-pll.c                  |   95 ++
 drivers/clk/sta2x11/clk.c                          |  865 ++++++++++++++++++
 drivers/clk/sta2x11/clk.h                          |   88 ++
 drivers/dma/pl330.c                                |  107 ++--
 drivers/gpio/Kconfig                               |    8 -
 drivers/gpio/Makefile                              |    1 -
 drivers/gpio/gpio-sta2x11.c                        |  440 ---------
 drivers/mfd/Kconfig                                |    6 -
 drivers/mfd/Makefile                               |    1 -
 drivers/mfd/sta2x11-mfd.c                          |  680 --------------
 drivers/mmc/host/mmci.c                            |    2 +-
 drivers/mmc/host/msm_sdcc.c                        |    2 +-
 drivers/mmc/host/mvsdio.c                          |    2 +-
 drivers/mmc/host/pxamci.c                          |    3 +-
 drivers/of/platform.c                              |   24 +-
 drivers/pinctrl/Kconfig                            |    6 +-
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-nomadik-sta2x11.c          |  578 ++++++++++++
 drivers/pinctrl/pinctrl-nomadik.c                  |    7 +
 drivers/pinctrl/pinctrl-nomadik.h                  |   14 +
 include/linux/irqdomain.h                          |    3 +
 include/linux/mfd/sta2x11-mfd.h                    |  518 -----------
 include/linux/of_platform.h                        |    7 +-
 include/linux/pci-amba.h                           |   42 +
 kernel/irq/irqdomain.c                             |    3 +-
 44 files changed, 4167 insertions(+), 1730 deletions(-)
 create mode 100644 arch/x86/platform/sta2x11/Makefile
 create mode 100644 arch/x86/platform/sta2x11/northville.dts
 create mode 100644 arch/x86/platform/sta2x11/sta2x11.c
 create mode 100644 drivers/amba/Kconfig
 create mode 100644 drivers/amba/pci-amba.c
 create mode 100644 drivers/clk/sta2x11/Makefile
 create mode 100644 drivers/clk/sta2x11/clk-audio-pll.c
 create mode 100644 drivers/clk/sta2x11/clk-soc-pll.c
 create mode 100644 drivers/clk/sta2x11/clk.c
 create mode 100644 drivers/clk/sta2x11/clk.h
 delete mode 100644 drivers/gpio/gpio-sta2x11.c
 delete mode 100644 drivers/mfd/sta2x11-mfd.c
 create mode 100644 drivers/pinctrl/pinctrl-nomadik-sta2x11.c
 delete mode 100644 include/linux/mfd/sta2x11-mfd.h
 create mode 100644 include/linux/pci-amba.h

-- 
1.7.7.2
