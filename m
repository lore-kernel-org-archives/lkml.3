Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbbA0XrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:47:05 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758445AbbA0XrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:47:04 -0500
Message-ID: <54C82373.9070606@nod.at>
Date: Wed, 28 Jan 2015 00:46:59 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>, dedekind1@gmail.com
CC: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] UBI: Add initial support for scatter gather
References: <1420926734-16417-1-git-send-email-richard@nod.at> <54C820F9.6060602@vanguardiasur.com.ar>
In-Reply-To: <54C820F9.6060602@vanguardiasur.com.ar>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.01.2015 um 00:36 schrieb Ezequiel Garcia:
> On 01/10/2015 06:52 PM, Richard Weinberger wrote:
>> Adds a new set of functions to deal with scatter gather.
>> ubi_eba_read_leb_sg() will read from a LEB into a scatter gather list.
>> The new data structure struct ubi_sgl will be used within UBI to
>> hold the scatter gather list itself and metadata to have a cursor
>> within the list.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> Tested-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> 
> Three nitpicks below, and my
> 
> Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> 
>> ---
>>  drivers/mtd/ubi/eba.c   | 56 +++++++++++++++++++++++++++++
>>  drivers/mtd/ubi/kapi.c  | 95 +++++++++++++++++++++++++++++++++++++++++--------
>>  drivers/mtd/ubi/ubi.h   |  3 ++
>>  include/linux/mtd/ubi.h | 46 ++++++++++++++++++++++++
>>  4 files changed, 185 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
>> index b698534..0aaf707 100644
>> --- a/drivers/mtd/ubi/eba.c
>> +++ b/drivers/mtd/ubi/eba.c
>> @@ -481,6 +481,62 @@ out_unlock:
>>  }
>>  
>>  /**
>> + * ubi_eba_read_leb_sg - read data into a scatter gather list.
>> + * @ubi: UBI device description object
>> + * @vol: volume description object
>> + * @lnum: logical eraseblock number
>> + * @sgl: UBI scatter gather list to store the read data
>> + * @offset: offset from where to read
>> + * @len: how many bytes to read
>> + * @check: data CRC check flag
>> + *
>> + * This function works exactly like ubi_eba_read_leb(). But instead of
>> + * storing the read data into a buffer it writes to an UBI scatter gather
>> + * list.
>> + */
>> +int ubi_eba_read_leb_sg(struct ubi_device *ubi, struct ubi_volume *vol,
>> +			struct ubi_sgl *sgl, int lnum, int offset, int len,
>> +			int check)
>> +{
>> +	int to_read;
>> +	int ret;
>> +	struct scatterlist *sg;
>> +
>> +	for (;;) {
>> +		ubi_assert(sgl->list_pos < UBI_MAX_SG_COUNT);
>> +		sg = &sgl->sg[sgl->list_pos];
>> +		if (len < sg->length - sgl->page_pos)
>> +			to_read = len;
>> +		else
>> +			to_read = sg->length - sgl->page_pos;
>> +
>> +		ret = ubi_eba_read_leb(ubi, vol, lnum,
>> +				       sg_virt(sg) + sgl->page_pos, offset,
>> +				       to_read, check);
>> +		if (ret < 0)
>> +			goto out;
> 
> Matter of taste, but isn't it better to just return here?

After dealing with a lot of nasty bugs in error paths in other projects I've started
using the principle of a single function exit path.
But in this case a "return ret;" is also perfectly fine as the "out" label does no cleanup.

Will fix before pushing.

>> +
>> +		offset += to_read;
>> +		len -= to_read;
>> +		if (!len) {
>> +			sgl->page_pos += to_read;
>> +			if (sgl->page_pos == sg->length) {
>> +				sgl->list_pos++;
>> +				sgl->page_pos = 0;
>> +			}
>> +
>> +			break;
>> +		}
>> +
>> +		sgl->list_pos++;
>> +		sgl->page_pos = 0;
>> +	}
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +/**
>>   * recover_peb - recover from write failure.
>>   * @ubi: UBI device description object
>>   * @pnum: the physical eraseblock to recover
>> diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
>> index f3bab66..d0055a2 100644
>> --- a/drivers/mtd/ubi/kapi.c
>> +++ b/drivers/mtd/ubi/kapi.c
>> @@ -355,6 +355,43 @@ void ubi_close_volume(struct ubi_volume_desc *desc)
>>  EXPORT_SYMBOL_GPL(ubi_close_volume);
>>  
>>  /**
>> + * leb_read_sanity_check - does sanity checks on read requests.
>> + * @desc: volume descriptor
>> + * @lnum: logical eraseblock number to read from
>> + * @offset: offset within the logical eraseblock to read from
>> + * @len: how many bytes to read
>> + *
>> + * This function is used by ubi_leb_read() and ubi_leb_read_sg()
>> + * to perfrom sanity checks.
> 
> s/perfrom/perform

Thx.

> 
>> + */
>> +static int leb_read_sanity_check(struct ubi_volume_desc *desc, int lnum,
>> +				 int offset, int len)
>> +{
>> +	struct ubi_volume *vol = desc->vol;
>> +	struct ubi_device *ubi = vol->ubi;
>> +	int vol_id = vol->vol_id;
>> +
>> +	if (vol_id < 0 || vol_id >= ubi->vtbl_slots || lnum < 0 ||
>> +	    lnum >= vol->used_ebs || offset < 0 || len < 0 ||
>> +	    offset + len > vol->usable_leb_size)
>> +		return -EINVAL;
>> +
>> +	if (vol->vol_type == UBI_STATIC_VOLUME) {
>> +		if (vol->used_ebs == 0)
>> +			/* Empty static UBI volume */
>> +			return 0;
>> +		if (lnum == vol->used_ebs - 1 &&
>> +		    offset + len > vol->last_eb_bytes)
>> +			return -EINVAL;
>> +	}
>> +
>> +	if (vol->upd_marker)
>> +		return -EBADF;
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>>   * ubi_leb_read - read data.
>>   * @desc: volume descriptor
>>   * @lnum: logical eraseblock number to read from
>> @@ -390,22 +427,10 @@ int ubi_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
>>  
>>  	dbg_gen("read %d bytes from LEB %d:%d:%d", len, vol_id, lnum, offset);
>>  
>> -	if (vol_id < 0 || vol_id >= ubi->vtbl_slots || lnum < 0 ||
>> -	    lnum >= vol->used_ebs || offset < 0 || len < 0 ||
>> -	    offset + len > vol->usable_leb_size)
>> -		return -EINVAL;
>> -
>> -	if (vol->vol_type == UBI_STATIC_VOLUME) {
>> -		if (vol->used_ebs == 0)
>> -			/* Empty static UBI volume */
>> -			return 0;
>> -		if (lnum == vol->used_ebs - 1 &&
>> -		    offset + len > vol->last_eb_bytes)
>> -			return -EINVAL;
>> -	}
>> +	err = leb_read_sanity_check(desc, lnum, offset, len);
>> +	if (err < 0)
>> +		return err;
>>  
>> -	if (vol->upd_marker)
>> -		return -EBADF;
>>  	if (len == 0)
>>  		return 0;
>>  
>> @@ -419,6 +444,46 @@ int ubi_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
>>  }
>>  EXPORT_SYMBOL_GPL(ubi_leb_read);
>>  
>> +
>> +/**
>> + * ubi_leb_read_sg - read data into a scatter gather list.
>> + * @desc: volume descriptor
>> + * @lnum: logical eraseblock number to read from
>> + * @buf: buffer where to store the read data
>> + * @offset: offset within the logical eraseblock to read from
>> + * @len: how many bytes to read
>> + * @check: whether UBI has to check the read data's CRC or not.
>> + *
>> + * This function works exactly like ubi_leb_read_sg(). But instead of
>> + * storing the read data into a buffer it writes to an UBI scatter gather
>> + * list.
>> + */
>> +int ubi_leb_read_sg(struct ubi_volume_desc *desc, int lnum, struct ubi_sgl *sgl,
>> +		    int offset, int len, int check)
>> +{
>> +	struct ubi_volume *vol = desc->vol;
>> +	struct ubi_device *ubi = vol->ubi;
>> +	int err, vol_id = vol->vol_id;
>> +
>> +	dbg_gen("read %d bytes from LEB %d:%d:%d", len, vol_id, lnum, offset);
>> +
>> +	err = leb_read_sanity_check(desc, lnum, offset, len);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	if (len == 0)
>> +		return 0;
>> +
>> +	err = ubi_eba_read_leb_sg(ubi, vol, sgl, lnum, offset, len, check);
>> +	if (err && mtd_is_eccerr(err) && vol->vol_type == UBI_STATIC_VOLUME) {
>> +		ubi_warn(ubi, "mark volume %d as corrupted", vol_id);
>> +		vol->corrupted = 1;
>> +	}
>> +
>> +	return err;
>> +}
>> +EXPORT_SYMBOL_GPL(ubi_leb_read_sg);
>> +
>>  /**
>>   * ubi_leb_write - write data.
>>   * @desc: volume descriptor
>> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
>> index ee7ac0b..a5283cf 100644
>> --- a/drivers/mtd/ubi/ubi.h
>> +++ b/drivers/mtd/ubi/ubi.h
>> @@ -791,6 +791,9 @@ int ubi_eba_unmap_leb(struct ubi_device *ubi, struct ubi_volume *vol,
>>  		      int lnum);
>>  int ubi_eba_read_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
>>  		     void *buf, int offset, int len, int check);
>> +int ubi_eba_read_leb_sg(struct ubi_device *ubi, struct ubi_volume *vol,
>> +			struct ubi_sgl *sgl, int lnum, int offset, int len,
>> +			int check);
>>  int ubi_eba_write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
>>  		      const void *buf, int offset, int len);
>>  int ubi_eba_write_leb_st(struct ubi_device *ubi, struct ubi_volume *vol,
>> diff --git a/include/linux/mtd/ubi.h b/include/linux/mtd/ubi.h
>> index c3918a0..3d5916d 100644
>> --- a/include/linux/mtd/ubi.h
>> +++ b/include/linux/mtd/ubi.h
>> @@ -23,11 +23,16 @@
>>  
>>  #include <linux/ioctl.h>
>>  #include <linux/types.h>
>> +#include <linux/scatterlist.h>
>>  #include <mtd/ubi-user.h>
>>  
>>  /* All voumes/LEBs */
>>  #define UBI_ALL -1
>>  
>> +/* Maximum number of scatter gather list entries,
>> + * we use only 64 to have a lower memory foot print. */
> 
> Multilines comments style is:
> 
> /*
>  *
>  */

Correct. I wonder why checkpatch.pl did not bark on that.

Thanks,
//richard
