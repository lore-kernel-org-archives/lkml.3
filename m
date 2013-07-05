Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab3GEALw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:11:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159Ab3GEALr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:11:47 -0400
Date: Thu, 4 Jul 2013 17:12:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Chen Gang <gang.chen@asianux.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        uml-user <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support
 'COMPILE_TEST' in 'asm-generic'.
Message-ID: <20130705001239.GA20869@kroah.com>
References: <20130704011221.GA11230@kroah.com>
 <20130704061204.GA12148@kroah.com>
 <51D517A7.6030908@asianux.com>
 <201307041125.15083.arnd@arndb.de>
 <51D60D53.7050405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D60D53.7050405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 08:03:31AM +0800, Chen Gang F T wrote:
> On 07/04/2013 05:25 PM, Arnd Bergmann wrote:
> > On Thursday 04 July 2013, Chen Gang wrote:
> > 
> >> > --------------------------patch begin----------------------------------
> >> > 
> >> > 'asm-generic' need provide necessary configuration checking, if can't
> >> > pass checking, 'asm-generic' shouldn't implement it.
> >> > 
> >> > For 'COMPILE_TEST', according to its help contents, 'asm-generic' need
> >> > let it pass configuration checking, and provide related dummy contents
> >> > for it.
> >> > 
> >> > Part of 'COMPLE_TEST' help contents in "init/Kconfig":
> >> > 
> >> >   "...Despite they cannot be loaded there (or even when they load they cannot be used due to missing HW support)..."
> >> > 
> >> > One sample for using 'COMPILE_TEST':
> >> > 
> >> >   'PTP_1588_CLOCK_PCH' in drivers/ptp/Kconfig, which need depend on 'HAS_IOMEM'.
> > Then please submit a patch that adds the 'depends on HAS_IOMEM' line there.
> > That line was clearly left out by accident.
> > 
> 
> Yes, I will send the related patch for it (I have sent one, but that
> seems incorrect, I will send patch v2 for that, after this patch
> finishes discussing).
> 
> But excluding 'PTP_1588_CLOCK_PCH' own issue, it is as a sample for our
> discussion (If "COMPILE_TEST=y", it should can be compiled under the
> archs which no 'HAS_IOMEM').
> 
> 
> >> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> >> > ---
> >> >  include/asm-generic/io.h |   22 ++++++++++++++++++----
> >> >  1 files changed, 18 insertions(+), 4 deletions(-)
> >> > 
> >> > diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> >> > index d5afe96..301ce80 100644
> >> > --- a/include/asm-generic/io.h
> >> > +++ b/include/asm-generic/io.h
> >> > @@ -303,13 +303,18 @@ static inline void *phys_to_virt(unsigned long address)
> >> >  /*
> >> >   * Change "struct page" to physical address.
> >> >   *
> >> > - * This implementation is for the no-MMU case only... if you have an MMU
> >> > - * you'll need to provide your own definitions.
> >> > + * This for the no-MMU, or no-IOMEM but still try to COMPILE_TEST cases.
> >> > + * if you have an MMU and IOMEM, you'll need to provide your own definitions.
> >> >   */
> >> > -#ifndef CONFIG_MMU
> >> > +#if !defined(CONFIG_MMU) || \
> >> > +	(!defined(CONFIG_HAS_IOMEM) && defined(CONFIG_COMPILE_TEST))
> >> >  static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
> >> >  {
> >> > +#if !defined(CONFIG_MMU)
> >> >  	return (void __iomem*) (unsigned long)offset;
> >> > +#else
> >> > +	return NULL;
> >> > +#endif
> >> >  }
> >> >  
> >> >  #define __ioremap(offset, size, flags)	ioremap(offset, size)
> > This is wrong for multiple reasons, all of which have been discussed in
> > this thread before.
> 
> Hmm..., COMPILE_TEST has integrated into 3.11 (at least can be found in
> next tree).
> 
> When a module select "COMPILE_TEST=y" (e.g with allmodconfig), it has
> right to compile under the architecture which no related HW support.

That is not true at all, and is not what COMPILE_TEST means.

> If it can not pass compiling, at least it is not the module's issue,
> neither the architecture's issue.

What?

> We have to look for who has duty on it. At least now, it seems only
> 'asm-generic' can be qualified to play this unlucky role.

Huh?

Look, asm-generic is not what you think it is it seems, nor is
COMPILE_TEST, which has caused this whole mess of a thread.  Please
start over, learn what asm-generic is there for, and used for today.
Same goes for COMPILE_TEST.

I'm done with this thread, it's madness...

greg k-h
