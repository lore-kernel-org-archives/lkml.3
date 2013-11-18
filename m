Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3KRTDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:03:31 -0500
Received: from www.sr71.net ([198.145.64.142]:35496 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab3KRTD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:03:27 -0500
Message-ID: <528A6448.3080907@sr71.net>
Date: Mon, 18 Nov 2013 11:02:32 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        akpm@linux-foundation.org, dhillf@gmail.com,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: call cond_resched() per MAX_ORDER_NR_PAGES pages
 copy
References: <20131115225550.737E5C33@viggo.jf.intel.com> <20131115225553.B0E9DFFB@viggo.jf.intel.com> <1384800714-y653r3ch-mutt-n-horiguchi@ah.jp.nec.com> <1384800841-314l1f3e-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1384800841-314l1f3e-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 10:54 AM, Naoya Horiguchi wrote:
> diff --git a/mm/migrate.c b/mm/migrate.c
> index cb5d152b58bc..661ff5f66591 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -454,7 +454,8 @@ static void __copy_gigantic_page(struct page *dst, struct page *src,
>  	struct page *src_base = src;
>  
>  	for (i = 0; i < nr_pages; ) {
> -		cond_resched();
> +		if (i % MAX_ORDER_NR_PAGES == 0)
> +			cond_resched();
>  		copy_highpage(dst, src);

This is certainly OK on x86, but remember that MAX_ORDER can be
overridden by a config variable.  Just picking one at random:

config FORCE_MAX_ZONEORDER
        int "Maximum zone order"
        range 9 64 if PPC64 && PPC_64K_PAGES
...

Would it be OK to only resched once every 2^63 pages? ;)

Really, though, a lot of things seem to have MAX_ORDER set up so that
it's at 256MB or 512MB.  That's an awful lot to do between rescheds.
