Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbaHZOhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:37:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37354 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727AbaHZOhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:37:13 -0400
Date: Tue, 26 Aug 2014 15:37:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 2/8] ARM: expand fixmap region to 3MB
Message-ID: <20140826143725.GW23445@arm.com>
References: <1407949593-16121-1-git-send-email-keescook@chromium.org>
 <1407949593-16121-3-git-send-email-keescook@chromium.org>
 <20140819122653.GH23128@arm.com>
 <CAGXu5jJRx8e2_9jpMYApH8maJog_z2YAs2ihoD4SFNfvPqn2Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJRx8e2_9jpMYApH8maJog_z2YAs2ihoD4SFNfvPqn2Aw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 01:16:34PM +0100, Kees Cook wrote:
> On Tue, Aug 19, 2014 at 7:26 AM, Will Deacon <will.deacon@arm.com> wrote:
> > On Wed, Aug 13, 2014 at 06:06:27PM +0100, Kees Cook wrote:
> >> From: Rob Herring <robh@kernel.org>
> >>
> >> With commit a05e54c103b0 ("ARM: 8031/2: change fixmap mapping region to
> >> support 32 CPUs"), the fixmap region was expanded to 2MB, but it
> >> precluded any other uses of the fixmap region. In order to support other
> >> uses the fixmap region needs to be expanded beyond 2MB. Fortunately, the
> >> adjacent 1MB range 0xffe00000-0xfff00000 is availabe.
> >>
> >> Remove fixmap_page_table ptr and lookup the page table via the virtual
> >> address so that the fixmap region can span more that one pmd. The 2nd
> >> pmd is already created since it is shared with the vector page.
> >
> > [...]
> >
> >> diff --git a/arch/arm/mm/highmem.c b/arch/arm/mm/highmem.c
> >> index 45aeaaca9052..81061987ac45 100644
> >> --- a/arch/arm/mm/highmem.c
> >> +++ b/arch/arm/mm/highmem.c
> >> @@ -18,19 +18,20 @@
> >>  #include <asm/tlbflush.h>
> >>  #include "mm.h"
> >>
> >> -pte_t *fixmap_page_table;
> >> -
> >>  static inline void set_fixmap_pte(int idx, pte_t pte)
> >>  {
> >>       unsigned long vaddr = __fix_to_virt(idx);
> >> -     set_pte_ext(fixmap_page_table + idx, pte, 0);
> >> +     pte_t *ptep = pte_offset_kernel(pmd_off_k(vaddr), vaddr);
> >> +
> >> +     set_pte_ext(ptep, pte, 0);
> >>       local_flush_tlb_kernel_page(vaddr);
> >>  }
> >
> > Minor comment, but we can drop the ifx parameter here now, right? It looks a
> > bit weird having a setter/getter pair of functions where the type signatures
> > aren't the inverse.
> 
> idx is used to get the vaddr here. I suppose the various users of
> these functions in highmem could be reworked, but that doesn't look
> sensible either. Maybe it's just the names of the functions that are
> confusing?

Sorry, I misread the context line as a deletion. Leave it like it is.

Will
