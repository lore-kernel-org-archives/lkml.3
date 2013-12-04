Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab3LDMhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:37:32 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:33382 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab3LDMha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:37:30 -0500
Message-ID: <529F21B6.1020909@schinagl.nl>
Date: Wed, 04 Dec 2013 13:36:06 +0100
From: Oliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        hdegoede@redhat.com, oliver+list@schinagl.nl
Subject: Re: [PATCH 1/3] RFC: AHCI: libahci is missing DMA
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl> <1386159055-10264-2-git-send-email-oliver@schinagl.nl> <20131204123234.GC3158@htj.dyndns.org>
In-Reply-To: <20131204123234.GC3158@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tejun Heo,

On 04-12-13 13:32, Tejun Heo wrote:
> On Wed, Dec 04, 2013 at 01:10:53PM +0100, oliver@schinagl.nl wrote:
>> From: Oliver Schinagl <oliver@schinagl.nl>
>>
>> The Allwinner sunxi platforms have patched in the following to enable
>> DMA. This patch enables DMA controllers for the SUNXI Architecture.
>>
>> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
>> ---
>>   drivers/ata/ahci.h    | 6 ++++++
>>   drivers/ata/libahci.c | 8 ++++++++
>>   2 files changed, 14 insertions(+)
>>
>> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
>> index 2289efdf..2bf2423 100644
>> --- a/drivers/ata/ahci.h
>> +++ b/drivers/ata/ahci.h
>> @@ -138,6 +138,7 @@ enum {
>>   	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
>>   	PORT_FBS		= 0x40, /* FIS-based Switching */
>>   	PORT_DEVSLP		= 0x44, /* device sleep */
>> +	PORT_DMA		= 0x70, /* direct memory access */
>>   
>>   	/* PORT_IRQ_{STAT,MASK} bits */
>>   	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
>> @@ -209,6 +210,11 @@ enum {
>>   	PORT_DEVSLP_DSP		= (1 << 1),       /* DevSlp present */
>>   	PORT_DEVSLP_ADSE	= (1 << 0),       /* Aggressive DevSlp enable */
>>   
>> +	/* PORT_DMA bits */
>> +	PORT_DMA_SETUP_OFFSET	= 8, /* dma setup offset */
>> +	PORT_DMA_SETUP_MASK	= (0xff << PORT_DMA_SETUP_OFFSET),/* dma mask */
>> +	PORT_DMA_SETUP_INIT	= (0x44 << 0),
> Ummm... this doesn't belong to ahci proper, right?
I have no idea why Allwinner added that and what it really does. We have 
no documentation, only code drops.

I had high hopes someone around here knows what it could mean and where 
it does belong.
>
>> +
>>   	/* hpriv->flags bits */
>>   
>>   #define AHCI_HFLAGS(flags)		.private_data	= (void *)(flags)
>> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
>> index c482f8c..d697a74 100644
>> --- a/drivers/ata/libahci.c
>> +++ b/drivers/ata/libahci.c
>> @@ -570,6 +570,14 @@ void ahci_start_engine(struct ata_port *ap)
>>   	void __iomem *port_mmio = ahci_port_base(ap);
>>   	u32 tmp;
>>   
>> +#ifdef CONFIG_ARCH_SUNXI
>> +	/* Setup DMA before DMA start */
>> +	tmp = readl(port_mmio + PORT_DMA);
>> +	tmp &= ~PORT_DMA_SETUP_MASK;
>> +	tmp |= PORT_DMA_SETUP_INIT << PORT_DMA_SETUP_OFFSET;
>> +	writel(tmp, port_mmio + PORT_DMA);
>> +#endif
> If this is something platform device specific, wouldn't overriding
> ->port_start() which wraps around ahci_port_start() make more sense?
Again, I don't know, this is where Allwinner had put it. We don't even 
know who's IP they use. I'm happy to start experimenting moving this 
around a bit and will take your clue to figure out what you mean and if 
it could work.

Oliver
>
> Thanks.
>

