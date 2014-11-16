Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaKPXod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 18:44:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:58961 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaKPXob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 18:44:31 -0500
Date: Mon, 17 Nov 2014 00:44:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kees Cook <keescook@chromium.org>
cc: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
In-Reply-To: <CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411162127310.3909@nanos>
References: <20141114204517.GA24402@www.outflux.net> <CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com> <CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
 <CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Kees Cook wrote:
> On Fri, Nov 14, 2014 at 6:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > should use attached one instead.
> >
> > 1. should use _brk_end instead of &end, as we only use partial of
> >    brk.
> > 2. [_brk_end, pm_end) page range is already converted. aka
> >    is not wasted.
> 
> Are you sure? For me, _brk_end isn't far enough:
> 
> [    1.475572] all_end: 0xffffffff82df5000
> [    1.476736] _brk_end: 0xffffffff82dd6000

_brk_end is adjusted at boot time via extend_brk() up to __brk_limit,
which is the same as _end. We usually do not use all of that space. So
it's expected that _brk_end < _end.
 
> Is this correct? It sounded like tglx wanted the pmd split, like this:

Yes, I wanted to get rid of the high mapping for anything between
_brk_end and _end, and I brought you on the wrong track with my
suggestion to call free_init_pages(). Sorry about that.

That happened because I missed the completely non obvious fact, that
only the effective brk section is reserved for the kernel via
reserve_brk(). So the area between _brk_end and _end is already
reusable. Though that reuse works only by chance and not by design and
is completely undocumented as everything else in that area.

So the initial patch to get rid of the X mapping is of course to just
extend the area to the PMD. A little bit different to your initial
patch, but essentially the same.

-	unsigned long all_end = PFN_ALIGN(&_end);
+	unsigned long all_end = roundup((unsigned long) &_end, PMD_SIZE);

I'm going to apply your V1 patch with the above roundup()
simplification. If a page of that area gets used later on then we are
going to split up the PMD anyway.
 
But still we want to get rid of that highmap between _brk_end and
_end, but there is absolutely no reason to come up with extra silly
functions for that.

So the obvious solution is to let setup_arch() reserve the memory up
to _end instead of _bss_stop, get rid of the extra reservation in
reserve_brk() and then let free_initmem() release the area between
_brk_end and _end. No extra hackery, no side effects, just works.

I spent quite some time to stare into that and I wonder about the
following related issues:

1) Why is the mark_rodata_ro() business a debug configuration, i.e
   CONFIG_DEBUG_RODATA?

   This does not make any sense at all. We really want RO and NX on by
   default and AFAICT distros are turning that on anyway for obvious
   reasons.

   The only idiocity I found so far is the kgdb Documentation which
   recommends to turn it off. Sigh.

   So that should be changed to:

      config ARCH_HAS_RONX
      	  bool   

      config DISABLE_RONX
   	  def_bool !ARCH_HAS_RONX || !KGDB_ENABLE_SECURITY_HOLES

   plus

      config ARCH_WANTS_KGDB_SECURITY_HOLES
      	  bool

      config KGDB_ENABLE_SECURITY_HOLES
      	  bool "WTF?"
   	  depends on BROKEN && ARCH_WANTS_KGDB_SECURITY_HOLES

2) What is actually the modules counterpart for mark_rodata_ro()?

   CONFIG_DEBUG_SET_MODULE_RONX

   Of course not enabled by default, but enabled by distros again.

   See #1.
   
   Now what's interesting aside of the general fuckup is that
   CONFIG_DEBUG_RODATA is supported by:
  
     arch/x86 and arch/parisc

   But CONFIG_DEBUG_SET_MODULE_RONX is supported by:

     arch/arm/ arch/arm64 arch/s390 and arch/x86

   This does not make any sense at all.

   Do arm/arm64/s390 have other means to make RO/NX work or are they
   just doing it for modules? And how is that supposed to work with
   KGDB if it is not aware of modules sections being RO/NX? KGDB has
   only extra magic for CONFIG_DEBUG_RODATA, but not for
   CONFIG_DEBUG_SET_MODULE_RONX.

   Now for extended fun the x86 help text for that option says:
   
    ... Such protection may interfere with run-time code
    patching and dynamic kernel tracing - and they might also protect
    against certain classes of kernel exploits.
    If in doubt, say "N".

   Patently wrong. More sigh.  

3) Why is mark_rodata_ro() called AFTER free_initmem() and therefor
   cannot be marked __init ?

   Just because ...

Thanks,

	tglx
