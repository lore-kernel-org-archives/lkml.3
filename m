Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935353Ab3BTM3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:29:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10772 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934845Ab3BTM3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:29:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 20 Feb 2013 04:28:28 -0800
Message-ID: <5124C18F.6070108@nvidia.com>
Date: Wed, 20 Feb 2013 17:59:03 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra114: add spi driver
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com> <5123C18A.9010604@wwwdotorg.org>
In-Reply-To: <5123C18A.9010604@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2013 11:46 PM, Stephen Warren wrote:
> On 02/19/2013 06:38 AM, Laxman Dewangan wrote:
>> +	bits_per_word = t->bits_per_word ? t->bits_per_word :
>> +						spi->bits_per_word;
> I thought I'd seen patches so this conditional wasn't needed any more;
> isn't t->bit_per_word always set correctly by the SPI core now?
> Certainly the existing spi-tegra20-slink.c doesn't seem to have any
> conditional here.

Yes, core have changes. I will remove this check.


>
> A similar comment applies in tegra_spi_read_rx_fifo_to_client_rxbuf()
> and tegra_spi_copy_spi_rxbuf_to_client_rxbuf().
>
>> +		total_fifo_words = (max_len + 3)/4;
> Need spaces around /. The same comment applies in some other places;
> please search for them. Was checkpatch run? I'm not sure if catches this.
>
> spi-tegra20-slink.c doesn't have that rounding; is just says:
>
>      total_fifo_words = max_len / 4;
>
> Is that a bug in the old driver?


I will check and fix the either place.


>
>> +	if (tspi->cur_direction & DATA_DIR_TX) {
>> +		tegra_spi_copy_client_txbuf_to_spi_txbuf(tspi, t);
>> +		ret = tegra_spi_start_tx_dma(tspi, len);
> In spi-tegra20-slink.c, there's a wmb() right between those last two
> lines. Is it needed here?

I think wmb() is no require and hence not keeping here. Perhaps I got 
the review feedback when I was working on serial tegra driver.


>
>> +static int tegra_spi_start_transfer_one(struct spi_device *spi,
>> +		struct spi_transfer *t, bool is_first_of_msg,
>> +		bool is_single_xfer)
> ...
>> +		/* possibly use the hw based chip select */
>> +		command1 |= SPI_CS_SW_HW;
>> +		if (spi->mode & SPI_CS_HIGH)
>> +			command1 |= SPI_CS_SS_VAL;
>> +		else
>> +			command1 &= ~SPI_CS_SS_VAL;
> Why "possibly"; the code seems to always use HW chip select.


Yes, wrong comment. Remove the controller_data from driver but forgot to 
remove this comment.

>> +	ret = pm_runtime_get_sync(tspi->dev);
>> +	if (ret < 0) {
>> +		dev_err(tspi->dev, "runtime PM get failed: %d\n", ret);
>> +		msg->status = ret;
>> +		spi_finalize_current_message(master);
>> +		return ret;
>> +	}
> In the older Tegra SPI drivers, the PM runtime logic was was of
> master->{un,}prepare_transfer. I'm curious why it's implemented
> differently here.

The prepare  is called in atomic context and in this we are calling 
pm_runtime_get_sync() which is blocking and it can cause issue.

I have already bug reported by you that sometimes you saw locking in 
tegra20 slink driver which we need to fix. When testing this, I ran into 
similar case and hence now moving this out or prepare.

I will push the change for fixing this in tegra20_slink driver also.

>> +	prop = of_get_property(np, "spi-max-frequency", NULL);
>> +	if (prop)
>> +		tspi->spi_max_frequency = be32_to_cpup(prop);
> The following might be better:
>
>          if (of_property_read_u32(np, "spi-max-frequency",
>                                          &tspi->spi_max_frequency))
>                  tspi->spi_max_frequency = 25000000; /* 25MHz */
>
> (and you can remove the check of !tspi->spi_max_frequency from probe()
> then too)

Yes, Agree. Will do.

>
>> +static int tegra_spi_probe(struct platform_device *pdev)
> ...
>> +	if (!pdev->dev.of_node) {
>> +		dev_err(&pdev->dev, "Driver support DT registration only\n");
>> +		return -ENODEV;
>> +	}
> I don't think there's much point checking that; see the Tegra20 SPI
> cleanup patches I posted a couple days ago.
>
>> +	tspi->base = devm_request_and_ioremap(&pdev->dev, r);
>> +	if (!tspi->base) {
> The existing Tegra20 driver checks if (IS_ERR(tspi->base)) here. Which
> is wrong?
The tegra20 driver use the devm_ioremap_resource() which is new API get 
added recently. I will change this driver to use this one.



>> +	tspi->clk = devm_clk_get(&pdev->dev, "spi");
> Does this HW block use multiple clocks? If not, I think s/"spi"/NULL/
> there, just like the Tegra20 driver.

No, spi controller uses the only one clock. I will change to NULL.


>
> As an overall comment, this driver is textually perhaps 80-90% the same
> as spi-tegra20-slink.c. Instead of creating a completely new driver, how
> nasty would a unified driver look; one which contained some runtime
> conditionals for the register layout and programming differences? It
> might be worth looking at, although perhaps it would turn out to be a
> crazy mess, so a separate driver really is appropriate.

We had created the similarly in past where common part is in same file 
and controller specific is in the different file as hal file but the 
driver becomes complex.
It was not easy to add any feature as the require api need to be added 
in all places for hal.  We were about to split the driver separately but 
before then we moved to Linux.

So first look, it is great but adding feature/maintaining/enhancing is 
difficult.
I like to go with separate driver until there is much pushback to make 
it one.


