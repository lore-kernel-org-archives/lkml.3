Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab3HSLTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:19:25 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:10290 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3HSLTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:19:24 -0400
Message-ID: <5211FEE9.5000300@nsn.com>
Date: Mon, 19 Aug 2013 13:18:01 +0200
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ionut Nicu <ioan.nicu.ext@nsn.com>, linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Fwd: Re: [PATCH 1/3] regmap: flat: use the cache_present bitmap
References: <52052401.7030707@nsn.com> <5211D68C.1070608@nsn.com>
In-Reply-To: <5211D68C.1070608@nsn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 5635
X-purgate-ID: 151667::1376911084-0000471E-EF42983A/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On 08/19/2013 10:25 AM, Ionut Nicu wrote:
> -------- Original Message --------
> Subject: Re: [PATCH 1/3] regmap: flat: use the cache_present bitmap
> Date: Fri, 09 Aug 2013 19:16:49 +0200
> From: Ionut Nicu <ioan.nicu.ext@nsn.com>
> To: ext Mark Brown <broonie@kernel.org>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  linux-kernel@vger.kernel.org
> 
> On 09.08.2013 13:44, ext Mark Brown wrote:
>> On Fri, Aug 09, 2013 at 12:09:11PM +0200, Ionut Nicu wrote:
>>> As opposed to the other regmap cache implementations,
>>> regcache_flat didn't use the cache_present bitmap for
>>> figuring out whether a register was cached or not, nor
>>> did it mark a register as present in the cache when
>>> regcache_flat_write() was called.
>>
>>> This caused incorrect behaviour, such as returning
>>> value 0 for non-volatile registers without first reading
>>> their value from the device and storing it in the cache.
>>
>> The goal with the flat cache is to do as little work as possible for
>> things like memory mapped devices where the cache operations are
>> actually noticable in comparison with the I/O costs.  I would therefore
>> exapect that anything using the flat cache would want to ensure that the
>> cache is fully populated at init time, reading back from the device if
>> nothing else (by setting num_reg_defaults_raw but not providing values),
>> rather than do additional operations in the data path.
>>
> 
> Ok, I get your point. I've tried using this approach, but the thing is
> that I have a device which supports only single rw operations. The
> regcache_hw_init() function calls regmap_raw_read which in turn calls
> _regmap_raw_read() when cache_bypass is enabled. But _regmap_raw_read()
> doesn't take the use_single_rw flag into account and tries to read
> num_reg_defaults_raw registers in a single bus transfer. Unfortunately
> this doesn't work with my device. 
> 
> I thought about changing regcache_hw_init() to check for this flag in
> the same way regmap_bulk_read() does, but I think this is pretty ugly.
> 
> What do you think about moving the check to use_single_rw inside
> _regmap_raw_read(), right where the bus accesses are done?
> 
> Something like in the following patch:

Acked-by: Alexander Sverdlin <alexander.sverdlin@nsn.com>

> 
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 42b45ac..de7f353 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -1486,14 +1486,16 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
>  {
>  	struct regmap_range_node *range;
>  	u8 *u8 = map->work_buf;
> -	int ret;
> +	size_t val_bytes = map->format.val_bytes;
> +	size_t reg_size = map->format.reg_bytes + map->format.pad_bytes;
> +	int ret, i;
>  
>  	WARN_ON(!map->bus);
>  
>  	range = _regmap_range_lookup(map, reg);
>  	if (range) {
>  		ret = _regmap_select_page(map, &reg, range,
> -					  val_len / map->format.val_bytes);
> +					  val_len / val_bytes);
>  		if (ret != 0)
>  			return ret;
>  	}
> @@ -1508,15 +1510,41 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
>  	 */
>  	u8[0] |= map->read_flag_mask;
>  
> -	trace_regmap_hw_read_start(map->dev, reg,
> -				   val_len / map->format.val_bytes);
> +	/*
> +	 * Some devices does not support bulk read, for
> +	 * them we have a series of single read operations.
> +	 */
> +	if (map->use_single_rw) {
> +		for (i = 0; i < val_len; i++) {
> +			trace_regmap_hw_read_start(map->dev,
> +					reg + (i * map->reg_stride), 1);
> +
> +			map->format.format_reg(map->work_buf,
> +					reg + (i *  map->reg_stride),
> +					map->reg_shift);
> +			u8[0] |= map->read_flag_mask;
> +
> +			ret = map->bus->read(map->bus_context,
> +					map->work_buf,
> +					reg_size,
> +					val + (i * val_bytes),
> +					val_bytes);
> +			if (ret != 0)
> +				return ret;
>  
> -	ret = map->bus->read(map->bus_context, map->work_buf,
> -			     map->format.reg_bytes + map->format.pad_bytes,
> -			     val, val_len);
> +			trace_regmap_hw_read_done(map->dev,
> +					reg + (i * map->reg_stride), 1);
> +		}
> +	} else {
> +		trace_regmap_hw_read_start(map->dev, reg, val_len / val_bytes);
>  
> -	trace_regmap_hw_read_done(map->dev, reg,
> -				  val_len / map->format.val_bytes);
> +		ret = map->bus->read(map->bus_context, map->work_buf,
> +				reg_size, val, val_len);
> +		if (ret != 0)
> +			return ret;
> +
> +		trace_regmap_hw_read_done(map->dev, reg, val_len / val_bytes);
> +	}
>  
>  	return ret;
>  }
> @@ -1702,25 +1730,9 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
>  		return -EINVAL;
>  
>  	if (vol || map->cache_type == REGCACHE_NONE) {
> -		/*
> -		 * Some devices does not support bulk read, for
> -		 * them we have a series of single read operations.
> -		 */
> -		if (map->use_single_rw) {
> -			for (i = 0; i < val_count; i++) {
> -				ret = regmap_raw_read(map,
> -						reg + (i * map->reg_stride),
> -						val + (i * val_bytes),
> -						val_bytes);
> -				if (ret != 0)
> -					return ret;
> -			}
> -		} else {
> -			ret = regmap_raw_read(map, reg, val,
> -					      val_bytes * val_count);
> -			if (ret != 0)
> -				return ret;
> -		}
> +		ret = regmap_raw_read(map, reg, val, val_bytes * val_count);
> +		if (ret != 0)
> +			return ret;
>  
>  		for (i = 0; i < val_count * val_bytes; i += val_bytes)
>  			map->format.parse_inplace(val + i);
> 
> 
> 
> 
> 

-- 
Best regards,
Alexander Sverdlin.
