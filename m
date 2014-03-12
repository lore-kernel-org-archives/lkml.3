Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaCLPqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:46:34 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:50993 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbaCLPqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
	<CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
	<CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
	<CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
	<CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
	<CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
	<CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com>
	<CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>
	<531F365B.4060000@linux.intel.com>
	<CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com>
	<531F3D02.30706@linux.intel.com>
	<CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com>
	<CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com>
	<CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
	<1394613046.995.51.camel@wall-e.seibold.net>
	<CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com>
Date: Wed, 12 Mar 2014 08:46:30 -0700
X-Google-Sender-Auth: RUB-vW7QnHO9gxbWg19hg5PkRb0
Message-ID: <CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 7:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Nobody has even explained why we want this at all, and why we want
> this headache. Nobody has explained why the solution is not to "just
> don't do that then". Instead, people are piling up *more* complexity
> because the patch had a problem.
>
> That's a technical issue, Stefani. And the threat to not apply patches
> is a technical solution, and I'm getting more and more convinced is
> the *right* technical solution.

.. which is not to say that there aren't possible ways forward.

But quite frankly, I do *not* believe that the way forward is "let's
pile on more complexity to hide the problems this patch caused".

And I absolutely do *not* believe that it is a good idea to make big
fundamental changes to x86-32 that may have lots of legacy users (and
potential embedded future users), but that new installations and
developers have largely left behind.

So I'd very strongly suggest that people go back to square one, and
look at the original patch that caused the problem. There's two
issues:

 - the fact that it grows the code sufficiently that our single-page
approach doesn't work under certain (unusual) configurations

   This is the obvious problem and the thing that people seem to have
worked most on. I don't think it's right to be so eager to work around
the problem, when presumably it should be straightforward to make the
damn code smaller in the first place.

 - the patch really is ugly, and already adds random stuff to map the
vvar/hpet pages into user memory, using absolutely disgusting code.

So quite frankly, if I had looked at that patch *before* hearing of
the size issues, I would personally still have NAK'ed it. The games it
plays are just nasty.

Having looked at it a bit more, I think the correct solution is:

 - leave the legacy compat-vdso FIXMAP entry at a single page

 - do *not* add the HPET/VVAR page games to the legacy case. Get rid
of the remap_pfn_pages() games entirely.

 - do the new thing only for the non-compat case, where we can just
use the "vdso_pages[]" array and not play any games.

IOW, just cut the cord. Separate out the legacy one-page FIXMAP case.
Get rid of the magic pfn_remap stuff entirely. It was ugly and it was
a mistake.

Hmm? That way, people can use the vdso and it really looks the same
between x86-32 and -64, and we can leave the legacy fixmap case alone.
Don't touch it.

But I think that "x86, vdso: Add 32 bit VDSO time support for 32 bit
kernel" patch needs to die. And the helper patches building up to it
(just because that patch used [io_]remap_pfn_range()) should die too.
Why weren't those pages in the vdso*_pages[] array anyway?

              Linus
