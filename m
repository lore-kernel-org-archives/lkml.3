Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaFYC4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:56:15 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:41022
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753934AbaFYC4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:56:13 -0400
X-WSS-ID: 0N7PETF-08-1PN-02
X-M-MSG: 
Message-ID: <53AA3A3A.2050401@amd.com>
Date: Tue, 24 Jun 2014 21:55:54 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] arm/gic: Add supports for GICv2m MSI(-X)
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1403569980-12913-3-git-send-email-suravee.suthikulpanit@amd.com>
 <20140624101111.GD5856@leverpostej>
In-Reply-To: <20140624101111.GD5856@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377454003)(51704005)(479174003)(164054003)(24454002)(189002)(199002)(51914003)(92726001)(20776003)(64706001)(87266999)(50986999)(74662001)(74502001)(85306003)(47776003)(36756003)(101416001)(95666004)(105586002)(76176999)(65816999)(97736001)(86362001)(54356999)(87936001)(83072002)(31966008)(92566001)(21056001)(65806001)(76482001)(19580395003)(81542001)(46102001)(84676001)(85852003)(83506001)(83322001)(68736004)(44976005)(80022001)(19580405001)(77982001)(4396001)(59896001)(33656002)(64126003)(81342001)(102836001)(50466002)(79102001)(99396002)(106466001)(65956001)(23756003)(107046001);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0201MB0924;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

Thank you for all your comments. Please see my reply below. I have 
omitted the minor ones.

On 6/24/2014 5:11 AM, Mark Rutland wrote:
> On Tue, Jun 24, 2014 at 01:33:00AM +0100, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> +static int alloc_msi_irq(struct gicv2m_msi_data *data, int nvec, int *irq)
>> +{
>> +       int size = sizeof(unsigned long) * data->bm_sz;
>> +       int next = size, ret, num;
>> +
>> +       spin_lock(&data->msi_cnt_lock);
>> +
>> +       for (num = nvec; num > 0; num--) {
>> +               next = bitmap_find_next_zero_area(data->bm,
>> +                                       size, 0, num, 0);
>> +               if (next < size)
>> +                       break;
>> +       }
>
> If max_spi_cnt is not a multiple of BITS_PER_LONG, this can allocate a
> number greater or equal to max_spi_cnt, but below size. We should never
> allocate max_spi_cnt or above.
>
Thanks for the catch. I also need to clean up this logic for V2.

>> +       spin_unlock(&data->msi_cnt_lock);
>> +
>> +       return ret;
>> +}
>> +
>> +static void free_msi_irq(struct gicv2m_msi_data *data, unsigned int irq)
>> +{
>> +       int pos;
>> +
>> +       spin_lock(&data->msi_cnt_lock);
>> +
>> +       pos = irq - data->spi_start;
>> +       if (pos >= 0 && pos < data->max_spi_cnt)
>
> Should either of these cases ever happen?

This is to check if the irq provided is within the MSI range.

>> +static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
>> +                     struct msi_desc *desc)
>> +{
>> +       int avail, irq = 0;
>> +       struct msi_msg msg;
>> +       phys_addr_t addr;
>> +       struct gicv2m_msi_data *data = to_gicv2m_msi_data(chip);
>> +
>> +       if (data == NULL) {
>
> If container_of returns NULL, you have bigger problems.

It was just sanity check. But, if you think this is obvious, I'll remove 
this check then.

>> +int __init gicv2m_msi_init(struct device_node *node,
>> +                          struct gicv2m_msi_data *msi)
>> +{
>> +       unsigned int val;
>> +       const __be32 *msi_be;
>
> Every time I see a __be32* in a DT probe function I weep. There is no
> need to deal with the internal details of the DTB.
>
>> +
>> +       msi_be = of_get_address(node, GIC_OF_MSIV2M_RANGE_INDEX, NULL, NULL);
>> +       if (!msi_be) {
>> +               pr_err("GICv2m failed. Fail to locate MSI base.\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       msi->paddr64 = of_translate_address(node, msi_be);
>> +       msi->base = of_iomap(node, GIC_OF_MSIV2M_RANGE_INDEX);
>
> You can instead use of_address_to_resource to query the address from the
> DTB once, without having to muck about with endianness conversion
> manually. Take a look at what of_iomap does.

Thanks for this suggestion. I was not quite familiar with the "of_" 
interface. I am cleaning up this whole section now.

> I'm surprised we don't have an ioremap_resource given we have a devm_
> variant.
>

>> +
>> +       /*
>> +       * MSI_TYPER:
>> +       *     [31:26] Reserved
>> +       *     [25:16] lowest SPI assigned to MSI
>> +       *     [15:10] Reserved
>> +       *     [9:0]   Numer of SPIs assigned to MSI
>> +       */
>> +       val = __raw_readl(msi->base + MSI_TYPER);
>
> Are you sure you want to use __raw_readl?
>
Probably not.  I am replacing this with ioread32(msi->base + MSI_TYPER).

>> +       if (!val) {
>> +               pr_warn("GICv2m: Failed to read MSI_TYPER register\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       msi->spi_start = (val >> 16) & 0x3ff;
>> +       msi->max_spi_cnt = val & 0x3ff;
>> +
>> +       pr_debug("GICv2m: SPI = %u, cnt = %u\n",
>> +               msi->spi_start, msi->max_spi_cnt);
>> +
>> +       if (msi->spi_start < GIC_V2M_MIN_SPI ||
>> +               msi->max_spi_cnt >= GIC_V2M_MAX_SPI) {
>> +                       pr_err("GICv2m: Init failed\n");
>> +                       return -EINVAL;
>> +       }
>> +
>> +       msi->bm_sz = BITS_TO_LONGS(msi->max_spi_cnt);
>
> So msi->bm_sz is msi->max_spi_cnt in _longs_ (rounded up)...
>
>> +       msi->bm = kzalloc(msi->bm_sz, GFP_KERNEL);
>
> ...yet we allocate that many _bytes_?
>
Sorry, I got a bit confused here. I'll fix this.

>> +
>> +       gic_arch_extn.irq_mask = gicv2m_mask_msi;
>> +       gic_arch_extn.irq_unmask = gicv2m_unmask_msi;
>
> I'll leave others to comment on the validity of this...
>
Marc has commented this part in the other patch.

>> +       void __iomem *base;       /* GICv2m virt address */
>> +       unsigned int spi_start;   /* The SPI number that MSIs start */
>> +       unsigned int max_spi_cnt; /* The number of SPIs for MSIs */
>> +       unsigned long *bm;        /* MSI vector bitmap */
>> +       unsigned long bm_sz;      /* MSI bitmap size */
>
> It's a bit odd in my mind that this is in longs. Why not just use
> max_spi_cnt, which you can trivially use to determine bytes or longs?

That's true. I'm cleaning this up.

>> @@ -246,7 +254,8 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
>>                              bool force)
>>   {
>>          void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
>> -       unsigned int cpu, shift = (gic_irq(d) % 4) * 8;
>> +       unsigned int shift = (gic_irq(d) % 4) * 8;
>> +       unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
>
> Unrelated change?

Sorry, this was not supposed to be part of this patch.

Thanks,

Suravee

