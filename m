Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaL2RaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:30:00 -0500
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:40355 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbaL2R35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:29:57 -0500
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dvhart@infradead.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 0/2] x86: Add IMR support to Quark/Galileo
Date: Mon, 29 Dec 2014 17:23:01 +0000
Message-Id: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds an IMR driver to the kernel plus platform code for
Intel Galileo Gen1/Gen2 boards.

IMRs:
Quark SoC X1000 ships with a set of registers called Isolated Memory Regions
IMRs provide fine grained memory access control to various system agents
within the SoC such as CPU SMM/non-SMM mode, PCIe virtual channels, CPU snoop
cycles, eSRAM flush cycles and the RMU. In simple terms, IMRs provide a
mechanism to protect memory regions from unwarranted access by system agents
that should not have access to that memory.

IMRs support a lock bit. Once a lock bit is set for an individual IMR it is
not possible to tear down that IMR without performing a cold boot of the
system. IMRs support reporting of violations. The SoC system can be
configured to reboot immediately when an IMR violation has taken place.
Immediate reboot of the system on IMR violation is recommended and is
currently how Quark BIOS configures the system.

As an example Galileo boards ship with an IMR around the ACPI runtime
services memory and if a DMA read/write cycle were to occur to this region
of memory this would trigger the IMR violation mechansim. 

Galileo:
Intel's Arduino compatible Galileo boards boot to Linux with IMRs protecting
the compressed kernel image and boot params data structure. The memory that
the compressed kernel and boot params data structure is in, is marked as
usable memory by the EFI memory map. As a result it is possible for memory
marked as processor read/write only in an IMR to be given to devices in the
SoC for the purposes of DMA by way of dma_alloc_coherent.
A DMA to a region of memory by a system agent which is not allowed access
this memory result in a system reset. Without tearing down the IMRs placed
around the compressed kernel image and boot params data structure there is a
high risk of triggering an inadvertent system reset when performing DMA
actions with any of the peripherals that support DMA in Quark such as the
MMC, Ethernet or USB host/device.

Therefore Galileo specific platform code is the second component of this
patchset. The platform code tears-down every unlocked IMR to ensure no
conflict exists between the IMR usage during boot and the EFI memory map. In
addition an IMR is placed around the kernel's .text section to ensure no
invalid access to kernel code can happen by way of spurious DMA, SMM or RMU
read/write cycles. This code gets compiled into the kernel because we want
to run the code early before any DMA has taken place. The prime examples of
DMA transactions resetting the system are mouting a root filesystem on MMC
or mouting a root filesystem over NFS.

Bryan O'Donoghue (2):
  x86: Add Isolated Memory Regions for Quark X1000
  platform/x86 Add Intel Galileo platform specific setup

 arch/x86/Kconfig                     |  23 ++
 arch/x86/include/asm/imr.h           |  79 ++++++
 arch/x86/include/asm/intel-quark.h   |  31 ++
 arch/x86/kernel/Makefile             |   1 +
 arch/x86/kernel/imr.c                | 529 +++++++++++++++++++++++++++++++++++
 drivers/platform/x86/Kconfig         |  15 +
 drivers/platform/x86/Makefile        |   1 +
 drivers/platform/x86/intel_galileo.c | 175 ++++++++++++
 8 files changed, 854 insertions(+)
 create mode 100644 arch/x86/include/asm/imr.h
 create mode 100644 arch/x86/include/asm/intel-quark.h
 create mode 100644 arch/x86/kernel/imr.c
 create mode 100644 drivers/platform/x86/intel_galileo.c

-- 
1.9.1

