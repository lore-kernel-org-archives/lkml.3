Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaGUWgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:36:41 -0400
Received: from 8bytes.org ([81.169.241.247]:52065 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbaGUWgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:36:39 -0400
Date: Tue, 22 Jul 2014 00:36:37 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 1/6] PM / Hibernate: Create a Radix-Tree to store memory
 bitmap
Message-ID: <20140721223637.GU30979@8bytes.org>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <1405938422-21900-2-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405938422-21900-2-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Mon, Jul 21, 2014 at 12:26:57PM +0200, Joerg Roedel wrote:
>  unsigned int snapshot_additional_pages(struct zone *zone)
>  {
> +	unsigned int rtree, nodes;
>  	unsigned int res;
>  
>  	res = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
>  	res += DIV_ROUND_UP(res * sizeof(struct bm_block),
>  			    LINKED_PAGE_DATA_SIZE);
> -	return 2 * res;
> +	rtree = nodes = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
> +	rtree += DIV_ROUND_UP(rtree * sizeof(struct rtree_node),
> +			      LINKED_PAGE_DATA_SIZE);
> +	while (nodes > 1) {
> +		nodes = DIV_ROUND_UP(nodes, BM_ENTRIES_PER_LEVEL);
> +		rtree += nodes;
> +	}
> +
> +	return 2 * (res + rtree);
>  }

Since you asked in another mail if I took the new data structure size
requirements into account, here is the code I added for this
computation.

Note that the above diff leaves the old code around because the old
memory bitmap implementation is not removed before patch 5/6 (which also
removes the old computation). So the final code will only have the new
size calculation in it.

Do you have any more concerns?


	Joerg

