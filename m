Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbaHEDjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:39:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:34517 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbaHEDXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:23:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,802,1400050800"; 
   d="scan'208";a="583451044"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Bugfix 0/2] Fix bugs caused by "use irqdomain to dynamically allocate IRQ for IOAPIC"
Date: Tue,  5 Aug 2014 11:26:16 +0800
Message-Id: <1407209178-18644-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two issues have been reported against patch set "use irqdomain to
dynamically allocate IRQ for IOAPIC" at https://lkml.org/lkml/2014/6/9/44.

This first one causes failure of suspend/hibernation, please refer to
https://lkml.org/lkml/2014/7/28/822 for more information. And we have
worked out a patch to fix it (https://lkml.org/lkml/2014/7/30/725) and
Borislav has tested it. But with more testing and analysis, I found the
provided patch still has some issues:
1) It may cause regression to Xen
2) Flag dev->dev.power.is_prepared has already been cleared when
   pcibios_enable_device() gets called, so it will cause IOAPIC pin
   reference count leak.

So I reworked the patch to fix above issues. The first patch fixes issue
1 by moving check of dev->dev.power.is_prepared pcibios_enable_irq, so
it won't affect Xen. The second patch fixes the IOAPIC pin reference
count leakage issue. It also solves the issue we have discussed at
http://www.spinics.net/lists/linux-pci/msg32902.html

Regards!
Gerry

Jiang Liu (2):
  x86, irq, PCI: Keep IRQ assignment for PCI devices during
    suspend/hibernation
  x86, irq: Keep balance of IOAPIC pin reference count

 arch/x86/pci/intel_mid_pci.c |    9 ++++++++-
 arch/x86/pci/irq.c           |    8 +++++++-
 drivers/acpi/pci_irq.c       |   15 +++++++++++++--
 include/linux/pci.h          |    1 +
 4 files changed, 29 insertions(+), 4 deletions(-)

-- 
1.7.10.4

