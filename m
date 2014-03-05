Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaCEIum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:50:42 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35714 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaCEIuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:50:40 -0500
Date: Wed, 05 Mar 2014 09:50:35 +0100
From: Christian Riesch <christian.riesch@omicron.at>
To: Brian Norris <computersforpeace@gmail.com>
cc: Amul Kumar Saha <amul.saha@samsung.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 2/2] mtd: Fix the behavior of otp write if
 there is not enough room for data
Message-ID: <E7B001C441C40FC980CFBA5E@[172.22.2.41]>
In-Reply-To: <20140305072010.GL13420@norris-Latitude-E6410>
References: <1390897785-991-1-git-send-email-christian.riesch@omicron.at>
 <b8fb0b78-04b2-41bf-a1f4-6f54039b7829@mary.at.omicron.at>
 <20140305072010.GL13420@norris-Latitude-E6410>
X-Mailer: Mulberry/4.0.8 (Win32)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,
Thank you very much for your comments on the patch!

--On March 04, 2014 23:20 -0800 Brian Norris <computersforpeace@gmail.com> 
wrote:

> Hi Christian,
>
> A few comments below.
>
> On Tue, Jan 28, 2014 at 09:29:45AM +0100, Christian Riesch wrote:
>> An OTP write shall write as much data as possible to the OTP memory
>> and return the number of bytes that have actually been written.
>> If no data could be written at all due to lack of OTP memory,
>> return -ENOSPC.
>>
>> Signed-off-by: Christian Riesch <christian.riesch@omicron.at>
>> Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Amul Kumar Saha <amul.saha@samsung.com>
>> ---
>>  drivers/mtd/chips/cfi_cmdset_0001.c |   13 +++++++++++--
>>  drivers/mtd/devices/mtd_dataflash.c |   13 +++++--------
>>  drivers/mtd/mtdchar.c               |    7 +++++++
>>  drivers/mtd/onenand/onenand_base.c  |   10 +++++++++-
>>  4 files changed, 32 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c
>> b/drivers/mtd/chips/cfi_cmdset_0001.c index 7aa581f..cf423a6 100644
>> --- a/drivers/mtd/chips/cfi_cmdset_0001.c
>> +++ b/drivers/mtd/chips/cfi_cmdset_0001.c
>> @@ -2387,8 +2387,17 @@ static int
>> cfi_intelext_write_user_prot_reg(struct mtd_info *mtd, loff_t from,
>>  					    size_t len, size_t *retlen,
>>  					     u_char *buf)
>>  {
>> -	return cfi_intelext_otp_walk(mtd, from, len, retlen,
>> -				     buf, do_otp_write, 1);
>> +	int ret;
>> +
>> +	ret = cfi_intelext_otp_walk(mtd, from, len, retlen,
>> +				    buf, do_otp_write, 1);
>> +
>> +	/* if no data could be written due to lack of OTP memory,
>> +	   return ENOSPC */
>
> /*
>  * Can you use this style of mult-line comments please?
>  * It's in Documentation/CodingStyle
>  */
>

Ok, I will change that.

>> +	if (!ret && len && !(*retlen))
>> +		return -ENOSPC;
>
> Couldn't (shouldn't) this check be pushed to the common
> mtd_write_user_prot_reg() helper in mtdcore.c?

Yes, I don't see why this wouldn't work. But I thought the code would be 
easier to understand if we return the correct error code as soon as the 
error is detected, not using some additional logic in some other function. 
What do you think?

