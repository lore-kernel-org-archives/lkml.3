Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3GEBZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:25:17 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:2071 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab3GEBZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:25:14 -0400
Message-ID: <51D62074.9070303@atmel.com>
Date: Fri, 5 Jul 2013 09:25:08 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [RFC PATCH 01/13] misc: atmel_ssc: add device tree DMA support
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com> <1372667978-4718-2-git-send-email-richard.genoud@gmail.com> <51D24299.9050209@atmel.com> <CACQ1gAgcc=j3kmcpjp8bbdHhxr_k=h8jJs6R_paJbPUMv74uGg@mail.gmail.com> <51D29927.80900@atmel.com> <CACQ1gAhnDk-qSt_5xrsMakXqGGDO5pEbA-9UDWCJG=AABDc+zg@mail.gmail.com> <CACQ1gAgPaRm3gxxJNgfj9bR565Q0+SNY3+EcjA_mrh1N+yPzSA@mail.gmail.com> <51D4CC94.3020908@atmel.com> <CACQ1gAio0ekQMgyfrLjTHmMPGJQoKoe61GreFQDN-iLjxbLQ0w@mail.gmail.com>
In-Reply-To: <CACQ1gAio0ekQMgyfrLjTHmMPGJQoKoe61GreFQDN-iLjxbLQ0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 7/4/2013 21:44, Richard Genoud wrote:
> 2013/7/4 Bo Shen <voice.shen@atmel.com>:
>> Hi Richard,
>>
>>
>> On 7/3/2013 23:51, Richard Genoud wrote:
>>>>
>>>>> but there's a violent hang (kernel stops, no trace) when I try the
>>>>> record :
>>>>> arecord -v -V stereo -Dplug:default -f cd -t wav -c 2 /tmp/toto.wav
>>>>> last thing I see is :
>>>>> dma dma0chan3: atc_control (3)
>>
>>
>> I don't meet this issue. Playback and recording works well on my side on
>> at91sam9g35ek board.
>>
>>
>>>>> I'll try to trace that.
>>>
>>> I think it's DMA related.
>>> the last thing done by the kernel is:
>>>    i2c i2c-0: i2c_outb: 0x34 A
>>>    i2c i2c-0: i2c_outb: 0x0c A
>>>    i2c i2c-0: i2c_outb: 0x5a A
>>> meaning: enable power on, LINE IN, ADC, OSC, on the WM8731
>>> so, after that, data is comming from the codec to the SSC and then is
>>> handled by the DMA.
>>> there must be something nasty on the DMA bus to hang everything like
>>> that...
>>
>>
>> Will you try i2c without DMA support to test this issue?
>
> Ok, I nailed it !
>
> To be sure we are on the same base, here is what I have done:
> onto next-20130704:
> - your 5 patches:
> ASoC: atmel_ssc_dai: move set dma data to startup callback
> ASoC: atmel_ssc_dai: add error mask define
> ASoC: atmel-pcm-dma: move prepare for dma to dai prepare
> ARM: atmel-ssc: change phybase type to dma_addr_t
> ASoC: atmel-pcm: use generic dmaengine framework
> - my patches 4-8:
> ARM: at91: DTS: sam9x5: add SSC DMA parameters
> ARM: AT91: DTS: sam9x5ek: add WM8731 codec
> ARM: AT91: DTS: sam9x5ek: add sound configuration
> ARM: AT91: DTS: sam9x5ek: enable SSC
> sound: sam9x5_wm8731: machine driver for at91sam9x5 wm8731 boards
>
> To be sure that dma-I2c doesn't disturb something, I use i2c gpio bitbang:
> diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> index 6684d4b..53a991e 100644
> --- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> +++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> @@ -57,15 +57,6 @@
>   				status = "okay";
>   			};
>
> -			i2c0: i2c@f8010000 {
> -				status = "okay";
> -
> -				wm8731: wm8731@1a {
> -					compatible = "wm8731";
> -					reg = <0x1a>;
> -				};
> -			};
> -
>   			pinctrl@fffff400 {
>   				mmc0 {
>   					pinctrl_board_mmc0: mmc0-board {
> @@ -114,6 +105,15 @@
>   		};
>   	};
>
> +	i2c@0 {
> +		status = "okay";
> +
> +		wm8731: wm8731@1a {
> +			compatible = "wm8731";
> +			reg = <0x1a>;
> +		};
> +	};
> +
>   	sound {
>   		compatible = "atmel,sam9x5-audio-wm8731";
>
> with that configuration, it hangs when I do a:
> arecord -v -V stereo -Dplug:default -f cd -t wav -c 2 /tmp/toto.wav
>
> Now, if I remove the overrun error on ssc in rx_mask:
> diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
> index 0ecf356..c04e825 100644
> --- a/sound/soc/atmel/atmel_ssc_dai.c
> +++ b/sound/soc/atmel/atmel_ssc_dai.c
> @@ -83,7 +83,6 @@ static struct atmel_ssc_mask ssc_rx_mask = {
>   	.ssc_disable	= SSC_BIT(CR_RXDIS),
>   	.ssc_endx	= SSC_BIT(SR_ENDRX),
>   	.ssc_endbuf	= SSC_BIT(SR_RXBUFF),
> -	.ssc_error	= SSC_BIT(SR_OVRUN),
>   	.pdc_enable	= ATMEL_PDC_RXTEN,
>   	.pdc_disable	= ATMEL_PDC_RXTDIS,
>   };
>
> It doesn't hang any more doing a simple record.
> BUT it still hangs if we do record and play at the same time.
>
> Removing the overrun on tx_mask prevent the hang:
> diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
> index 0ecf356..41e15c2 100644
> --- a/sound/soc/atmel/atmel_ssc_dai.c
> +++ b/sound/soc/atmel/atmel_ssc_dai.c
> @@ -73,7 +73,6 @@ static struct atmel_ssc_mask ssc_tx_mask = {
>   	.ssc_disable	= SSC_BIT(CR_TXDIS),
>   	.ssc_endx	= SSC_BIT(SR_ENDTX),
>   	.ssc_endbuf	= SSC_BIT(SR_TXBUFE),
> -	.ssc_error	= SSC_BIT(SR_OVRUN),
>   	.pdc_enable	= ATMEL_PDC_TXTEN,
>   	.pdc_disable	= ATMEL_PDC_TXTDIS,
>   };
>
> i.e. when I revert "ASoC: atmel_ssc_dai: add error mask define", I
> don't see any hang.
>
> Could you test and confirm that behaviour please ?

Yes, I aware this issue.
Actually the system not hang, the resource all are occupied by the 
interrupt. This because, we enable the interrupt, when once interrupt 
occur, I try many methods to clear it, however we can not clear it. So, 
it generates the interrupt all the time. It seems the system hang.

Temp solution: not enable the interrupt. use the following patch to 
disable the interrupt.
---8>---
diff --git a/sound/soc/atmel/atmel_ssc_dai.c 
b/sound/soc/atmel/atmel_ssc_dai.c
index 0ecf356..bb53dea 100644
--- a/sound/soc/atmel/atmel_ssc_dai.c
+++ b/sound/soc/atmel/atmel_ssc_dai.c
@@ -649,7 +649,7 @@ static int atmel_ssc_prepare(struct 
snd_pcm_substream *substream,
         dma_params = ssc_p->dma_params[dir];

         ssc_writel(ssc_p->ssc->regs, CR, dma_params->mask->ssc_enable);
-       ssc_writel(ssc_p->ssc->regs, IER, dma_params->mask->ssc_error);
+       ssc_writel(ssc_p->ssc->regs, IDR, dma_params->mask->ssc_error);

         pr_debug("%s enabled SSC_SR=0x%08x\n",
                         dir ? "receive" : "transmit",
---<8---

BTW, I am checking this with our IP team, if find the real solution, I 
will fix it.

> I attached a the (simple) .config I used for the tests.
>
> PS: I hope the patches won't be mangled by gmail...
>
> Best regards,
> Richard.

Best Regards,
Bo Shen

