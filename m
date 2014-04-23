Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaDWPH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:07:28 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:44928 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544AbaDWPHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:07:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140423144901.GA24220@redhat.com>
References: <20140422180308.GA19038@redhat.com>
	<CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com>
	<alpine.LSU.2.11.1404221303060.6220@eggly.anvils>
	<20140423144901.GA24220@redhat.com>
Date: Wed, 23 Apr 2014 08:07:16 -0700
X-Google-Sender-Auth: MztCJWMfkywAlq14FuLZoF-425Q
Message-ID: <CA+55aFziPHmSP5yjxDP6h_hRY-H2VgWZKsqC7w8+B9d9wXqn6Q@mail.gmail.com>
Subject: Re: 3.15rc2 hanging processes on exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 7:49 AM, Dave Jones <davej@redhat.com> wrote:
>
> So for reasons I can't figure out, I've not been able to hit it on 3.14
> The only 'interesting' thing I've hit in overnight testing is this, which
> I'm not sure if I've also seen in my .15rc testing, but it doesn't look
> familiar to me.  (Though the vm oopses I've seen the last few months
> are starting to all blur together in my memory)
>
>
> kernel BUG at mm/mlock.c:82!

That's

  mlock_vma_page:
    BUG_ON(!PageLocked(page));

which is odd, because:

> Call Trace:
>  [<ffffffffbe196612>] try_to_unmap_nonlinear+0x2a2/0x530
>  [<ffffffffbe1972a7>] rmap_walk+0x157/0x320
>  [<ffffffffbe1976e3>] try_to_unmap+0x93/0xf0
>  [<ffffffffbe1bb8f6>] migrate_pages+0x3b6/0x7b0

All the calls to "try_to_unmap()" in mm/migrate.c are preceded by the pattern

        if (!trylock_page(page)) {
                 ....
                lock_page(page);
        }

where there are just a few "goto out" style cases for the "ok, we're
not going to wait for this page lock" in there.

Very odd.  Does anybody see anything I missed?

              Linus
