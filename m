Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbaLANZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:25:10 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40315 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaLANZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:25:06 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Andy Gross <agross@codeaurora.org>, Thierry Reding <treding@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, devicetree@vger.kernel.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>, Michal Simek <monstr@monstr.eu>,
        Antti Palosaari <crope@iki.fi>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Joe Perches <joe@perches.com>, Sandeep Nair <sandeep_n@ti.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v5 0/7] Xilinx Zynq OCM support
Date: Mon,  1 Dec 2014 14:24:51 +0100
Message-Id: <cover.1417440250.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-3253-1417440298-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-3253-1417440298-0001

Hi,

this is the next attepmt to add support for On Chip Memory
configuration via On Chip Memory Controller.
OCM can be divided into 4 independend blocks and placed to
two locations which this driver detects.

For everybody on-chip SRAM driver "mmio-sram"
is missing parity IRQ handling not sure how to write
in generic way and also the memory layout
can be changed at run time (not currently supported by this driver)

smp-sram trampoline allocation can be used from mmio-sram
and size allocated via DT but currently no reason for using
it.

Creating mmio-sram node with setting at run time based on current setting
is possible but it won't look good.
One way how to do it is here
"ARM: mvebu: Add quirk for i2c for the OpenBlocks AX3-4 board"
(sha1: 85e618a1be2b2092318178d1d66bdad49cbbeeeb)
but creating nodes at run-time or changing compact strings
will be just more hacky code.

Using device-tree overlays is another option but SMP
trampoline code is placed there and it will be used by PM code
that's why driver should be there before user-space.

Next option is to create driver which just create platform device
at run-time. This is doable but I expect sram driver has to be
updated.

Regarding reading SLCR OCM configuration there is an option to use
regmap and not to use zynq_slcr_get_ocm_config.
This is how that code will look like when regmap is used.

+       struct regmap *syscon;
+
+       syscon = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+                                                "regmap");
+       if (IS_ERR(syscon)) {
+               dev_err(&pdev->dev, "regmap property not found\n");
+               return PTR_ERR(syscon);
+       }

-       ocm_config = zynq_slcr_get_ocm_config();
+       ret = regmap_read(syscon, SLCR_OCM_CFG_OFFSET,
+                         &ocm_config);
+       if (ret)
+               return -ENODEV;

Not sure which option is better but this is also working fine.
With this change patch
"ARM: zynq: Extend SLCR driver to read OCM configuration"
is not needed.

Regarding ifdef CONFIG_SMP driver allocates just size which
is used by the kernel - there could be an option to allocate
fixed size but it is IMHO worse then allocate actual needed
part.
With this simplification there is no need to refactor
common.h but it doesn't mean that refactoring is not good
to do.

Thanks,
Michal


Changes in v5:
- Separate binding from the driver
- Fix commit message reported by Linus W
- Use SZ_64K instead size in HEX reported by Linus W
- Fix dev_dbg message for allocate reset vector table
- Detect start address not base for SMP trampoline allocation
- Move binding to separate patch

Changes in v4:
- New patch in this series
- New patch in this series
- Move only slcr.h and smp.h and keep common.h in platform
  which is not needed by OCMC driver
  Based on Arnd request: https://lkml.org/lkml/2014/10/20/268
  Not all symbols from slcr.h/smp.h will be used by OCMC driver
  - no problem to remove them if it is needed
- Add record to MAINTAINERS file
- slcr.h has moved to soc/include/ folder. Move definition there too.
- Use }; instead of } ; in doc
- Use memory-controller@... instead of ocmc@...
- Create Kconfig entry for OCMC driver - enable GENERIC_ALLOCATOR here
- Add entry to MAINTAINERS file
- Use memory-controller@... instead of ocmc@...

Changes in v3:
- Move OCM to drivers/soc
- Update year
- Extract DTS node to be able to apply it out of driver
- Remove generic allocator enabling
- Extract SLCR part
- Use const in of_device_id
- OCM->OCMC
- Use ocmc-1.0 compatible string
- Extract from OCM driver

Changes in v2:
- Update pm.c added in 3.17 too - Soren pointed on it
- Change compatibility string to be in xilinx format
- Fix kernel-doc format

Michal Simek (7):
  ARM: zynq: Extract smp related functions out of common.h
  ARM: zynq: Extract slcr related functions out of common.h
  ARM: zynq: Move slcr.h and smp.h to generic location
  ARM: zynq: Extend SLCR driver to read OCM configuration
  devicetree: bindings: Add zynq ocmc node description
  ARM: zynq: Add OCM controller driver
  ARM: zynq: DT: Add OCM controller node

 .../bindings/arm/zynq/xlnx,zynq-ocmc.txt           |  17 ++
 MAINTAINERS                                        |   2 +
 arch/arm/boot/dts/zynq-7000.dtsi                   |   7 +
 arch/arm/mach-zynq/common.c                        |   2 +
 arch/arm/mach-zynq/common.h                        |  19 --
 arch/arm/mach-zynq/platsmp.c                       |   3 +
 arch/arm/mach-zynq/slcr.c                          |  17 ++
 drivers/soc/Kconfig                                |   1 +
 drivers/soc/Makefile                               |   1 +
 drivers/soc/zynq/Kconfig                           |  13 ++
 drivers/soc/zynq/Makefile                          |   1 +
 drivers/soc/zynq/zynq_ocmc.c                       | 249 +++++++++++++++++++++
 include/soc/zynq/slcr.h                            |  30 +++
 include/soc/zynq/smp.h                             |  30 +++
 14 files changed, 373 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/zynq/xlnx,zynq-ocmc.txt
 create mode 100644 drivers/soc/zynq/Kconfig
 create mode 100644 drivers/soc/zynq/Makefile
 create mode 100644 drivers/soc/zynq/zynq_ocmc.c
 create mode 100644 include/soc/zynq/slcr.h
 create mode 100644 include/soc/zynq/smp.h

--
1.8.2.3


--=_mimegpg-monstr-desktop-3253-1417440298-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlR8bCoACgkQykllyylKDCF9TgCeKt/T1i9cGZ7577ABIL7ivi0i
sHcAn07rXwWdhDckmr3s0uRLUyQ/9sgY
=Nk1G
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-3253-1417440298-0001--
