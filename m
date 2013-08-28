Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3H1WRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:17:13 -0400
Received: from [204.155.152.216] ([204.155.152.216]:45406 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab3H1WRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:17:11 -0400
Date: Thu, 29 Aug 2013 00:19:02 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
Message-ID: <20130828211902.GA22796@shutemov.name>
References: <1377726732.3625.31.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377726732.3625.31.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 02:52:12PM -0700, Tim Chen wrote:
> This patch detects that when free inodes and dentries are really
> low, their reclamation is skipped so we do not have to contend
> on the global sb_lock uselessly under memory pressure. Otherwise
> we create a log jam trying to acquire the sb_lock in prune_super(),
> with little or no freed memory to show for the effort.
> 
> The profile below shows a multi-threaded large file read exerting
> pressure on memory with page cache usage.  It is dominated
> by the sb_lock contention in the cpu cycles profile.  The patch
> eliminates the sb_lock contention almost entirely for prune_super().
> 
>     43.94%           usemem  [kernel.kallsyms]             [k] _raw_spin_lock
>                      |
>                      --- _raw_spin_lock
>                         |
>                         |--32.44%-- grab_super_passive
>                         |          prune_super
>                         |          shrink_slab
>                         |          do_try_to_free_pages
>                         |          try_to_free_pages
>                         |          __alloc_pages_nodemask
>                         |          alloc_pages_current
>                         |
>                         |--32.18%-- put_super
>                         |          drop_super
>                         |          prune_super
>                         |          shrink_slab
>                         |          do_try_to_free_pages
>                         |          try_to_free_pages
>                         |          __alloc_pages_nodemask
>                         |          alloc_pages_current
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  fs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 68307c0..70fa26c 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -53,6 +53,7 @@ static char *sb_writers_name[SB_FREEZE_LEVELS] = {
>   * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
>   * take a passive reference to the superblock to avoid this from occurring.
>   */
> +#define SB_CACHE_LOW 5
>  static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
>  {
>  	struct super_block *sb;
> @@ -68,6 +69,13 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
>  	if (sc->nr_to_scan && !(sc->gfp_mask & __GFP_FS))
>  		return -1;
>  
> +	/*
> +	 * Don't prune if we have few cached objects to reclaim to
> +	 * avoid useless sb_lock contention
> +	 */
> +	if ((sb->s_nr_dentry_unused + sb->s_nr_inodes_unused) <= SB_CACHE_LOW)
> +		return -1;

I don't think it's correct: you don't account fs_objects here and
prune_icache_sb() calls invalidate_mapping_pages() which can free a lot of
memory. It's too naive approach. You can miss a memory hog easily this
way.

> +
>  	if (!grab_super_passive(sb))
>  		return -1;
>  

-- 
 Kirill A. Shutemov
