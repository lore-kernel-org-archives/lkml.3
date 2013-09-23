Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3IWT6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:58:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60906 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3IWT6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:58:31 -0400
Message-ID: <52409D63.3020909@wwwdotorg.org>
Date: Mon, 23 Sep 2013 13:58:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [RESEND] spi/tegra114: Correct support for cs_change
References: <1379528245-6283-1-git-send-email-rklein@nvidia.com> <52408DC8.3020407@wwwdotorg.org> <52409B1E.3030405@nvidia.com>
In-Reply-To: <52409B1E.3030405@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 01:48 PM, Rhyland Klein wrote:
> On 9/23/2013 2:51 PM, Stephen Warren wrote:
>> On 09/18/2013 12:17 PM, Rhyland Klein wrote:
>>> The tegra114 driver wasn't currently handling the cs_change functionality.
>>> It is meant to invert normal behavior, and we were only using it to possibly
>>> delay at the end of a transfer.
...
>>> diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
...
>>> @@ -717,7 +718,12 @@ static int tegra_spi_start_transfer_one(struct spi_device *spi,
>>>  		else if (req_mode == SPI_MODE_3)
>>>  			command1 |= SPI_CONTROL_MODE_3;
>>>  
>>> -		tegra_spi_writel(tspi, command1, SPI_COMMAND1);
>>> +		if (tspi->cs_control) {
>>> +			if (tspi->cs_control != spi)
>>> +				tegra_spi_writel(tspi, command1, SPI_COMMAND1);
>>
>> Do you really need a separate write call there? The value of command1
>> isn't fully set up there (the CS bits are all set up immediately after),
>> so won't that glitch the CS lines in some cases?
> 
> On our hardware (as far as I've seen), the CS line is normally low. We

I assume you meant "normally *active* low", not "normally low"?

> need to generate a falling-edge to trigger the beginning of a SPI
> transaction. Doing this write with the default value of SPI_COMMAND1
> causes a brief rise and fall of CS, giving us our falling-edge.

That sounds like exactly the glitch I was talking about.

Assuming CS isn't held constantly asserted (low), isn't CS de-asserted
(rises) at the end of transaction n-1, and re-asserted (falls) at the
start of transaction n? If so, I'm not sure why the setup for
transaction n needs to both de-assert and then re-assert it? It seems
like cs_control should be handled at the end of a transaction, not at
the start of the next one.
