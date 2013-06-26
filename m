Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3FZRVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:21:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab3FZRU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:20:59 -0400
Date: Wed, 26 Jun 2013 13:20:54 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Geremy Condra <gcondra@google.com>,
        device-mapper development <dm-devel@redhat.com>
cc: wad@chromium.org, linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v2] dm: verity: Add support for emitting
 uevents on dm-verity errors.
In-Reply-To: <1371783624-23962-1-git-send-email-gcondra@google.com>
Message-ID: <alpine.LRH.2.02.1306261304290.29719@file01.intranet.prod.int.rdu2.redhat.com>
References: <1371783624-23962-1-git-send-email-gcondra@google.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I think the idea is fine.

There is architecture problem - that target specific routines are being 
pushed into generic dm core.

I suggest that instead of dm_send_verity_uevent and dm_path_uevent you 
create just one generic function (for example dm_send_uevent) that takes 
variable argument list of target-specific uevent variables and that can be 
used for both multipath and verity. Something like: dm_send_uevent(ti, 
"DM_VERITY_BLOCK_NR=123", "DM_ACTION=VERITY_DATA_ERROR", NULL);

There is GFP_ATOMIC allocation and this type of allocation can fail 
anytime. Could it be a problem if uevent is lost? It's probably not a 
problem for dm-verity, because uevents are generated only in errorneous 
state ... but what about multipath? Can it misbehave if we lose uevent?

Mikulas


On Thu, 20 Jun 2013, Geremy Condra wrote:

