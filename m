Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650Ab3GEAgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:36:16 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15411 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab3GEAgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:36:13 -0400
X-Spam-Score: -100.8
Message-ID: <51D614C7.8060904@asianux.com>
Date: Fri, 05 Jul 2013 08:35:19 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
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
References: <20130704011221.GA11230@kroah.com> <20130704061204.GA12148@kroah.com> <51D517A7.6030908@asianux.com> <201307041125.15083.arnd@arndb.de> <51D60D53.7050405@gmail.com> <20130705001239.GA20869@kroah.com>
In-Reply-To: <20130705001239.GA20869@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 08:12 AM, Greg KH wrote:
> On Fri, Jul 05, 2013 at 08:03:31AM +0800, Chen Gang F T wrote:
>> > On 07/04/2013 05:25 PM, Arnd Bergmann wrote:
>>> > > On Thursday 04 July 2013, Chen Gang wrote:
>>> > > 
>>>>> > >> > --------------------------patch begin----------------------------------
>>>>> > >> > 
>>>>> > >> > 'asm-generic' need provide necessary configuration checking, if can't
>>>>> > >> > pass checking, 'asm-generic' shouldn't implement it.
>>>>> > >> > 
>>>>> > >> > For 'COMPILE_TEST', according to its help contents, 'asm-generic' need
>>>>> > >> > let it pass configuration checking, and provide related dummy contents
>>>>> > >> > for it.
>>>>> > >> > 
>>>>> > >> > Part of 'COMPLE_TEST' help contents in "init/Kconfig":
>>>>> > >> > 
>>>>> > >> >   "...Despite they cannot be loaded there (or even when they load they cannot be used due to missing HW support)..."
>>>>> > >> > 
>>>>> > >> > One sample for using 'COMPILE_TEST':
>>>>> > >> > 
>>>>> > >> >   'PTP_1588_CLOCK_PCH' in drivers/ptp/Kconfig, which need depend on 'HAS_IOMEM'.
>>> > > Then please submit a patch that adds the 'depends on HAS_IOMEM' line there.
>>> > > That line was clearly left out by accident.
>>> > > 
>> > 
>> > Yes, I will send the related patch for it (I have sent one, but that
>> > seems incorrect, I will send patch v2 for that, after this patch
>> > finishes discussing).
>> > 
>> > But excluding 'PTP_1588_CLOCK_PCH' own issue, it is as a sample for our
>> > discussion (If "COMPILE_TEST=y", it should can be compiled under the
>> > archs which no 'HAS_IOMEM').
>> > 
>> > 
>>>>> > >> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>>> > >> > ---
>>>>> > >> >  include/asm-generic/io.h |   22 ++++++++++++++++++----
>>>>> > >> >  1 files changed, 18 insertions(+), 4 deletions(-)
>>>>> > >> > 
>>>>> > >> > diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
>>>>> > >> > index d5afe96..301ce80 100644
>>>>> > >> > --- a/include/asm-generic/io.h
>>>>> > >> > +++ b/include/asm-generic/io.h
>>>>> > >> > @@ -303,13 +303,18 @@ static inline void *phys_to_virt(unsigned long address)
>>>>> > >> >  /*
>>>>> > >> >   * Change "struct page" to physical address.
>>>>> > >> >   *
>>>>> > >> > - * This implementation is for the no-MMU case only... if you have an MMU
>>>>> > >> > - * you'll need to provide your own definitions.
>>>>> > >> > + * This for the no-MMU, or no-IOMEM but still try to COMPILE_TEST cases.
>>>>> > >> > + * if you have an MMU and IOMEM, you'll need to provide your own definitions.
>>>>> > >> >   */
>>>>> > >> > -#ifndef CONFIG_MMU
>>>>> > >> > +#if !defined(CONFIG_MMU) || \
>>>>> > >> > +	(!defined(CONFIG_HAS_IOMEM) && defined(CONFIG_COMPILE_TEST))
>>>>> > >> >  static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
>>>>> > >> >  {
>>>>> > >> > +#if !defined(CONFIG_MMU)
>>>>> > >> >  	return (void __iomem*) (unsigned long)offset;
>>>>> > >> > +#else
>>>>> > >> > +	return NULL;
>>>>> > >> > +#endif
>>>>> > >> >  }
>>>>> > >> >  
>>>>> > >> >  #define __ioremap(offset, size, flags)	ioremap(offset, size)
>>> > > This is wrong for multiple reasons, all of which have been discussed in
>>> > > this thread before.
>> > 
>> > Hmm..., COMPILE_TEST has integrated into 3.11 (at least can be found in
>> > next tree).
>> > 
>> > When a module select "COMPILE_TEST=y" (e.g with allmodconfig), it has
>> > right to compile under the architecture which no related HW support.
> That is not true at all, and is not what COMPILE_TEST means.
> 

Below is the 'COMPILE_TEST' help contents.

config COMPILE_TEST
       bool "Compile also drivers which will not load"
       default n
       help
         Some drivers can be compiled on a different platform than they are
         intended to be run on. Despite they cannot be loaded there (or even
         when they load they cannot be used due to missing HW support),
         developers still, opposing to distributors, might want to build such
         drivers to compile-test them.

         If you are a developer and want to build everything available, say Y
         here. If you are a user/distributor, say N here to exclude useless
         drivers to be distributed.

Does a module have no right to choose "COMPILE_TEST=y" under the
architecture which no related HW support ?

Or I misunderstand the help contents ?

>> > If it can not pass compiling, at least it is not the module's issue,
>> > neither the architecture's issue.
> What?
> 

If it can not pass compiling because of HW not support when
"COMPILE_TEST=y", it is not the module's issue, neither the
architecture's issue.

>> > We have to look for who has duty on it. At least now, it seems only
>> > 'asm-generic' can be qualified to play this unlucky role.
> Huh?
> 
> Look, asm-generic is not what you think it is it seems, nor is
> COMPILE_TEST, which has caused this whole mess of a thread.  Please
> start over, learn what asm-generic is there for, and used for today.
> Same goes for COMPILE_TEST.
> 

At least, we can not suspend this issue. It is not suitable to fix
module by force (if multiple modules want "COMPILE_TEST=y", we need fix
multiple various times in various areas).


> I'm done with this thread, it's madness...

We are just discussing, every member has right to reply or not.

If no members reply, I will (of cause) not continue to send repeated
contents.

And excuse me, some contents are really repeated multiple times because
of some of members need it for discussion.


Thanks.
-- 
Chen Gang
