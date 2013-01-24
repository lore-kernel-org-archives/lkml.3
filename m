Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3AXEm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 23:42:59 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:54936 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3AXEmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 23:42:52 -0500
Date: Thu, 24 Jan 2013 04:44:38 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] userns: improve uid/gid map collision detection
Message-ID: <20130124044438.GA13354@mail.hallyn.com>
References: <20130123160221.GG17632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123160221.GG17632@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> Initial implementation of the uid/gid maps will enforce that the
> maps should be in order and would prevent a use case like this from
> being used:
> 	0	1000	1
> 	48	500	1
> 
> since the second entry both values should be bigger than the previous.
> This patch implements a more elaborate collision detection allowing any
> order to be used.
> 
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>

I *think* that looks just right :)

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 2b042c4..fb0e492 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -521,6 +521,28 @@ struct seq_operations proc_projid_seq_operations = {
>  
>  static DEFINE_MUTEX(id_map_mutex);
>  
> +#define in_range(b,first,len) ((b)>=(first)&&(b)<(first)+(len))
> +static inline int extent_collision(struct uid_gid_map *new_map,
> +				   struct uid_gid_extent *extent)
> +{
> +	int i;
> +	struct uid_gid_extent *cur;
> +
> +	for (i = 0; i < new_map->nr_extents; i++) {
> +		cur = &new_map->extent[i];
> +		if (in_range(extent->first, cur->first, cur->count) ||
> +		    in_range(extent->first + extent->count, cur->first,
> +			     cur->count))
> +			return 1;
> +		if (in_range(extent->lower_first, cur->lower_first,
> +			     cur->count) ||
> +		    in_range(extent->lower_first + extent->count,
> +			     cur->lower_first, cur->count))
> +			return 1;
> +	}
> +	return 0;
> +}
> +
>  static ssize_t map_write(struct file *file, const char __user *buf,
>  			 size_t count, loff_t *ppos,
>  			 int cap_setid,
> @@ -634,10 +656,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  		if ((extent->lower_first + extent->count) <= extent->lower_first)
>  			goto out;
>  
> -		/* For now only accept extents that are strictly in order */
> -		if (last &&
> -		    (((last->first + last->count) > extent->first) ||
> -		     ((last->lower_first + last->count) > extent->lower_first)))
> +		if (extent_collision(&new_map, extent))
>  			goto out;
>  
>  		new_map.nr_extents++;
