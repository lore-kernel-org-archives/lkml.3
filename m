Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbbA1U2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:28:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45505 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbbA1U2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:28:07 -0500
Date: Wed, 28 Jan 2015 12:10:17 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "zhichang.yuan@linaro.org" <zhichang.yuan@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liguozhu@huawei.com" <liguozhu@huawei.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: [PATCHv2] arm64:mm: free the useless initial page table
Message-ID: <20150128121017.GB9000@e104818-lin.cambridge.arm.com>
References: <1418110007-13270-1-git-send-email-zhichang.yuan@linaro.org>
 <20150123162126.GD9557@e104818-lin.cambridge.arm.com>
 <CAKv+Gu8OQB+eziL6X85-v-+9KKPsK6Z=h2+1oDrM9imnSU8drg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8OQB+eziL6X85-v-+9KKPsK6Z=h2+1oDrM9imnSU8drg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:40:40PM +0000, Ard Biesheuvel wrote:
> On 23 January 2015 at 16:21, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Tue, Dec 09, 2014 at 07:26:47AM +0000, zhichang.yuan@linaro.org wrote:
> >> From: "zhichang.yuan" <zhichang.yuan@linaro.org>
> >>
> >> For 64K page system, after mapping a PMD section, the corresponding initial
> >> page table is not needed any more. That page can be freed.
> >>
> >> Changes since v1:
> >>
> >> * make consistent code between alloc_init_pmd and alloc_init_pud;
> >> * flush the TLB before the unused page table is freed;
> >>
> >> Signed-off-by: Zhichang Yuan <zhichang.yuan@linaro.org>
> >
> > I thought about queuing this patch but I realised that
> > alloc_init_pmd/pud may be called in a late context where memblock_free()
> > would no longer make sense. Cc'ing Laura and Ard for any ideas here but
> > I think we may just end up with a few old page table pages sitting
> > around (not many though). In general we don't go from smaller to larger
> > mappings (that's what this patch targets) but given the API, I'm not
> > sure we have any guarantee.
> >
> > One solution would be to check for alloc == early_alloc or something
> > similar. Cc'ing Laura and Ard as they added the create_mapping_late()
> > code.
> >
> 
> The UEFI page tables are only built up once, based on a series of
> disjoint memory regions, so that will never hit either of the
> memblock_free() branches.
> And AFAICT, the DEBUG_RODATA code does the splitting early, which
> causes the create_mapping_late() code to only change permissions, not
> change the granularity of any regions.
> 
> Perhaps it's sufficient to add a comment and a BUG_ON(alloc !=
> early_alloc) to the memblock_free() branches?

Thanks for confirming, I merged this patch together with BUG_ON(), just
in case.

-- 
Catalin
