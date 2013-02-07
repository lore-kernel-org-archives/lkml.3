Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab3BGNMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:12:34 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:23513 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755023Ab3BGNMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:12:33 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 0/7] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu mode outside of FSL SOC environments and add a grlib variant normally running on sparc
Date: Thu,  7 Feb 2013 14:12:04 +0100
Message-Id: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the cpu mode of the driver available outside of an FSL SOC
and even powerpc environment. Furthermore, this adds support for the
mostly register-compatible SPICTRL core from the GRLIB VHDL IP core
library normally running on SPARC.

This effort is split up in several patches for clarity of what is being
changed. Patches 3-5 prepares for the introduction of the GRLIB SPICTRL
functionality in patch 6. 

To use what is introduced right away they could eventually be merged:
  Patch A: patch 1
  Patch B: patch 2
  Patch C: patches 3-6 merged
  Patch D: patch 7

Patch 1 makes the driver compileable and presumably useable outside of
FSL SOC and powerpc environments (SPARC in particular)

Patch 2 fixes a bug that can happen when a device uses SPI_CS_HIGH

Patches 3-6 makes the driver working for GRLIB SPICTRL cores that has
the built in slave select register and that uses that exclusively for
chipselects.

Patch 7 introduces gpio support for GRLIB SPICTRL cores. That patch (and
that patch only) relies upon the "of, of_gpio, of_spi: Fix and improve
of_parse_phandle_with_args, of_gpio_named_count and
of_spi_register_master" patchset - https://lkml.org/lkml/2013/1/29/308

The GRLIB type has been tested under sparc. The FSL type has been
compile tested in powerpc, arm and x86 environments. It would be great
if someone with an FSL board could test this out.

One could argue that it would be better to add the GRLIB variant as a
mode flag in of_mpc8xxx_spi_probe instead of using a new type field, but
that would require to add a flag for this core in
include/linux/fsl_devices.h which does not feel right given that this
core is not part of an FSL device.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Andreas Larsson (7):
  spi: spi-fsl-spi: Make driver usable in CPU mode outside of an
    FSL_SOC environment
  spi: spi-fsl-spi: Make sure in spi_fsl_setup that chipselect becomes
    inactive
  spi: spi-fsl-spi: Move setting non-zero tx and rx shifts to a
    function accessed by a function pointer
  spi: spi-fsl-spi: Introduce a type for the driver
  spi: spi-fsl-spi: Add support for setting a maximum number of bits
    per word
  spi: spi-fsl-spi: Add support for Aeroflex Gaisler GRLIB cores
    normally running on SPARC
  spi: spi-fsl-spi: Add support for gpio chipselects for GRLIB type
    cores

 Documentation/devicetree/bindings/spi/fsl-spi.txt  |    3 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 drivers/spi/Kconfig                                |   11 +-
 drivers/spi/Makefile                               |    1 +
 drivers/spi/spi-fsl-cpm.c                          |  387 +++++++++++++
 drivers/spi/spi-fsl-cpm.h                          |   43 ++
 drivers/spi/spi-fsl-lib.c                          |    8 +
 drivers/spi/spi-fsl-lib.h                          |   15 +-
 drivers/spi/spi-fsl-spi.c                          |  610 ++++++--------------
 drivers/spi/spi-fsl-spi.h                          |   72 +++
 10 files changed, 725 insertions(+), 426 deletions(-)
 create mode 100644 drivers/spi/spi-fsl-cpm.c
 create mode 100644 drivers/spi/spi-fsl-cpm.h
 create mode 100644 drivers/spi/spi-fsl-spi.h

