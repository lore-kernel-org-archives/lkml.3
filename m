Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3IWVBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:01:48 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18996 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3IWVBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:01:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Sep 2013 14:01:45 -0700
Message-ID: <5240AC3A.9060206@nvidia.com>
Date: Mon, 23 Sep 2013 17:01:46 -0400
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
References: <1379528245-6283-1-git-send-email-rklein@nvidia.com> <52408DC8.3020407@wwwdotorg.org> <52409B1E.3030405@nvidia.com> <52409D63.3020909@wwwdotorg.org>
In-Reply-To: <52409D63.3020909@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/2013 3:58 PM, Stephen Warren wrote:
> On 09/23/2013 01:48 PM, Rhyland Klein wrote:
>> On 9/23/2013 2:51 PM, Stephen Warren wrote:
>>> On 09/18/2013 12:17 PM, Rhyland Klein wrote:
>>>> The tegra114 driver wasn't currently handling the cs_change functionality.
>>>> It is meant to invert normal behavior, and we were only using it to possibly
>>>> delay at the end of a transfer.
> ...
>>>> diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
> ...
>>>> @@ -717,7 +718,12 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
>>>>  		else if (req_mode == SPI_MODE_3)
>>>>  			command1 |= SPI_CONTROL_MODE_3;
>>>>  
>>>> -		tegra_spi_writel(tspi, command1, SPI_COMMAND1);
>>>> +		if (tspi->cs_control) {
>>>> +			if (tspi->cs_control != spi)
>>>> +				tegra_spi_writel(tspi, command1, SPI_COMMAND1);
>>>
>>> Do you really need a separate write call there? The value of command1
>>> isn't fully set up there (the CS bits are all set up immediately after),
>>> so won't that glitch the CS lines in some cases?
>>
>> On our hardware (as far as I've seen), the CS line is normally low. We
> 
> I assume you meant "normally *active* low", not "normally low"?

I mean that when I look at CS, before a transaction starts, the line is
low. Then we do a write like this (default SPI_COMMAND1) you see CS rise
and fall very soon after. This is purely how we generate the edge
triggers (as far as I can tell on all Tegra hw, though Laxman can
correct me if I am wrong).

> 
>> need to generate a falling-edge to trigger the beginning of a SPI
>> transaction. Doing this write with the default value of SPI_COMMAND1
>> causes a brief rise and fall of CS, giving us our falling-edge.
> 
> That sounds like exactly the glitch I was talking about.
> 
> Assuming CS isn't held constantly asserted (low), isn't CS de-asserted
> (rises) at the end of transaction n-1, and re-asserted (falls) at the
> start of transaction n? If so, I'm not sure why the setup for
> transaction n needs to both de-assert and then re-assert it? It seems
> like cs_control should be handled at the end of a transaction, not at
> the start of the next one.

cs_change has to maintain state over spi_message boundries, not just
between spi_transfers within a spi_message.

In this specific case, this is a safe guard.

>>>> +		if (tspi->cs_control) {
This sees that the previous transfer stored its spi_device pointer,
meaning it had cs_change set on the last part of the last spi_message
(I.E. CS hasn't been deasserted, so the SPI transaction is still on-going).

>>>> +			if (tspi->cs_control != spi)
This however finds that the device trying to send a SPI message isn't
the same one that was in the middle of its transaction. This is a
collision between 2 clients on 1 bus. This simply ends the previous
transaction (the ongoing one) in favor of starting a new transaction.

Otherwise, this logic allows us to skip the spi of COMMAND1 which would
normally be used to create the falling edge to start a new transaction,
leaving the previous one open for more transfers.

-rhyland

-- 
nvpublic
