Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3IWTss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:48:48 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11066 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3IWTsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:48:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Sep 2013 12:48:46 -0700
Message-ID: <52409B1E.3030405@nvidia.com>
Date: Mon, 23 Sep 2013 15:48:46 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [RESEND] spi/tegra114: Correct support for cs_change
References: <1379528245-6283-1-git-send-email-rklein@nvidia.com> <52408DC8.3020407@wwwdotorg.org>
In-Reply-To: <52408DC8.3020407@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/2013 2:51 PM, Stephen Warren wrote:
> On 09/18/2013 12:17 PM, Rhyland Klein wrote:
>> The tegra114 driver wasn't currently handling the cs_change functionality.
>> It is meant to invert normal behavior, and we were only using it to possibly
>> delay at the end of a transfer.
> 
> I don't really follow this patch description well. It may help if you
> fully spelled out the definition of normal behaviour, what the driver
> was doing, and what it should be doing (which is presumable what it does
> do after this patch).

Yah, I'll explain the cs_change logic a little clearer in the next
version, but for now:

cs_change is meant to invert the normal behavior of the CS line during a
SPI transfer. Normally, the CS line stays asserted from the beginning of
the first transfer until the last is completed within the same
spi_message, and then it is deasserted. There can be any number of
spi_transfers within a spi_message. When cs_change is asserted for a
spi_transfer that is not the last one in the message, this means that
after that transfer is completed, the CS line should be deasserted
(where normally it would stay asserted). Then when the next transfer
starts, it will assert CS again. If the last spi_transfer in a
spi_message has cs_change set, then it means that instead of deasserted
CS at the end of the transaction (spi_message) then it leaves CS asserted.

> 
>> This patch modifies the logic so that the cs state will be toggled after
>> every individual transfer or NOT toggled at the end of the last transfer
>> if cs_change is set in that transfer struct.
>>
>> Also, this builds in logic so that if a different device tries to start
>> a transfer while CS is active from a different device, it will abort the
>> previous transfer and start a new one for the new device.
> 
> What user-visible impact does this patch have. Does it solve a bug, or
> improve performance, or ...? In other words, how would I test this
> patch, other that testing for regressions in SPI functionality that I
> know already works.

This allows a spi client to send a write, and then any number of reads
as a single spi transaction, but separated into separate spi_messages. I
tested this for ChromeOS where our platform has an embedded controller
which communicates over SPI. It has some quirks, namely when we read
back data, we maybe need to do multiple reads before we start getting
valid data. This means we need to be able to control when the CS line is
deasserted which would be after we know we finally received all the data
we were expecting.

I don't know of any other hardware currently that is good for exercising
this logic on our reference boards.

> 
> BTW, I don't think you're using get_maintainer.pl, since Mark Brown is
> the SPI maintainer now, not Grant Likely.

I could have sworn I ran it, but I didn't see Mark come up, I'll
definitely add him for the next revision.

> 
>> diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
>> index 145dd43..a9973de 100644
>> --- a/drivers/spi/spi-tegra114.c
>> +++ b/drivers/spi/spi-tegra114.c
>> @@ -182,6 +182,7 @@ struct tegra_spi_data {
>>  	u32					cur_speed;
>>  
>>  	struct spi_device			*cur_spi;
>> +	struct spi_device			*cs_control;
>>  	unsigned				cur_pos;
>>  	unsigned				cur_len;
>>  	unsigned				words_per_32bit;
>> @@ -717,7 +718,12 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
>>  		else if (req_mode == SPI_MODE_3)
>>  			command1 |= SPI_CONTROL_MODE_3;
>>  
>> -		tegra_spi_writel(tspi, command1, SPI_COMMAND1);
>> +		if (tspi->cs_control) {
>> +			if (tspi->cs_control != spi)
>> +				tegra_spi_writel(tspi, command1, SPI_COMMAND1);
> 
> Do you really need a separate write call there? The value of command1
> isn't fully set up there (the CS bits are all set up immediately after),
> so won't that glitch the CS lines in some cases?

On our hardware (as far as I've seen), the CS line is normally low. We
need to generate a falling-edge to trigger the beginning of a SPI
transaction. Doing this write with the default value of SPI_COMMAND1
causes a brief rise and fall of CS, giving us our falling-edge.

> 
>> +			tspi->cs_control = NULL;
>> +		} else
>> +			tegra_spi_writel(tspi, command1, SPI_COMMAND1);
>>  
>>  		command1 |= SPI_CS_SW_HW;
>>  		if (spi->mode & SPI_CS_HIGH)
>> @@ -732,6 +738,9 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
>>  		command1 |= SPI_BIT_LENGTH(bits_per_word - 1);
>>  	}
>>  
>> +	if (t->len == 0 && !t->tx_buf && !t->rx_buf)
>> +		return 0;
> 
> What if !t->len, but t->tx_buf || t->rx_buf ?
> 
> This code is also duplicated in tegra_spi_transfer_one_message() after
> this patch. Instead, perhaps the first N lines of
> tegra_spi_start_transfer_one() should be split out into e.g.
> tegra_spi_setup_transfer_one(), such that
> tegra_spi_transfer_one_message() can always call it, plus have
> tegra_spi_transfer_one_message() only call
> tegra_spi_start_transfer_one() if (t->len != 0).

I'll look into this some more. The main reason I have this here is
because tegra_spi_start_transfer_one() contains the logic for starting a
transaction (which when this type of spi_transfer is set, can be used
just to toggle CS and end a previous transaction that had cs_change
set). Breaking apart tegra_spi_start_transfer_one() might very well be
much nicer. I'll see how it looks.

Thanks,
-rhyland

-- 
nvpublic
