Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab3LUCab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:30:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3LUCaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:30:30 -0500
Date: Fri, 20 Dec 2013 21:33:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, P J P <ppandit@redhat.com>,
        Jan Beulich <JBeulich@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Broken initrd compression settings in 3.13
Message-ID: <20131220213321.32d59343@corrin.poochiereds.net>
In-Reply-To: <CA+55aFwwXKAs0dyJJ2FAcJj-okqqLYQsPsSask1p_nXvyrtWXw@mail.gmail.com>
References: <CA+55aFzYZEmNEHQVgWS6usVnDVi-8ar7ZzP+eUGrqoO2OP66kA@mail.gmail.com>
	<20131220173935.0812cc4e.akpm@linux-foundation.org>
	<CA+55aFwwXKAs0dyJJ2FAcJj-okqqLYQsPsSask1p_nXvyrtWXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013 18:15:29 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Dec 20, 2013 at 5:39 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Fri, 20 Dec 2013 16:41:43 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >>
> >>  (a) most sane people don't even have lz4 _installed_, so dracut won't
> >> actually succeed
> >>
> >>  (b) there's no way to select the compression level (unlike the
> >> INITRAMFS_COMPRESSION thing that actually has a choice)
> >>
> >>  (c) even if you *do* have lz4, it doesn't actually work, because
> >> while that causes the new F20 dracut to compress the initramfs with
> >> lz4, the end result is completely broken, because the F20 "lsinitrd"
> >> scripts don't understand the end result, so now the whole kernel
> >> install fails.
> >>
> >> (a) and (b) are very much kernel bugs.
> >
> > Jeff sent the below this morning.  Will that fix (a)?
> 
> Yes, it fixes (a), at least to some degree, in that at least
> defaulting to bzip2 is a lot more sane than defaulting to lz4. I
> suspect most everybody has bzip2 installed. And at least on my current
> F20 install, it looks like lsinitrd understands to use zcat, bzcat or
> xzcat on the resulting initrd image (and bzcat does that bzip2
> decoding).
> 
> So I think Jeff's patch at least fixes the symptoms.
> 
> That said, I think it does nothing *but* fix the symptoms, and we're
> actually still better off with the 3.12 behavior which was to never
> set INITRD_COMPRESS at all. Because quite frankly, there's currently
> no way for the kernel to know what the right compressor is. bz2 may
> well work, but can you guarantee it? I certainly can't..
> 
> Now, if we asked the user, that would be a different thing. But right
> now we very much don't ask the user, and we just pick one at random.
> 
> We're better off not picking a compression method at all, at which
> point the distro "installkernel" will do whatever the distro does.
> 
>             Linus

Perhaps a better solution for this would be to instead export an
env var with a list of the compression algorithms that the kernel
supports. Then installkernel or dracut could use that info to make a
semi-intelligent decision based on that and what tools are installed.

...or maybe a separate env var for each one that it supports:

    $INITRD_COMPRESS_LZ4
    $INITRD_COMPRESS_BZIP2
    $INITRD_COMPRESS_GZIP

...etc.

-- 
Jeff Layton <jlayton@redhat.com>
