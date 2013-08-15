Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3HOF6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 01:58:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46710 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3HOF6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 01:58:46 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-ab-520c6e139bf9
Message-id: <520C6E0A.8030505@samsung.com>
Date: Thu, 15 Aug 2013 08:58:34 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: joelf@ti.com
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 00/10] crypto: omap-aes: DMA and PIO mode improvements
References: <1376521969-16807-1-git-send-email-joelf@ti.com>
 <520C1327.8090607@ti.com>
In-reply-to: <520C1327.8090607@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4NV3hPJ4gg4e7lCzmnG9hsdi3kdfi
	487prBabHl9jtbh/7yeTxeVdc9gsZi/pZ7FY0fGF0eLBZiaLZ/17GC1e961htth/xcuBx6Pv
	8XNmj29fJ7F4bFl5k8nj23tZj81L6j2O39jO5PF5k1wAexSXTUpqTmZZapG+XQJXxt0fSQVz
	5SuOdS1la2C8JtHFyMkhIWAicfP0A2YIW0ziwr31bF2MXBxCAksZJXbM2sEK4TQySfTsfM8E
	4SxklOhYvpsNpIVXQEti6YJuMJtFQFXi+/Ff7CA2m4CexIbmH2C2qECExMolD1gh6gUlfky+
	xwJiiwgISFw795MZZCizwD9midcL/4IVCQt4SdxsawUq4gDaFiFxcI8nSJhTQE3iy9ZvTCA2
	s4COxP7WaWwQtrzE5jVvwV4QArqhe+1aNoh3FCVOTz7HPIFReBaS1bOQtM9C0r6AkXkVo2hq
	aXJBcVJ6rpFecWJucWleul5yfu4mRkisfd3BuPSY1SFGAQ5GJR7eiDbuICHWxLLiytxDjBIc
	zEoivP+9eYKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MMaLMkqWlXxLvdHGe25KMAPXpOQrCR5J
	j5etrbwapP7Idc1D5VtH51fLbMioPrt+rsO9hx3bbsuoVLrW7GJl/JMsqPJMN8CpxLTrG7fy
	8TsXOc+IXLR5qKVxMj3kecn+GBmNolfyGWL9aTfDra/a+e+zl9vKmdf/enPxSrsPX9y/fFBZ
	uJJjjhJLcUaioRZzUXEiALHRCf+TAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/13 02:30, Joel Fernandes wrote:
> On 08/14/2013 06:12 PM, Joel Fernandes wrote:
>> This patch series is a rewrite of the DMA portion of omap-aes driver
>> and also adds support for PIO mode. Both these modes, give better
>> performance than before.
>>
>> Earlier, only a single SG was used for DMA purpose, and the SG-list
>> passed from the crypto layer was being copied and DMA'd one entry at
>> a time. This turns out to be quite inefficient, so we replace it with
>> much simpler code that directly passes the SG-list from crypto to the
>> DMA layer.
>>
>> We also add PIO mode support to the driver, and switch to PIO mode
>> whenever the DMA channel allocation is not available. This is only for
>> OMAP4 platform will work on any platform on which IRQ information is
>> populated.
>>
>> Tests performed on am33xx and omap4 SoCs , notice the 50% perf improvement
> Just correcting, this is more like 35% not 50% when using DMA.

Hmm :)

1766/1460 = ~20%

>
> Thanks,
>
> -Joel
>
>
>
>
>
>> for large 8K blocks:
>>
>> Sample run on am33xx (beaglebone):
>> With DMA rewrite:
>> [   26.410052] test 0 (128 bit key, 16 byte blocks): 4318 operations in 1 seconds (69088 bytes)
>> [   27.414314] test 1 (128 bit key, 64 byte blocks): 4360 operations in 1 seconds (279040 bytes)
>> [   28.414406] test 2 (128 bit key, 256 byte blocks): 3609 operations in 1 seconds (923904 bytes)
>> [   29.414410] test 3 (128 bit key, 1024 byte blocks): 3418 operations in 1 seconds (3500032 bytes)
>> [   30.414510] test 4 (128 bit key, 8192 byte blocks): 1766 operations in 1 seconds (14467072 bytes)
>>
>> Without DMA rewrite:
>> [   31.920519] test 0 (128 bit key, 16 byte blocks): 4417 operations in 1 seconds (70672 bytes)
>> [   32.925997] test 1 (128 bit key, 64 byte blocks): 4221 operations in 1 seconds (270144 bytes)
>> [   33.926194] test 2 (128 bit key, 256 byte blocks): 3528 operations in 1 seconds (903168 bytes)
>> [   34.926225] test 3 (128 bit key, 1024 byte blocks): 3281 operations in 1 seconds (3359744 bytes)
>> [   35.926385] test 4 (128 bit key, 8192 byte blocks): 1460 operations in 1 seconds (11960320 bytes)
>>
>> With PIO mode, note the tremndous boost in performance for small blocks there:
>> [   27.294905] test 0 (128 bit key, 16 byte blocks): 20585 operations in 1 seconds (329360 bytes)
>> [   28.302282] test 1 (128 bit key, 64 byte blocks): 8106 operations in 1 seconds (518784 bytes)
>> [   29.302374] test 2 (128 bit key, 256 byte blocks): 2359 operations in 1 seconds (603904 bytes)
>> [   30.302575] test 3 (128 bit key, 1024 byte blocks): 605 operations in 1 seconds (619520 bytes)
>> [   31.303781] test 4 (128 bit key, 8192 byte blocks): 79 operations in 1 seconds (647168 bytes)
>>
>> Future work in this direction would be to dynamically change between
>> PIO/DMA mode based on the block size.
>>
>> Joel Fernandes (10):
>>   crypto: scatterwalk:  Add support for calculating number of SG
>>     elements
>>   crypto: omap-aes: Add useful debug macros
>>   crypto: omap-aes: Populate number of SG elements
>>   crypto: omap-aes: Simplify DMA usage by using direct SGs
>>   crypto: omap-aes: Sync SG before DMA operation
>>   crypto: omap-aes: Remove previously used intermediate buffers
>>   crypto: omap-aes: Add IRQ info and helper macros
>>   crypto: omap-aes: PIO mode: Add IRQ handler and walk SGs
>>   crypto: omap-aes: PIO mode: platform data for OMAP4 and trigger it
>>   crypto: omap-aes: Switch to PIO mode in probe function
>>
>>  crypto/scatterwalk.c         |   22 +++
>>  drivers/crypto/omap-aes.c    |  400 ++++++++++++++++++++----------------------
>>  include/crypto/scatterwalk.h |    2 +
>>  3 files changed, 217 insertions(+), 207 deletions(-)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

