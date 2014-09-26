Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaIZCFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:05:44 -0400
Received: from [119.145.14.64] ([119.145.14.64]:41736 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaIZCFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:05:42 -0400
Message-ID: <5424C9BD.3040506@huawei.com>
Date: Fri, 26 Sep 2014 10:04:45 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>, <Bharat.Bhushan@freescale.com>,
        <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Tony Luck" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v2 03/22] MSI: Remove the redundant irq_set_chip_data()
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com> <1411614872-4009-4-git-send-email-wangyijing@huawei.com> <20140925071919.GH12423@ulmo>
In-Reply-To: <20140925071919.GH12423@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/25 15:19, Thierry Reding wrote:
> On Thu, Sep 25, 2014 at 11:14:13AM +0800, Yijing Wang wrote:
>> Currently, pcie-designware, pcie-rcar, pci-tegra drivers
>> use irq chip_data to save the msi_chip pointer. They
>> already call irq_set_chip_data() in their own MSI irq map
>> functions. So irq_set_chip_data() in arch_setup_msi_irq()
>> is useless.
> 
> Again, I think this should be the other way around. If drivers do
> something that's already handled by the core, then the duplicate code
> should be dropped from the drivers.

Hi Thierry, this is different thing, because chip_data is specific to IRQ
controller, and in other platform, like in x86, chip_data is used to save irq_cfg.
So we can not call irq_set_chip_data() in core code.

x86 irq piece code

int arch_setup_hwirq(unsigned int irq, int node)
{
	struct irq_cfg *cfg;
	unsigned long flags;
	int ret;

	cfg = alloc_irq_cfg(irq, node);
	if (!cfg)
		return -ENOMEM;

	raw_spin_lock_irqsave(&vector_lock, flags);
	ret = __assign_irq_vector(irq, cfg, apic->target_cpus());
	raw_spin_unlock_irqrestore(&vector_lock, flags);

	if (!ret)
		irq_set_chip_data(irq, cfg);  ------------->Save irq_cfg
	else
		free_irq_cfg(irq, cfg);
	return ret;
}

Thanks!
Yijing.

> 
> Thierry
> 


-- 
Thanks!
Yijing

