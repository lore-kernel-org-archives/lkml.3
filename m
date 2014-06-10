Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaFJXdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:33:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaFJXdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:33:40 -0400
Date: Tue, 10 Jun 2014 16:33:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Yucong <slaoub@gmail.com>
Cc: mgorman@suse.de, mhocko@suse.cz, hannes@cmpxchg.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
Message-Id: <20140610163338.5b463c5884c4c7e3f1b948e2@linux-foundation.org>
In-Reply-To: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Jun 2014 21:27:16 +0800 Chen Yucong <slaoub@gmail.com> wrote:

> Via https://lkml.org/lkml/2013/4/10/334 , we can find that recording the
> original scan targets introduces extra 40 bytes on the stack. This patch
> is able to avoid this situation and the call to memcpy(). At the same time,
> it does not change the relative design idea.
> 
> ratio = original_nr_file / original_nr_anon;
> 
> If (nr_file > nr_anon), then ratio = (nr_file - x) / nr_anon.
>  x = nr_file - ratio * nr_anon;
> 
> if (nr_file <= nr_anon), then ratio = nr_file / (nr_anon - x).
>  x = nr_anon - nr_file / ratio;
> 
> ...
>

Are you sure this is an equivalent-to-before change?  If so, then I
can't immediately see why :(

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2057,8 +2057,7 @@ out:
>  static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  {
>  	unsigned long nr[NR_LRU_LISTS];
> -	unsigned long targets[NR_LRU_LISTS];
> -	unsigned long nr_to_scan;
> +	unsigned long nr_to_scan, ratio;
>  	enum lru_list lru;
>  	unsigned long nr_reclaimed = 0;
>  	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
> @@ -2067,8 +2066,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  
>  	get_scan_count(lruvec, sc, nr);
>  
> -	/* Record the original scan target for proportional adjustments later */
> -	memcpy(targets, nr, sizeof(nr));
> +	ratio = (nr[LRU_INACTIVE_FILE] + nr[LRU_ACTIVE_FILE] + 1) /
> +			(nr[LRU_INACTIVE_ANON] + nr[LRU_ACTIVE_ANON] + 1);
>  
>  	/*
>  	 * Global reclaiming within direct reclaim at DEF_PRIORITY is a normal
> @@ -2088,7 +2087,6 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
>  					nr[LRU_INACTIVE_FILE]) {
>  		unsigned long nr_anon, nr_file, percentage;
> -		unsigned long nr_scanned;
>  
>  		for_each_evictable_lru(lru) {
>  			if (nr[lru]) {
> @@ -2123,15 +2121,13 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  			break;
>  
>  		if (nr_file > nr_anon) {
> -			unsigned long scan_target = targets[LRU_INACTIVE_ANON] +
> -						targets[LRU_ACTIVE_ANON] + 1;
> +			nr_to_scan = nr_file - ratio * nr_anon;
> +			percentage = nr[LRU_FILE] * 100 / nr_file;

here, nr_file and nr_anon are derived from the contents of nr[].  But
nr[] was modified in the for_each_evictable_lru() loop, so its contents
now may differ from what was in targets[]?

>  			lru = LRU_BASE;
> -			percentage = nr_anon * 100 / scan_target;
>  		} else {
> -			unsigned long scan_target = targets[LRU_INACTIVE_FILE] +
> -						targets[LRU_ACTIVE_FILE] + 1;
> +			nr_to_scan = nr_anon - nr_file / ratio;
> +			percentage = nr[LRU_BASE] * 100 / nr_anon;
>  			lru = LRU_FILE;
> -			percentage = nr_file * 100 / scan_target;
>  		}
>  
>  		/* Stop scanning the smaller of the LRU */
> ...

