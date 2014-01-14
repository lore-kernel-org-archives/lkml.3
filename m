Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaANM2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:28:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaANM2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:28:21 -0500
Message-ID: <52D52D30.6040508@redhat.com>
Date: Tue, 14 Jan 2014 13:27:28 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] zram: do not pass rw argument to __zram_make_request()
References: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com> <1389692260-4421-3-git-send-email-sergey.senozhatsky@gmail.com> <52D5195A.3040001@redhat.com> <20140114111311.GD2180@swordfish.minsk.epam.com>
In-Reply-To: <20140114111311.GD2180@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 12:13 PM, Sergey Senozhatsky wrote:
> On (01/14/14 12:02), Jerome Marchand wrote:
>>>  static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
>>> -			int offset, struct bio *bio, int rw)
>>> +			int offset, struct bio *bio)
>>>  {
>>>  	int ret;
>>> +	int rw = bio_data_dir(bio);
>>>  
>>> -	if (rw == READ)
>>> +	if (rw == READA)
>>> +		rw = READ;
>>
>> This could never happen: bio_data_dir() can only return READ or WRITE.
>>
> 
> thanks. my bad. will replace with bio_rw().

There is no point in doing that. In read-ahead case, bio_data_dir()
already returns READ. Since we don't do anything special in read-ahead
case, just keep bio_data_dir() and drop this test.

> 
> 	-ss
> 
>> Jerome
>>
>>> +
>>> +	if (rw == READ) {
>>> +		atomic64_inc(&zram->stats.num_reads);
>>>  		ret = zram_bvec_read(zram, bvec, index, offset, bio);
>>> -	else
>>> +	} else {
>>> +		atomic64_inc(&zram->stats.num_writes);
>>>  		ret = zram_bvec_write(zram, bvec, index, offset);
>>> +	}
>>>  
>>>  	return ret;
>>>  }
>>> @@ -670,22 +677,13 @@ out:
>>>  	return ret;
>>>  }
>>>  
>>> -static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
>>> +static void __zram_make_request(struct zram *zram, struct bio *bio)
>>>  {
>>>  	int offset;
>>>  	u32 index;
>>>  	struct bio_vec bvec;
>>>  	struct bvec_iter iter;
>>>  
>>> -	switch (rw) {
>>> -	case READ:
>>> -		atomic64_inc(&zram->stats.num_reads);
>>> -		break;
>>> -	case WRITE:
>>> -		atomic64_inc(&zram->stats.num_writes);
>>> -		break;
>>> -	}
>>> -
>>>  	index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
>>>  	offset = (bio->bi_iter.bi_sector &
>>>  		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
>>> @@ -704,16 +702,15 @@ static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
>>>  			bv.bv_len = max_transfer_size;
>>>  			bv.bv_offset = bvec.bv_offset;
>>>  
>>> -			if (zram_bvec_rw(zram, &bv, index, offset, bio, rw) < 0)
>>> +			if (zram_bvec_rw(zram, &bv, index, offset, bio) < 0)
>>>  				goto out;
>>>  
>>>  			bv.bv_len = bvec.bv_len - max_transfer_size;
>>>  			bv.bv_offset += max_transfer_size;
>>> -			if (zram_bvec_rw(zram, &bv, index+1, 0, bio, rw) < 0)
>>> +			if (zram_bvec_rw(zram, &bv, index + 1, 0, bio) < 0)
>>>  				goto out;
>>>  		} else
>>> -			if (zram_bvec_rw(zram, &bvec, index, offset, bio, rw)
>>> -			    < 0)
>>> +			if (zram_bvec_rw(zram, &bvec, index, offset, bio) < 0)
>>>  				goto out;
>>>  
>>>  		update_position(&index, &offset, &bvec);
>>> @@ -743,7 +740,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
>>>  		goto error;
>>>  	}
>>>  
>>> -	__zram_make_request(zram, bio, bio_data_dir(bio));
>>> +	__zram_make_request(zram, bio);
>>>  	up_read(&zram->init_lock);
>>>  
>>>  	return;
>>>
>>

