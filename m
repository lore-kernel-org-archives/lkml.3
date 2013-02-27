Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3B0Vd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:33:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3B0Vdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:33:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECK
Date: Wed, 27 Feb 2013 21:33:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Metcalf <cmetcalf@tilera.com>
References: <1361934016-22630-1-git-send-email-sboyd@codeaurora.org> <201302272032.21014.arnd@arndb.de> <512E6FA9.4060504@codeaurora.org>
In-Reply-To: <512E6FA9.4060504@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302272133.27466.arnd@arndb.de>
X-Provags-ID: V02:K0:S+7V5DEm8QwC/NY9prAR3Y4stz9L2LIFd42V2ORiBhs
 Tiw/SS6EJBc7xkB+nhjBxn1x70S9iHvDcBDnlSrOGqrxvmJyh9
 Rt5rUoJ0iqqCmS5JZQePCtU865jdMZKgdEv3zWcGhJLfqVuKtQ
 PdSyS5ylConMTjJN3uCQ28EfctJpZfmQEm66XrDm0M4a4l5x8o
 guW4RZDnyw0mGfbvJMsqpf+uqe6MZVaYW2PnQzokdhv0wKlqBy
 InN3wUG0VWtVthfxGggERvBpIONiRetOIFdf0eeEfzE7MoCF3L
 /utJtIufH2uOSofvc+PzbU9JBgQG8eJ9UIzI1/DNaQunbCrBpI
 942nUiSxjdJTkrxcZyL4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2013, Stephen Boyd wrote:
> On 02/27/13 12:32, Arnd Bergmann wrote:
> > On Wednesday 27 February 2013, Stephen Boyd wrote:
> >> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> >> index 28be08c..ae80518 100644
> >> --- a/lib/Kconfig.debug
> >> +++ b/lib/Kconfig.debug
> >> @@ -1292,6 +1292,24 @@ config LATENCYTOP
> >>  	  Enable this option if you want to use the LatencyTOP tool
> >>  	  to find out which userspace is blocking on what kernel operations.
> >>  
> >> +config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
> >> +	bool
> >> +
> >> +config DEBUG_STRICT_USER_COPY_CHECKS
> >> +	bool "Strict user copy size checks"
> >> +	depends on ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
> >> +	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
> >> +	help
> >> +	  Enabling this option turns a certain set of sanity checks for user
> >> +	  copy operations into compile time failures.
> >> +
> >> +	  The copy_from_user() etc checks are there to help test if there
> >> +	  are sufficient security checks on the length argument of
> >> +	  the copy operation, by having gcc prove that the argument is
> >> +	  within bounds.
> >> +
> >> +	  If unsure, say N.
> >> +
> > Is there actually any architecture dependency left after this?
> > I wonder if we actually need the ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
> > symbol, or could just show the DEBUG_STRICT_USER_COPY_CHECKS option
> > on all architectures.
> >
> > It's fine to do your patch as a first step though, which would not
> > change the behavior.
> 
> A lot of arches seem to not want to enable it because false positives
> are everywhere. It really depends on how good the compiler is at doing
> constant propagation and dead code removal.

Ok, I see. Of course they would not need to enable that option, but
I guess if we know that enabling it doesn't work, there is no point
in providing the option.

> >>  
> >> +lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
> >>  lib-$(CONFIG_MMU) += ioremap.o
> >>  lib-$(CONFIG_SMP) += cpumask.o
> >>
> > I think this should instead be
> >
> > +lib-$(DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
> >
> > No point building that file if we are not using it.
> 
> We still need it to link the kernel because the callers of the function
> don't have ifdefs. Also, all arches were doing an obj-y before, so this
> is equivalent.

Ok.

	Arnd
