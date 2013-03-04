Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab3CDWRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:17:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:43956 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3CDWRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:17:16 -0500
Message-ID: <51351D88.7060100@infradead.org>
Date: Mon, 04 Mar 2013 14:17:44 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, dmdevel <dm-devel@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ejt@redhat.com
Subject: Re: linux-next: Tree for Mar 4 (dm-cache-target)
References: <20130304144358.bd62a57601d4d4793921213e@canb.auug.org.au> <5134EE05.30305@infradead.org> <20130304221207.GA12140@redhat.com>
In-Reply-To: <20130304221207.GA12140@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/13 14:12, Mike Snitzer wrote:
> On Mon, Mar 04 2013 at  1:55pm -0500,
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> On 03/03/13 19:43, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20130301:
>>>
>>> The device-mapper tree gained a conflict against Linus' tree.
>>>
>>
>>
>> on i386:
>>
>> drivers/built-in.o: In function `is_discarded_oblock':
>> dm-cache-target.c:(.text+0x1ea28e): undefined reference to `__udivdi3'
>> drivers/built-in.o: In function `remap_to_origin_clear_discard':
>> dm-cache-target.c:(.text+0x1ea3ac): undefined reference to `__udivdi3'
>> drivers/built-in.o: In function `remap_to_cache_dirty.part.21':
>> dm-cache-target.c:(.text+0x1ea48f): undefined reference to `__udivdi3'
>> drivers/built-in.o: In function `cache_ctr':
>> dm-cache-target.c:(.text+0x1eaa2b): undefined reference to `__udivdi3'
>> dm-cache-target.c:(.text+0x1eaa71): undefined reference to `__udivdi3'
>> drivers/built-in.o:dm-cache-target.c:(.text+0x1eac51): more undefined references to `__udivdi3' follow
>>
>>
>>
>> Full randconfig file is attached.
> 
> I was able to reproduce using your randconfig file.
> 
> This patch fixed the build for my v3.9-rc1 tree:

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 0f4e84b..96bfec1 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -415,7 +415,7 @@ static bool block_size_is_power_of_two(struct cache *cache)
>  static dm_dblock_t oblock_to_dblock(struct cache *cache, dm_oblock_t oblock)
>  {
>  	sector_t discard_blocks = cache->discard_block_size;
> -	dm_block_t b = from_oblock(oblock);
> +	sector_t b = from_oblock(oblock);
>  
>  	if (!block_size_is_power_of_two(cache))
>  		(void) sector_div(discard_blocks, cache->sectors_per_block);
> @@ -999,7 +999,7 @@ static void process_discard_bio(struct cache *cache, struct bio *bio)
>  {
>  	dm_block_t start_block = dm_sector_div_up(bio->bi_sector,
>  						  cache->discard_block_size);
> -	dm_block_t end_block = bio->bi_sector + bio_sectors(bio);
> +	sector_t end_block = bio->bi_sector + bio_sectors(bio);
>  	dm_block_t b;
>  
>  	(void) sector_div(end_block, cache->discard_block_size);
> @@ -1801,7 +1801,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
>  	char **error = &ca->ti->error;
>  	struct cache *cache;
>  	struct dm_target *ti = ca->ti;
> -	dm_block_t origin_blocks;
> +	sector_t origin_blocks;
>  	struct dm_cache_metadata *cmd;
>  	bool may_format = ca->features.mode == CM_WRITE;
>  
> @@ -1845,7 +1845,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
>  	}
>  
>  	if (ca->block_size & (ca->block_size - 1)) {
> -		dm_block_t cache_size = ca->cache_sectors;
> +		sector_t cache_size = ca->cache_sectors;
>  
>  		cache->sectors_per_block_shift = -1;
>  		(void) sector_div(cache_size, ca->block_size);
> 


-- 
~Randy
