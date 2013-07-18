Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446Ab3GRVwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:52:43 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:62041 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933881Ab3GRVwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:52:40 -0400
Message-ID: <51E863AC.3030202@cogentembedded.com>
Date: Fri, 19 Jul 2013 01:52:44 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: phil.edworthy@renesas.com
CC: Max Filippov <max.filippov@cogentembedded.com>, djbw@fb.com,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-sh-owner@vger.kernel.org, vinod.koul@intel.com
Subject: Re: [PATCH] dma: add driver for R-Car HPB-DMAC
References: <201306300015.50713.sergei.shtylyov@cogentembedded.com> <OF8D49C605.99A1CBE3-ON80257B9B.003FC397-80257B9B.004368CF@eu.necel.com>
In-Reply-To: <OF8D49C605.99A1CBE3-ON80257B9B.003FC397-80257B9B.004368CF@eu.necel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/01/2013 04:16 PM, phil.edworthy@renesas.com wrote:

> Hi Max, Sergei,

> Thanks for your work on this.

>> Add support for HPB-DMAC found in Renesas R-Car SoCs, using 'shdma-base' DMA
>> driver framework.

>> Based on the original patch by Phil Edworthy <phil.edworthy@renesas.com>.

>> Signed-off-by: Max Filippov <max.filippov@cogentembedded.com>
>> [Sergei: removed useless #include, sorted #include's, fixed HPB_DMA_TCR_MAX,
>> fixed formats and removed line breaks in the dev_dbg() calls, rephrased and
>> added IRQ # to the shdma_request_irq() failure message, added MODULE_AUTHOR(),
>> fixed guard macro name in the header file, fixed #define ASYNCRSTR_ASRST20,
>> added #define ASYNCRSTR_ASRST24, beautified some commets.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

    Please don't quote the text you're not replying to, else it makes me 
scroll and scroll and scroll in search of your remarks (and then remove the 
unanswered text myself).

[...]
>> Index: slave-dma/drivers/dma/sh/rcar-hpbdma.c
>> ===================================================================
>> --- /dev/null
>> +++ slave-dma/drivers/dma/sh/rcar-hpbdma.c
>> @@ -0,0 +1,623 @@
[...]
>> +/* DMA channel registers */
>> +#define DSAR0      0x00
>> +#define DDAR0      0x04
>> +#define DTCR0      0x08
>> +#define DSAR1      0x0C
>> +#define DDAR1      0x10
>> +#define DTCR1      0x14
>
>> +#define DSASR      0x18
>> +#define DDASR      0x1C
>> +#define DTCSR      0x20

> These are not used.

    So what? I think Max's purpose was to show the full register space here.

>> +#define DPTR      0x24
>> +#define DCR      0x28
>> +#define DCMDR      0x2C
>> +#define DSTPR      0x30
>> +#define DSTSR      0x34

>> +#define DDBGR      0x38
>> +#define DDBGR2      0x3C

> These are not used.

    Likewise answer.

>> +#define HPB_CHAN(n)   (0x40 * (n))
>> +
>> +/* DMA command register (DCMDR) bits */
>> +#define DCMDR_BDOUT   BIT(7)

> This is not used

    Will remove.

>> +#define DCMDR_DQSPD   BIT(6)

>> +#define DCMDR_DQSPC   BIT(5)
>> +#define DCMDR_DMSPD   BIT(4)
>> +#define DCMDR_DMSPC   BIT(3)

> These are not used.

    Will remove. Though perhaps Max's intent was to show the full set of DCMDR 
bits...

>> +#define DCMDR_DQEND   BIT(2)
>> +#define DCMDR_DNXT   BIT(1)
>> +#define DCMDR_DMEN   BIT(0)
>> +
>> +/* DMA forced stop register (DSTPR) bits */
>> +#define   DSTPR_DMSTP   BIT(0)
>> +
>> +/* DMA status register (DSTSR) bits */
>> +#define   DSTSR_DMSTS   BIT(0)
>> +
>> +/* DMA common registers */
>
>> +#define DTIMR      0x00

> This is not used.

    See above about full register space.

>> +#define DINTSR0      0x0C
>> +#define DINTSR1      0x10
>> +#define DINTCR0      0x14
>> +#define DINTCR1      0x18
>> +#define DINTMR0      0x1C
>> +#define DINTMR1      0x20
>
>> +#define DACTSR0      0x24
>> +#define DACTSR1      0x28

> These are not used.

    See above.

>> +#define HSRSTR(n)   (0x40 + (n) * 4)

>> +#define HPB_DMASPR(n)   (0x140 + (n) * 4)
>> +#define HPB_DMLVLR0   0x160
>> +#define HPB_DMLVLR1   0x164
>> +#define HPB_DMSHPT0   0x168
>> +#define HPB_DMSHPT1   0x16C

> These are not used.

    Likewise.

>> +static bool hpb_dmae_chan_irq(struct shdma_chan *schan, int irq)
>> +{
>> +   struct hpb_dmae_chan *chan = to_chan(schan);
>> +   struct hpb_dmae_device *hpbdev = to_dev(chan);
>> +   int ch = chan->cfg->dma_ch;
>> +
>> +   /* Check Complete DMA Transfer */
>> +   if (dintsr_read(hpbdev, ch)) {
>> +      /* Clear Interrupt status */
>> +      dintcr_write(hpbdev, ch);
>> +      return true;
>> +   }
>> +   return false;
>> +}

> For some peripherals, e.g. MMC, there is only one physical DMA channel
> available for both tx & rx. In this case, the MMC driver should request
> two logical channels. So, the DMAC driver should map logical channels to
> physical channels. When it comes to the interrupt handler, the only way to
> tell if the tx or rx logical channel completed, as far as I can see, is to
> check the settings in the DCR reg.

    Hm, note taken.

>> Index: slave-dma/include/linux/platform_data/dma-rcar-hpbdma.h
>> ===================================================================
>> --- /dev/null
>> +++ slave-dma/include/linux/platform_data/dma-rcar-hpbdma.h
>> @@ -0,0 +1,103 @@
[...]
>> +/* DMA control register (DCR) bits */
>> +#define   DCR_DTAMD   (1u << 26)
>> +#define   DCR_DTAC   (1u << 25)
>> +#define   DCR_DTAU   (1u << 24)
>> +#define   DCR_DTAU1   (1u << 23)
>> +#define   DCR_SWMD   (1u << 22)
>> +#define   DCR_BTMD   (1u << 21)
>> +#define   DCR_PKMD   (1u << 20)
>> +#define   DCR_CT      (1u << 18)
>> +#define   DCR_ACMD   (1u << 17)
>> +#define   DCR_DIP      (1u << 16)
>> +#define   DCR_SMDL   (1u << 13)
>> +#define   DCR_SPDAM   (1u << 12)
>> +#define   DCR_SDRMD_MASK   (3u << 10)
>> +#define   DCR_SDRMD_MOD   (0u << 10)
>> +#define   DCR_SDRMD_AUTO   (1u << 10)
>> +#define   DCR_SDRMD_TIMER   (2u << 10)
>> +#define   DCR_SPDS_MASK   (3u << 8)
>> +#define   DCR_SPDS_8BIT   (0u << 8)
>> +#define   DCR_SPDS_16BIT   (1u << 8)
>> +#define   DCR_SPDS_32BIT   (2u << 8)
>> +#define   DCR_DMDL   (1u << 5)
>> +#define   DCR_DPDAM   (1u << 4)
>> +#define   DCR_DDRMD_MASK   (3u << 2)
>> +#define   DCR_DDRMD_MOD   (0u << 2)
>> +#define   DCR_DDRMD_AUTO   (1u << 2)
>> +#define   DCR_DDRMD_TIMER   (2u << 2)
>> +#define   DCR_DPDS_MASK   (3u << 0)
>> +#define   DCR_DPDS_8BIT   (0u << 0)
>> +#define   DCR_DPDS_16BIT   (1u << 0)
>> +#define   DCR_DPDS_32BIT   (2u << 0)
>> +
>> +/* Asynchronous reset register (ASYNCRSTR) bits */
>> +#define   ASYNCRSTR_ASRST41   BIT(10)
>> +#define   ASYNCRSTR_ASRST40   BIT(9)
>> +#define   ASYNCRSTR_ASRST39   BIT(8)
>> +#define   ASYNCRSTR_ASRST27   BIT(7)
>> +#define   ASYNCRSTR_ASRST26   BIT(6)
>> +#define   ASYNCRSTR_ASRST25   BIT(5)
>> +#define   ASYNCRSTR_ASRST24   BIT(4)
>> +#define   ASYNCRSTR_ASRST23   BIT(3)
>> +#define   ASYNCRSTR_ASRST22   BIT(2)
>> +#define   ASYNCRSTR_ASRST21   BIT(1)
>> +#define   ASYNCRSTR_ASRST20   BIT(0)

> If you replace this with a macro with an argument, you can simplify the
> setup code.

    That would be quite a complex macro considering a gap after bit 7.

> I.e. since we already have .dma_ch in the slave config struct,
> you won't need the .rstr field.

    If you look at the platform code, you'll see that all peripheral channels 
are reset every time, so not a single bit of .rstr is set but multiple. This
actually surprised me too.

> Similarly, looking at your patches to add SDHC DMA support, the .mdr and
> .mdm fields do not need to be channel specific. All we really need to know
> is if the channel needs async MD single and async BTMD burst. The
> calculation for the bits required can be internal to the DMAC driver.

    I'll see what can be done...

WBR, Sergei

