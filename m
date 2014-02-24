Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaBXXSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:18:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaBXXSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:18:00 -0500
Date: Mon, 24 Feb 2014 15:17:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and
 family
Message-Id: <20140224151758.b06125f6ddef2086d2b2a969@linux-foundation.org>
In-Reply-To: <201402240902.35977.arnd@arndb.de>
References: <20140222192325.GA12587@thin>
	<201402240902.35977.arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 09:02:35 +0100 Arnd Bergmann <arnd@arndb.de> wrote:

> On Saturday 22 February 2014, Josh Triplett wrote:
> > When !CONFIG_BUG, WARN_ON and family become simple passthroughs of their
> > condition argument; however, WARN_ON_ONCE and family still have
> > conditions and a boolean to detect one-time invocation, even though the
> > warning they'd emit doesn't exist.  Make the existing definitions
> > conditional on CONFIG_BUG, and map them all to the passthrough WARN_ON
> > when !CONFIG_BUG.
> > 
> > This saves 4.4k on a minimized configuration (smaller than
> > allnoconfig), and 20.6k with defconfig plus CONFIG_BUG=n.
> 
> This looks good, but it reminds me of a patch that I did a while ago
> and that got lost while I was on leave:
> 
> > +#else /* !CONFIG_BUG */
> > +#ifndef HAVE_ARCH_BUG
> > +#define BUG() do {} while(0)
> > +#endif
> > +
> > +#ifndef HAVE_ARCH_BUG_ON
> > +#define BUG_ON(condition) do { if (condition) ; } while(0)
> > +#endif
> 
> I've done some analysis of this before[1] and came to the conclusion that
> this definition (which I realize you are not changing) is bad.
> 
> For one thing, it will cause lots of gcc warnings about code that
> should have been unreachable being compiled. It also causes
> misoptimizations for code that should be detected as unused or
> (worse) lets us run into undefined behavior if we ever get into
> the BUG() case.
> 
> This means we actually want BUG() to end with __builtin_unreachable()
> as in the CONFIG_BUG=y case, and also ensure it actually is
> unreachable. As I have shown in [1], the there is a small overhead
> of doing this in terms of code size.

CONFIG_BUG=n causes all sorts of stupid problems.

And as kernel developers we don't *want* people disabling BUG - it
reduces our ability to detect and fix stuff and it adds all sorts of
hard-to-maintain nobody-tests-it things like this.

So...  how about we just do away with CONFIG_BUG?

- Do we know of anyone who is really using this and to good effect?

- Is their use case important/valuable enough for us to continue bothering?

