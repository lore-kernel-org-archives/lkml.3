Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaDDNHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:07:22 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53436 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbaDDNHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:07:16 -0400
Message-ID: <533EAE81.6060109@mm-sol.com>
Date: Fri, 04 Apr 2014 16:07:13 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Courtney Cavin <courtney.cavin@sonymobile.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 3/9] crypto: qce: Add dma and sg helpers
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-4-git-send-email-svarbanov@mm-sol.com> <20140403231525.GE17066@sonymobile.com>
In-Reply-To: <20140403231525.GE17066@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Courtney,

Thanks for the comments!

On 04/04/2014 02:15 AM, Courtney Cavin wrote:
> On Thu, Apr 03, 2014 at 06:18:00PM +0200, Stanimir Varbanov wrote:
>> This adds dmaengine and sg-list helper functions used by
>> other parts of the crypto driver.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
>>  drivers/crypto/qce/dma.c | 201 +++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/crypto/qce/dma.h |  57 ++++++++++++++
>>  2 files changed, 258 insertions(+)
>>  create mode 100644 drivers/crypto/qce/dma.c
>>  create mode 100644 drivers/crypto/qce/dma.h
> 
> More nitpicking, because everyone loves that....
> 
>>
>> diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
>> new file mode 100644
>> index 000000000000..1bad958db2f9
>> --- /dev/null
>> +++ b/drivers/crypto/qce/dma.c
>> @@ -0,0 +1,201 @@
> [...]
>> +int qce_dma_request(struct device *dev, struct qce_dma_data *dma)
>> +{
>> +	unsigned int memsize;
>> +	void *va;
>> +	int ret;
>> +
>> +	dma->txchan = dma_request_slave_channel_reason(dev, "tx");
>> +	if (IS_ERR(dma->txchan)) {
>> +		ret = PTR_ERR(dma->txchan);
>> +		return ret;
> 
> You can just return PTR_ERR(dma->txchan) here, no need to set 'ret'.

I think the idea was to have only one exit point from the function,
never mind I will return from here.

> 
>> +	}
>> +
>> +	dma->rxchan = dma_request_slave_channel_reason(dev, "rx");
>> +	if (IS_ERR(dma->rxchan)) {
>> +		ret = PTR_ERR(dma->rxchan);
>> +		goto error_rx;
>> +	}
>> +
>> +	memsize = QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ;
>> +	va = kzalloc(memsize, GFP_KERNEL);
> 
> 'memsize' is only used here.  Just pass 'QCE_RESULT_BUF_SZ +
> QCE_IGNORE_BUF_SZ' directly to kzalloc().
> 

The only reason to have "memsize" variable is to avoid carry over the
new line. The compiler is smart enough to delete this variable. But this
is a minor issue and I tend to agree with you.

> Additionally, is there some particular reason why we need to zero this
> memory?

IMO, it makes sense when debugging some issue related to dma to this
memory.

> 
>> +	if (!va) {
>> +		ret = -ENOMEM;
>> +		goto error_nomem;
>> +	}
>> +
>> +	dma->result_buf = va;
> 
> Is there some requirement that we don't set dma->result_buf on error?
> If not, we can discard the 'va' variable as well.

No, there is no such requirement, the error is fatal and driver will
refuse to .probe.

> 
>> +	dma->ignore_buf = dma->result_buf + QCE_RESULT_BUF_SZ;
>> +
>> +	return 0;
>> +error_nomem:
>> +	if (!IS_ERR(dma->rxchan))
>> +		dma_release_channel(dma->rxchan);
>> +error_rx:
>> +	if (!IS_ERR(dma->txchan))
>> +		dma_release_channel(dma->txchan);
>> +	return ret;
>> +}
>> +
>> +void qce_dma_release(struct qce_dma_data *dma)
>> +{
>> +	dma_release_channel(dma->txchan);
>> +	dma_release_channel(dma->rxchan);
>> +	kfree(dma->result_buf);
>> +}
>> +
>> +int qce_mapsg(struct device *dev, struct scatterlist *sg, unsigned int nents,
>> +	      enum dma_data_direction dir, bool chained)
>> +{
>> +	int err;
>> +
>> +	if (chained) {
>> +		while (sg) {
>> +			err = dma_map_sg(dev, sg, 1, dir);
>> +			if (!err)
>> +				goto error;
>> +			sg = scatterwalk_sg_next(sg);
>> +		}
>> +	} else {
>> +		err = dma_map_sg(dev, sg, nents, dir);
>> +		if (!err)
>> +			goto error;
>> +	}
>> +
>> +	return nents;
>> +error:
>> +	return -EFAULT;
> 
> No need for this label, as there's no cleanup.  Just return
> -EFAULT directly on error.

Sure, will do.

> 
>> +}
> [...]
>> +struct scatterlist *
>> +qce_sgtable_add(struct sg_table *sgt, struct scatterlist *new_sgl)
>> +{
>> +	struct scatterlist *sg = sgt->sgl, *sg_last = NULL;
>> +
>> +	while (sg) {
>> +		if (!sg_page(sg))
>> +			break;
>> +		sg = sg_next(sg);
>> +	}
>> +
>> +	if (!sg)
>> +		goto error;
>> +
>> +	while (new_sgl && sg) {
>> +		sg_set_page(sg, sg_page(new_sgl), new_sgl->length,
>> +			    new_sgl->offset);
>> +		sg_last = sg;
>> +		sg = sg_next(sg);
>> +		new_sgl = sg_next(new_sgl);
>> +	}
>> +
>> +	if (new_sgl)
>> +		goto error;
>> +
>> +	return sg_last;
>> +error:
>> +	return ERR_PTR(-EINVAL);
> 
> No need for this label, as there's no cleanup.  Just return
> ERR_PTR(-EINVAL) directly on error.

Sure, will fix it.

> 
>> +}
>> +
>> +static int qce_dma_prep_sg(struct dma_chan *chan, struct scatterlist *sg,
>> +			   int nents, unsigned long flags,
>> +			   enum dma_transfer_direction dir,
>> +			   dma_async_tx_callback cb, void *cb_param)
>> +{
>> +	struct dma_async_tx_descriptor *desc;
>> +
>> +	if (!sg || !nents)
>> +		return -EINVAL;
>> +
>> +	desc = dmaengine_prep_slave_sg(chan, sg, nents, dir, flags);
>> +	if (!desc)
>> +		return -EINVAL;
>> +
>> +	desc->callback = cb;
>> +	desc->callback_param = cb_param;
>> +	dmaengine_submit(desc);
> 
> Do we not care if there is an error here?
> 
> dma_cookie_t cookie;
> ...
> cookie = dmaengine_submit(desc);
> return dma_submit_error(cookie);
> 

Good catch, we should care. Will check the error. Thanks.

>> +	return 0;
>> +}
> [...]
>> diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
>> new file mode 100644
>> index 000000000000..932b02fd8f25
>> --- /dev/null
>> +++ b/drivers/crypto/qce/dma.h
>> @@ -0,0 +1,57 @@
>> +/*
>> + * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _DMA_H_
>> +#define _DMA_H_
>> +
>> +#define QCE_AUTHIV_REGS_CNT		16
>> +#define QCE_AUTH_BYTECOUNT_REGS_CNT	4
>> +#define QCE_CNTRIV_REGS_CNT		4
>> +
>> +/* result dump format */
>> +struct qce_result_dump {
>> +	u32 auth_iv[QCE_AUTHIV_REGS_CNT];
>> +	u32 auth_byte_count[QCE_AUTH_BYTECOUNT_REGS_CNT];
>> +	u32 encr_cntr_iv[QCE_CNTRIV_REGS_CNT];
>> +	u32 status;
>> +	u32 status2;
>> +};
>> +
>> +#define QCE_IGNORE_BUF_SZ	(2 * QCE_BAM_BURST_SIZE)
> 
> QCE_BAM_BURST_SIZE is defined in common.h in 6/9.  Either that file
> needs to be included from this one, or the definition needs to be moved.

I decided to not include any files in driver private headers. Thus I
include the private header files in relevant c files in order.

-- 
regards,
Stan
