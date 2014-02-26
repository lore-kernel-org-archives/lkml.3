Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaBZO6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:58:16 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52423 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaBZO6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:58:14 -0500
X-Originating-IP: 50.43.14.201
Date: Wed, 26 Feb 2014 06:58:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] bug: Make BUG() call unreachable()
Message-ID: <20140226145806.GA24150@thin>
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
 <d97712e037ea4c90e9cb30c56229383d257831de.1393385236.git.josh@joshtriplett.org>
 <201402261429.06553.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402261429.06553.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:29:06PM +0100, Arnd Bergmann wrote:
> On Wednesday 26 February 2014, Josh Triplett wrote:
> > @@ -134,7 +134,7 @@ extern void warn_slowpath_null(const char *file, const int line);
> >  
> >  #else /* !CONFIG_BUG */
> >  #ifndef HAVE_ARCH_BUG
> > -#define BUG() do {} while (0)
> > +#define BUG() do { unreachable(); } while (0)
> >  #endif
> 
> I disagree with this one. As Alan said, we really want to use an
> arch specific BUG() even in the !CONFIG_BUG case.

Possibly, but when doing so on an arch-by-arch basis, we'd need to make
sure that either there's a sensible trap handler for whatever trap it
invokes (for instance, ud2), or that there's some kind of useful
behavior otherwise (for instance, a reboot).  Hence why I didn't make
any attempt to add architecture-specific patches in this series.

In any case, I tried a quick test of that on x86 below, along with the
generic equivalent.

> For the cases where this is not yet possible, I'd suggest using
> 
> #define BUG() do { } while (1)

I just tested this, and:

$ scripts/bloat-o-meter vmlinux-nobug-base vmlinux-nobug-loop
add/remove: 2/1 grow/shrink: 247/33 up/down: 5461/-604 (4857)

In particular:

$ scripts/bloat-o-meter vmlinux-nobug-unreachable vmlinux-nobug-loop
add/remove: 6/0 grow/shrink: 261/9 up/down: 5679/-64 (5615)

So, some functions do get the optimizations from GCC treating the code
after an infinite loop as unreachable, but overall the infinite loops
themselves (and the conditionals around them in the more common case of
BUG_ON) are non-trivially large.

I tried a quick hack that used:
#define BUG() do { asm("ud2"); unreachable(); } while (0)
in place of the infinite loop, and got:

$ scripts/bloat-o-meter vmlinux-nobug-base vmlinux-nobug-ud2-unreachable
add/remove: 2/1 grow/shrink: 250/37 up/down: 4874/-606 (4268)

So, very little savings there compared to the infinite loop (unsurprising,
since ud2 is two bytes, and so is "1: jmp 1b").

This doesn't seem any different than compiling out assert() at runtime
in a userspace program, given how the kernel uses BUG() and BUG_ON().
I'd argue that adding unreachable() doesn't seem like it makes the
current implementation of BUG() any worse; either way if you reach it
you have a problem.

- Josh Triplett
