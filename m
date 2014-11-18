Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaKRRMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:12:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:40417 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaKRRMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:12:05 -0500
Date: Tue, 18 Nov 2014 18:11:57 +0100 (CET)
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
Message-ID: <alpine.DEB.2.11.1411181811000.3909@nanos>
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
> > On Fri, Nov 14, 2014 at 5:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> On Fri, Nov 14, 2014 at 12:45 PM, Kees Cook <keescook@chromium.org> wrote:
> >>> v2:
> >>>  - added call to free_init_pages(), as suggested by tglx
> >
> >> something is wrong:
> >>
> >> [    7.842479] Freeing unused kernel memory: 3844K (ffffffff82e52000 -
> >> ffffffff83213000)
> >> [    7.843305] Write protecting the kernel read-only data: 28672k
> >
> > ....
> > should use attached one instead.
> >
> > 1. should use _brk_end instead of &end, as we only use partial of
> >    brk.
> > 2. [_brk_end, pm_end) page range is already converted. aka
> >    is not wasted.
> 
> Are you sure? For me, _brk_end isn't far enough:

_brk_end is guaranteed to be <= _end. But we really want to use
_brk_end here, because if we have the following situation:

_brk_start:     0x03ff0000
_brk_end:       0x03ffff00
_end:           0x04016000

So we have the following PMDs setup:

0x03e00000     pmd rw nx        <- covers the top of .bss
                                   and the start  of .brk
0x04000000     pmd rw nx        <- covers the end of .brk
                                   and some random unused

So if _brk_end is less than 0x04000000, then cleanup_highmem() has
zapped the extra PMD already. So we don't want to call set_nx() on
that.

If _brk_end is >= 0x04000000 then we cover that last pmd with the
set_nx call.

Completely non obvious as anything else in that area.

Thanks,

	tglx
