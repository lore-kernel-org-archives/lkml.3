Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbbALNQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:16:34 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:58103 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbALNQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:16:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.19-rc3
Date: Mon, 12 Jan 2015 14:15:53 +0100
Message-ID: <3565689.rjhDkKGSkL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150112115342.GA19807@e104818-lin.cambridge.arm.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com> <4665410.x9Uu42bKmJ@wuerfel> <20150112115342.GA19807@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:FFCqHcuzDFgPBNno8q/V9VtdRQnr7l0xq/ouHrW3lKK9NY/69Po
 WXxSduhcJNuHbwI903oBq+Zd7qPv+j9cMQdyS7ZwUThcfjFpH//JMXkYx7XoX+zWZvzeLck
 daLBGYaVFEHV5jcfW0Xrr7lTyN1UMy/iAY52k90ImYgkXonki25eTh0hJYH7mV8VUXSidmp
 0tfkokSp27SDh/NPVXPwg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2015 11:53:42 Catalin Marinas wrote:
> On Sat, Jan 10, 2015 at 08:16:02PM +0000, Arnd Bergmann wrote:
> > Regarding ARM64 in particular, I think it would be nice to investigate
> > how to extend the THP code to cover 64KB TLBs when running with the 4KB
> > page size. There is a hint bit in the page table to tell the CPU that
> > a set of 16 aligned pages can share one TLB, and it would be nice to
> > use that bit in Linux, and to make this case more common for anonymous
> > mappings, and possible large file based mappings.
> 
> The generic THP code assumes that huge pages are done at the pmd level,
> which means 2MB for arm64 with 4KB page configuration. Hugetlb allows
> larger ptes which may not necessarily be at the pmd level, though we
> haven't implemented this on arm64 and it's not transparent either. As a
> first step it would be nice if at least we unify the APIs between
> hugetlbfs and THP (set_huge_pte_at vs. set_pmd_at).
> 
> I think you could do some arch-only tricks by pretending that you have a
> pte with 16 entries only and a dummy pmd (without a corresponding
> hardware page table level) that can host a "huge" page (16 consecutive
> ptes). But we lose the 2MB transparent huge page as I don't see
> mm/huge_memory.c handling huge puds. We also lose the ability of
> building 4 real level page tables since we use the pmd as a dummy one.

Yes, it quickly gets ugly at that point.
 
> But it would be a nice investigation. Maybe something simpler like
> getting the mm layer to prefer contiguous 64KB ranges and we do the
> detection in the arch set_pte_at().

Doing the detection would be easy enough I guess and immediately
helps with the post-split THP mapping, but I don't think that
by itself would have a noticeable benefit on general workloads.

My first reaction to a change to the mm layer was that it's probably really
hard, but then again if we limit it to anonymous mappings, all we really
need is a modification in do_anonymous_page() to allocate a larger chunk
if possible and install n PTEs at a time or fall back to the current
behavior if anything gets in the way. For completeness, the same thing
could be done in do_wp_page() for the case where an entire block of pages
are either not mapped or point to the zero page. Anything beyond that
probably adds more complexity than it gains.

Do we have someone who code this up and do some benchmarks to find out
the cost in terms of memory consumption and the performance compared to
normal 4k pages and static 64k pages?

Do the Cortex-A53/A57 cores actually implement the necessary hardware
feature?
IIRC some x86 processors are also able to use larger TLBs for contiguous
page table entries even without an architected hint bit, so if one
could show this to perform better on x86, it would be much easier to
merge.

	Arnd
