Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaKFAF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:05:57 -0500
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:3728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbaKFAFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:05:50 -0500
X-WSS-ID: 0NELC9F-08-BNB-02
X-M-MSG: 
Message-ID: <545ABB4C.8010103@amd.com>
Date: Wed, 5 Nov 2014 18:05:32 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <jason@lakedaemon.net>, <tglx@linutronix.de>
CC: <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>, <liviu.dudau@arm.com>,
        <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com>
 <5458CE31.3040404@linux.intel.com>
In-Reply-To: <5458CE31.3040404@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(24454002)(51704005)(479174003)(377454003)(164054003)(101416001)(87266999)(120886001)(65806001)(99396003)(15202345003)(106466001)(87936001)(65956001)(36756003)(20776003)(2201001)(105586002)(92726001)(120916001)(107046002)(59896002)(62966003)(68736004)(31966008)(46102003)(84676001)(97736003)(83506001)(19580395003)(47776003)(80316001)(92566001)(54356999)(50466002)(44976005)(65816999)(4396001)(102836001)(21056001)(33656002)(76176999)(86362001)(77156002)(15975445006)(64706001)(95666004)(50986999)(64126003)(23746002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0387D64A71
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/2014 7:01 AM, Jiang Liu wrote:
> Hi Suravee,
> 	You may build a two level hierarchy irqdomains. Use the
> utilities in this thread
> http://www.spinics.net/lists/arm-kernel/msg374722.html  to build an MSI
> irqdomain to manage MSI controllers
> in PCI devices. And build another irqdomain to manage SPI allocation
> in GICv2.
> 	That is: MSI irqdomain (program MSI registers)  -->
> GIV irqdomain (manage SPIs in GICv2 controller)
>
> Regards!
> Gerry

Gerry,

I try out your patch from the link above, and I have a couple 
questions/issues.

1. In the drivers/pci/msi.c: msi_irq_domain_alloc_irqs(), it seems that 
the hwirq comes from msi_get_hwirq(dev, msidesc). In GICv2m, hwirq for 
MSI is fixed over a specific range. This might require arch-specific
callback.

2. In msi_domain_activate, why "if (!irq_data->chip_data)"?

3. In, msi_domain_alloc():

- There should be a way to specify other types of irq handler besides 
the "handle_edge_irq". In case of GIC, it needs handle_fasteoi_irq.

- When calling irq_domain_set_hwirq_and_chip(), you are passing "(void 
*)(long)i" for the "void *chip_data" parameter. What is this used for, 
and where?  Shouldn't this be pointing to arch-specific data structure?

- The code is calling irq_domain_alloc_irqs_parent before the loop, 
which calls irq_domain_set_hwirq_and_chip() and __irq_set_handler. 
Shouldn't the order be switched?

- Overall, it seems that msi_domain_alloc() could be quite different 
across architectures. Would it be possible to declare this function as 
weak, and allow arch to override (similar to arch_setup_msi_irq)?

Thanks,

Suravee

