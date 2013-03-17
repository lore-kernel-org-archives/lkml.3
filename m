Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3CQOtx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:49:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:30080 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab3CQOtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,859,1355126400"; 
   d="scan'208";a="280701301"
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] mm: vmscan: Block kswapd if it is encountering pages under writeback
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
	<1363525456-10448-8-git-send-email-mgorman@suse.de>
Date: Sun, 17 Mar 2013 07:49:50 -0700
In-Reply-To: <1363525456-10448-8-git-send-email-mgorman@suse.de> (Mel Gorman's
	message of "Sun, 17 Mar 2013 13:04:13 +0000")
Message-ID: <m21ubejd2p.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:


> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 493728b..7d5a932 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -725,6 +725,19 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  
>  		if (PageWriteback(page)) {
>  			/*
> +			 * If reclaim is encountering an excessive number of
> +			 * pages under writeback and this page is both under
> +			 * writeback and PageReclaim then it indicates that
> +			 * pages are being queued for IO but are being
> +			 * recycled through the LRU before the IO can complete.
> +			 * is useless CPU work so wait on the IO to complete.
> +			 */
> +			if (current_is_kswapd() &&
> +			    zone_is_reclaim_writeback(zone)) {
> +				wait_on_page_writeback(page);
> +				zone_clear_flag(zone, ZONE_WRITEBACK);
> +
> +			/*

Something is wrong with the indentation here. Comment should be indented
or is the code in the wrong block?

It's not fully clair to me how you decide here that the writeback
situation has cleared. There must be some kind of threshold for it,
but I don't see it. Or do you clear already when the first page
finished? That would seem too early.

BTW longer term the code would probably be a lot clearer with a
real explicit state machine instead of all these custom state bits.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
