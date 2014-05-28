Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaE1Nih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:38:37 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36084 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaE1Nif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:38:35 -0400
Date: Wed, 28 May 2014 08:38:32 -0500
From: Michael Welling <mwelling@ieee.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Stickel <ms@mycable.de>
Subject: Re: linux-next: manual merge of the gpio tree with Linus' tree
Message-ID: <20140528133832.GA2541@deathray>
References: <20140528190011.302a2e52@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528190011.302a2e52@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 07:00:11PM +1000, Stephen Rothwell wrote:
> Hi Linus,
> 
> Today's linux-next merge of the gpio tree got a conflict in
> drivers/gpio/gpio-mcp23s08.c between commit 99e4b98dbe3a ("gpio:
> mcp23s08: Bug fix of SPI device tree registration") from Linus' tree
> and commit 3e3bed913e8b ("gpio: mcp23s08: fixed count variable for
> devicetree probing") from the gpio tree.
> 
> I fixed it up (one way - see below) and can carry the fix as necessary
> (no action is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/gpio/gpio-mcp23s08.c
> index 3d53fd6880d1,00fbb30b9b10..000000000000
> --- a/drivers/gpio/gpio-mcp23s08.c
> +++ b/drivers/gpio/gpio-mcp23s08.c
> @@@ -894,11 -894,14 +894,12 @@@ static int mcp23s08_probe(struct spi_de
>   			dev_err(&spi->dev, "invalid spi-present-mask\n");
>   			return -ENODEV;
>   		}
> + 
>   		for (addr = 0; addr < ARRAY_SIZE(pdata->chip); addr++) {
> - 			if ((spi_present_mask & (1 << addr)))
> - 				chips++;
>   			pullups[addr] = 0;
> + 			if (spi_present_mask & (1 << addr))
> + 				chips++;
>   		}
>  -		if (!chips)
>  -			return -ENODEV;
>   	} else {
>   		type = spi_get_device_id(spi)->driver_data;
>   		pdata = dev_get_platdata(&spi->dev);


Looking at the Linux next version, I am fairly certian that the following is
redundant checking:
                if (chips < 0) {
                        dev_err(&spi->dev, "FATAL: invalid negative chip id\n");
                        goto fail;
                }

The chips variable should equal the number of bits in the spi_present_mask variable.
Or am I missing something?

