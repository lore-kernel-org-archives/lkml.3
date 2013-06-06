Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab3FFKJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:09:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56825 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626Ab3FFKJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:09:17 -0400
Message-ID: <51B05FB8.6050903@ti.com>
Date: Thu, 6 Jun 2013 13:08:56 +0300
From: Illia Smyrnov <x0194613@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Illia Smyrnov <illia.smyrnov@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 2/2] spi: omap2-mcspi: Add FIFO buffer support
References: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com> <1370432398-7796-3-git-send-email-illia.smyrnov@ti.com> <20130605120346.GZ31367@sirena.org.uk>
In-Reply-To: <20130605120346.GZ31367@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.193]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/05/2013 03:03 PM, Mark Brown wrote:
> On Wed, Jun 05, 2013 at 02:39:58PM +0300, Illia Smyrnov wrote:
>
>>   - The spi slave nodes can provide the following information which is used
>>     by the spi controller:
>>     - ti,spi-turbo-mode: Set turbo mode for this device.
>> +  - ti,spi-fifo-depth: Enable FIFO and set up buffer depth.
>
> Why is this defined for slaves?  Surely the size of the FIFO in the
> controller is a property of the controller not the slave?

According to OMAP TRM [1] the FIFO buffer can be used by only one 
channel at a time. If several channels are selected and several FIFO 
enable bit fields are set to 1, the controller forces the buffer not to 
be used.

If there are several slaves on the controller we must select which of 
slaves will use the FIFO for SPI transfers. Also, optimal FIFO size is 
heavily dependent of the SPI transfers length specific for certain slave.

>
>> +		bytes_per_word = (cs->word_len <= 8) ? 1 :
>> +				(cs->word_len <= 16) ? 2 :
>> +				/* cs->word_len <= 32 */ 4;
>
> This isn't legible.  Use a switch statement, or better yet just divide.
>
>> +		level = (t->len < mcspi->fifo_depth ? t->len :
>> +			mcspi->fifo_depth) - 1;
>> +
>> +		mcspi_write_reg(master, OMAP2_MCSPI_XFERLEVEL,
>> +			((wcnt << 16) | (level << (is_read ? 8 : 0))));
>> +
>> +		chconf |= is_read ? OMAP2_MCSPI_CHCONF_FFER :
>> +			OMAP2_MCSPI_CHCONF_FFET;
>
> Please avoid such extensive use of the ternery operator, it's not good
> for legibility.
>> +	} else {
>> +		mcspi->fifo_depth = 0;
>> +		chconf &= ~(is_read ? OMAP2_MCSPI_CHCONF_FFER :
>> +			OMAP2_MCSPI_CHCONF_FFET);
>> +	}
>> +
>> +	mcspi_write_chconf0(spi, chconf);
>
> We have a bunch of return statements further up the function in cases
> where the FIFO can't be used which means that if we're in FIFO mode then
> hit one of those we'll not disable FIFO mode as far as I can tell?
>

I will rework this in the next patch version.

[1]: http://www.ti.com/lit/ug/swpu235z/swpu235z.pdf
