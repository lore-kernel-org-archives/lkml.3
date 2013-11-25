Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3KYKWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:22:45 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53802 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab3KYKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:22:40 -0500
Message-ID: <1385374955.2354.24.camel@dabdike>
Subject: Re: [PATCH 08/24] parisc/uapi: Use Kbuild logic to provide
 <asm/types.h>
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Parisc List <linux-parisc@vger.kernel.org>
Date: Mon, 25 Nov 2013 14:22:35 +0400
In-Reply-To: <CAMuHMdUV4R0BK-eKkXeDD9B0pRLJjziUkvXZVvfWmuaK=dv9Mg@mail.gmail.com>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
	 <1385369734-24893-9-git-send-email-geert@linux-m68k.org>
	 <1385373313.2354.16.camel@dabdike>
	 <CAMuHMdUV4R0BK-eKkXeDD9B0pRLJjziUkvXZVvfWmuaK=dv9Mg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 11:12 +0100, Geert Uytterhoeven wrote:
> On Mon, Nov 25, 2013 at 10:55 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Mon, 2013-11-25 at 09:55 +0100, Geert Uytterhoeven wrote:
> >> Uapi <asm-generic/types.h> just includes <asm-generic/int-ll64.h>
> >
> > This really doesn't look like a good idea:  Firstly the default of
> > asm-generic/types.h should *not* be int-ll64, because that's for 32 bit
> > only and most processors are moving towards 64 bit.  Secondly parisc
> 
> In kernelspace, both 32 and 64 bit are ll64.

Not necessarily; the files exist because of variations in gcc.  Some
versions of gcc have long long being 128 bits and for those you have to
use int-l64.h

> > currently only has a 32 bit userspace, which is why the file is a simple
> > include of int-ll64.h; however, people are working on 64 bit userspace
> 
> Sorry, I didn't know you support 32 bit userspace only.
> 
> > (albeit very slowly) and that file would then have to change.  If we
> > take the file away someone will forget to add the changed file back.
> 
> However, is this a "new" 64 bit userspace ABI? If yes, you may want to
> consider using ll64 in userspace on 64 bit too, like all "new" 64 bit ports
> do (arm64, s390, sparc, tile, x86). Only legacy alpha, ia64, mips and
> old ppc use l64.
> 
> Or follow the ppc64 road:
> 
> /*
>  * This is here because we used to use l64 for 64bit powerpc
>  * and we don't want to impact user mode with our change to ll64
>  * in the kernel.
>  *
>  * However, some user programs are fine with this.  They can
>  * flag __SANE_USERSPACE_TYPES__ to get int-ll64.h here.
>  */
> #ifndef __KERNEL__
> #if !defined(__SANE_USERSPACE_TYPES__) && defined(__powerpc64__)
> # include <asm-generic/int-l64.h>
> #else
> # include <asm-generic/int-ll64.h>
> #endif
> #endif

That's the one I was thinking we might need.

James


