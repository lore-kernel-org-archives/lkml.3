Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3A1O2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:28:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab3A1O2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:28:20 -0500
Date: Mon, 28 Jan 2013 09:28:16 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH review 2/6] userns: Allow any uid or gid mappings that
 don't overlap.
Message-ID: <20130128142816.GU17632@redhat.com>
References: <87ehh8it9s.fsf@xmission.com>
 <87zjzwhegj.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjzwhegj.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 06:21:00PM -0800, Eric W. Biederman wrote:
> When I initially wrote the code for /proc/<pid>/uid_map.  I was lazy
> and avoided duplicate mappings by the simple expedient of ensuring the
> first number in a new extent was greater than any number in the
> previous extent.
> 
> Unfortunately that precludes a number of valid mappings, and someone
> noticed and complained.  So use a simple check to ensure that ranges
> in the mapping extents don't overlap.

Acked-by: Someone <aris@redhat.com>

> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/user_namespace.c |   45 +++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 24f8ec3..8b65083 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -520,6 +520,42 @@ struct seq_operations proc_projid_seq_operations = {
>  	.show = projid_m_show,
>  };
>  
> +static bool mappings_overlap(struct uid_gid_map *new_map, struct uid_gid_extent *extent)
> +{
> +	u32 upper_first, lower_first, upper_last, lower_last;
> +	unsigned idx;
> +
> +	upper_first = extent->first;
> +	lower_first = extent->lower_first;
> +	upper_last = upper_first + extent->count - 1;
> +	lower_last = lower_first + extent->count - 1;
> +
> +	for (idx = 0; idx < new_map->nr_extents; idx++) {
> +		u32 prev_upper_first, prev_lower_first;
> +		u32 prev_upper_last, prev_lower_last;
> +		struct uid_gid_extent *prev;
> +
> +		prev = &new_map->extent[idx];
> +
> +		prev_upper_first = prev->first;
> +		prev_lower_first = prev->lower_first;
> +		prev_upper_last = prev_upper_first + prev->count - 1;
> +		prev_lower_last = prev_lower_first + prev->count - 1;
> +
> +		/* Does the upper range intersect a previous extent? */
> +		if ((prev_upper_first <= upper_last) &&
> +		    (prev_upper_last >= upper_first))
> +			return true;
> +
> +		/* Does the lower range intersect a previous extent? */
> +		if ((prev_lower_first <= lower_last) &&
> +		    (prev_lower_last >= lower_first))
> +			return true;
> +	}
> +	return false;
> +}
> +
> +
>  static DEFINE_MUTEX(id_map_mutex);
>  
>  static ssize_t map_write(struct file *file, const char __user *buf,
> @@ -532,7 +568,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  	struct user_namespace *ns = seq->private;
>  	struct uid_gid_map new_map;
>  	unsigned idx;
> -	struct uid_gid_extent *extent, *last = NULL;
> +	struct uid_gid_extent *extent = NULL;
>  	unsigned long page = 0;
>  	char *kbuf, *pos, *next_line;
>  	ssize_t ret = -EINVAL;
> @@ -635,14 +671,11 @@ static ssize_t map_write(struct file *file, const char __user *buf,
>  		if ((extent->lower_first + extent->count) <= extent->lower_first)
>  			goto out;
>  
> -		/* For now only accept extents that are strictly in order */
> -		if (last &&
> -		    (((last->first + last->count) > extent->first) ||
> -		     ((last->lower_first + last->count) > extent->lower_first)))
> +		/* Do the ranges in extent overlap any previous extents? */
> +		if (mappings_overlap(&new_map, extent))
>  			goto out;
>  
>  		new_map.nr_extents++;
> -		last = extent;
>  
>  		/* Fail if the file contains too many extents */
>  		if ((new_map.nr_extents == UID_GID_MAP_MAX_EXTENTS) &&
> -- 
> 1.7.5.4
> 

-- 
Aristeu

