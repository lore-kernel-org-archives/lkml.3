Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbaEMOg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:36:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:35061 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760213AbaEMOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:36:55 -0400
Date: Tue, 13 May 2014 16:37:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, Ley Foon Tan <lftan@altera.com>,
        James Hogan <james.hogan@imgtec.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
In-Reply-To: <6047893.vbvIgNOHCV@wuerfel>
Message-ID: <alpine.DEB.2.02.1405131625520.6261@ionos.tec.linutronix.de>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <alpine.DEB.2.02.1405131405590.6261@ionos.tec.linutronix.de> <CAMuHMdV2NPwacZwP=QRP+d+eFT85jDq9V0F+Q+Hdch3xukpbkw@mail.gmail.com> <6047893.vbvIgNOHCV@wuerfel>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Arnd Bergmann wrote:
> On Tuesday 13 May 2014 15:11:33 Geert Uytterhoeven wrote:
> > On Tue, May 13, 2014 at 2:07 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Tue, 13 May 2014, Arnd Bergmann wrote:
> > >> On Tuesday 13 May 2014 18:17:40 Ley Foon Tan wrote:
> > >> > When we export this posix_types.h file for user software, they need to
> > >> > define this config, eg: CONFIG_32BIT_TIME to use 32 bit time. Is this
> > >> > what we want to do?
> > >>
> > >> No, this doesn't really work: You can't use CONFIG_* symbols in
> > >> user-visible header files.
> > >
> > > Then make the config symbol generate the header from a template.
> > 
> > Indeed. I think it's worthwhile to add CONFIG_* expansion for such "hard"
> > CONFIG symbols to make headers_install, cfr. the existing unifdef support.
> > 
> > We do such a hard work to improve asm-generic, so new architectures can
> > just use that, only to see early adaptors now having to migrate away from it
> > (e.g. OpenRISC suddenly gaining uapi/asm/posix_types.h).
> 
> This was always the idea: New architectures should use the default ABI
> as it is defined at the time when they get added. When we later change
> the ABI, everything that is already there is no longer using the default,
> so they now have to change.
>  
> > Or is there another solution?
> 
> We could in theory have a versioned ABI, and define for instance that
> openrisc uses the 3.1 version while nios2 uses the 3.16 version.
> 
> Doing that would introduce other problems I guess, but it would
> avoid the use of changing lots of architectures when the default
> ABI changes.

The most simple solution is to use the existing unifdef machinery for
the export version and make the #ifdef maze use CONFIG_ARCH_XXX. For
the simple architectures you just need the CONFIG_ARCH_NAME, for such
which support 32 and 64 or some more ABI versions you need to look for
a matching one or a combination of several config options.

You even can combine that with versioning:

#ifdef CONFIG_ARCH_OPENRISC
# include <asm-generic/hdr-v31.h>
#endif

That gives you a nice history in a single place and avoids updating
the world and some when you change stuff.

Hmm?

	tglx
