Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3KUXAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:00:48 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:56923 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3KUXAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:00:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1ERfNr+J5gT-s1Qe+RVmNz+CenNFOzAWi86MNCt2ZGLB4ZCA@mail.gmail.com>
References: <1384976973-32722-1-git-send-email-ddstreet@ieee.org>
 <528D570D.3020006@oracle.com> <CAL1ERfNr+J5gT-s1Qe+RVmNz+CenNFOzAWi86MNCt2ZGLB4ZCA@mail.gmail.com>
From: Dan Streetman <ddstreet@ieee.org>
Date: Thu, 21 Nov 2013 18:00:24 -0500
X-Google-Sender-Auth: RXoJDumerogr4E3QJLkej0YkqqU
Message-ID: <CALZtONBzk4Yh9yHk3320a4x2DfSvUxGik8q+sLV38_cy4cuefg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: change zswap to writethrough cache
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>, Seth Jennings <sjennings@variantweb.net>,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:50 PM, Weijie Yang <weijie.yang.kh@gmail.com> wrote:
> Hello Dan,
>
> On Thu, Nov 21, 2013 at 8:42 AM, Bob Liu <bob.liu@oracle.com> wrote:
>> Hi Dan,
>>
>> On 11/21/2013 03:49 AM, Dan Streetman wrote:
>>> Currently, zswap is writeback cache; stored pages are not sent
>>> to swap disk, and when zswap wants to evict old pages it must
>>> first write them back to swap cache/disk manually.  This avoids
>>> swap out disk I/O up front, but only moves that disk I/O to
>>> the writeback case (for pages that are evicted), and adds the
>>> overhead of having to uncompress the evicted pages, and adds the
>>> need for an additional free page (to store the uncompressed page)
>>> at a time of likely high memory pressure.  Additionally, being
>>> writeback adds complexity to zswap by having to perform the
>>> writeback on page eviction.
>>>
>>
>> Good work!
>>
>>> This changes zswap to writethrough cache by enabling
>>> frontswap_writethrough() before registering, so that any
>>> successful page store will also be written to swap disk.  All the
>>> writeback code is removed since it is no longer needed, and the
>>> only operation during a page eviction is now to remove the entry
>>> from the tree and free it.
>>>
>
> Thanks for your work. I reviewed this patch, and it is good to me.
>
> However, I am skeptical about it because:
> 1. it will add more IO than original zswap, how does it result in a
> performance improvement ?

I haven't used SPECjbb yet (I don't have it, I'll have to find someone
who has it that I can borrow), but my testing with a small test
program I wrote does show that CPU-bound performance is better with
writethrough over writeback, once zswap is full, which I think is
expected since writeback adds cycles for decompressing old pages while
writethrough simply drops the compressed page.  Now, the additional
CPU load may be more desirable depending on CPU speed, # of CPUs, swap
disk speed, etc., so maybe it would be better to make zswap writeback
or writethrough, with a param to select, depending on the specific hw
it's being run on.

> 2. most embedded device use NAND, more IO will reduce its working life

This is certainly true; but most embedded devices also have tiny cpus
that might get hit hard when zswap fills up and has to start
decompressing pages while simultaneously compressing newly swapped out
pages.  I'd expect for many embedded devices it would be better to
simply invoke the oom killer and/or reboot than try to run with
overcommitted memory.  But, having writeback vs writethrough
selectable by param would allow flexibility based on the specific
user's needs.


>
> Regards
>
>> Could you do some testing using eg. SPECjbb? And compare the result with
>> original zswap.
>>
>> Thanks,
>> -Bob
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
