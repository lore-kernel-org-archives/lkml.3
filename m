Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaBSMQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:16:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaBSMQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:16:10 -0500
Message-ID: <5304A042.7090903@redhat.com>
Date: Wed, 19 Feb 2014 13:14:58 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: =?ISO-8859-1?Q?David_Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 4/8] ARM: sunxi: Add driver for SD/MMC hosts found
 on Allwinner sunxi SoCs
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch> <20140217100234.15040.84232.stgit@pagira.o2s.ch> <20140218153731.GK3142@lukather> <5303C751.5090809@redhat.com> <20140219094615.GT3142@lukather>
In-Reply-To: <20140219094615.GT3142@lukather>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

On 02/19/2014 10:46 AM, Maxime Ripard wrote:
> Hi Hans,
> 
> On Tue, Feb 18, 2014 at 09:49:21PM +0100, Hans de Goede wrote:
>> Hi,
>> 
>> On 02/18/2014 04:37 PM, Maxime Ripard wrote:
>> 
>> <snip>
>> 
>>>> + +	for (i = 0; i < data->sg_len; i++) { +		pdes[i].config = SDXC_IDMAC_DES0_CH | SDXC_IDMAC_DES0_OWN | +				 SDXC_IDMAC_DES0_DIC; + +		if (data->sg[i].length == max_len) +			pdes[i].buf_size = 0; /* 0 == max_len */ +		else +			pdes[i].buf_size = data->sg[i].length; + +		pdes[i].buf_addr_ptr1 = sg_dma_address(&data->sg[i]); +		pdes[i].buf_addr_ptr2 = (u32)&pdes_pa[i + 1]; +	} + +	pdes[0].config |= SDXC_IDMAC_DES0_FD; +	pdes[i - 1].config = SDXC_IDMAC_DES0_OWN | SDXC_IDMAC_DES0_LD; + +	wmb(); /* Ensure idma_des hit main mem before we start the idmac */
>>> 
>>> wmb ensure the proper ordering of the instructions, not flushing the caches like what your comment implies.
>> 
>> Since I put that comment there, allow me to explain. A modern ARM cpu core has 2 or more units handling stores. One for regular memory stores, and one for io-mem stores. Regular mem stores can be re-ordered, io stores cannot. Normally there is no "syncing" between the 2 store units. Cache flushing is not an issue here since the memory holding the descriptors for the idma controller is allocated cache coherent, which on arm means it is not cached.
>> 
>> What is an issue here is the io-store starting the idmac hitting the io-mem before the descriptors hit the main-mem, the wmb() ensures this does not happen.
> 
> To expand a bit, my point was not that it was functionnally wrong. Since you put a barrier in there, and that it resides in a cache coherent section, we're fine.
> 
> My point was that the comment itself was misleading.

Well as explained above, the purpose of the wmb is to ensure that
the descriptors hit main memory, before the following writel (in the
caller of this function) starts the controller. So I don't see exactly
how the comment is wrong.

If you've a better wording for the comment, suggestions are welcome.

<snip>

>>>> +static void sunxi_mmc_dump_errinfo(struct sunxi_mmc_host *smc_host) +{ +	struct mmc_command *cmd = smc_host->mrq->cmd; +	struct mmc_data *data = smc_host->mrq->data; + +	/* For some cmds timeout is normal with sd/mmc cards */ +	if ((smc_host->int_sum & SDXC_INTERRUPT_ERROR_BIT) == SDXC_RESP_TIMEOUT && +			(cmd->opcode == SD_IO_SEND_OP_COND || cmd->opcode == SD_IO_RW_DIRECT)) +		return; + +	dev_err(mmc_dev(smc_host->mmc),
>>> 
>>> I'd rather put it at a debug loglevel.
>> 
>> Erm, this only happens if something is seriously wrong.
> 
> Still. Something would be seriously wrong in the MMC driver/controller. You don't want to bloat the whole kernel logs with the dump of your registers just because the MMC is failing. This is of no interest to anyone but someone that would actually try to debug what's wrong.

This is not a complete register dump, this writes a single line to the
kernel log saying that an io error happened, and printing the error flags
set in the status register. We cannot be much shorter then this without
simply not notifying the user that an io error has happened, and not
notifying the user is wrong IMHO.

> 
>>>> +	/* Make sure the controller is in a sane state before enabling irqs */ +	ret = sunxi_mmc_init_host(host->mmc); +	if (ret) +		return ret; + +	host->irq = platform_get_irq(pdev, 0); +	ret = devm_request_irq(&pdev->dev, host->irq, sunxi_mmc_irq, 0, +			       "sunxi-mmc", host); +	if (ret == 0) +		disable_irq(host->irq);
>>> 
>>> The disable_irq is useless here. Just exit.
>> 
>> No it is not note the ret == 0, this is not an error handling path!
> 
> Doh... Right. My bad.
> 
>> This is done under an if because we want to do the sunxi_mmc_exit_host regardless of the request_irq succeeding or not.
>> 
>>> 
>>>> + +	/* And put it back in reset */ +	sunxi_mmc_exit_host(host);
>>> 
>>> Hu? If it's in reset, how can it generate some IRQs?
>> 
>> Yes, that is why we do the whole dance of init controller, get irq, disable irq, drop it back in reset (until the mmc subsys does a power on of the mmc card / sdio dev).
>> 
>> Sometime the controller asserts the irq in reset for some reason, so without the dance as soon as we do the devm_request_irq we get an irq, and worse, not only do we get an irq, we cannot clear it since writing to the interrupt status register does not work when the controller is in reset, so we get stuck re-entering the irq handler.
> 
> Hmmm, I see. It probably deserves some commenting here too then.

This call is the mirror of the sunxi_mmc_init_host a few lines higher, which
has this comment:

/* Make sure the controller is in a sane state before enabling irqs */

Which attempts to explain why we do the init controller, claim irq,
disable irq, put controller back in reset sequence. Again suggestions
for a better comment are welcome.

<snip>

>>>> +	ret = mmc_add_host(mmc); + +	if (ret) +		goto error_free_dma; + +	dev_info(&pdev->dev, "base:0x%p irq:%u\n", host->reg_base, host->irq); +	platform_set_drvdata(pdev, mmc);
>>> 
>>> This should be before the registration. Otherwise, you're racy.
>> 
>> Nope, we only need this to get the data on sunxi_mmc_remove, everywhere else the data is found through the mmc-host struct.
> 
> Still, if anyone makes a following patch using the platform_device for some reason, we will have a race condition, without any way to notice it.
> 
> Plus, you're doing all the other bits of initialization of your structures much earlier, why not be consistent and having all of them at the same place?

Most platform drivers I've worked on do platform_set_drvdata as late as possible,
so that the drvdata does not get set and never cleared in error paths.

This is just following that pattern.

Regards,

Hans
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMEoDYACgkQF3VEtJrzE/uAggCdGpdcz1Nli6JREPcUcGww7wXk
r4QAoIZfwy2e5GkHjQvrdpz0aT62x9/W
=y0wO
-----END PGP SIGNATURE-----
