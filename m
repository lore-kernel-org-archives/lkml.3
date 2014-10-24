Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbaJXQ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:28:48 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48390 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806AbaJXQ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:28:31 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH RFC v2 0/2] Fix procfs PCI resources mmap
Date: Fri, 24 Oct 2014 17:28:04 +0100
Message-Id: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way PCI memory resources are exported to user space through procfs
is not uniform across architectures. In particular, some architectures
(ie SPARC) export the resource PCI bus address to user space, whereas
others (ARM, PowerPC, Microblaze) export the resource CPU physical address.
This convention should be followed when it comes to passing the pgoff
values to the mmap syscall to map the resource in question.

Consequently, the checks applied to the offset passed to the mmap syscall
(in pci_mmap_fits()) are to be interpreted differently on different
architectures, and in particular they should match the values exported to
user space through the pci_resource_to_user() conversion function.

This patch series addresses two issues. First patch applies the
pci_resource_to_user() filter to the PCI resource that is being
mapped in order to carry out a proper check against the pgoff passed
from user space. Second patch fixes the way the pgoff is handled in
the ARM pci_mmap_page_range() implementation.

v1 posting:

http://marc.info/?l=linux-kernel&m=141337461318554&w=2

v1 => v2
- Reworded commit log as per RMK comments

Lorenzo Pieralisi (2):
  drivers: pci: fix pci_mmap_fits() implementation for procfs mmap
  arm: kernel: fix pci_mmap_page_range() offset calculation

 arch/arm/kernel/bios32.c | 10 ++--------
 drivers/pci/pci-sysfs.c  | 13 ++++++++-----
 2 files changed, 10 insertions(+), 13 deletions(-)

-- 
2.1.2

