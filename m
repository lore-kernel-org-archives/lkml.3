Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab3GDRKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 13:10:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:51941 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3GDRKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 13:10:14 -0400
Date: Thu, 4 Jul 2013 13:09:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Joe Perches <joe@perches.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 4/4] checkpatch: only allow COMPILE_TEST in Kconfig
 dependency lines
Message-ID: <20130704170958.GM22702@windriver.com>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
 <1372916353-24050-5-git-send-email-paul.gortmaker@windriver.com>
 <1372952486.1886.37.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1372952486.1886.37.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH 4/4] checkpatch: only allow COMPILE_TEST in Kconfig dependency lines] On 04/07/2013 (Thu 08:41) Joe Perches wrote:

> On Thu, 2013-07-04 at 01:39 -0400, Paul Gortmaker wrote:
> > The option CONFIG_COMPILE_TEST, added in commit 4bb1667255a
> > ("build some drivers only when compile-testing") is meant to
> > give a middle ground[1] between those who want the widest compile
> > coverage possible (e.g. building sparc drivers for mips) and
> > those who want dependencies to represent real world systems
> > (e.g. don't allow me to see OMAP options when building x86).
> > 
> > As such, this addition is meant to be used in dependency lines,
> > properly or'd in with the real world hardware dependency.  Those
> > who select it, get wide compile coverage.  Those who do not, get
> > real world dependencies that match where the hardware is available
> > and/or where the driver is useful.
> > 
> > With that in mind, it is clear that this is _not_ to be used in
> > any C code with "#ifdef CONFIG_COMPILE_TEST" etc.  However there
> > will (and already has been) instances of people thinking this is
> > an OK practice[2].  So teach checkpatch to spot them as an error.
> > 
> > [1] https://lkml.org/lkml/2013/3/7/456
> > [2] https://lkml.org/lkml/2013/7/1/641
> > 
> > Cc: Joe Perches <joe@perches.com>
> > Cc: Andy Whitcroft <apw@canonical.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Jiri Slaby <jslaby@suse.cz>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > ---
> >  scripts/checkpatch.pl | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index b954de5..c0871a3 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -1922,6 +1922,12 @@ sub process {
> >  			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
> >  		}
> >  
> > +# disallow the addition of CONFIG_COMPILE_TEST in #if(def).
> > +		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_COMPILE_TEST\b/) {
> > +			ERROR("CONFIG_COMPILE_TEST",
> > +			     "Use of COMPILE_TEST is only allowed in Kconfig dependency lines.\n");
> 
> Why not just look for \bCONFIG_COMPILE_TEST\b?
> 
> I see it's the same style as the CONFIG_EXPERIMENTAL above it,
> but perhaps code could be written like

That is exactly why.  I valued consistency and the fact that this was
already a tested and working check, vs. me reinventing my own and then
having a "Oh crap, I never thought of that false positive" moment.

I'd suggest leaving it consistent with the existing solution as lowest
risk and then later (post 3.11) you could come along and recode all
similar instances to increase their scope if you really wanted to.

P.
--

> 
> #if defined CONFIG_FOO || \
>     defined CONFIG_BAR
> 
> and this wouldn't trigger.
> 
> 
