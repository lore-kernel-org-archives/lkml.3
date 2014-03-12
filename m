Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaCLQSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:18:45 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:62955 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaCLQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
 <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
 <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
 <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
 <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
 <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
 <CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com>
 <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>
 <531F365B.4060000@linux.intel.com> <CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com>
 <531F3D02.30706@linux.intel.com> <CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com>
 <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com>
 <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
 <1394613046.995.51.camel@wall-e.seibold.net> <CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com>
 <CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 09:18:22 -0700
Message-ID: <CALCETrUjSDEejWmD9UC=Wp=bFFd8M03tAQajSJo2bpusBDzzbQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 8:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 12, 2014 at 7:41 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>
> Having looked at it a bit more, I think the correct solution is:
>
>  - leave the legacy compat-vdso FIXMAP entry at a single page
>
>  - do *not* add the HPET/VVAR page games to the legacy case. Get rid
> of the remap_pfn_pages() games entirely.

If I understand your suggestion right, I you're saying that we
should have two cases:

1. CONFIG_COMPAT_VDSO or vdso32=2: Use a one-page vdso in the fixmap.

2. !CONFIG_COMPAT_VDSO or vdso32=1: Use a multiple-page vdso + vvar
area in a vma (or maybe a couple of vmas).

The current 32-bit vdso is actually three separate .so files, selected
at boot time.  So now we'd need six.  (Yes, this can be reduced to
two.  But still.)  I think I'd prefer:

1. CONFIG_COMPAT_VDSO or vdso32=2: No vdso at all

2. !CONFIG_COMPAT_VDSO or vdso32=1: Use a multiple-page vdso + vvar
area in a vma (or maybe a couple of vmas).

This variant is a *lot* less code, and it avoids the need to generate
a further combinatorial blowup in the number of vdso images that the
kernel builds.  (This is more or less the same thing as my
thoroughly-nakked patch, except with the default flipped.)

The only downside that I can think of is that people who are using
CONFIG_COMPAT_VDSO unnecessarily take a small performance hit.

IOW, I don't think that anyone really wants to support two
implementations of a non-trivial 32-bit vdso.


Re: leaving the hpet and such in the fixmap unconditionally, I'm not
sure I see the advantage.  For one thing, it can't support the compat
case, it's not really clear to me how it fits in with x32, and it
prevents future improvements that involve adjusting those mappings per
process.  Doing it with vmas is IMO not so bad.  (Doing with with vmas
or with fixmaps depending on kernel configuration, on the other hand,
is a mess.)

--Andy
