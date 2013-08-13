Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab3HMFCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:02:18 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:36445 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3HMFCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:02:16 -0400
Date: Tue, 13 Aug 2013 09:02:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, xemul@parallels.com, mpm@selenic.com,
        xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com,
        kosaki.motohiro@gmail.com, sfr@canb.auug.org.au, peterz@infradead.org,
        aneesh.kumar@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2/2] [PATCH] mm: Save soft-dirty bits on file pages
Message-ID: <20130813050213.GA2869@moon>
References: <20130730204154.407090410@gmail.com>
 <20130730204654.966378702@gmail.com>
 <20130807132812.60ad4bfe85127794094d385e@linux-foundation.org>
 <20130808145120.GA1775@moon>
 <20130812145720.3b722b066fe1bd77291331e5@linux-foundation.org>
 <CALCETrUXOoKrOAXhvd=GcK3YpBNWr2rk2ArBBgekXDv9yj7sNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUXOoKrOAXhvd=GcK3YpBNWr2rk2ArBBgekXDv9yj7sNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 03:28:06PM -0700, Andy Lutomirski wrote:
> >
> > You could have #undefed _mfrob and __frob after using them, but whatever.

Sure, for some reason I forgot to do that. Will send update on top.

> > I saved this patch to wave at the x86 guys for 3.12.  I plan to merge
> > mm-save-soft-dirty-bits-on-file-pages.patch for 3.11.
> >
> >> Guys, is there a reason for "if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE"
> >> test present in this pgtable-2level.h file at all? I can't imagine
> >> where it can be false on x86.
> >
> > I doubt if "Guys" read this.  x86 maintainers cc'ed.

Thanks!

> > +#define _mfrob(v,r,m,l)                ((((v) >> (r)) & (m)) << (l))
> > +#define __frob(v,r,l)          (((v) >> (r)) << (l))
> > +
> >  #ifdef CONFIG_MEM_SOFT_DIRTY
> 
> If I'm understanding this right, the idea is to take the bits in the
> range a..b of v and stick them at c..d, where a-b == c-d.  Would it
> make sense to change this to look something like
> 
> #define __frob(v, inmsb, inlsb, outlsb) ((v >> inlsb) & ((1<<(inmsb -
> inlsb + 1)-1) << outlsb)

There is a case when you don't need a mask completely. And because this
pte conversion is on hot path and time critical I kept generated code
as it was (even if that lead to slightly less clear source code).

> For extra fun, there could be an __unfrob macro that takes the same
> inmsg, inlsb, outlsb parameters but undoes it so that it's (more)
> clear that the operations that are supposed to be inverses are indeed
> inverses.
