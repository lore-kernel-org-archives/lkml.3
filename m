Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaBXIos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:44:48 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35425 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXIoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:44:46 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 24 Feb 2014 00:44:37 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and
 family
Message-ID: <20140224084437.GG20680@thin>
References: <20140222192325.GA12587@thin>
 <201402240902.35977.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402240902.35977.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 09:02:35AM +0100, Arnd Bergmann wrote:
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

I agree that allowing BUG() to become a no-op seems suboptimal, if only
because of the resulting warnings and mis-optimizations.  However, I
think the overhead could be cut down massively, such that BUG() just
compiles down to a one-byte undefined instruction.  (__builtin_trap()
might do the right thing here; worth checking.)

That said, I think there's still a reasonable argument to be made for
allowing it to be cut down to just __builtin_unreachable() without a
trap, for much the same reason that noreturn doesn't generate code
expecting the function to return.  A one-byte undefined instruction
isn't that bad, but that also means BUG_ON has to generate the
conditional and the conditional jump around that instruction.

(Consider the reasoning behind CONFIG_DOUBLEFAULT, and its Kconfig help
text.)

On the other hand, it's also a good argument for converting far more
BUGs to WARNs and BUG_ONs to WARN_ONs.

In any case, while I agree that the change you're proposing seems
reasonable, I don't think it should occur as part of this patch.  Do you
think this patch seems reasonable, and that further patches could occur
on top of it for the behavior you describe?

> > +#ifndef HAVE_ARCH_WARN_ON
> > +#define WARN_ON(condition) ({						\
> > +	int __ret_warn_on = !!(condition);				\
> > +	unlikely(__ret_warn_on);					\
> > +})
> > +#endif
> > +
> > +#ifndef WARN
> > +#define WARN(condition, format...) ({					\
> > +	int __ret_warn_on = !!(condition);				\
> > +	unlikely(__ret_warn_on);					\
> > +})
> > +#endif
> 
> FWIW, there is an easy extension to this to get rid of some "unused variable"
> warnings, but using the format string in an unreachable part of the macro,
> as I did in my patch (but didn't explain there):
> 
> @@ -125,6 +126,8 @@ extern void warn_slowpath_null(const char *file, const int line);
>  #ifndef WARN
>  #define WARN(condition, format...) ({					\
>  	int __ret_warn_on = !!(condition);				\
> +	if (0 && (__ret_warn_on))					\
> +		printk(format);						\
>  	unlikely(__ret_warn_on);					\
>  })
>  #endif

This seems better done via no_printk, but yes, that seems sensible.
The arguments should be used too.

(But again, I'm not actually changing these in this patch; diff just
thinks I'm moving them.)

- Josh Triplett
