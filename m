Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbaKTQb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:31:56 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35407 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaKTQby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:31:54 -0500
Message-ID: <546E1771.4030201@arm.com>
Date: Thu, 20 Nov 2014 16:31:45 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Yijing Wang <wangyijing@huawei.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Removal of bus->msi assignment breaks MSI with stacked domains
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn, Yijing,

I've just realized that patch c167caf8d174 (PCI/MSI: Remove useless
bus->msi assignment) completely breaks MSI on arm64 when using the new
MSI stacked domain:

This patch relies on architectures to implement either
pcibios_msi_controller() or arch_setup_msi_irq(). It turns out that with
stacked domains, none of this is actually necessary, as long as you can
access to the msi_controller.

And everything was fine until this patch came around (and managed to
test on a system where the PCI devices are not directly attached to the
root bus). Of course, everything now breaks, as we cannot get to the MSI
controller (which contains the domain we allocate the MSIs from).

In short, this patch breaks an important feature on which arm64 relies,
and I believe this patch should be reverted ASAP.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
