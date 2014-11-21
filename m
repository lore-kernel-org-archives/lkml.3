Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaKUWfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:35:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40520 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaKUWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:34:59 -0500
Date: Fri, 21 Nov 2014 17:33:09 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121223309.GC19283@laptop.dumpdata.com>
References: <CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
 <20141121162742.GB15461@htj.dyndns.org>
 <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
 <CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
 <20141121170805.GD30603@home.goodmis.org>
 <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
 <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
 <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
 <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
 <alpine.DEB.2.11.1411212049220.6439@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411212049220.6439@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 08:51:43PM +0100, Thomas Gleixner wrote:
> On Fri, 21 Nov 2014, Linus Torvalds wrote:
> > Here's the simplified end result. Again, this is TOTALLY UNTESTED. I
> > compiled it and verified that the code generation looks like what I'd
> > have expected, but that's literally it.
> > 
> >   static noinline int vmalloc_fault(unsigned long address)
> >   {
> >         pgd_t *pgd_dst;
> >         pgdval_t pgd_entry;
> >         unsigned index = pgd_index(address);
> > 
> >         if (index < KERNEL_PGD_BOUNDARY)
> >                 return -1;
> > 
> >         pgd_entry = init_mm.pgd[index].pgd;
> >         if (!pgd_entry)
> >                 return -1;
> > 
> >         pgd_dst = __va(PAGE_MASK & read_cr3());
> >         pgd_dst += index;
> > 
> >         if (pgd_dst->pgd)
> >                 return -1;
> > 
> >         ACCESS_ONCE(pgd_dst->pgd) = pgd_entry;
> 
> This will break paravirt. set_pgd/set_pmd are paravirt functions.
> 
> But I'm fine with breaking it, then you just need to change
> CONFIG_PARAVIRT to 'def_bool n'

That is not very nice.
