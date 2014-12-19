Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaLSBDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:03:40 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42570 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaLSBDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:03:38 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Fri, 19 Dec 2014 10:04:52 +0900
From: Minchan Kim <minchan@kernel.org>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "'Kirill A. Shutemov'" <kirill@shutemov.name>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'n-horiguchi@ah.jp.nec.com'" <n-horiguchi@ah.jp.nec.com>
Subject: Re: [RFC] MADV_FREE doesn't work when doesn't have swap partition
Message-ID: <20141219010452.GC1538@bbox>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
 <20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
 <35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
 <20141208114601.GA28846@node.dhcp.inet.fi>
 <35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net>
 <CALYGNiMEytHuND37f+hNdMKqCPzN0k_uha6CaeL_fyzrj-obNQ@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B31408@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103EDAF89E14C@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103EDAF89E14C@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 11:50:01AM +0800, Wang, Yalin wrote:
> I notice this commit:
> mm: support madvise(MADV_FREE),
> 
> it can free clean anonymous pages directly,
> doesn't need pageout to swap partition,
> 
> but I found it doesn't work on my platform,
> which don't enable any swap partitions.

Current implementation, if there is no empty slot in swap, it does
instant free instead of delayed free. Look at madvise_vma.

> 
> I make a change for this.
> Just to explain my issue clearly,
> Do we need some other checks to still scan anonymous pages even
> Don't have swap partition but have clean anonymous pages?

There is a few places we should consider if you want to scan anonymous page
withotu swap. Refer 69c854817566 and 74e3f3c3391d.

However, it's not simple at the moment. If we reenable anonymous scan without swap,
it would make much regress of reclaim. So my direction is move normal anonymos pages
into unevictable LRU list because they're real unevictable without swap and
put delayed freeing pages into anon LRU list and age them.

> ---
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5e8772b..8258f3a 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1941,7 +1941,7 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
>                 force_scan = true;
> 
>         /* If we have no swap space, do not bother scanning anon pages. */
> -       if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
> +       if (!sc->may_swap) {
>                 scan_balance = SCAN_FILE;
>                 goto out;
>         }

-- 
Kind regards,
Minchan Kim
