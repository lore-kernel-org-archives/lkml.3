Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031351Ab3HIWVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:21:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40151 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031204Ab3HIWVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:21:23 -0400
Date: Fri, 9 Aug 2013 15:21:04 -0700
From: Kees Cook <kees@outflux.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with the ext4 tree
Message-ID: <20130809222104.GY2280@outflux.net>
References: <20130807151903.6281b33735f4e3f79231bf5e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130807151903.6281b33735f4e3f79231bf5e@canb.auug.org.au>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 07, 2013 at 03:19:03PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> fs/ext4/extents_status.c between commit 49c6efc7b80e ("ext4: add new
> ioctl EXT4_IOC_PRECACHE_EXTENTS") from the ext4 tree and commit
> "fs-convert-fs-shrinkers-to-new-scan-count-api-fix" from the akpm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/ext4/extents_status.c
> index 28e2627,0361206..0000000
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@@ -947,13 -909,23 +947,15 @@@ static int __ext4_es_shrink(struct ext4
>   	struct ext4_inode_info *ei;
>   	struct list_head *cur, *tmp;
>   	LIST_HEAD(skiped);
> - 	int ret, nr_shrunk = 0;
> + 	unsigned long nr_shrunk = 0;
>  +	int retried = 0, skip_precached = 1, nr_skipped = 0;
>   
>   	spin_lock(&sbi->s_es_lru_lock);
>   
>  -	/*
>  -	 * If the inode that is at the head of LRU list is newer than
>  -	 * last_sorted time, that means that we need to sort this list.
>  -	 */
>  -	ei = list_first_entry(&sbi->s_es_lru, struct ext4_inode_info, i_es_lru);
>  -	if (sbi->s_es_last_sorted < ei->i_touch_when) {
>  -		list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
>  -		sbi->s_es_last_sorted = jiffies;
>  -	}
>  -
>  +retry:

It seems like fs-convert-fs-shrinkers-to-new-scan-count-api-fix is carrying
this needless chunk above:

>   	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
> + 		int ret;
> + 
>   		/*
>   		 * If we have already reclaimed all extents from extent
>   		 * status tree, just stop the loop immediately.

Which is masking the "ret" at the start, leading to warnings at build-time:

fs/ext4/extents_status.c: In function ‘__ext4_es_shrink’:
fs/ext4/extents_status.c:950:6: warning: unused variable ‘ret’ [-Wunused-variable]

-Kees

-- 
Kees Cook                                            @outflux.net
