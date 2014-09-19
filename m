Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaISBAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:00:35 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:56886 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaISBAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:00:34 -0400
MIME-Version: 1.0
In-Reply-To: <713c7342-bdf4-4e38-8de2-37d840d7028b@email.android.com>
References: <20140918135202.GA26038@khazad-dum.debian.net> <541B2F33.8000002@amacapital.net>
 <20140918145328.0253f009@as> <9c84cde6-3d70-4337-8738-0283d06d8cf0@email.android.com>
 <20140918200659.GA5331@khazad-dum.debian.net> <20140919001311.GB5331@khazad-dum.debian.net>
 <CALCETrVoeqQUXH7g+reu=hUvCJoiy+edHKBqYKPWXPCS3_UtUw@mail.gmail.com> <713c7342-bdf4-4e38-8de2-37d840d7028b@email.android.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 18 Sep 2014 18:00:12 -0700
Message-ID: <CALCETrXaD01bHdpO9F1ukjhWnkusWuQ-M-FcJiqr47vWFUgGsg@mail.gmail.com>
Subject: Re: x86, microcode: BUG: microcode update that changes x86_capability
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 18, 2014 5:28 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> The cpuid bit gets twiddled...

Yes, but how?  I assume that BIOS isn't switching between two
different ucode blobs, and I don't know about any wrcpuid instruction.
So there must be *some* way, at least on new ucode (and maybe on old
ucode) to change that bit.  If we could do that in the kernel, we
might be able to come up with a more intelligent way to handle this
ucode gotcha (such as, ideally, clearing the bit ourselves on old
ucode).

>
> On September 18, 2014 5:23:40 PM PDT, Andy Lutomirski <luto@amacapital.net> wrote:
> >On Sep 18, 2014 5:13 PM, "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
> >wrote:
> >>
> >> On Thu, 18 Sep 2014, Henrique de Moraes Holschuh wrote:
> >> > On Thu, 18 Sep 2014, H. Peter Anvin wrote:
> >> > > We should, but this is also part of why we want the early ucode
> >capability.
> >> >
> >> > Well, yes.  But that won't help the several stable and LTS distros
> >with
> >> > kernels without early ucode update support.
> >>
> >> Here's a plan that might work, pending actually checking the
> >libpthread TSX
> >> code to make sure it keys on /proc/cpuinfo flags:
> >
> >Surely it checks cpuid directly, though.
> >
> >Can we twiddle the cpuid bit?  I never noticed any way in the docs to
> >do it, but if BIOS has such an ability, maybe we do, too.  I wonder if
> >there's anything semi-documented in biosbits, or if we could just
> >reverse-engineer it.
> >
> >--Andy
> >
> >>
> >> Add a cpu quirk, triggered by the Haswell cpuids, to force-disable
> >hle on
> >> the affected processors.
> >>
> >> This will work around the x86_capability capability issue (which
> >should
> >> still be fixed, anyway), and it should also get userspace to stay
> >away from
> >> TSX, therefore also working around the worst issue (processes getting
> >> SIGILL).
> >>
> >> This will disable the "user may ask the BIOS to keep TSX enabled"
> >> anti-feature, though.  This drawback can be avoided, but only if a
> >future
> >> microcode update won't re-disable hle when the BIOS enabled it.  For
> >now, I
> >> suggest that we decree that "hle is toast" for the current Haswells
> >and add
> >> back ways to enable it for testing when we know more about it.
> >>
> >> --
> >>   "One disk to rule them all, One disk to find them. One disk to
> >bring
> >>   them all and in the darkness grind them. In the Land of Redmond
> >>   where the shadows lie." -- The Silicon Valley Tarot
> >>   Henrique Holschuh
>
> --
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.
