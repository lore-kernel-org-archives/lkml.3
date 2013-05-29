Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102Ab3E2H0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:26:14 -0400
Received: from mx01-sz.bfs.de ([194.94.69.67]:46942 "EHLO mx01-sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935077Ab3E2H0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:26:12 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2013 03:26:12 EDT
Message-ID: <51A5AB81.5070908@bfs.de>
Date: Wed, 29 May 2013 09:17:21 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: Re: [patch] ceph: tidy ceph_mdsmap_decode() a little
References: <20130529062213.GF23932@mwanda>
In-Reply-To: <20130529062213.GF23932@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 29.05.2013 08:22, schrieb Dan Carpenter:
> I introduced a new temporary variable "info" instead of
> "m->m_info[mds]".  Also I reversed the if condition and pulled
> everything in one indent level.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This goes on top of Emil Goode's patch.
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index d4d3897..132b64e 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -92,6 +92,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  		u32 num_export_targets;
>  		void *pexport_targets = NULL;
>  		struct ceph_timespec laggy_since;
> +		struct ceph_mds_info *info;
>  
>  		ceph_decode_need(p, end, sizeof(u64)*2 + 1 + sizeof(u32), bad);
>  		global_id = ceph_decode_64(p);
> @@ -126,26 +127,27 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  		     i+1, n, global_id, mds, inc,
>  		     ceph_pr_addr(&addr.in_addr),
>  		     ceph_mds_state_name(state));
> -		if (mds >= 0 && mds < m->m_max_mds && state > 0) {
> -			m->m_info[mds].global_id = global_id;
> -			m->m_info[mds].state = state;
> -			m->m_info[mds].addr = addr;
> -			m->m_info[mds].laggy =
> -				(laggy_since.tv_sec != 0 ||
> -				 laggy_since.tv_nsec != 0);
> -			m->m_info[mds].num_export_targets = num_export_targets;
> -			if (num_export_targets) {
> -				m->m_info[mds].export_targets =
> -					kcalloc(num_export_targets, sizeof(u32),
> -						GFP_NOFS);
> -				if (m->m_info[mds].export_targets == NULL)
> -					goto badmem;
> -				for (j = 0; j < num_export_targets; j++)
> -					m->m_info[mds].export_targets[j] =
> -					       ceph_decode_32(&pexport_targets);
> -			} else {
> -				m->m_info[mds].export_targets = NULL;
> -			}
> +
> +		if (mds < 0 || mds >= m->m_max_mds || state <= 0)
> +			continue;
> +
> +		info = &m->m_info[mds];
> +		info->global_id = global_id;
> +		info->state = state;
> +		info->addr = addr;
> +		info->laggy = (laggy_since.tv_sec != 0 ||
> +			       laggy_since.tv_nsec != 0);
> +		info->num_export_targets = num_export_targets;
personally i would go for:
		info->export_targets = NULL;
and remove the else below.

hope that helps,

re,
 wh

> +		if (num_export_targets) {
> +			info->export_targets = kcalloc(num_export_targets,
> +						       sizeof(u32), GFP_NOFS);
> +			if (info->export_targets == NULL)
> +				goto badmem;
> +			for (j = 0; j < num_export_targets; j++)
> +				info->export_targets[j] =
> +				       ceph_decode_32(&pexport_targets);
> +		} else {
> +			info->export_targets = NULL;
>  		}
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
