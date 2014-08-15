Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaHOOxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:53:49 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:52164
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751076AbaHOOxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:53:46 -0400
X-WSS-ID: 0NACS1A-08-RHU-02
X-M-MSG: 
Message-ID: <53EE1EE5.3060103@amd.com>
Date: Fri, 15 Aug 2014 09:53:25 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2 V4] irqchip: gicv2m: Add support for multiple MSI
 for ARM64 GICv2m
References: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1407942041-3291-3-git-send-email-suravee.suthikulpanit@amd.com>
 <87k369ri9k.fsf@approximate.cambridge.arm.com>
In-Reply-To: <87k369ri9k.fsf@approximate.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(164054003)(51704005)(24454002)(189002)(377454003)(479174003)(199003)(57704003)(46102001)(97736001)(76482001)(54356999)(50986999)(21056001)(65806001)(79102001)(65816999)(80022001)(76176999)(68736004)(59896001)(102836001)(77982001)(64126003)(65956001)(92566001)(92726001)(50466002)(36756003)(85852003)(33656002)(85306004)(101416001)(110136001)(83072002)(86362001)(83506001)(99396002)(81342001)(107046002)(83322001)(106466001)(20776003)(44976005)(105586002)(81542001)(87936001)(87266999)(84676001)(31966008)(74502001)(74662001)(47776003)(64706001)(4396001)(80316001)(95666004)(23756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB042;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0304E36CA3
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2014 8:31 AM, Marc Zyngier wrote:
> Hi Suravee,
>
>> +/*
>> + * ARM64 function for seting up MSI irqs.
>> + * Copied from driver/pci/msi.c: arch_setup_msi_irqs().
>> + */
>> +int arm64_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>> +{
>> +	struct msi_desc *entry;
>> +	int ret;
>> +
>> +	if (type == PCI_CAP_ID_MSI && nvec > 1)
>> +		return 1;
>> +
>> +	list_for_each_entry(entry, &dev->msi_list, list) {
>> +		ret = arch_setup_msi_irq(dev, entry);
>> +		if (ret < 0)
>> +			return ret;
>> +		if (ret > 0)
>> +			return -ENOSPC;
>> +	}
>> +
>> +	return 0;
>> +}
>
> I'm going to reiterate what I said last time: Why do we need this?

[Suravee] Marc, I understand what you described last time but I think 
there is one point that missing here. See below.

> So far, we have two MSI-capable controllers on their way upstream:
> GICv2m and GICv3. Both are perfectly capable of handling more than a
> single MSI per device.

[Suravee] I am aware of this.

> So why should we cater for this? My gut feeling is that we should just
> have:
>
> int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> {
>          struct msi_desc *entry;
>          int ret;
>
>          /*
>           * So far, all our MSI controllers are capable of handling more
>           * than a single MSI per device. Should we encounter less
>           * capable devices, we'll consider doing something special for
>           * them.
>           */
>          list_for_each_entry(entry, &dev->msi_list, list) {
>                  ret = arch_setup_msi_irq(dev, entry);
>                  if (ret < 0)
>                          return ret;
>                  if (ret > 0)
>                          return -ENOSPC;
>          }
>
>          return 0;
> }
>
> and nothing else. Your driver should be able to retrieve the number of
> MSI needed by the device, and allocate them. GICv3 manages it, and so
> should GICv2m.
>

[Suravee] Multi-MSI and MSI-x are not the same. For MSI-X, you can treat 
each of the MSI separately since it MSI-X capability structure has a 
table specific for each one of them.  For Multi-MSI, there is only one 
MSI capability structure which control all of them, and you need to 
program the "multiple-message enable" field with the encoding for 
"power-of-two", and therefore must be in contiguous range.

Your logic above is what the standard MSI-x setup code is using. It is 
not handling of how many it can allocate all at once.

As for sharing the logic b/w GICv2m and GICv3, unless they are sharing 
the same common data structure (e.g. the struct v2m which contans 
msi_chip), and the allocation function (e.g. generic 
gic_alloc_msi_irqs()), you pretty much need to do this separately since 
we need to walk the msi_chip back to its container structure.

I am not saying this cannot be done, but we need to work out the detail 
together b/w GICv2m and GICv3.

Thanks,

Suravee


