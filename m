Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3DWE3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:29:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:53813 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab3DWE3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:29:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,531,1363158000"; 
   d="scan'208";a="323335758"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] mei: fix krealloc() misuse in in
 mei_cl_irq_read_msg()
Thread-Topic: [PATCH -next] mei: fix krealloc() misuse in in
 mei_cl_irq_read_msg()
Thread-Index: AQHOP80I7NtMzU4p6kuINeLHL3c5VJjjNccg
Date: Tue, 23 Apr 2013 04:29:09 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01F036A6@HASMSX106.ger.corp.intel.com>
References: <CAPgLHd9_yV2V06XgyevDoHUOTMJ-htiJG3m5y4rqE21mC4+SZA@mail.gmail.com>
In-Reply-To: <CAPgLHd9_yV2V06XgyevDoHUOTMJ-htiJG3m5y4rqE21mC4+SZA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> If krealloc() returns NULL, it doesn't free the original. So any code of the form
> 'foo = krealloc(foo, ...);' is almost certainly a bug.
> 
> Introduced by commit fcb136e1ac5774909e0d85189f721b8dfa800e0f(mei: fix
> reading large reposnes)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Thanks, strange that my checkpatch didn't shout on that. 
I don't like the unrelated reuse of the  buffer variable but the code looks correct so ACK.

Thanks
Tomas

> ---
>  drivers/misc/mei/interrupt.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c index
> 37a8c35..089c516 100644
> --- a/drivers/misc/mei/interrupt.c
> +++ b/drivers/misc/mei/interrupt.c
> @@ -148,16 +148,16 @@ static int mei_cl_irq_read_msg(struct mei_device
> *dev,
>  			dev_dbg(&dev->pdev->dev, "message overflow.
> size %d len %d idx %ld\n",
>  				cb->response_buffer.size,
>  				mei_hdr->length, cb->buf_idx);
> -			cb->response_buffer.data =
> -					krealloc(cb->response_buffer.data,
> -					mei_hdr->length + cb->buf_idx,
> -					GFP_KERNEL);
> +			buffer = krealloc(cb->response_buffer.data,
> +					  mei_hdr->length + cb->buf_idx,
> +					  GFP_KERNEL);
> 
> -			if (!cb->response_buffer.data) {
> +			if (!buffer) {
>  				dev_err(&dev->pdev->dev, "allocation
> failed.\n");
>  				list_del(&cb->list);
>  				return -ENOMEM;
>  			}
> +			cb->response_buffer.data = buffer;
>  			cb->response_buffer.size =
>  				mei_hdr->length + cb->buf_idx;
>  		}

