Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3A3IVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:21:35 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:9484 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab3A3IVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:21:31 -0500
Message-ID: <5108D808.6010405@bfs.de>
Date: Wed, 30 Jan 2013 09:21:28 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Julia Lawall <julia.lawall@lip6.fr>, Russell King <linux@arm.linux.org.uk>,
        Mike Rapoport <mike@compulab.co.il>, Valdis.Kletnieks@vt.edu,
        cocci@systeme.lip6.fr, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: coccinelle and bitmask arithmetic
References: <20130127194039.GA18787@elgon.mountain>	 <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>	 <9561.1359474916@turing-police.cc.vt.edu>	 <1359475998.4196.26.camel@joe-AO722>	 <alpine.DEB.2.02.1301291847070.3339@hadrien> <1359482637.15135.7.camel@joe-AO722>
In-Reply-To: <1359482637.15135.7.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 29.01.2013 19:03, schrieb Joe Perches:
> On Tue, 2013-01-29 at 18:49 +0100, Julia Lawall wrote:
>> How about the following (from today's linux-next).  They appear to be
>> trying to do the same calculation, once with + and once with |.
> 
> (cc'ing the original developer and Russell King)
> 
> Likely the it8152_pci_platform_notify uses should use +
> 
>> arch/arm/common/it8152.c
>>
>> int dma_set_coherent_mask(struct device *dev, u64 mask)
>> {
>>         if (mask >= PHYS_OFFSET + SZ_64M - 1)
>>                 return 0;
>>
>>         return -EIO;
>> }
>>

Great hit Joe :)

Sometimes i am really surprised what code can be found
in the kernal and it is still working.
Having no clue of the code i suspect somebody tries to
check is mask outside the range it should read
PHYS_OFFSET |( SZ_64M - 1)
maybe someone should tell them that
1+1=10 while 1|1=1
It does not seem to matter here (or ... ?)

really perplexed,

wh


>> static int it8152_pci_platform_notify(struct device *dev)
>> {
>>         if (dev->bus == &pci_bus_type) {
>>                 if (dev->dma_mask)
>>                         *dev->dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
>>                 dev->coherent_dma_mask = (SZ_64M - 1) | PHYS_OFFSET;
>>                 dmabounce_register_dev(dev, 2048, 4096, it8152_needs_bounce);
>>         }
>>         return 0;
>> }
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
