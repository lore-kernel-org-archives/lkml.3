Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbaIEOBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:01:15 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:43593 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaIEOBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:01:14 -0400
Message-ID: <1409925023.28990.176.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/5] x86, mm, pat: Set WT to PA4 slot of PAT MSR
From: Toshi Kani <toshi.kani@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, hpa@zytor.com,
        tglx@linutronix.de, mingo@redhat.com, akpm@linuxfoundation.org,
        arnd@arndb.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        jgross@suse.com, stefan.bader@canonical.com, luto@amacapital.net,
        konrad.wilk@oracle.com
Date: Fri, 05 Sep 2014 07:50:23 -0600
In-Reply-To: <20140905102347.GA30096@gmail.com>
References: <1409855739-8985-1-git-send-email-toshi.kani@hp.com>
	 <1409855739-8985-2-git-send-email-toshi.kani@hp.com>
	 <20140904201123.GA9116@khazad-dum.debian.net>
	 <1409862708.28990.141.camel@misato.fc.hp.com>
	 <1409873255.28990.158.camel@misato.fc.hp.com>
	 <20140905102347.GA30096@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 12:23 +0200, Ingo Molnar wrote:
> * Toshi Kani <toshi.kani@hp.com> wrote:
> 
> > On Thu, 2014-09-04 at 14:31 -0600, Toshi Kani wrote:
> > > On Thu, 2014-09-04 at 17:11 -0300, Henrique de Moraes Holschuh wrote:
> > > > On Thu, 04 Sep 2014, Toshi Kani wrote:
> > > > > This patch sets WT to the PA4 slot in the PAT MSR when the processor
> > > > > is not affected by the PAT errata.  The upper 4 slots of the PAT MSR
> > > > > are continued to be unused on the following Intel processors.
> > > > > 
> > > > >   errata           cpuid
> > > > >   --------------------------------------
> > > > >   Pentium 2, A52   family 0x6, model 0x5
> > > > >   Pentium 3, E27   family 0x6, model 0x7
> > > > >   Pentium M, Y26   family 0x6, model 0x9
> > > > >   Pentium 4, N46   family 0xf, model 0x0
> > > > > 
> > > > > For these affected processors, _PAGE_CACHE_MODE_WT is redirected to UC-
> > > > > per the default setup in __cachemode2pte_tbl[].
> > > > 
> > > > There are at least two PAT errata.  The blacklist is in
> > > > arch/x86/kernel/cpu/intel.c:
> > > > 
> > > >         if (c->x86 == 6 && c->x86_model < 15)
> > > >                 clear_cpu_cap(c, X86_FEATURE_PAT);
> > > > 
> > > > It covers model 13, which is not in your blacklist.
> > > > 
> > > > It *is* possible that PAT would work on model 13, as I don't think it has
> > > > any PAT errata listed and it was blacklisted "just in case" (from memory. I
> > > > did not re-check), but this is untested, and unwise to enable on an aging
> > > > platform.
> > > > 
> > > > I am worried of uncharted territory, here.  I'd actually advocate for not
> > > > enabling the upper four PAT entries on IA-32 at all, unless Windows 9X / XP
> > > > is using them as well.  Is this a real concern, or am I being overly
> > > > cautious?
> > > 
> > > The blacklist you pointed out covers a different PAT errata, and is
> > > still effective after this change.  pat_init() will call pat_disable()
> > > and the PAT will continue to be disabled on these processors.  There is
> > > no change for them.
> > > 
> > > My blacklist covers the PAT errata that makes the upper four bit
> > > unusable when the PAT is enabled.
> > 
> > I checked more carefully, and it turns out that the processors 
> > that have the WC bug with PAT/MTRR also have the upper four bit 
> > bug in PAT as well.  The updated blacklist is:
> > 
> >    errata               cpuid
> >    --------------------------------------
> >    Pentium 2, A52       family 0x6, model 0x5
> >    Pentium 3, E27       family 0x6, model 0x7, 0x8
> >    Pentium 3 Xeon, G26  family 0x6, model 0x7, 0x8, 0xa
> >    Pentium M, Y26       family 0x6, model 0x9
> >    Pentium M 90nm, X9   family 0x6, model 0xd
> >    Pentium 4, N46       family 0xf, model 0x0
> >                 
> > So, the check can be the same as cpu/intel.c, except that early 
> > Pentium 4 steppings also have the upper four bit bug.  I will 
> > update the check. In any case, this check is only meaningful 
> > for P4 since the PAT is disabled for P2/3/M.
> 
> Any reason why we have to create such a sharp boundary, instead 
> of simply saying: 'disable PAT on all x86 CPU families that have 
> at least one buggy model'?
> 
> That would nicely sort out all the broken CPUs, and would make it 
> highly unlikely that we'd accidentally forget about a model or 
> two.

Agreed.  I will disable this feature on all Pentium 4 models as well.  I
do not think there is any necessity to enable it on Pentium 4.

Thanks,
-Toshi

