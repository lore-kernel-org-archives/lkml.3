Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab3IZAa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:30:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60165 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3IZAa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:30:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAAQqrdQgLFRcvFc=-RK8G4j8jN72-ij_e-jrcPS4zYqgwhGvkA@mail.gmail.com>
References: <CAAQqrdRPij9ySiOpaEk28eLdVUUNx+_7QZNVbRzQRS_mpUjq7g@mail.gmail.com>
	<CAEwNFnAr89i0iL0380dWiJoWQizizXHd8R=5vOsZB2kxJ7ERiw@mail.gmail.com>
	<CAAQqrdQgLFRcvFc=-RK8G4j8jN72-ij_e-jrcPS4zYqgwhGvkA@mail.gmail.com>
Date: Thu, 26 Sep 2013 09:30:27 +0900
X-Google-Sender-Auth: teX1ZCXKrFg4PyAKSylpiGBVEdI
Message-ID: <CAEwNFnA7sMo8er9bxZY+qHm4wsvQfbp_DaLeUChVibw+mK5U+Q@mail.gmail.com>
Subject: Re: squashfs enhance [RFC 3/5] squashfs: remove cache for normal data page
From: Minchan Kim <minchan@kernel.org>
To: chintu kumar <chintu.kr78@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?7ZWc7LC97Z2sIChDaGFuZ2hlZSBIYW4p?= <ch0.han@lge.com>,
        gunho.lee@lge.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello chintu,

On Wed, Sep 25, 2013 at 5:13 PM, chintu kumar <chintu.kr78@gmail.com> wrote:
> Hi Minchan,
>
> Thanks for the response!
>
> I checked add_to_page_cache_lru and you are right for existing pages in page
> cache it won't add the page you allocated so my questions are answered thank
> you. However my concern is still regarding parallel calls to
> squashfs_readpage for the same inode.
>
> I'll try to rephrase,
>
> Actually I was concerned about allocation on every squashfs_readpage. In the
> original code suppose that all pages weren't present in page cache and we
> are taking random read on the file. Now in the original code the
> cache->entry would've been filled once for all the requested pages within
> that block.
>
> However with your patch we always do I/O however and as you said
> add_to_page_cache_lru would take care of adding that page to the inode's
> mapping so we need not worry about that [Correct?] . Now suppose that you've
> read those pages as well for which squashfs_readpage has been called however
> since you won't be able to add the page to page_cache_lru it'll do I/O again
> just to fill the page that a different squashfs_readpage wasn't able to
> fill.
>
> timeline
> |
> |
> ---->  Process 1 (VFS initiates read for page 2)
> |
> ----> Initiates read for pages 1-5
> Process 2 (VFS intiates read for page 3)
> |
> ----> attempts to add the pages read in page cache
> Initiates read for pages 1-5 again
>        and fails for page 3 since VFS already initiated
> attempts to add pages read in page cache
>        read for page 3.
> and fails for every page. Page 3 isn't added since you got it from VFS in
> squashfs_readpage
>
>
> So it means that cost of memcpy in the original code from cache->entry to
> the page cache page IS MORE than   __page_cache_alloc + I/O? that you did in
> your patch.

If the race happen with same CPU, buffer cache will mitigate a problem
but it happens on different CPUs,
we will do unnecessary I/O. But I think it's not a severe regression
because old code's cache coverage is
too limited and even stuck with concurrent I/O due to *a* cache.

One of solution is to add locked pages right before request I/O to
page cache and if one of the page
in the compressed block is found from page cache, it means another
stream is going on so we can wait to finish
I/O and copy, just return. Does it make sense?

>
>
> Regards,
> Chintu
>
>
>
> On Wed, Sep 25, 2013 at 5:52 AM, Minchan Kim <minchan@kernel.org> wrote:
>>
>> Hello,
>>
>> On Tue, Sep 24, 2013 at 6:07 PM, chintu kumar <chintu.kr78@gmail.com>
>> wrote:
>> > Hi Minchan,
>> >
>> >
>> > In the below snippet
>> >
>> > + /* alloc buffer pages */
>> > + for (i = 0; i < pages; i++) {
>> > + if (page->index == start_index + i)
>> > + push_page = page;
>> > + else
>> > + push_page = __page_cache_alloc(gfp_mask);
>> >
>> >
>> > You are adding the allocated page in the inode mapping regardless of
>> > whether
>> > it was already there or not.
>> >
>> > ......
>> > ......
>> >
>> > + if (add_to_page_cache_lru(push_page, mapping,
>> > + start_index + i, gfp_mask)) {
>> >   page_cache_release(push_page);
>> >
>> >
>> >
>> >
>> > 1) My question is what happens to the previous mapped page; in case,
>> > there
>> > already was a mapping to that page and it was uptodate?.
>>
>> add_to_page_cache_lru would fail and the page will be freed by
>> page_cache_release.
>>
>> >
>> > 2.a) Another case occurs for multiple simultaneous squashfs_readpage
>> > calls.
>> > In those cases the page passed in via read_pages should be the one that
>> > needs to be filled and unlocked however since while filling cache entry
>> > only
>> > a single squashfs_readpage would actually fill data the rest of the
>> > processes waiting for the entry to be filled wouldn't get the page they
>> > sent
>> > in. [Correct?]
>> >
>> > 2.b) Wouldn't that result in a non updated page to be returned to the
>> > process which would result in EIO?
>> >
>> > 2.c) But on subsequent calls it would get the freshly allocated page
>> > which
>> > you added above in page cache.[Correct?]
>>
>> I couldn't understand your questions. Could you elaborate on a bit?
>> Anyway, it seem you worry about race by several sources for readahead.
>> Thing is add_to_page_cache_lru which will prevent the race and free pages.
>>
>> Thanks for the review!
>>
>> >
>> >
>> >
>> > Regards,
>> > Chintu
>> >
>> >
>>
>>
>>
>> --
>> Kind regards,
>> Minchan Kim
>
>



-- 
Kind regards,
Minchan Kim