> And once you do that, you
> will see that cfi_intelext_write_user_prot_reg() (and other
> mtd->_write_user_prot_reg() implementations) will never be called with
> len == 0. So this just becomes (in mtdcore.c):
>
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 0a7d77e65335..ee6730748f7e 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -909,11 +909,16 @@ EXPORT_SYMBOL_GPL(mtd_read_fact_prot_reg);
>  int mtd_get_user_prot_info(struct mtd_info *mtd, size_t len, size_t
> *retlen,  			   struct otp_info *buf)
>  {
> +	int ret;
> +
>  	if (!mtd->_get_user_prot_info)
>  		return -EOPNOTSUPP;
>  	if (!len)
>  		return 0;
> -	return mtd->_get_user_prot_info(mtd, len, retlen, buf);
> +	ret = mtd->_get_user_prot_info(mtd, len, retlen, buf);
> +	if (ret)
> +		return ret;
> +	return !(*retlen) ? -ENOSPC: 0;
>  }
>  EXPORT_SYMBOL_GPL(mtd_get_user_prot_info);
>
>
>> +
>> +	return ret;
>>  }
>>
>>  static int cfi_intelext_lock_user_prot_reg(struct mtd_info *mtd,
>> diff --git a/drivers/mtd/devices/mtd_dataflash.c
>> b/drivers/mtd/devices/mtd_dataflash.c index 09c69ce..5236d85 100644
>> --- a/drivers/mtd/devices/mtd_dataflash.c
>> +++ b/drivers/mtd/devices/mtd_dataflash.c
>> @@ -545,14 +545,11 @@ static int dataflash_write_user_otp(struct
>> mtd_info *mtd, struct dataflash	*priv = mtd->priv;
>>  	int			status;
>>
>
> I'm not sure I quite follow the logic for the following hunk. I think it
> deserves some more explanation, either in your commit or in a comment.
> As it stands, you're deleting a comment and potentially changing the
> return code behavior subtly.
>
>> -	if (len > 64)
>> -		return -EINVAL;
>> -
>> -	/* Strictly speaking, we *could* truncate the write ... but
>> -	 * let's not do that for the only write that's ever possible.
>> -	 */
>> -	if ((from + len) > 64)
>> -		return -EINVAL;
>> +	if ((from + len) > 64) {
>> +		len = 64 - from;
>
> Why are you reassigning len? Are you trying to undo the comment above,
> so that you *can* truncate the write? (It looks like there are other
> implmentations which will truncate the write and return -ENOSPC, FWIW.)

Currently we have two kind of implementations: We have implementations like 
this one which will refuse to write any data if the write requests more 
data to be written than space is available. And we have implementations 
like cfi_intelext_write_user_prot_reg that will truncate the write and 
write as much data that is possible (and return the number of bytes that 
actually have been written, -ENOSPC shall only be returned if no data could 
be written at all).

For a harmonization one of the implementations and their behavior must be 
changed. I chose to change it to "write as much as possible/truncate the 
write" since this is how a write should behave 
(http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html). And 
yes, this is why I try to undo the comment.

But if you are afraid that this will break things for current users of the 
functions, I would keep the old behavior. What do you think?

>
>> +		if (len <= 0)
>> +			return -ENOSPC;
>> +	}
>>
>>  	/* OUT: OP_WRITE_SECURITY, 3 zeroes, 64 data-or-zero bytes
>>  	 * IN:  ignore all
>> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
>> index 0edb0ca..db99031 100644
>> --- a/drivers/mtd/mtdchar.c
>> +++ b/drivers/mtd/mtdchar.c
>> @@ -323,6 +323,13 @@ static ssize_t mtdchar_write(struct file *file,
>> const char __user *buf, size_t c default:
>>  			ret = mtd_write(mtd, *ppos, len, &retlen, kbuf);
>>  		}
>> +		/* return -ENOSPC only if no data was written */
>> +		if ((ret == -ENOSPC) && (total_retlen)) {
>> +			ret = 0;
>> +			retlen = 0;
>> +			/* drop the remaining data */
>> +			count = 0;
>
> This block can just be a 'break' statement, no?

No. mtdchar_write may split the write into several calls of mtd_write, 
mtd_write_user_prot_reg... It will call mtd_write, mtd_write_user_prot_reg 
as long as there is data to be written. If the write hits the boundary of 
the memory, the last call of mtd_write_user_prot_reg will return -ENOSPC. 
If this was the only call of mtd_write_user_prot_reg (so no data could be 
written at all), returning -ENOSPC to the user is fine. However, if data 
has been written before, we must not return -ENOSPC, we must return the 
number of bytes that have actually been written.

So at least it must be

if ((ret == -ENOSPC) && (total_retlen)) {
	ret = 0;
	break;
}

Which one do you prefer?

>
>> +		}
>
> I'm a bit wary of changing the behavior of non-OTP writes. At a minimum,
> the patch description needs to acknowledge that this affects more than
> just OTP writes. But after a cursory review of mtd->_write()
> implementations, it looks like there's no driver which could be
> returning -ENOSPC already, so this change is probably OK.

The behavior of non-OTP writes is not changed at all. At the begin of 
mtdchar_write, a check against mtd->size is done, and the write is 
truncated. Therefore, non-OTP writes will never hit the end of memory in 
the write function.

Regards, Christian

>
>>  		if (!ret) {
>>  			*ppos += retlen;
>>  			total_retlen += retlen;
>> diff --git a/drivers/mtd/onenand/onenand_base.c
>> b/drivers/mtd/onenand/onenand_base.c index 419c538..6c49a6f 100644
>> --- a/drivers/mtd/onenand/onenand_base.c
>> +++ b/drivers/mtd/onenand/onenand_base.c
>> @@ -3316,7 +3316,15 @@ static int onenand_read_user_prot_reg(struct
>> mtd_info *mtd, loff_t from, static int
>>  onenand_write_user_prot_reg(struct mtd_info *mtd, loff_t from, size_t
>>  			len, size_t *retlen, u_char *buf)
>>  {
>> -	return onenand_otp_walk(mtd, from, len, retlen, buf, do_otp_write,
>> MTD_OTP_USER); +	int ret;
>> +	ret = onenand_otp_walk(mtd, from, len, retlen, buf, do_otp_write,
>> MTD_OTP_USER); +
>> +	/* if no data could be written due to lack of OTP memory,
>> +	   return ENOSPC */
>> +	if (!ret && len && !(*retlen))
>> +		return -ENOSPC;
>
> Same comments from cfi_intelext_write_user_prot_reg(), so I think this
> change can be dropped. (And again, 'len' never will be 0.)
>
>> +
>> +	return ret;
>>  }
>>
>>  /**
>
> Brian
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/




