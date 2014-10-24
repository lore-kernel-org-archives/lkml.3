Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbaJXRFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:05:52 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:51403 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJXRFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:05:50 -0400
Message-ID: <1414169518.12798.31.camel@misato.fc.hp.com>
Subject: Re: [RESEND PATCH V3 0/3] x86: Full support of PAT
From: Toshi Kani <toshi.kani@hp.com>
To: Juergen Gross <jgross@suse.com>
Cc: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com
Date: Fri, 24 Oct 2014 10:51:58 -0600
In-Reply-To: <5449D0D0.7070305@suse.com>
References: <1413188011-12655-1-git-send-email-jgross@suse.com>
	 <54448896.9040908@suse.com> <5449D0D0.7070305@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juergen,

Can you rebase the patchset to 3.18.0-rc1? There are some minor merge
conflicts.

Thanks,
-Toshi


On Fri, 2014-10-24 at 06:08 +0200, Juergen Gross wrote:
> Ping?
> 
> On 10/20/2014 05:59 AM, Juergen Gross wrote:
> > Hi x86 maintainers,
> >
> > any reason you seem to ignore this patch series? I think I've replied
> > to all open issues and sent the patches more than one month ago. Each
> > patch has a "Reviewed-by". Is there something else missing?
> >
> >
> > Juergen
> >
> > On 10/13/2014 10:13 AM, Juergen Gross wrote:
> >> The x86 architecture offers via the PAT (Page Attribute Table) a way to
> >> specify different caching modes in page table entries. The PAT MSR
> >> contains
> >> 8 entries each specifying one of 6 possible cache modes. A pte
> >> references one
> >> of those entries via 3 bits: _PAGE_PAT, _PAGE_PWT and _PAGE_PCD.
> >>
> >> The Linux kernel currently supports only 4 different cache modes. The
> >> PAT MSR
> >> is set up in a way that the setting of _PAGE_PAT in a pte doesn't
> >> matter: the
> >> top 4 entries in the PAT MSR are the same as the 4 lower entries.
> >>
> >> This results in the kernel not supporting e.g. write-through mode.
> >> Especially
> >> this cache mode would speed up drivers of video cards which now have
> >> to use
> >> uncached accesses.
> >>
> >> OTOH some old processors (Pentium) don't support PAT correctly and the
> >> Xen
> >> hypervisor has been using a different PAT MSR configuration for some
> >> time now
> >> and can't change that as this setting is part of the ABI.
> >>
> >> This patch set abstracts the cache mode from the pte and introduces
> >> tables to
> >> translate between cache mode and pte bits (the default cache mode
> >> "write back"
> >> is hard-wired to PAT entry 0). The tables are statically initialized with
> >> values being compatible to old processors and current usage. As soon
> >> as the
> >> PAT MSR is changed (or - in case of Xen - is read at boot time) the
> >> tables are
> >> changed accordingly. Requests of mappings with special cache modes are
> >> always
> >> possible now, in case they are not supported there will be a fallback
> >> to a
> >> compatible but slower mode.
> >>
> >> Summing it up, this patch set adds the following features:
> >> - capability to support WT and WP cache modes on processors with full PAT
> >>    support
> >> - processors with no or uncorrect PAT support are still working as
> >> today, even
> >>    if WT or WP cache mode are selected by drivers for some pages
> >> - reduction of Xen special handling regarding cache mode
> >>
> >> Changes in V3:
> >> - corrected two minor nits (UC_MINUS, again) detected by Toshi Kani
> >>
> >> Changes in V2:
> >> - simplified handling of PAT MSR write under Xen as suggested by David
> >> Vrabel
> >> - removed resetting of pat_enabled under Xen
> >> - two small corrections requested by Toshi Kani (UC_MINUS cache mode in
> >>    vermilion driver, fix 32 bit kernel build failure)
> >> - correct build error on non-x86 arch by moving definition of
> >>    update_cache_mode_entry() to x86 specific header
> >>
> >> Changes since RFC:
> >> - renamed functions and variables as suggested by Toshi Kani
> >> - corrected cache mode bits for WT and WP
> >> - modified handling of PAT MSR write under Xen as suggested by Jan
> >> Beulich
> >>
> >>
> >> Juergen Gross (3):
> >>    x86: Make page cache mode a real type
> >>    x86: Enable PAT to use cache mode translation tables
> >>    Support Xen pv-domains using PAT
> >>
> >>   arch/x86/include/asm/cacheflush.h         |  38 ++++---
> >>   arch/x86/include/asm/fb.h                 |   6 +-
> >>   arch/x86/include/asm/io.h                 |   2 +-
> >>   arch/x86/include/asm/pat.h                |   7 +-
> >>   arch/x86/include/asm/pgtable.h            |  19 ++--
> >>   arch/x86/include/asm/pgtable_types.h      |  96 ++++++++++++----
> >>   arch/x86/mm/dump_pagetables.c             |  24 ++--
> >>   arch/x86/mm/init.c                        |  37 ++++++
> >>   arch/x86/mm/init_64.c                     |   9 +-
> >>   arch/x86/mm/iomap_32.c                    |  15 ++-
> >>   arch/x86/mm/ioremap.c                     |  63 ++++++-----
> >>   arch/x86/mm/mm_internal.h                 |   2 +
> >>   arch/x86/mm/pageattr.c                    |  84 ++++++++------
> >>   arch/x86/mm/pat.c                         | 181
> >> +++++++++++++++++++-----------
> >>   arch/x86/mm/pat_internal.h                |  22 ++--
> >>   arch/x86/mm/pat_rbtree.c                  |   8 +-
> >>   arch/x86/pci/i386.c                       |   4 +-
> >>   arch/x86/xen/enlighten.c                  |  25 ++---
> >>   arch/x86/xen/mmu.c                        |  48 +-------
> >>   arch/x86/xen/xen-ops.h                    |   1 -
> >>   drivers/video/fbdev/gbefb.c               |   3 +-
> >>   drivers/video/fbdev/vermilion/vermilion.c |   6 +-
> >>   22 files changed, 421 insertions(+), 279 deletions(-)
> >>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 


