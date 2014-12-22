Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaLVKaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:30:25 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51017 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaLVKaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:30:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141219010452.GC1538@bbox>
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
	<20141219010452.GC1538@bbox>
Date: Mon, 22 Dec 2014 14:30:22 +0400
Message-ID: <CALYGNiPbwCDtYNO+JrNDNJkqXHdwPVduT4fz0tQ_cM0SrXTJ4Q@mail.gmail.com>
Subject: Re: [RFC] MADV_FREE doesn't work when doesn't have swap partition
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 4:04 AM, Minchan Kim <minchan@kernel.org> wrote:
> On Thu, Dec 18, 2014 at 11:50:01AM +0800, Wang, Yalin wrote:
>> I notice this commit:
>> mm: support madvise(MADV_FREE),
>>
>> it can free clean anonymous pages directly,
>> doesn't need pageout to swap partition,
>>
>> but I found it doesn't work on my platform,
>> which don't enable any swap partitions.
>
> Current implementation, if there is no empty slot in swap, it does
> instant free instead of delayed free. Look at madvise_vma.
>
>>
>> I make a change for this.
>> Just to explain my issue clearly,
>> Do we need some other checks to still scan anonymous pages even
>> Don't have swap partition but have clean anonymous pages?
>
> There is a few places we should consider if you want to scan anonymous page
> withotu swap. Refer 69c854817566 and 74e3f3c3391d.
>
> However, it's not simple at the moment. If we reenable anonymous scan without swap,
> it would make much regress of reclaim. So my direction is move normal anonymos pages
> into unevictable LRU list because they're real unevictable without swap and
> put delayed freeing pages into anon LRU list and age them.

This sounds reasonable. In this case swapon must either scan
unevictable pages and make
some of them evictable again or just move all unevictable pages into
active list and postpone
this job till reclaimer invocation.

>
>> ---
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 5e8772b..8258f3a 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1941,7 +1941,7 @@ static void get_scan_count(struct lruvec *lruvec, int swappiness,
>>                 force_scan = true;
>>
>>         /* If we have no swap space, do not bother scanning anon pages. */
>> -       if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
>> +       if (!sc->may_swap) {
>>                 scan_balance = SCAN_FILE;
>>                 goto out;
>>         }
>
> --
> Kind regards,
> Minchan Kim
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
