Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaF0Pnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:43:37 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:46029
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753187AbaF0Pnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:43:35 -0400
X-WSS-ID: 0N7U3OI-07-W19-02
X-M-MSG: 
Message-ID: <53AD911C.6040301@amd.com>
Date: Fri, 27 Jun 2014 10:43:24 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm/gic: Add supports for GICv2m MSI(-X)
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1403569980-12913-3-git-send-email-suravee.suthikulpanit@amd.com>
 <53A94A46.1010801@arm.com>
In-Reply-To: <53A94A46.1010801@arm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(51704005)(377454003)(479174003)(199002)(189002)(164054003)(64126003)(76482001)(102836001)(105586002)(85306003)(33656002)(85852003)(79102001)(74502001)(31966008)(81342001)(54356999)(74662001)(81542001)(95666004)(87266999)(76176999)(50986999)(101416001)(44976005)(19580395003)(80316001)(50466002)(68736004)(65816999)(83322001)(77982001)(19580405001)(36756003)(106466001)(4396001)(21056001)(92726001)(84676001)(99396002)(92566001)(86362001)(64706001)(59896001)(83072002)(107046002)(87936001)(80022001)(65806001)(65956001)(97736001)(46102001)(47776003)(20776003)(23746002);DIR:OUT;SFP:;SCL:1;SRVR:BN3PR0201MB0916;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

After looking at the GICv3 implementation and trying to understand how 
you architect the driver, I have a couple questions below.

 > On 06/24/2014 04:52 AM, Marc Zyngier wrote:
> Hi Suravee,
>
> On 24/06/14 01:33, suravee.suthikulpanit@amd.com wrote:
>> +       pr_info("GICv2m: SPI range [%d:%d]\n",
>> +               msi->spi_start, (msi->spi_start + msi->max_spi_cnt));
>> +
>> +       gic_arch_extn.irq_mask = gicv2m_mask_msi;
>> +       gic_arch_extn.irq_unmask = gicv2m_unmask_msi;
>
> Right, I now see why you need to test on the MSI descriptor. Don't do
> that. The gic_arch_extn crap should *never* *be* *used*.

Hm, sounds like this should be removed all together then? In that case, 
this would require changes in the irq-gic.c to call these functions 
directly.

>
> What you want to do is do assign a different irq_chip to your MSI
> interrupts. This will require a different integration with the main GIC
> code though. For the GICv3 ITS, I do it when the interrupt gets mapped.

Ah, that's what I was trying to avoid. Why should we need a whole 
different irq_chip just to add the MSI register frame support on top of 
the GICv2 which is already supported by the current irq-gic.c?

>
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(gicv2m_msi_init);
>> +
>> +
>> +
>> +/**
>> + * Override arch_setup_msi_irq in drivers/pci/msi.c
>> + * since we don't want to change the chip_data
>> + */
>> +int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
>> +{
>> +       struct msi_chip *chip = pdev->bus->msi;
>> +
>> +       if (!chip || !chip->setup_irq)
>> +               return -EINVAL;
>> +
>> +       return chip->setup_irq(chip, pdev, desc);
>> +}
>> +
>> +/**
>> + * Override arch_teardown_msi_irq in drivers/pci/msi.c
>> + */
>> +void arch_teardown_msi_irq(unsigned int irq)
>> +{
>> +       struct msi_desc *desc;
>> +       struct msi_chip *chip;
>> +
>> +       desc = irq_get_msi_desc(irq);
>> +       if (!desc)
>> +               return;a
>> +
>> +       chip = desc->dev->bus->msi;
>> +       if (!chip)
>> +               return;
>> +
>> +       chip->teardown_irq(chip, irq);
>> +}
>
> Please don't overtide those. There shouldn't be any reason for a
> *driver* to do so. Only architecture code should do it. And nothing in
> your code requires it (at least once you've stopped playing with the
> silly gic extension...).

The reason I need these because the __weak version of arch_setup_msi_irq 
function in driver/pci/msi.c calls irq_set_chip_data and replace the 
chip_data with msi_chip (originally was pointing to the gic_chip_data 
structure). This ended up breaking the GIC.

Looking at the GICv3 ITS implementation, this seems to also have similar 
implementation. So, this was not an issue for you?

Thanks,

Suravee
