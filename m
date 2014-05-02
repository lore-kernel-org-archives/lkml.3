Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaEBXeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 19:34:06 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:37209 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaEBXeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 19:34:04 -0400
MIME-Version: 1.0
Date: Sat, 3 May 2014 01:34:01 +0200
X-Google-Sender-Auth: aESOFVT_7gEXhklTwNTFvRqQSZA
Message-ID: <CAJZ5v0gVEfcv6NeYwiNL8=0jtJXd3po_TK3+fP4q_3Rz0hBy_g@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.15-rc4
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.15-rc4

to receive ACPI, power management and PNP fixes for v3.15-rc4
with top-most commit de3afce5336af3214374de6df360f9eb010a9a36

  Merge branches 'acpi-ec' and 'acpi-processor'

on top of commit d1db0eea852497762cab43b905b879dfcd3b8987

  Linux 3.15-rc3

A bunch of regression fixes this time.  They fix two regressions
in the PNP subsystem, one in the ACPI processor driver and one in
the ACPI EC driver, four cpufreq driver regressions and an unrelated
bug in one of the drivers.  The regressions are recent or introduced
in 3.14.

Specifics:

 - There are two bugs in the ACPI PNP core that cause errors to
   be returned if optional ACPI methods are not present.  After
   an ACPI core change made in 3.14 one of those errors leads
   to serial port suspend failures on some systems.  Fix from
   yours truly.

 - A recently added PNP quirk related to Intel chipsets intorduced
   a build error in unusual configurations (PNP without PCI).  Fix
   from Bjorn Helgaas.

 - An ACPI EC workaround related to system suspend on Samsung machines
   added in 3.14 introduced a race causing some valid EC events to be
   discarded.  Fix from Kieran Clancy.

 - The acpi-cpufreq driver fails to load on some systems after a 3.14
   commit related to APIC ID parsing that overlooked one corner case.
   Fix from Lan Tianyu.

 - Fix for a recently introduced build problem in the ppc-corenet
   cpufreq driver from Tim Gardner.

 - A recent cpufreq core change to ensure serialization of frequency
   transitions for drivers with a ->target_index() callback overlooked
   the fact that some of those drivers had been doing operations
   introduced by it into the core already by themselves.  That resulted
   in a mess in which the core and the drivers try to do the same thing
   and block each other which leads to deadlocks.  Fixes for the
   powernow-k7, powernow-k6, and longhaul cpufreq drivers from
   Srivatsa S Bhat.

 - Fix for a computational error in the powernow-k6 cpufreq driver
   from Srivatsa S Bhat.

Thanks!


---------------

Bjorn Helgaas (1):
      PNP: Fix compile error in quirks.c

Kieran Clancy (1):
      ACPI / EC: Process rather than discard events in acpi_ec_clear

Lan Tianyu (1):
      ACPI / processor: Fix failure of loading acpi-cpufreq driver

Rafael J. Wysocki (1):
      PNP / ACPI: Do not return errors if _DIS or _SRS are not present

Srivatsa S. Bhat (4):
      cpufreq: longhaul: Fix double invocation of
cpufreq_freq_transition_begin/end
      cpufreq: powernow-k6: Fix incorrect comparison with max_multipler
      cpufreq: powernow-k6: Fix double invocation of
cpufreq_freq_transition_begin/end
      cpufreq: powernow-k7: Fix double invocation of
cpufreq_freq_transition_begin/end

Tim Gardner (1):
      cpufreq: ppc-corenet-cpufreq: Fix __udivdi3 modpost error

---------------

 drivers/acpi/acpi_processor.c         |  7 +++---
 drivers/acpi/ec.c                     | 21 ++++++++++-------
 drivers/cpufreq/longhaul.c            | 36 ++++++++++++++++++----------
 drivers/cpufreq/powernow-k6.c         | 23 ++++++++++--------
 drivers/cpufreq/powernow-k7.c         |  4 ----
 drivers/cpufreq/ppc-corenet-cpufreq.c |  5 +++-
 drivers/pnp/pnpacpi/core.c            | 44 +++++++++++++++++++++--------------
 drivers/pnp/quirks.c                  |  4 ++--
 8 files changed, 85 insertions(+), 59 deletions(-)
