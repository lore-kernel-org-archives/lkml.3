Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab3KZXQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:16:12 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:59988 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3KZXQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:16:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131126004456.GF19648@hostway.ca>
References: <20130706000949.GD16853@hostway.ca>
	<CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
	<20130819201717.GA23608@hostway.ca>
	<0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
	<CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
	<20130820040648.GG27005@ZenIV.linux.org.uk>
	<CAEcaRjip29P8TdMHF8zJ3zzsQj7o_B9chEz7Q6xH0Bqtw3A-jg@mail.gmail.com>
	<20130820072143.GJ27005@ZenIV.linux.org.uk>
	<CAEcaRjg7GJhEbQoduup6xQKea4Pn4+SOgv8GbbJUeU=xR74dVQ@mail.gmail.com>
	<20131126004456.GF19648@hostway.ca>
Date: Tue, 26 Nov 2013 15:16:09 -0800
X-Google-Sender-Auth: TNXf1MEMxNTYsmxZ-Gjb94vTAiY
Message-ID: <CA+55aFxmVteJApiC5e=d9NmYO6PSbNertq5ipLpunmVreCTYUQ@mail.gmail.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Simon Kirby <sim@hostway.ca>
Cc: Ian Applegate <ia@cloudflare.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 4:44 PM, Simon Kirby <sim@hostway.ca> wrote:
>
> I was hoping this or something else by 3.12 would have fixed it, so after
> testing we deployed this everywhere and turned off the rest of the debug
> options. I missed slub_debug on one server, though...and it just hit
> another case of overwritten poison.

Your thing is *very* consistent, it's once more four bytes into that
pipe-info. And it's once more that exact same "increment second word
in the allocation" pattern.

But the fact that it goes away when you enable other debug options is
really really annoying. It's consistent only if you don't have the
options on that might help us debug it further. Damn.

> Is it true that with slub_debug, aliasing of equal-sized objects is
> turned off, and so they shouldn't be immediately side-by-side? In other
> words, would there be similar scrawling victim chances as allocating
> pipe_inode_info with pages instead of slabs? "slabinfo -a" is empty.

So the thing is, with slub debugging, slub shouldn't be merging
different slab caches.

HOWEVER.

The pipe-info structure isn't using its own slab cache, it's just
using "kmalloc()". So it by definition will merge with all other
kmalloc() allocations of the same size (or, to be exact, of "similar
enough size to hit the same size bucket"). In your case it's the
192-byte-sized bucket.

But all the debugging code talks purely about pipe_info allocations -
both the previous kmalloc/kfree _and_ the kmalloc() that actually sees
the slub debugging error. So if it's mixing with something else, I'm
not seeing what that would be. It would have to be an older allocation
(as it "it got re-allocated to a pipe in between") or another type
that was the similar size.

Which doesn't look all that likely. Not when your problems are so
consistent, and seem to be *always* about that pipe_inode_info.

But dammit, that it such a simple set of allocations. I still don't
see how they could be to blame. And if it's some suspicious access to
the pipe mutex (that second word is still the "wait_lock" spinlock in
the pipe inode mutex) I really would have expected the mutex debugging
to have screamed loudly. Or the DEBUG_PAGEALLOC.

I'm really not very happy with the whole pipe locking logic (or the
refcounting we do, separately from the "struct inode"), and in that
sense I'm perfectly willing to blame that code for doing bad things.
But the fact that it all goes away with debugging makes me very very
unhappy.

                Linus
