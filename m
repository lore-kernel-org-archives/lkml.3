Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbaEFUX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:23:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46250 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbaEFUX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:23:56 -0400
Date: Tue, 6 May 2014 22:23:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/17] mm: page_alloc: Use jump labels to avoid checking
 number_of_cpusets
Message-ID: <20140506202350.GE1429@laptop.programming.kicks-ass.net>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-4-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1398933888-4940-4-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 09:44:34AM +0100, Mel Gorman wrote:
> If cpusets are not in use then we still check a global variable on every
> page allocation. Use jump labels to avoid the overhead.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  include/linux/cpuset.h | 31 +++++++++++++++++++++++++++++++
>  kernel/cpuset.c        |  8 ++++++--
>  mm/page_alloc.c        |  3 ++-
>  3 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index b19d3dc..2b89e07 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -17,6 +17,35 @@
>  
>  extern int number_of_cpusets;	/* How many cpusets are defined in system? */
>  
> +#ifdef HAVE_JUMP_LABEL
> +extern struct static_key cpusets_enabled_key;
> +static inline bool cpusets_enabled(void)
> +{
> +	return static_key_false(&cpusets_enabled_key);
> +}
> +#else
> +static inline bool cpusets_enabled(void)
> +{
> +	return number_of_cpusets > 1;
> +}
> +#endif
> +
> +static inline void cpuset_inc(void)
> +{
> +	number_of_cpusets++;
> +#ifdef HAVE_JUMP_LABEL
> +	static_key_slow_inc(&cpusets_enabled_key);
> +#endif
> +}
> +
> +static inline void cpuset_dec(void)
> +{
> +	number_of_cpusets--;
> +#ifdef HAVE_JUMP_LABEL
> +	static_key_slow_dec(&cpusets_enabled_key);
> +#endif
> +}

Why the HAVE_JUMP_LABEL and number_of_cpusets thing? When
!HAVE_JUMP_LABEL the static_key thing reverts to an atomic_t and
static_key_false() becomes:

 return unlikely(atomic_read(&key->enabled) > 0);

