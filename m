Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3GDPli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 11:41:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53712 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756729Ab3GDPl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 11:41:27 -0400
Message-ID: <1372952486.1886.37.camel@joe-AO722>
Subject: Re: [PATCH 4/4] checkpatch: only allow COMPILE_TEST in Kconfig
 dependency lines
From: Joe Perches <joe@perches.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 04 Jul 2013 08:41:26 -0700
In-Reply-To: <1372916353-24050-5-git-send-email-paul.gortmaker@windriver.com>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
	 <1372916353-24050-5-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-04 at 01:39 -0400, Paul Gortmaker wrote:
> The option CONFIG_COMPILE_TEST, added in commit 4bb1667255a
> ("build some drivers only when compile-testing") is meant to
> give a middle ground[1] between those who want the widest compile
> coverage possible (e.g. building sparc drivers for mips) and
> those who want dependencies to represent real world systems
> (e.g. don't allow me to see OMAP options when building x86).
> 
> As such, this addition is meant to be used in dependency lines,
> properly or'd in with the real world hardware dependency.  Those
> who select it, get wide compile coverage.  Those who do not, get
> real world dependencies that match where the hardware is available
> and/or where the driver is useful.
> 
> With that in mind, it is clear that this is _not_ to be used in
> any C code with "#ifdef CONFIG_COMPILE_TEST" etc.  However there
> will (and already has been) instances of people thinking this is
> an OK practice[2].  So teach checkpatch to spot them as an error.
> 
> [1] https://lkml.org/lkml/2013/3/7/456
> [2] https://lkml.org/lkml/2013/7/1/641
> 
> Cc: Joe Perches <joe@perches.com>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  scripts/checkpatch.pl | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b954de5..c0871a3 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1922,6 +1922,12 @@ sub process {
>  			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
>  		}
>  
> +# disallow the addition of CONFIG_COMPILE_TEST in #if(def).
> +		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_COMPILE_TEST\b/) {
> +			ERROR("CONFIG_COMPILE_TEST",
> +			     "Use of COMPILE_TEST is only allowed in Kconfig dependency lines.\n");

Why not just look for \bCONFIG_COMPILE_TEST\b?

I see it's the same style as the CONFIG_EXPERIMENTAL above it,
but perhaps code could be written like

#if defined CONFIG_FOO || \
    defined CONFIG_BAR

and this wouldn't trigger.


