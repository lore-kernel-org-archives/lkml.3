Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab3GEAEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:04:39 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35461 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab3GEAEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:04:38 -0400
Message-ID: <51D60D53.7050405@gmail.com>
Date: Fri, 05 Jul 2013 08:03:31 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Chen Gang <gang.chen@asianux.com>, Greg KH <gregkh@linuxfoundation.org>,
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
References: <20130704011221.GA11230@kroah.com> <20130704061204.GA12148@kroah.com> <51D517A7.6030908@asianux.com> <201307041125.15083.arnd@arndb.de>
In-Reply-To: <201307041125.15083.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 05:25 PM, Arnd Bergmann wrote:
> On Thursday 04 July 2013, Chen Gang wrote:
> 
>> > --------------------------patch begin----------------------------------
>> > 
>> > 'asm-generic' need provide necessary configuration checking, if can't
>> > pass checking, 'asm-generic' shouldn't implement it.
>> > 
>> > For 'COMPILE_TEST', according to its help contents, 'asm-generic' need
>> > let it pass configuration checking, and provide related dummy contents
>> > for it.
>> > 
>> > Part of 'COMPLE_TEST' help contents in "init/Kconfig":
>> > 
>> >   "...Despite they cannot be loaded there (or even when they load they cannot be used due to missing HW support)..."
>> > 
>> > One sample for using 'COMPILE_TEST':
>> > 
>> >   'PTP_1588_CLOCK_PCH' in drivers/ptp/Kconfig, which need depend on 'HAS_IOMEM'.
> Then please submit a patch that adds the 'depends on HAS_IOMEM' line there.
> That line was clearly left out by accident.
> 

Yes, I will send the related patch for it (I have sent one, but that
seems incorrect, I will send patch v2 for that, after this patch
finishes discussing).

But excluding 'PTP_1588_CLOCK_PCH' own issue, it is as a sample for our
discussion (If "COMPILE_TEST=y", it should can be compiled under the
archs which no 'HAS_IOMEM').


>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  include/asm-generic/io.h |   22 ++++++++++++++++++----
>> >  1 files changed, 18 insertions(+), 4 deletions(-)
>> > 
>> > diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
>> > index d5afe96..301ce80 100644
>> > --- a/include/asm-generic/io.h
>> > +++ b/include/asm-generic/io.h
>> > @@ -303,13 +303,18 @@ static inline void *phys_to_virt(unsigned long address)
>> >  /*
>> >   * Change "struct page" to physical address.
>> >   *
>> > - * This implementation is for the no-MMU case only... if you have an MMU
>> > - * you'll need to provide your own definitions.
>> > + * This for the no-MMU, or no-IOMEM but still try to COMPILE_TEST cases.
>> > + * if you have an MMU and IOMEM, you'll need to provide your own definitions.
>> >   */
>> > -#ifndef CONFIG_MMU
>> > +#if !defined(CONFIG_MMU) || \
>> > +	(!defined(CONFIG_HAS_IOMEM) && defined(CONFIG_COMPILE_TEST))
>> >  static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
>> >  {
>> > +#if !defined(CONFIG_MMU)
>> >  	return (void __iomem*) (unsigned long)offset;
>> > +#else
>> > +	return NULL;
>> > +#endif
>> >  }
>> >  
>> >  #define __ioremap(offset, size, flags)	ioremap(offset, size)
> This is wrong for multiple reasons, all of which have been discussed in
> this thread before.

Hmm..., COMPILE_TEST has integrated into 3.11 (at least can be found in
next tree).

When a module select "COMPILE_TEST=y" (e.g with allmodconfig), it has
right to compile under the architecture which no related HW support.

If it can not pass compiling, at least it is not the module's issue,
neither the architecture's issue.

We have to look for who has duty on it. At least now, it seems only
'asm-generic' can be qualified to play this unlucky role.


Could you provide your suggestions or completions for this issue ?


Thanks.
-- 
Chen Gang
