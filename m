Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaKCSPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:15:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:54727 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaKCSPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:15:33 -0500
Date: Mon, 3 Nov 2014 19:15:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Toshi Kani <toshi.kani@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 1/7] x86, mm, pat: Set WT to PA7 slot of PAT MSR
In-Reply-To: <CALCETrWwEsaz8j2ajqqxS4mupO48tv0e_wbrODsmJfZeON2ptA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411031913140.5308@nanos>
References: <1414450545-14028-1-git-send-email-toshi.kani@hp.com> <1414450545-14028-2-git-send-email-toshi.kani@hp.com> <alpine.DEB.2.11.1411031812390.5308@nanos> <1415036879.29109.26.camel@misato.fc.hp.com>
 <CALCETrWwEsaz8j2ajqqxS4mupO48tv0e_wbrODsmJfZeON2ptA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Andy Lutomirski wrote:
> On Mon, Nov 3, 2014 at 9:47 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Mon, 2014-11-03 at 18:14 +0100, Thomas Gleixner wrote:
> >> On Mon, 27 Oct 2014, Toshi Kani wrote:
> >> > +   } else {
> >> > +           /*
> >> > +            * PAT full support. WT is set to slot 7, which minimizes
> >> > +            * the risk of using the PAT bit as slot 3 is UC and is
> >> > +            * currently unused. Slot 4 should remain as reserved.
> >>
> >> This comment makes no sense. What minimizes which risk and what has
> >> this to do with slot 3 and slot 4?
> >
> > This is for precaution.  Since the patch enables the PAT bit the first
> > time, it was suggested that we keep slot 4 reserved and set it to WB.
> > The PAT bit still has no effect to slot 0/1/2 (WB/WC/UC-) after this
> > patch.  Slot 7 is the safest slot since slot 3 (UC) is unused today.
> >
> > https://lkml.org/lkml/2014/9/4/691
> > https://lkml.org/lkml/2014/9/5/394
> >
> 
> I would clarify the comment, since this really has nothing to do with
> slot 3 being unused.  How about:
> 
> We put WT in slot 7 to improve robustness in the presence of errata
> that might cause the high PAT bit to be ignored.  This way a buggy
> slot 7 access will hit slot 3, and slot 3 is UC, so at worst we lose
> performance without causing a correctness issue.  Pentium 4 erratum
> N46 is an example of such an erratum, although we try not to use PAT
> at all on affected CPUs.

Indeed. That makes a lot more sense.
 
> >> > +            *
> >> > +            *  PTE encoding used in Linux:
> >> > +            *      PAT
> >> > +            *      |PCD
> >> > +            *      ||PWT  PAT
> >> > +            *      |||    slot
> >> > +            *      000    0    WB : _PAGE_CACHE_MODE_WB
> >> > +            *      001    1    WC : _PAGE_CACHE_MODE_WC
> >> > +            *      010    2    UC-: _PAGE_CACHE_MODE_UC_MINUS
> >> > +            *      011    3    UC : _PAGE_CACHE_MODE_UC
> >> > +            *      100    4    <reserved>
> >> > +            *      101    5    <reserved>
> >> > +            *      110    6    <reserved>
> >>
> >> Well, they are still mapped to WB/WC/UC_MINUS ....
> >
> > Right, the reserved slots are also initialized with their safe values.
> > However, the macros _PAGE_CACHE_MODE_XXX only refer to the slots
> > specified above.

Then the table should reflect this, i.e.: reserved, but mapped to XX

And a comment below that explaining WHY we map the reserved slots.

Thanks,

	tglx
