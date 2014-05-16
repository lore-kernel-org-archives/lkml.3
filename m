Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaEPJwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:52:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:50014 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751475AbaEPJwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:52:12 -0400
Date: Fri, 16 May 2014 10:51:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "msalter@redhat.com" <msalter@redhat.com>
Cc: Steve Capper <steve.capper@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: fix pud_huge() for 2-level pagetables
Message-ID: <20140516095125.GF5624@arm.com>
References: <1400163562-7481-1-git-send-email-msalter@redhat.com>
 <20140515144424.GA23884@linaro.org>
 <1400171258.21547.136.camel@deneb.redhat.com>
 <CAPvkgC2WQcvn5e01Y70cm5nzenYZ6tk_1BampHw66VoRFn7Jiw@mail.gmail.com>
 <1400179157.21547.147.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400179157.21547.147.camel@deneb.redhat.com>
Thread-Topic: [PATCH] arm64: fix pud_huge() for 2-level pagetables
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 07:39:17PM +0100, Mark Salter wrote:
> On Thu, 2014-05-15 at 18:55 +0100, Steve Capper wrote:
> > On 15 May 2014 17:27, Mark Salter <msalter@redhat.com> wrote:
> > > On Thu, 2014-05-15 at 15:44 +0100, Steve Capper wrote:
> > >> On Thu, May 15, 2014 at 10:19:22AM -0400, Mark Salter wrote:
> > >> > In arch/arm/kvm/mmu.c:unmap_range(), we end up doing an extra put_page()
> > >> > on the stage2 pgd which leads to the BUG in put_page_testzero(). This
> > >> > happens because a pud_huge() test in unmap_range() returns true when it
> > >> > should always be false with 2-level pages tables used by 64k pages.
> > >> > This patch removes support for huge puds if 2-level pagetables are
> > >> > being used.
[...]
> > Yeah I agree for 64K granule it doesn't make sense to have a huge_pud.
> > The patch looks sound now, but checking for a folded pmd may run into
> > problems if/when we get to 3-levels and 64K pages in future.
> > 
> > Perhaps checking for PAGE_SHIFT==12 (or something similar) would be a
> > bit more robust?
> 
> I don't think testing based on granule size is generally correct either.
> Maybe support for 3-level page tables with 64k granule gets added as an
> option. That would break the pagesize based test. With a folded pmd, we
> know there is no pud, so pud_huge() should always be false.

I agree, pud_huge() should be false in the same way we define
pud_present() to be 1 when __PGTABLE_PMD_FOLDED. The *_huge() macros
aren't covered by the generic headers unfortunately (some clean-up would
be useful at some point but for now this patch is fine).

-- 
Catalin