> With this change dm-verity errors will cause uevents to be
> sent to userspace, notifying it that an error has occurred
> and potentially triggering recovery actions.
> 
> Signed-off-by: Geremy Condra <gcondra@google.com>
> ---
> Changelog since v1:
> - Removed the DM_VERITY_ERROR_NOTIFY config option
> 
>  drivers/md/dm-uevent.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-uevent.h | 12 ++++++++++--
>  drivers/md/dm-verity.c | 28 ++++++++++++++++++++++++++++
>  3 files changed, 78 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-uevent.c b/drivers/md/dm-uevent.c
> index 8efe033..17a6662 100644
> --- a/drivers/md/dm-uevent.c
> +++ b/drivers/md/dm-uevent.c
> @@ -36,6 +36,8 @@ static const struct {
>  } _dm_uevent_type_names[] = {
>  	{DM_UEVENT_PATH_FAILED, KOBJ_CHANGE, "PATH_FAILED"},
>  	{DM_UEVENT_PATH_REINSTATED, KOBJ_CHANGE, "PATH_REINSTATED"},
> +	{DM_UEVENT_VERITY_DATA_ERROR, KOBJ_CHANGE, "VERITY_DATA_ERROR"},
> +	{DM_UEVENT_VERITY_HASH_ERROR, KOBJ_CHANGE, "VERITY_HASH_ERROR"},
>  };
>  
>  static struct kmem_cache *_dm_event_cache;
> @@ -202,6 +204,44 @@ void dm_path_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
>  }
>  EXPORT_SYMBOL_GPL(dm_path_uevent);
>  
> +void dm_send_verity_uevent(enum dm_uevent_type event_type, struct dm_target *ti,
> +						unsigned long long block_nr)
> +{
> +	struct mapped_device *md = dm_table_get_md(ti->table);
> +	struct dm_uevent *event = dm_uevent_alloc(md);
> +	struct gendisk *disk = dm_disk(md);
> +
> +	if (!event) {
> +		DMERR("%s: dm_uevent_alloc() failed", __func__);
> +		return;
> +	}
> +
> +	if (event_type >= ARRAY_SIZE(_dm_uevent_type_names)) {
> +		DMERR("%s: Invalid event_type %d", __func__, event_type);
> +		goto out;
> +	}
> +
> +	if (add_uevent_var(&event->ku_env, "DM_VERITY_BLOCK_NR=%llu", block_nr)) {
> +		DMERR("%s: add_uevent_var() for DM_VERITY_BLOCK failed", __func__);
> +		goto out;
> +	}
> +
> +	if (add_uevent_var(&event->ku_env, "DM_ACTION=%s",
> +			_dm_uevent_type_names[event_type].name)) {
> +		DMERR("%s: add_uevent_var() for DM_ACTION failed", __func__);
> +		goto out;
> +	}
> +
> +	if (kobject_uevent_env(&disk_to_dev(disk)->kobj, event_type,
> +				event->ku_env.envp)) {
> +		DMERR("%s: kobject_uevent_env failed", __func__);
> +	}
> +
> +out:
> +	dm_uevent_free(event);
> +}
> +EXPORT_SYMBOL_GPL(dm_send_verity_uevent);
> +
>  int dm_uevent_init(void)
>  {
>  	_dm_event_cache = KMEM_CACHE(dm_uevent, 0);
> diff --git a/drivers/md/dm-uevent.h b/drivers/md/dm-uevent.h
> index 2eccc8b..1c59dba 100644
> --- a/drivers/md/dm-uevent.h
> +++ b/drivers/md/dm-uevent.h
> @@ -24,6 +24,8 @@
>  enum dm_uevent_type {
>  	DM_UEVENT_PATH_FAILED,
>  	DM_UEVENT_PATH_REINSTATED,
> +	DM_UEVENT_VERITY_DATA_ERROR,
> +	DM_UEVENT_VERITY_HASH_ERROR,
>  };
>  
>  #ifdef CONFIG_DM_UEVENT
> @@ -34,7 +36,9 @@ extern void dm_send_uevents(struct list_head *events, struct kobject *kobj);
>  extern void dm_path_uevent(enum dm_uevent_type event_type,
>  			   struct dm_target *ti, const char *path,
>  			   unsigned nr_valid_paths);
> -
> +extern void dm_send_verity_uevent(enum dm_uevent_type event_type,
> +					struct dm_target *ti,
> +					unsigned long long block_nr);
>  #else
>  
>  static inline int dm_uevent_init(void)
> @@ -53,7 +57,11 @@ static inline void dm_path_uevent(enum dm_uevent_type event_type,
>  				  unsigned nr_valid_paths)
>  {
>  }
> -
> +static inline void dm_send_verity_uevent(enum dm_uevent_type event_type,
> +					struct dm_target *ti,
> +					unsigned long long block_nr)
> +{
> +}
>  #endif	/* CONFIG_DM_UEVENT */
>  
>  #endif	/* DM_UEVENT_H */
> diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
> index 68bf5c3..2e3695b 100644
> --- a/drivers/md/dm-verity.c
> +++ b/drivers/md/dm-verity.c
> @@ -20,6 +20,8 @@
>  #include <linux/device-mapper.h>
>  #include <crypto/hash.h>
>  
> +#include "dm-uevent.h"
> +
>  #define DM_MSG_PREFIX			"verity"
>  
>  #define DM_VERITY_IO_VEC_INLINE		16
> @@ -137,6 +139,30 @@ static void dm_bufio_alloc_callback(struct dm_buffer *buf)
>  }
>  
>  /*
> + * Trigger userspace data corruption handler.
> + */
> +#ifdef CONFIG_DM_UEVENT
> +static void verity_data_error(struct dm_verity *v, unsigned long long block_nr)
> +{
> +	dm_send_verity_uevent(DM_UEVENT_VERITY_DATA_ERROR, v->ti, block_nr);
> +}
> +
> +static void verity_hash_error(struct dm_verity *v, unsigned long long block_nr)
> +{
> +	dm_send_verity_uevent(DM_UEVENT_VERITY_HASH_ERROR, v->ti, block_nr);
> +}
> +#else
> +static inline void verity_data_error(struct dm_verity *v,
> +					unsigned long long block_nr)
> +{
> +}
> +static inline void verity_hash_error(struct dm_verity *v,
> +					unsigned long long block_nr)
> +{
> +}
> +#endif
> +
> +/*
>   * Translate input sector number to the sector number on the target device.
>   */
>  static sector_t verity_map_sector(struct dm_verity *v, sector_t bi_sector)
> @@ -255,6 +281,7 @@ static int verity_verify_level(struct dm_verity_io *io, sector_t block,
>  				(unsigned long long)hash_block);
>  			v->hash_failed = 1;
>  			r = -EIO;
> +			verity_hash_error(v, (unsigned long long)hash_block);
>  			goto release_ret_r;
>  		} else
>  			aux->hash_verified = 1;
> @@ -375,6 +402,7 @@ test_block_hash:
>  			DMERR_LIMIT("data block %llu is corrupted",
>  				(unsigned long long)(io->block + b));
>  			v->hash_failed = 1;
> +			verity_data_error(v, (unsigned long long)(io->block + b));
>  			return -EIO;
>  		}
>  	}
> -- 
> 1.8.3
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
