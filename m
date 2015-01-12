Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbbALN6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:58:07 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:55998 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbALN6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:58:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.19-rc3
Date: Mon, 12 Jan 2015 14:57:48 +0100
Message-ID: <23318125.rGnCbWvYBR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150112121815.GB19807@e104818-lin.cambridge.arm.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com> <10028397.kdbz8TfPck@wuerfel> <20150112121815.GB19807@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:tGD++beUltEXTpxLj1j0PYG3RWGZZ8X7KVUy39xmrCPNsyCyegj
 FklkXlccbAyWImqLgbd7R+iMFXl8b868NAvNXvleqfSHU3/Nmlau4VSommhzNtW6heqHnwr
 ckPNOncyeAwXDEOZHJpZ0Sc7XmX2i5hLc0PfMfzBx+/5rENL0Nw8ihAVJREXSMptwPgZ0dl
 b5Oj8GvEiEVttJiOQ938A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2015 12:18:15 Catalin Marinas wrote:
> On Sat, Jan 10, 2015 at 09:36:13PM +0000, Arnd Bergmann wrote:
> > On Saturday 10 January 2015 13:00:27 Linus Torvalds wrote:
> > > > IIRC, AIX works great with 64k pages, but only because of two
> > > > reasons that don't apply on Linux:
> > > 
> > > .. there's a few other ones:
> > > 
> > >  (c) nobody really runs AIX on dekstops. It's very much a DB load
> > > environment, with historically some HPC.
> > > 
> > >  (d) the powerpc TLB fill/buildup/teardown costs are horrible, so on
> > > AIX the cost of lots of small pages is much higher too.
> > 
> > I think (d) applies to ARM as well, since it has no hardware
> > dirty/referenced bit tracking and requires the OS to mark the
> > pages as invalid/readonly until the first access. ARMv8.1
> > has a fix for that, but it's optional and we haven't seen any
> > implementations yet.
> 
> Do you happen have any data on how significantly non-hardware
> dirty/access bits impact the performance? I think it may affect the user
> process start-up time a but at run-time it shouldn't be that bad.
> 
> If it is that significant, we could optimise it further in the arch
> code. For example, make a fast exception path where we need to mark the
> pte dirty. This would be handled by arch code without even calling
> handle_pte_fault().

If I understand the way that LRU works right, we end up clearing
the referenced bits in shrink_active_list()->page_referenced()->
page_referenced_one()->ptep_clear_flush_young_notify()->pte_mkold()
whenever there is memory pressure, so definitely not just for
startup.

> > > so I feel pretty confident in saying it won't happen. It's just too
> > > much of a bother, for little to no actual upside. It's likely a much
> > > better approach to try to instead use THP for anonymous mappings.
> > 
> > arm64 already supports 2MB transparent hugepages. I guess it
> > wouldn't be too hard to change it so that an existing hugepage
> > on an anonymous mapping that gets split up into 4KB pages gets
> > split along 64KB boundaries with the contiguous mapping bit set.
> > 
> > Having full support for multiple hugepage sizes (64KB, 2MB and 32MB
> > in case of ARM64 with 4KB PAGE_SIZE) would be even better and
> > probably negate any benefits of 64KB PAGE_SIZE, but requires more
> > changes to common mm code.
> 
> As I replied to your other email, I don't think that's simple for the
> transparent huge pages case.
> 
> The main advantage I see with 64KB pages is not the reduced TLB pressure
> but the number of levels of page tables. Take the AMD Seattle board for
> example, with 4KB pages you need 4 levels but 64KB allow only 2 levels
> (42-bit VA). Larger TLBs and improved walk caches (caching VA -> pmd
> entry translation rather than all the way to pte/PA) make things better
> but you still have the warming up time for any fork/new process as they
> don't share the same TLB entries.

Not sure I'm following. Does the A57 core cache partial TLBs or not?

Even if not, I would expect the page tables to be hot in dcache most
of the time, possibly with the exception of the last level on
multi-threaded processes, but then you are back to the difference
between the page size and the upper levels almost out of the equation.

	Arnd
