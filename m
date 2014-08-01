Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaHAQaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:30:21 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:33754
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbaHAQaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:30:18 -0400
X-WSS-ID: 0N9MZ5P-08-JCV-02
X-M-MSG: 
Message-ID: <53DBC074.3030309@amd.com>
Date: Fri, 1 Aug 2014 11:29:40 -0500
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
Subject: Re: [PATCH 3/4 V3] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1404947104-21345-4-git-send-email-suravee.suthikulpanit@amd.com>
 <87zjfqj3mc.fsf@approximate.cambridge.arm.com> <53DBB562.5020003@amd.com>
In-Reply-To: <53DBB562.5020003@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(164054003)(51704005)(377454003)(479174003)(24454002)(189002)(199002)(106466001)(101416001)(107046002)(95666004)(23756003)(93886004)(76482001)(85306004)(99396002)(83072002)(59896001)(83322001)(50986999)(54356999)(44976005)(76176999)(65956001)(21056001)(110136001)(46102001)(83506001)(65816999)(85852003)(92726001)(81342001)(50466002)(33656002)(74662001)(74502001)(87936001)(47776003)(20776003)(64126003)(84676001)(79102001)(92566001)(81542001)(86362001)(31966008)(97736001)(68736004)(80022001)(105586002)(80316001)(102836001)(87266999)(4396001)(77982001)(65806001)(36756003)(64706001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/2014 10:42 AM, Suravee Suthikulanit wrote:
>>> +#ifdef CONFIG_SMP
>>> +       .irq_set_affinity       = gic_set_affinity,
>>> +#endif
>>> +#ifdef CONFIG_PM
>>> +       .irq_set_wake           = gic_set_wake,
>>> +#endif
>>> +};
>>> +
>>> +#ifdef CONFIG_OF
>>> +static int __init
>>> +gicv2m_of_init(struct device_node *node, struct device_node *parent)
>>> +{
>>> +       struct gic_chip_data *gic;
>>> +       int ret;
>>> +
>>> +       ret = _gic_of_init(node, parent, &gicv2m_chip, &gic);
>>> +       if (ret) {
>>> +               pr_err("GICv2m: Failed to initialize GIC\n");
>>> +               return ret;
>>> +       }
>>> +
>>> +       gic->msi_chip.owner = THIS_MODULE;
>>> +       gic->msi_chip.of_node = node;
>>> +       gic->msi_chip.setup_irq = gicv2m_setup_msi_irq;
>>> +       gic->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
>>> +       ret = of_pci_msi_chip_add(&gic->msi_chip);
>>> +       if (ret) {
>>> +               /* MSI is optional and not supported here */
>>> +               pr_info("GICv2m: MSI is not supported.\n");
>>> +               return 0;
>>> +       }
>>> +
>>> +       ret = gicv2m_msi_init(node, &gic->v2m_data);
>>> +       if (ret)
>>> +               return ret;
>>> +       return ret;
>>> +}
>>> +
>>> +IRQCHIP_DECLARE(arm_gic_400_v2m, "arm,gic-400-v2m", gicv2m_of_init);
>>
>> So if you follow my advise of reversing your probing and call into the
>> v2m init from the main GIC driver, you could take a irq_chip as a
>> parameter, and use it to populate the v2m irq_chip, only overriding the
>> two methods that actually differ.
>>
>> This would have the net effect of completely dropping patch #2, which
>> becomes effectively useless.
>>
>
> [Suravee] Ok, lemme look into this.

So, in previous revision, you mentioned that we should have a separate 
irq_chip for gicv2m stuff, is that is still the case here?

Thanks,

Suravee

