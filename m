Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaG1NHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:07:15 -0400
Received: from [188.175.113.102] ([188.175.113.102]:55135 "EHLO
	router.aksignal.cz" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaG1NHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:07:10 -0400
Message-ID: <53D64ADA.1000102@aksignal.cz>
Date: Mon, 28 Jul 2014 15:06:34 +0200
From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Reply-To: jiri.prchal@aksignal.cz
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        voice.shen@atmel.com
Subject: Re: [PATCH] ARM: at91: spi: request all csgpio in spi probe
References: <b033d16ec31d26a895726ee72ec89b43943dfbae.1406547656.git.jiri.prchal@aksignal.cz> <20140728122103.GR9532@piout.net>
In-Reply-To: <20140728122103.GR9532@piout.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dne 28.7.2014 v 14:21 Alexandre Belloni napsal(a):
> Hi,
>
> Thank you for that patch, a few questions/comments below.
>
> On 28/07/2014 at 13:43:40 +0200, Jiri Prchal wrote :
>> This fix problem with PA14 set as periph A left from ROMBOOT and need it
>> to be set to gpio before spi bus communicate with chip on CS0 on other
>> gpio. As I reported a week ago.
>> Request all csgpios in spi_probe since cs depends on each other and must
>> be all of them in right state before any communication on bus. They are
>> part of bus, like miso, mosi, clk, not part of chips, they are defined
>> in parent spi node, not in child chip node.
>> Csgpio moved to atmel_spi struct as part of master bus.
>>
>> Signed-off-by: Jiri Prchal <jiri.prchal@aksignal.cz>
>> ---
>>   drivers/spi/spi-atmel.c | 68 +++++++++++++++++++++++++++++--------------------
>>   1 file changed, 41 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
>> index 92a6f0d..1fb7bb9 100644
>> --- a/drivers/spi/spi-atmel.c
>> +++ b/drivers/spi/spi-atmel.c
>> @@ -22,11 +22,14 @@
>>   #include <linux/platform_data/atmel.h>
>>   #include <linux/platform_data/dma-atmel.h>
>>   #include <linux/of.h>
>> +#include <linux/of_gpio.h>
>>
>>   #include <linux/io.h>
>>   #include <linux/gpio.h>
>>   #include <linux/pinctrl/consumer.h>
>>
>> +#define DRIVER_NAME "atmel-spi"
>> +
>
> This is not really related to the issue solved by that patch, maybe it
> could go in another patch ?
Probably yes, but is used for this patch, I based it upon spi-efm32.
>
>>   /* SPI register offsets */
>>   #define SPI_CR					0x0000
>>   #define SPI_MR					0x0004
>> @@ -242,11 +245,13 @@ struct atmel_spi {
>>
>>   	bool			keep_cs;
>>   	bool			cs_active;
>> +
>> +	/* chip selects */
>> +	unsigned int		csgpio[];
>>   };
>>
>>   /* Controller-specific per-slave state */
>>   struct atmel_spi_device {
>> -	unsigned int		npcs_pin;
>>   	u32			csr;
>>   };
>>
>> @@ -312,7 +317,7 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
>>   		}
>>
>>   		mr = spi_readl(as, MR);
>> -		gpio_set_value(asd->npcs_pin, active);
>> +		gpio_set_value(as->csgpio[spi->chip_select], active);
>>   	} else {
>>   		u32 cpol = (spi->mode & SPI_CPOL) ? SPI_BIT(CPOL) : 0;
>>   		int i;
>> @@ -329,18 +334,16 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
>>   		mr = spi_readl(as, MR);
>>   		mr = SPI_BFINS(PCS, ~(1 << spi->chip_select), mr);
>>   		if (spi->chip_select != 0)
>> -			gpio_set_value(asd->npcs_pin, active);
>> +			gpio_set_value(as->csgpio[spi->chip_select], active);
>>   		spi_writel(as, MR, mr);
>>   	}
>>
>>   	dev_dbg(&spi->dev, "activate %u%s, mr %08x\n",
>> -			asd->npcs_pin, active ? " (high)" : "",
>> -			mr);
>> +		as->csgpio[spi->chip_select], active ? " (high)" : "", mr);
>>   }
>>
>>   static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
>>   {
>> -	struct atmel_spi_device *asd = spi->controller_state;
>>   	unsigned active = spi->mode & SPI_CS_HIGH;
>>   	u32 mr;
>>
>> @@ -354,11 +357,10 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
>>   	}
>>
>>   	dev_dbg(&spi->dev, "DEactivate %u%s, mr %08x\n",
>> -			asd->npcs_pin, active ? " (low)" : "",
>> -			mr);
>> +		as->csgpio[spi->chip_select], active ? " (low)" : "", mr);
>>
>>   	if (atmel_spi_is_v2(as) || spi->chip_select != 0)
>> -		gpio_set_value(asd->npcs_pin, !active);
>> +		gpio_set_value(as->csgpio[spi->chip_select], !active);
>>   }
>>
>>   static void atmel_spi_lock(struct atmel_spi *as) __acquires(&as->lock)
>> @@ -989,8 +991,6 @@ static int atmel_spi_setup(struct spi_device *spi)
>>   	struct atmel_spi_device	*asd;
>>   	u32			csr;
>>   	unsigned int		bits = spi->bits_per_word;
>> -	unsigned int		npcs_pin;
>> -	int			ret;
>>
>>   	as = spi_master_get_devdata(spi->master);
>>
>> @@ -1017,27 +1017,13 @@ static int atmel_spi_setup(struct spi_device *spi)
>>   	csr |= SPI_BF(DLYBS, 0);
>>   	csr |= SPI_BF(DLYBCT, 0);
>>
>> -	/* chipselect must have been muxed as GPIO (e.g. in board setup) */
>> -	npcs_pin = (unsigned int)spi->controller_data;
>> -
>> -	if (gpio_is_valid(spi->cs_gpio))
>> -		npcs_pin = spi->cs_gpio;
>> -
>>   	asd = spi->controller_state;
>>   	if (!asd) {
>>   		asd = kzalloc(sizeof(struct atmel_spi_device), GFP_KERNEL);
>>   		if (!asd)
>>   			return -ENOMEM;
>>
>> -		ret = gpio_request(npcs_pin, dev_name(&spi->dev));
>> -		if (ret) {
>> -			kfree(asd);
>> -			return ret;
>> -		}
>> -
>> -		asd->npcs_pin = npcs_pin;
>>   		spi->controller_state = asd;
>> -		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
>>   	}
>>
>>   	asd->csr = csr;
>> @@ -1290,6 +1276,15 @@ static int atmel_spi_probe(struct platform_device *pdev)
>>   	int			ret;
>>   	struct spi_master	*master;
>>   	struct atmel_spi	*as;
>> +	struct device_node *np = pdev->dev.of_node;
>> +	int num_cs, i;
>> +
>> +	if (!np)
>> +		return -EINVAL;
>> +
>> +	num_cs = of_gpio_named_count(np, "cs-gpios");
>> +	if (num_cs < 0)
>> +		return num_cs;
>>
>
> This driver can still be probed without DT, this will break here, please
> don't assume that DT is present.
Yes, but I copied it from spi-efm32 and looked at others, is almost the same.
>
>
>>   	/* Select default pin state */
>>   	pinctrl_pm_select_default_state(&pdev->dev);
>> @@ -1308,7 +1303,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
>>
>>   	/* setup spi core then atmel-specific driver state */
>>   	ret = -ENOMEM;
>> -	master = spi_alloc_master(&pdev->dev, sizeof(*as));
>> +	master = spi_alloc_master(&pdev->dev, sizeof(*as) + num_cs * sizeof(unsigned));
>>   	if (!master)
>>   		goto out_free;
>>
>> @@ -1317,7 +1312,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
>>   	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(8, 16);
>>   	master->dev.of_node = pdev->dev.of_node;
>>   	master->bus_num = pdev->id;
>> -	master->num_chipselect = master->dev.of_node ? 0 : 4;
>> +	master->num_chipselect = num_cs;
>
> My guess is that you don't need to change that part.
I think I need it. What about 3 cs?
>
>>   	master->setup = atmel_spi_setup;
>>   	master->transfer_one_message = atmel_spi_transfer_one_message;
>>   	master->cleanup = atmel_spi_cleanup;
>> @@ -1325,6 +1320,25 @@ static int atmel_spi_probe(struct platform_device *pdev)
>>
>>   	as = spi_master_get_devdata(master);
>>
>> +	for (i = 0; i < master->num_chipselect; ++i) {
>> +		ret = of_get_named_gpio(np, "cs-gpios", i);
>
> Again, DT maybe not be compiled in or that driver may be probed from
> platform data.
Is another way how to do it? I see cs-gpios in master struct, but where it gets filled.
>
>> +		if (ret < 0) {
>> +			dev_err(&pdev->dev, "failed to get csgpio#%u (%d)\n",
>> +				i, ret);
>> +			goto out_free;
>> +		}
>> +		as->csgpio[i] = ret;
>> +		dev_dbg(&pdev->dev, "csgpio#%u = %u\n", i, as->csgpio[i]);
>> +		ret = devm_gpio_request_one(&pdev->dev, as->csgpio[i],
>> +					    GPIOF_OUT_INIT_HIGH, DRIVER_NAME);
>> +		if (ret < 0) {
>> +			dev_err(&pdev->dev,
>> +				"failed to configure csgpio#%u (%d)\n",
>> +				i, ret);
>> +			goto out_free;
>> +		}
>> +	}
>> +
>>   	/*
>>   	 * Scratch buffer is used for throwaway rx and tx data.
>>   	 * It's coherent to minimize dcache pollution.
>> --
>> 1.9.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
