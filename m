Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaBYDGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:06:42 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34104 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaBYDGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:06:40 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 24 Feb 2014 19:06:30 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and
 family
Message-ID: <20140225030630.GA28013@thin>
References: <20140222192325.GA12587@thin>
 <201402240902.35977.arnd@arndb.de>
 <20140224151758.b06125f6ddef2086d2b2a969@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224151758.b06125f6ddef2086d2b2a969@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 03:17:58PM -0800, Andrew Morton wrote:
> On Mon, 24 Feb 2014 09:02:35 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Saturday 22 February 2014, Josh Triplett wrote:
> > > When !CONFIG_BUG, WARN_ON and family become simple passthroughs of their
> > > condition argument; however, WARN_ON_ONCE and family still have
> > > conditions and a boolean to detect one-time invocation, even though the
> > > warning they'd emit doesn't exist.  Make the existing definitions
> > > conditional on CONFIG_BUG, and map them all to the passthrough WARN_ON
> > > when !CONFIG_BUG.
> > > 
> > > This saves 4.4k on a minimized configuration (smaller than
> > > allnoconfig), and 20.6k with defconfig plus CONFIG_BUG=n.
> > 
> > This looks good, but it reminds me of a patch that I did a while ago
> > and that got lost while I was on leave:
> > 
> > > +#else /* !CONFIG_BUG */
> > > +#ifndef HAVE_ARCH_BUG
> > > +#define BUG() do {} while(0)
> > > +#endif
> > > +
> > > +#ifndef HAVE_ARCH_BUG_ON
> > > +#define BUG_ON(condition) do { if (condition) ; } while(0)
> > > +#endif
> > 
> > I've done some analysis of this before[1] and came to the conclusion that
> > this definition (which I realize you are not changing) is bad.
> > 
> > For one thing, it will cause lots of gcc warnings about code that
> > should have been unreachable being compiled. It also causes
> > misoptimizations for code that should be detected as unused or
> > (worse) lets us run into undefined behavior if we ever get into
> > the BUG() case.
> > 
> > This means we actually want BUG() to end with __builtin_unreachable()
> > as in the CONFIG_BUG=y case, and also ensure it actually is
> > unreachable. As I have shown in [1], the there is a small overhead
> > of doing this in terms of code size.
> 
> CONFIG_BUG=n causes all sorts of stupid problems.
> 
> And as kernel developers we don't *want* people disabling BUG - it
> reduces our ability to detect and fix stuff and it adds all sorts of
> hard-to-maintain nobody-tests-it things like this.

I think Arnd's approach addresses this case nicely: do away with the
message, keep something isomorphic to a messageless panic.  And ideally
that could be reduced to a one-byte undefined instruction potentially
wrapped in a conditional.

> So...  how about we just do away with CONFIG_BUG?
> 
> - Do we know of anyone who is really using this and to good effect?

I'm using it, or I wouldn't have submitted the patch.

If you're on a system with no output whatsoever, the kind of system
where CONFIG_PRINTK=n makes sense, then CONFIG_BUG=n also makes sense.
That said, I completely understand and agree with Arnd's argument that
BUG should still compile to a panic-equivalent, rather than allowing
execution to continue from that point and thus allow undefined behavior.
A reboot is preferable.

So, is it CONFIG_BUG=n you're objecting to, or just the current
implementation of it in which BUG() becomes a no-op rather than a
messageless panic?

- Josh Triplett
