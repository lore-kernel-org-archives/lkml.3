Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3KECbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:31:40 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:24668 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839Ab3KECbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:31:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <5278587F.7090500@freescale.com>
Date: Tue, 5 Nov 2013 10:31:27 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <vinod.koul@intel.com>, <djbw@fb.com>
CC: Hongbo Zhang <hongbo.zhang@freescale.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <devicetree@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v11 3/3] DMA: Freescale: update driver to support 8-channel
 DMA engine
References: <1380188023-3936-1-git-send-email-hongbo.zhang@freescale.com> <1380188023-3936-4-git-send-email-hongbo.zhang@freescale.com> <525F7C18.3010409@freescale.com>
In-Reply-To: <525F7C18.3010409@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod Koul and Dan Williams,
Ping?


On 10/17/2013 01:56 PM, Hongbo Zhang wrote:
> Hi Vinod,
> I have gotten ACK from Mark for both the 1/3 and 2/3 patches.
> Thanks.
>
>
> On 09/26/2013 05:33 PM, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> This patch adds support to 8-channel DMA engine, thus the driver 
>> works for both
>> the new 8-channel and the legacy 4-channel DMA engines.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>> ---
>>   drivers/dma/Kconfig  |    9 +++++----
>>   drivers/dma/fsldma.c |    9 ++++++---
>>   drivers/dma/fsldma.h |    2 +-
>>   3 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>> index 6825957..3979c65 100644
>> --- a/drivers/dma/Kconfig
>> +++ b/drivers/dma/Kconfig
>> @@ -89,14 +89,15 @@ config AT_HDMAC
>>         Support the Atmel AHB DMA controller.
>>     config FSL_DMA
>> -    tristate "Freescale Elo and Elo Plus DMA support"
>> +    tristate "Freescale Elo series DMA support"
>>       depends on FSL_SOC
>>       select DMA_ENGINE
>>       select ASYNC_TX_ENABLE_CHANNEL_SWITCH
>>       ---help---
>> -      Enable support for the Freescale Elo and Elo Plus DMA 
>> controllers.
>> -      The Elo is the DMA controller on some 82xx and 83xx parts, and 
>> the
>> -      Elo Plus is the DMA controller on 85xx and 86xx parts.
>> +      Enable support for the Freescale Elo series DMA controllers.
>> +      The Elo is the DMA controller on some mpc82xx and mpc83xx 
>> parts, the
>> +      EloPlus is on mpc85xx and mpc86xx and Pxxx parts, and the Elo3 
>> is on
>> +      some Txxx and Bxxx parts.
>>     config MPC512X_DMA
>>       tristate "Freescale MPC512x built-in DMA engine support"
>> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
>> index 49e8fbd..16a9a48 100644
>> --- a/drivers/dma/fsldma.c
>> +++ b/drivers/dma/fsldma.c
>> @@ -1261,7 +1261,9 @@ static int fsl_dma_chan_probe(struct 
>> fsldma_device *fdev,
>>       WARN_ON(fdev->feature != chan->feature);
>>         chan->dev = fdev->dev;
>> -    chan->id = ((res.start - 0x100) & 0xfff) >> 7;
>> +    chan->id = (res.start & 0xfff) < 0x300 ?
>> +           ((res.start - 0x100) & 0xfff) >> 7 :
>> +           ((res.start - 0x200) & 0xfff) >> 7;
>>       if (chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
>>           dev_err(fdev->dev, "too many channels for device\n");
>>           err = -EINVAL;
>> @@ -1434,6 +1436,7 @@ static int fsldma_of_remove(struct 
>> platform_device *op)
>>   }
>>     static const struct of_device_id fsldma_of_ids[] = {
>> +    { .compatible = "fsl,elo3-dma", },
>>       { .compatible = "fsl,eloplus-dma", },
>>       { .compatible = "fsl,elo-dma", },
>>       {}
>> @@ -1455,7 +1458,7 @@ static struct platform_driver fsldma_of_driver = {
>>     static __init int fsldma_init(void)
>>   {
>> -    pr_info("Freescale Elo / Elo Plus DMA driver\n");
>> +    pr_info("Freescale Elo series DMA driver\n");
>>       return platform_driver_register(&fsldma_of_driver);
>>   }
>>   @@ -1467,5 +1470,5 @@ static void __exit fsldma_exit(void)
>>   subsys_initcall(fsldma_init);
>>   module_exit(fsldma_exit);
>>   -MODULE_DESCRIPTION("Freescale Elo / Elo Plus DMA driver");
>> +MODULE_DESCRIPTION("Freescale Elo series DMA driver");
>>   MODULE_LICENSE("GPL");
>> diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
>> index f5c3879..1ffc244 100644
>> --- a/drivers/dma/fsldma.h
>> +++ b/drivers/dma/fsldma.h
>> @@ -112,7 +112,7 @@ struct fsldma_chan_regs {
>>   };
>>     struct fsldma_chan;
>> -#define FSL_DMA_MAX_CHANS_PER_DEVICE 4
>> +#define FSL_DMA_MAX_CHANS_PER_DEVICE 8
>>     struct fsldma_device {
>>       void __iomem *regs;    /* DGSR register base */
>
>



