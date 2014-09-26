Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbaIZWIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 18:08:20 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:56087 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756063AbaIZWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 18:08:18 -0400
Message-ID: <1411769296.15241.36.camel@x220>
Subject: [PATCH 0/1] [RFC] kconfig: warn if an unknown symbol is selected
From: Paul Bolle <pebolle@tiscali.nl>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 27 Sep 2014 00:08:16 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 22:08:16.0678 (UTC) FILETIME=[5F93BC60:01CFD9D6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to make a recurring kconfig issue more visible:
select statements for unknown, or unreachable, Kconfig symbols. See,
I've submitted quite a few patches that remove statements like
    select BOGUS

One of the annoying properties of kconfig is that select statements like
that are silently treated as a nop. That makes them surprisingly easy to
stay unnoticed. Some of them are caught by my local "800 line perl
monster", but not all. But perhaps silently skipping these statements is
actually a feature. I think it is not.

Anyhow, I've tweaked kconfig to warn about them. Then I ran kconfig on
all (500+) in tree defconfig files as of next-20140926. These are the
select statements warns about when doing that.

1) arch/arm/Kconfig:429:warning: 'ARCH_EFM32' selects unknown symbol 'NO_DMA'

Unknown on arm. Patch submitted.

2) arch/arm/mach-meson/Kconfig:11:warning: 'MACH_MESON6' selects unknown symbol 'MESON6_TIMER'

Clearly bogus select. But Kconfig symbol MESON6_TIMER is apparently
queued.

3) arch/arm/mach-mvebu/Kconfig:40:warning: 'MACH_ARMADA_375' selects unknown symbol 'ARM_ERRATA_753970'
   arch/arm/mach-mvebu/Kconfig:55:warning: 'MACH_ARMADA_38X' selects unknown symbol 'ARM_ERRATA_753970'

Typo. Patch is being discussed for some time now.

4) arch/arm/mach-shmobile/Kconfig:39:warning: 'ARCH_SHMOBILE_MULTI' selects unknown symbol 'ARCH_HAS_OPP'

Unfinished Kconfig cleanup. Patches submitted and/or queued.

5) arch/hexagon/Kconfig:22:warning: 'HEXAGON' selects unknown symbol 'NO_IOPORT_MAP'

Unknown on hexagon. Patch submitted.

6) arch/powerpc/platforms/44x/Kconfig:217:warning: 'AKEBONO' selects unknown symbol 'IBM_EMAC_RGMII_WOL'
   arch/powerpc/platforms/44x/Kconfig:223:warning: 'AKEBONO' selects unknown symbol 'MMC_SDHCI_OF_476GTR'

Clearly bogus selects. One symbol might be queued. Not sure why the
other select hasn't been removed.

7) arch/score/Kconfig:24:warning: 'ARCH_SCORE7' selects unknown symbol 'SYS_SUPPORTS_32BIT_KERNEL'
   arch/score/Kconfig:28:warning: 'MACH_SPCT6600' selects unknown symbol 'SYS_SUPPORTS_32BIT_KERNEL'
   arch/score/Kconfig:32:warning: 'SCORE_SIM' selects unknown symbol 'SYS_SUPPORTS_32BIT_KERNEL'

Bogus. Submitted a patch long ago. Nothing happened.

8) drivers/acpi/Kconfig:165:warning: 'ACPI_PROCESSOR' selects unknown symbol 'CPU_IDLE'

Unreachable for eg ia64. Perhaps fixed by:
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -162,7 +162,7 @@ config ACPI_DOCK
 config ACPI_PROCESSOR
        tristate "Processor"
        select THERMAL
-       select CPU_IDLE
+       select CPU_IDLE if (ARM || ARM64 || MIPS || PPC || X86 || SUPERH)
        default y
        help
          This driver installs ACPI as the idle handler for Linux and uses
 
9) drivers/irqchip/Kconfig:16:warning: 'ARM_GIC_V3' selects unknown symbol 'MULTI_IRQ_HANDLER'
   drivers/irqchip/Kconfig:8:warning: 'ARM_GIC' selects unknown symbol 'MULTI_IRQ_HANDLER'

MULTI_IRQ_HANDLER is arm specific. So arm64 builds trigger this.
Suggested fix:
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -5,7 +5,7 @@ config IRQCHIP
 config ARM_GIC
        bool
        select IRQ_DOMAIN
-       select MULTI_IRQ_HANDLER
+       select MULTI_IRQ_HANDLER if ARM
 
 config GIC_NON_BANKED
        bool
@@ -13,7 +13,6 @@ config GIC_NON_BANKED
 config ARM_GIC_V3
        bool
        select IRQ_DOMAIN
-       select MULTI_IRQ_HANDLER
 
 config ARM_NVIC
        bool

10) lib/Kconfig.debug:1008:warning: 'DEBUG_ATOMIC_SLEEP' selects unknown symbol 'PREEMPT_COUNT'

Not all architectures have PREEMPT_COUNT. Maybe fixed by:
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1005,7 +1005,7 @@ config DEBUG_LOCKDEP
 
 config DEBUG_ATOMIC_SLEEP
        bool "Sleep inside atomic section checking"
-       select PREEMPT_COUNT
+       select PREEMPT_COUNT if !(ALPHA || FRV || HEXAGON || UML)
        depends on DEBUG_KERNEL
        help
          If you say Y here, various routines which may sleep will become very

Not sure, however.

11) sound/pci/Kconfig:158:warning: 'SND_AZT3328' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:28:warning: 'SND_ALS300' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:466:warning: 'SND_EMU10K1' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:482:warning: 'SND_EMU10K1X' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:516:warning: 'SND_ES1938' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:528:warning: 'SND_ES1968' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:53:warning: 'SND_ALI5451' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:615:warning: 'SND_ICE1712' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:703:warning: 'SND_MAESTRO3' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:812:warning: 'SND_SONICVIBES' selects unknown symbol 'ZONE_DMA'
    sound/pci/Kconfig:824:warning: 'SND_TRIDENT' selects unknown symbol 'ZONE_DMA'

Tricky. See commit 80ab8eae70e5 ("ALSA: Enable CONFIG_ZONE_DMA for
smaller PCI DMA masks"). Nice quote from Andrew Morton about adding
these selects (instead of fixing the underlying problem):
    But then we'll just forget about it :(

(https://bugzilla.kernel.org/show_bug.cgi?id=68221#c19 ).

Comments welcome!

Paul Bolle (1):
  kconfig: warn if an unknown symbol is selected

 scripts/kconfig/conf.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

-- 
1.9.3

