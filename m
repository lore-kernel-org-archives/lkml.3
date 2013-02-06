Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3BFKog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:44:36 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:28866 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751947Ab3BFKof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:44:35 -0500
Message-ID: <5112340B.7030505@gaisler.com>
Date: Wed, 06 Feb 2013 11:44:27 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>, software@gaisler.com,
        linux-kernel@vger.kernel.org, Peter Korsgaard <jacmet@sunsite.dk>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH RESEND] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu
 mode outside of FSL SOC environments and add a grlib variant normally running
 on sparc
References: <1359548124-13692-1-git-send-email-andreas@gaisler.com> <20130205175630.C6F7F3E167A@localhost>
In-Reply-To: <20130205175630.C6F7F3E167A@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-05 18:56, Grant Likely wrote:
> On Wed, 30 Jan 2013 13:15:24 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
>> This patch relies upon parts of the "of, of_gpio, of_spi: Fix and
>> improve of_parse_phandle_with_args, of_gpio_named_count and
>> of_spi_register_master" patchset - https://lkml.org/lkml/2012/12/27/54
>> (v2 at https://lkml.org/lkml/2013/1/29/308).

For TYPE_GRLIB, the gpio chipselect parts relies on this series. It 
would be great to get some feedback on that patch series as well.

>> Maybe the different out/in_be32 vs iowrite/read32be in spi-fsl-lib.h is
>> over the top, but I'm not sure if there might be subtle differences
>> between those on powerpc and I don't have any fsl hardware to try things
>> out on.
>
> Changing to ioread/write globally should be fine. I would change it and get
> someone with an fsl board to try it out. That will reduce the diffstat a
> bit.

Will do.

> As is, this is quite an invasive patch, so I'm not going to be
> comfortable merging it without at least one 3rd party tester. (Breaking
> things up into discrete patches will make me less nervous and possible
> to merge parts while still revising others.

I'll be happy to do that. Was trying to adhere to the guide line to not 
introduce something separately from its usage, but in this case it is 
probably better to split things up a bit.

>> +#ifdef CONFIG_FSL_SOC
>>   	else if (prop && !strcmp(prop, "qe"))
>>   		pdata->flags = SPI_CPM_MODE | SPI_QE;
>>   	else if (of_device_is_compatible(np, "fsl,cpm2-spi"))
>>   		pdata->flags = SPI_CPM_MODE | SPI_CPM2;
>>   	else if (of_device_is_compatible(np, "fsl,cpm1-spi"))
>>   		pdata->flags = SPI_CPM_MODE | SPI_CPM1;
>> +#endif
>
> The ifdefs are ugly and these lines won't affect sparc. Just leave them
> in.

Will do.

>> +/* TYPE_GRLIB SPI Controller capability register definitions */
>> +#define SPCAP_SSEN(x)           (((x) >> 16) & 0x1)
>> +#define SPCAP_SSSZ(x)           (((x) >> 24) & 0xff)
>> +#define SPCAP_MAXWLEN(x)	(((x) >> 20) & 0xf)
>
> Nit: inconsistent whitespace (tabs vs. spaces)

Will fix.

>> +	ret = of_property_read_u32(dev->of_node, "bus-number", &bus_num);
>> +	if (!ret)
>> +		master->bus_num = bus_num;
>
> Drop these lines. Never set the bus number explicitly when using DT. If
> you really want to assign a particular bus number, then use an alias.

Sure, I'll check that out.

> That's all the comments I've got for now, but there are an awful lot of
> #defines that are added to the driver which is kind of ugly. I'm not
> going to nack over that, but it would be good to clean it up and do some
> better abstraction.

I agree that it is ugly. If I move the cpm-related things from 
spi-fsl-spi.c to a separate file that only gets linked on FSL_SOC and 
have dummy functions in an h-file I think that it can be made much less 
ugly.

Thanks for the feedback!

Cheers,
Andreas

