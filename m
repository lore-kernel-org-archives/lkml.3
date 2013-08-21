Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab3HUAzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:55:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54476 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab3HUAzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:55:16 -0400
Message-ID: <52140FD2.7020403@ti.com>
Date: Tue, 20 Aug 2013 19:54:42 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2 04/14] crypto: omap-aes: Simplify DMA usage by using
 direct SGs
References: <1376793755-30478-1-git-send-email-joelf@ti.com> <1376793755-30478-5-git-send-email-joelf@ti.com> <521367B4.2020203@ti.com>
In-Reply-To: <521367B4.2020203@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 07:57 AM, Lokesh Vutla wrote:
> Hi Joel,
> 
> On Sunday 18 August 2013 08:12 AM, Joel Fernandes wrote:
>> In early version of this driver, assumptions were made such as DMA layer
>> requires contiguous buffers etc. Due to this, new buffers were allocated,
>> mapped and used for DMA. These assumptions are no longer true and DMAEngine
>> scatter-gather DMA doesn't have such requirements. We simply the DMA operations
>> by directly using the scatter-gather buffers provided by the crypto layer
>> instead of creating our own.
>>
>> Lot of logic that handled DMA'ing only X number of bytes of the total, or as
>> much as fitted into a 3rd party buffer is removed and is no longer required.
>>
>> Also, good performance improvement of atleast ~20% seen with encrypting a
>> buffer size of 8K (1800 ops/sec vs 1400 ops/sec).  Improvement will be higher
>> for much larger blocks though such benchmarking is left as an exercise for the
>> reader.  Also DMA usage is much more simplified and coherent with rest of the
>> code.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  drivers/crypto/omap-aes.c |  147 ++++++++-------------------------------------
>>  1 file changed, 25 insertions(+), 122 deletions(-)
>>
>> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
>> index e369e6e..64dd5c1 100644
>> --- a/drivers/crypto/omap-aes.c
>> +++ b/drivers/crypto/omap-aes.c
>> @@ -480,22 +480,14 @@ static int sg_copy(struct scatterlist **sg, size_t *offset, void *buf,
>>  }
>>  
>>  static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
>> -		struct scatterlist *in_sg, struct scatterlist *out_sg)
>> +		struct scatterlist *in_sg, struct scatterlist *out_sg,
>> +		int in_sg_len, int out_sg_len)
>>  {
>>  	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>>  	struct omap_aes_dev *dd = ctx->dd;
>>  	struct dma_async_tx_descriptor *tx_in, *tx_out;
>>  	struct dma_slave_config cfg;
>> -	dma_addr_t dma_addr_in = sg_dma_address(in_sg);
>> -	int ret, length = sg_dma_len(in_sg);
>> -
>> -	pr_debug("len: %d\n", length);
>> -
>> -	dd->dma_size = length;
>> -
>> -	if (!(dd->flags & FLAGS_FAST))
>> -		dma_sync_single_for_device(dd->dev, dma_addr_in, length,
>> -					   DMA_TO_DEVICE);
>> +	int ret;
> By this change FLAGS_FAST is unsed, it can be cleaned right?
> or Am I missing something?

Yes, FLAGS_FAST would be unused now and can go away. Since it is very trivial
change, I will make this change in the not-immediate future and submit.

Thanks,

-Joel


