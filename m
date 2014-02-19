Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBSAqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:46:08 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:63620 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBSAqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:46:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140202152106.GL20939@parisc-linux.org>
References: <1391319694-3089-1-git-send-email-linkinjeon@gmail.com>
	<20140202151624.GK20939@parisc-linux.org>
	<20140202152106.GL20939@parisc-linux.org>
Date: Wed, 19 Feb 2014 09:46:04 +0900
Message-ID: <CAKYAXd9Q3Bj61hdHJNKvKX0j-=CT16irRUw9ZpqCh5wuZjnogQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/10] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE)
 for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-03 0:21 GMT+09:00, Matthew Wilcox <matthew@wil.cx>:
> On Sun, Feb 02, 2014 at 08:16:24AM -0700, Matthew Wilcox wrote:
>> On Sun, Feb 02, 2014 at 02:41:34PM +0900, Namjae Jeon wrote:
>> > The semantics of this flag are following:
>> > 1) It collapses the range lying between offset and length by removing
>> > any data
>> >    blocks which are present in this range and than updates all the
>> > logical
>> >    offsets of extents beyond "offset + len" to nullify the hole created
>> > by
>> >    removing blocks. In short, it does not leave a hole.
>> > 2) It should be used exclusively. No other fallocate flag in
>> > combination.
>> > 3) Offset and length supplied to fallocate should be fs block size
>> > aligned
>> >    in case of xfs and ext4.
>> > 4) Collaspe range does not work beyond i_size.
>>
>> What if the file is mmaped at the time somebody issues this command?
>> Seems to me we should drop pagecache pages that overlap with the
>> removed blocks.  If the removed range is not a multiple of PAGE_SIZE,
>> then we should also drop any pagecache pages after the removed range.
Hi Matthew.
Yes, right. So both xfs and ext4 call truncate_pagecache_range to drop
page caches before removing blocks.
truncate_pagecache_range(inode, offset, -1);
and end offset is -1, which mean all page cache will be dropped from
start offset to the end of file.
>
> Oops, forgot to add "and if it is a multiple of page size, then we need
> to update the offsets of any pages after the removed page".  We should
> probably start easy though; just drop all pages that overlap the beginning
> of the affected range to the end of the file.
Yes, right. current implementation does exactly as you pointed

>  At some later point,
> if there's demand, we can add the optimisation to adjust the offsets of
> pages still in the cache.
-> Yes, Right. But if we consider that fs block size can be less than
page cache size,(512B, 1K, 2K)
I thought that it is proper to drop all pages from the start offset to
the end of the file.

Thanks for your reply.
>
> --
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
>
