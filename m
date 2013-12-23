Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3LWFEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:04:06 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47479 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3LWFEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:04:04 -0500
X-AuditID: 9c930197-b7c4aae000003d84-38-52b7c4426992
Date: Mon, 23 Dec 2013 14:04:51 +0900
From: Minchan Kim <minchan@kernel.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        =?utf-8?B?7J6E7Zqo7KSA?= <hyojun.im@lge.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: Re : Re: Re: Re : Re: [PATCH] Squashfs: add asynchronous read
 support
Message-ID: <20131223050451.GG19968@bbox>
References: <1387171826-20110-1-git-send-email-chanho.min@lge.com>
 <OF0A0B2022.F34682B9-ON49257C45.0018AF5F-49257C45.0018AF60@lge.com>
 <OFA5BC9264.067973F3-ON49257C48.000B85B4-49257C48.000B85B4@lge.com>
 <OF207E4497.72720BDC-ON49257C4A.0010D055-49257C4A.0010D055@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF207E4497.72720BDC-ON49257C4A.0010D055-49257C4A.0010D055@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 12:03:39PM +0900, Chanho Min wrote:
> 
> 
> > read_pages
> >   for(page_idx ...) {
> >     if (!add_to_page_cache_lru)) { <-- 1)
> >       mapping->a_ops->readpage(filp, page)
> >         squashfs_readpage
> >           for (i ...) {   2)  Here, 31 pages are inserted into page cache
> >             grab_cahe_page_nowait <------/
> >               add_to_page_cache_lru
> >           }
> >     }
> >     /*
> >      * 1) will be failed with EEXIST by 2) so every pages other than first page
> >      * in list would be freed
> >      */
> >     page_cache_release(page)
> >   }
> >
> > If you see ReadAhead works, it is just by luck as I told you.
> > Please simulate it with 64K dd.
> You right, This luck happened frequently with 128k dd or my test.

Yeah, it was not intented by MM's readahead.
If you test it with squashfs 256K compression, you couldn't get a benefit.
If you test it with small block size dd like 32K, you couldn't, either.
It means it's very fragile. One more thing. Your approach doesn't work
page cache has already some sparse page because you are solving only
direct page copy part, which couldn't work if we read some sparse page
in a file and reclaimed many pages.

Please rethink.

I already explained what's the problem in your patch.
You are ignoring VM's logic. (ex, PageReadahead mark)
The squashfs is rather special due to compression FS so if we have no other way,
I'd like to support your approach but I pointed out problem in your patch and
suggest my solution to overcome the problem. It culd be silly but at least,
it's time that you should prove why it's brain-damaged so maintainer will
review this thread and decide or suggest easily. :)

Here goes again.

I suggest it would be better to implment squashfs_readpages and it should
work with cache buffer instead of direct page cache so that it could copy
from cache buffers to pages passed by MM without freeing them so that it
preserves readhead hinted page and would work with VM's readahead well
1. although algorithm in readahead were changed, 2. although you use small
block size dd, 3. although you use other compression size of squashfs.

Thanks.

> 
> > I understand it but your patch doesn't make it.
> >
> I think my patch can make it if readahead works normally or luckily.
> 
> Thanks a lot!
> Chanho,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
