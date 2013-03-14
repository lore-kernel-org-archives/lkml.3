Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab3CNPHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:07:09 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58708 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965Ab3CNPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:07:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBAoNyniJpaeHafpWm0w7FfC9y+9+x_Gpdb74Jtzyk81HA@mail.gmail.com>
References: <CAAO_Xo7sEH5W_9xoOjax8ynyjLCx7GBpse+EU0mF=9mEBFhrgw@mail.gmail.com>
	<51347A6E.8010608@iskon.hr>
	<CAAO_Xo6bWo4QOvdowLG88NoQr2AEq4jxCWHQXeA8g-VBT4Yk9Q@mail.gmail.com>
	<513A9AF7.4020909@gmail.com>
	<CAJd=RBAoNyniJpaeHafpWm0w7FfC9y+9+x_Gpdb74Jtzyk81HA@mail.gmail.com>
Date: Thu, 14 Mar 2013 23:07:02 +0800
Message-ID: <CAAO_Xo5aX4WzAQSHN9G5=6WOMD+2zPUJYGX3FgQL986-Fp2v7A@mail.gmail.com>
Subject: Re: Inactive memory keep growing and how to release it?
From: Lenky Gao <lenky.gao@gmail.com>
To: Hillf Danton <dhillf@gmail.com>, Michal Hocko <mhocko@suse.cz>
Cc: Will Huck <will.huckk@gmail.com>, Zlatko Calusic <zlatko.calusic@iskon.hr>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>, Linux-MM <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 6:14 PM, Michal Hocko <mhocko@suse.cz> wrote:
> One way would be to increase /proc/sys/vm/min_free_kbytes which will
> enlarge watermaks so the reclaim starts sooner.
>

Good tip thanks. :)

> This is really an old kernel and also a distribution one which might
> contain a lot of patches on top of the core kernel. I would suggest to
> contact Redhat or try to reproduce the issue with the vanilla and
> up-to-date kernel and report here.

I have tested on other version vanilla kernel, such as 2.6.30 and 3.6.11, the
issue also exist and it is easy to reproduce.

Maybe i have found the answer for this question:

On Thu, Mar 14, 2013 at 4:00 PM, Lenky Gao <lenky.gao@gmail.com> wrote:
> Hi Everyone,
>
> Maybe i have found the answer for this question. The author of the JBD
> have explained in the comments:
>
> /*
>  * When an ext3-ordered file is truncated, it is possible that many pages are
>  * not successfully freed, because they are attached to a committing
> transaction.
>  * After the transaction commits, these pages are left on the LRU, with no
>  * ->mapping, and with attached buffers.  These pages are trivially reclaimable
>  * by the VM, but their apparent absence upsets the VM accounting, and it makes
>  * the numbers in /proc/meminfo look odd.
> ...
>  */
> static void release_buffer_page(struct buffer_head *bh)
> {
>         struct page *page;
> ...

But my new question is why not free those pages directly after the
transaction commits?

On Thu, Mar 14, 2013 at 8:39 PM, Hillf Danton <dhillf@gmail.com> wrote:
> Perhaps we have to consider page count for orphan page if it
> could be reproduced with mainline.
>
> Hillf
> ---
> --- a/mm/vmscan.c       Sun Mar 10 13:36:26 2013
> +++ b/mm/vmscan.c       Thu Mar 14 20:29:40 2013
> @@ -315,14 +315,14 @@ out:
>         return ret;
>  }
>
> -static inline int is_page_cache_freeable(struct page *page)
> +static inline int is_page_cache_freeable(struct page *page, int has_mapping)
>  {
>         /*
>          * A freeable page cache page is referenced only by the caller
>          * that isolated the page, the page cache radix tree and
>          * optional buffer heads at page->private.
>          */
> -       return page_count(page) - page_has_private(page) == 2;
> +       return page_count(page) - page_has_private(page) == has_mapping + 1;
>  }
>
>  static int may_write_to_queue(struct backing_dev_info *bdi,
> @@ -393,7 +393,7 @@ static pageout_t pageout(struct page *pa
>          * swap_backing_dev_info is bust: it doesn't reflect the
>          * congestion state of the swapdevs.  Easy to fix, if needed.
>          */
> -       if (!is_page_cache_freeable(page))
> +       if (!is_page_cache_freeable(page, mapping ? 1 : 0))
>                 return PAGE_KEEP;
>         if (!mapping) {
>                 /*

Thanks, i'll test it.

I am totally a newbie regarding VMM and EXT/JBD, thanks to everyone
for your kind attention and help.

-- 
Regards,

Lenky
