Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaGWERj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:17:39 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35929 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751207AbaGWERi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:17:38 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33664185"
Message-ID: <53CF3486.7030902@cn.fujitsu.com>
Date: Wed, 23 Jul 2014 12:05:26 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: <bcrl@kvack.org>, <axboe@kernel.dk>, <akpm@linux-foundation.org>,
        <linux-aio@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] aio: use iovec array rather than the single one
References: <1405996804-8262-1-git-send-email-guz.fnst@cn.fujitsu.com> <1405996804-8262-4-git-send-email-guz.fnst@cn.fujitsu.com> <x494my94dyj.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x494my94dyj.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
On 07/22/2014 11:20 PM, Jeff Moyer wrote:

> Gu Zheng <guz.fnst@cn.fujitsu.com> writes:
> 
>> use an iovec array rather than the single one, so that we can avoid
>> to alloc more iovecs buffer in small(< 8) PREADV/PWRITEV cases.
> 
> I did some basic functional testing of this change and the change in
> patch 1/4.  That testing included using aio-stress to drive queue depths
> of 7, 8 and 9, and verify that it didn't fall over.  I also ran xfstests
> './check -g aio', and libaio's 'make partcheck'.

> 
> The change looks good to me, and passed testing, so:
> 
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Thanks for your review and test.

> 
> However, I still would like some comment on the reasoning behind it, and
> whether there is some measurable performance advantage for some
> workload.  Additionally, it would be nice if that comment made its way
> into the commit message.

I'll add more useful info, and send it out later.

Thanks,
Gu

> 
> Cheers,
> Jeff
> 
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/aio.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 0cd0479..ef21efe 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -1260,12 +1260,12 @@ static ssize_t aio_setup_vectored_rw(struct kiocb *kiocb,
>>  	if (compat)
>>  		ret = compat_rw_copy_check_uvector(rw,
>>  				(struct compat_iovec __user *)buf,
>> -				*nr_segs, 1, *iovec, iovec);
>> +				*nr_segs, UIO_FASTIOV, *iovec, iovec);
>>  	else
>>  #endif
>>  		ret = rw_copy_check_uvector(rw,
>>  				(struct iovec __user *)buf,
>> -				*nr_segs, 1, *iovec, iovec);
>> +				*nr_segs, UIO_FASTIOV, *iovec, iovec);
>>  	if (ret < 0)
>>  		return ret;
>>  
>> @@ -1302,7 +1302,7 @@ static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
>>  	fmode_t mode;
>>  	aio_rw_op *rw_op;
>>  	rw_iter_op *iter_op;
>> -	struct iovec inline_vec, *iovec = &inline_vec;
>> +	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>>  	struct iov_iter iter;
>>  
>>  	switch (opcode) {
>> @@ -1337,7 +1337,7 @@ rw_common:
>>  		if (!ret)
>>  			ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
>>  		if (ret < 0) {
>> -			if (iovec != &inline_vec)
>> +			if (iovec != inline_vecs)
>>  				kfree(iovec);
>>  			return ret;
>>  		}
>> @@ -1384,7 +1384,7 @@ rw_common:
>>  		return -EINVAL;
>>  	}
>>  
>> -	if (iovec != &inline_vec)
>> +	if (iovec != inline_vecs)
>>  		kfree(iovec);
>>  
>>  	if (ret != -EIOCBQUEUED) {
> .
> 


