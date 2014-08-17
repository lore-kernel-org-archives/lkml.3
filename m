Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbaHQKEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 06:04:04 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:36253 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaHQKEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 06:04:00 -0400
MIME-Version: 1.0
Date: Sun, 17 Aug 2014 12:03:58 +0200
X-Google-Sender-Auth: ZxUVoddv82cwBIUuLQkn2R-7pPc
Message-ID: <CAMuHMdW+pGpnwhBGnLCiZ8FXw3wBvtrEwi3JRN6SBrgakRsRJw@mail.gmail.com>
Subject: Generating .config from DTS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduction
------------

As a Device Tree provides a description of the hardware, it should be
possible to derive a Linux kernel .config file from a DTS or DTB file.

This would allow developers, users, and distributions to start from a
hardware-independant "base" .config file (containing software features and
policies (IPv4, NFS, initrd, ...), and drivers for discoverable hardware
(PCI expansion cards, USB devices, ...)), and automatically add the options
needed to support their Linux devices.

To get the ball rolling, I wrote a simple script to generate a list of
CONFIG_* options from one or more preprocessed DTS files or DTB files.


Theory of operation
-------------------

The script performs the following steps:

  1. Run dtc to convert DTB input to DTS, or convert DTS to canonical DTS for
     simpler parsing,
  2. Find all (lists of) "compatible" properties,
  3. For each (list of) "compatible" properties, find driver sources that
     provide support for it,
  4. For each driver source, find the CONFIG_* option that needs to be enabled
     to build the driver.


Limitations
-----------

  - Driver sources are found by grepping "*.c" files in the kernel source tree.
    This may show false positives, like mfd drivers instantiating platform
    devices with the same name as a compatible entry (e.g. "gpio-keys").
    Parsing MODULE_DEVICE_TABLEs would be more accurate, but that would
    requiring building an allmodconfig kernel first.
    However, that would miss of_device_is_compatible() calls.
    Perhaps the entries in a MODULE_DEVICE_TABLE should be created by a
    cpp macro, so we can grep for users of that macro?
  - CONFIG_* symbols are found by grepping Makefiles in the kernel source tree
    for the typical "obj-$(CONFIG_FOO) += foo.o" pattern, which causes false
    negatives if that pattern isn't used.
  - Some properties are checked for in multiple places, causing false positives
    in platform-support on different platforms (e.g. "arm,cortex-a9").
  - Some drivers can be enabled by multiple distinct CONFIG_* symbols, causing
    false positives.
  - Drivers that rely on partial matching, i.e. by dropping the vendor-specific
    prefix, may not be found. This affects several i2c and spi drivers, e.g.
    at24 and m25p80.
  - Knowing that a CONFIG_* option needs to be enabled is not sufficient.
    Kconfig dependencies should be tracked as well, as manually finding which
    dependencies need to be fulfilled can be a tedious task.


Download
--------

You can find the script at
https://github.com/geertu/linux-scripts/blob/master/linux-config-from-dt
It must be run from a Linux kernel git repository.

Examples:

    linux-config-from-dt arch/arm/boot/dts/.r8a7791-koelsch.dtb.dts.tmp
    linux-config-from-dt arch/arm/boot/dts/*dtb

Enjoy, and thanks for your comments!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
