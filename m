Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3HWR4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:56:09 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:59936 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab3HWR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:56:05 -0400
Date: Fri, 23 Aug 2013 10:28:59 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        weijie.yang@samsung.com
Subject: Re: [PATCH 1/4] zswap bugfix: memory leaks when re-swapon
Message-ID: <20130823152859.GB5439@variantweb.net>
References: <CAL1ERfPzB=CvKJ6kAq2YYTkkg-EgSOWRyfSFWkvKp8ZdQkCDxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1ERfPzB=CvKJ6kAq2YYTkkg-EgSOWRyfSFWkvKp8ZdQkCDxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082317-5518-0000-0000-0000116B1DDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 07:03:37PM +0800, Weijie Yang wrote:
> zswap_tree is not freed when swapoff, and it got re-kzalloc in swapon,
> memory leak occurs.
> Add check statement in zswap_frontswap_init so that zswap_tree is
> inited only once.
> 
> ---
>  mm/zswap.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index deda2b6..1cf1c07 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -826,6 +826,11 @@ static void zswap_frontswap_init(unsigned type)
>  {
>  	struct zswap_tree *tree;
> 
> +	if (zswap_trees[type]) {
> +		BUG_ON(zswap_trees[type]->rbroot != RB_ROOT);  /* invalidate_area set it */

Lets leave this BUG_ON() out.  If we want to make sure that the rbtree has
been properly emptied out, we should do it in
zswap_frontswap_invalidate_area() after the while loop and make it a
WARN_ON() since the problem is not fatal.

Seth

> +		return;
> +	}
> +
>  	tree = kzalloc(sizeof(struct zswap_tree), GFP_KERNEL);
>  	if (!tree)
>  		goto err;
> -- 
> 1.7.0.4
> 

