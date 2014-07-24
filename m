Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbaGXB2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 21:28:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:26506 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934051AbaGXB2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 21:28:13 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33706774"
Message-ID: <53D05E4B.2050305@cn.fujitsu.com>
Date: Thu, 24 Jul 2014 09:15:55 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: <bcrl@kvack.org>, <axboe@kernel.dk>, <akpm@linux-foundation.org>,
        <linux-aio@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH 4/4] aio: use iovec array rather than the single
 one
References: <1406109834-4414-1-git-send-email-guz.fnst@cn.fujitsu.com> <1406109834-4414-4-git-send-email-guz.fnst@cn.fujitsu.com> <x497g34w6je.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497g34w6je.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
On 07/23/2014 09:25 PM, Jeff Moyer wrote:

> Gu Zheng <guz.fnst@cn.fujitsu.com> writes:
> 
>> Previously, we only offer a single iovec to handle all the read/write cases, so
>> the PREADV/PWRITEV request always need to alloc more iovec buffer when copying
>> user vectors.
>> If we use a tmp iovec array rather than the single one, some small PREADV/PWRITEV
>> workloads(vector size small than the tmp buffer) will not need to alloc more
>> iovec buffer when copying user vectors.
> 
> Hi, Gu,
> 
> This still doesn't explain why you decided to look into this.

The comment is clear, just want to avoid some needless memory allocation in
the io submit path.

> Did you
> notice a performance issue in this path?  Do you have benchmarks that
> show some speedup due to this change?

Just some common tests based on fio, it gains a slight improvement(~3%) when the
iodepth in [5,6,7] than before. I did not paste these info here, because I think
other guys(especially the guys have production environment) who are interested
in this can give us more meaningful feedback.

Thanks,
Gu

> 
> Thanks,
> Jeff
> 
>>
>> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/aio.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index f1fede2..df3491a 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -1267,12 +1267,12 @@ static ssize_t aio_setup_vectored_rw(struct kiocb *kiocb,
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
>> @@ -1309,7 +1309,7 @@ static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
>>  	fmode_t mode;
>>  	aio_rw_op *rw_op;
>>  	rw_iter_op *iter_op;
>> -	struct iovec inline_vec, *iovec = &inline_vec;
>> +	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>>  	struct iov_iter iter;
>>  
>>  	switch (opcode) {
>> @@ -1344,7 +1344,7 @@ rw_common:
>>  		if (!ret)
>>  			ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
>>  		if (ret < 0) {
>> -			if (iovec != &inline_vec)
>> +			if (iovec != inline_vecs)
>>  				kfree(iovec);
>>  			return ret;
>>  		}
>> @@ -1391,7 +1391,7 @@ rw_common:
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


