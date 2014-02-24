Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBXJfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:35:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaBXJfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:35:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and family
Date: Mon, 24 Feb 2014 10:35:09 +0100
Message-ID: <22118516.b9uAkaIibl@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140224084437.GG20680@thin>
References: <20140222192325.GA12587@thin> <201402240902.35977.arnd@arndb.de> <20140224084437.GG20680@thin>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:S8RsvwpAaDraVXkJRE8+lSMIeRb0XQQlTyx649YdR/C
 31QI5USgwm1y7UzfXZfmvz1GvtJt+b+Gt6pnLSNKBXaTl8J6z/
 bMloNm6zATFrlk18J270D9ZQvLWkJby4t6IXCBJaBdHYQUWMcy
 FSfOm3LBplkz2wDFhhU2BysuengDX7PiGWbBJpfS/lMa4Sowig
 KPxC9A7Pjc+snvOyaf6dAr14AamFJpM6G9DuESqalf9YzUa2hR
 U0f0HCw8C0ih03jB0GndDcmS3zdbBlfjAXpTySKvVzKOqv95RX
 FJl8lpVVYneImBakI5XgOG/IDoRrVmlGhBszKyR4cFKte+T2eG
 nHO36kt11w9seWLHpKjs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 February 2014 00:44:37 Josh Triplett wrote:
> 
> I agree that allowing BUG() to become a no-op seems suboptimal, if only
> because of the resulting warnings and mis-optimizations.  However, I
> think the overhead could be cut down massively, such that BUG() just
> compiles down to a one-byte undefined instruction.  (__builtin_trap()
> might do the right thing here; worth checking.)

__builtin_trap() sounds great. Is that available on all supported
architectures and gcc versions?

> In any case, while I agree that the change you're proposing seems
> reasonable, I don't think it should occur as part of this patch.  Do you
> think this patch seems reasonable, and that further patches could occur
> on top of it for the behavior you describe?

Yes, that's probably fine. I was hoping I could get you to address
both issues at once, but they are really different as you say, and
I'm pretty sure that applying my patch wouldn't change much regarding
the benifit of yours in terms of object code size changes.

One thing that would make it slightly easier for me later though:

> +#define WARN_ON_ONCE(condition) WARN_ON(condition)
> +#define WARN_ONCE(condition, format...) WARN_ON(condition)
> +#define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
> +#define WARN_TAINT_ONCE(condition, taint, format...) WARN_ON(condition)

Can you change those that come with a format to call WARN() rather than
WARN_ON()?

> > FWIW, there is an easy extension to this to get rid of some "unused variable"
> > warnings, but using the format string in an unreachable part of the macro,
> > as I did in my patch (but didn't explain there):
> > 
> > @@ -125,6 +126,8 @@ extern void warn_slowpath_null(const char *file, const int line);
> >  #ifndef WARN
> >  #define WARN(condition, format...) ({					\
> >  	int __ret_warn_on = !!(condition);				\
> > +	if (0 && (__ret_warn_on))					\
> > +		printk(format);						\
> >  	unlikely(__ret_warn_on);					\
> >  })
> >  #endif
> 
> This seems better done via no_printk, but yes, that seems sensible.
> The arguments should be used too.
> 
> (But again, I'm not actually changing these in this patch; diff just
> thinks I'm moving them.)

I understand. It's also unrelated to what I was doing in my patch.
Do you mind adding a second patch on top of yours to do no_printk()
here? It's a trivial change and since you're touching that code already
I think it makes sense to keep it with your series, even if it comes
as a second patch.

	Arnd
