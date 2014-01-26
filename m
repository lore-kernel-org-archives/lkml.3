Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaAZSCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 13:02:38 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:43845 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaAZSCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 13:02:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140124133830.GU4963@suse.de>
References: <20140121232708.GA29787@amazon.com>
	<20140122014908.GG18164@kroah.com>
	<CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
	<20140122032045.GA22182@falcon.amazon.com>
	<20140122050215.GC9931@konrad-lan.dumpdata.com>
	<20140122072914.GA9283@orcus.uplinklabs.net>
	<52DFD5DB.6060603@iogearbox.net>
	<CAEr7rXhJf1tf2KUErsGgUyYNUpVwLYD=fKUf8aPm0Dcg21MuNQ@mail.gmail.com>
	<20140122203337.GA31908@orcus.uplinklabs.net>
	<CAEr7rXjge6rKzxbwy+0A6-5YhVZL9WGmaLrDYbE8H5hrtwq_4A@mail.gmail.com>
	<20140124133830.GU4963@suse.de>
Date: Sun, 26 Jan 2014 13:02:35 -0500
Message-ID: <CAEr7rXjmVp-F88zQnc4a2tSzBAJFshzR0FPkOBdo1jbQLOv+2A@mail.gmail.com>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Steven Noonan <steven@uplinklabs.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        George Dunlap <george.dunlap@eu.citrix.com>,
        Dario Faggioli <dario.faggioli@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 8:38 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Thu, Jan 23, 2014 at 11:23:37AM -0500, Elena Ufimtseva wrote:
>> >> >> <SNIP>
>> >> >>
>> >> >> This dump doesn't look dramatically different, either.
>> >> >>
>> >> >>>
>> >> >>> The other question is - how is AutoNUMA running when it is not enabled?
>> >> >>> Shouldn't those _PAGE_NUMA ops be nops when AutoNUMA hasn't even been
>> >> >>> turned on?
>> >> >>
>> >> >>
>> >> >> Well, NUMA_BALANCING is enabled in the kernel config[1], but I presume you
>> >> >> mean not enabled at runtime?
>> >> >>
>> >> >> [1]
>> >> >> http://git.uplinklabs.net/snoonan/projects/archlinux/ec2/ec2-packages.git/tree/linux-ec2/config.x86_64
>> >>
>> >>
>> >>
>> >> --
>> >> Elena
>>
>> I was able to reproduce this consistently, also with the latest mm
>> patches from yesterday.
>> Can you please try this:
>>
>
> Thanks Elena,
>
>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>> index ce563be..76dcf96 100644
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -365,7 +365,7 @@ void xen_ptep_modify_prot_commit(struct mm_struct
>> *mm, unsigned long addr,
>>  /* Assume pteval_t is equivalent to all the other *val_t types. */
>>  static pteval_t pte_mfn_to_pfn(pteval_t val)
>>  {
>> -       if (val & _PAGE_PRESENT) {
>> +       if ((val & _PAGE_PRESENT) || ((val &
>> (_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA)) {
>>                 unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
>>                 unsigned long pfn = mfn_to_pfn(mfn);
>>
>> @@ -381,7 +381,7 @@ static pteval_t pte_mfn_to_pfn(pteval_t val)
>>
>>  static pteval_t pte_pfn_to_mfn(pteval_t val)
>>  {
>> -       if (val & _PAGE_PRESENT) {
>> +       if ((val & _PAGE_PRESENT) || ((val &
>> (_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA)) {
>>                 unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
>>                 pteval_t flags = val & PTE_FLAGS_MASK;
>>                 unsigned long mfn;
>
> Would reusing pte_present be an option? Ordinarily I expect that
> PAGE_NUMA/PAGE_PROTNONE is only set if PAGE_PRESENT is not set and pte_present
> is defined as
>
> static inline int pte_present(pte_t a)
> {
>         return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE |
>                                _PAGE_NUMA);
> }
>
> So it looks like it work work. Of course it would need to be split to
> reuse it within xen if pte_present was split to have a pteval_present
> helper like so
>
> static inline int pteval_present(pteval_t val)
> {
>         /*
>          * Yes Linus, _PAGE_PROTNONE == _PAGE_NUMA. Expressing it this
>          * way clearly states that the intent is that a protnone and numa
>          * hinting ptes are considered present for the purposes of
>          * pagetable operations like zapping, protection changes, gup etc.
>          */
>         return val & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_NUMA);
> }
>
> static inline int pte_present(pte_t pte)
> {
>         return pteval_present(pte_flags(pte))
> }
>
> If Xen is doing some other tricks with _PAGE_PRESENT then it might be
> ruled out as an option. If so, then maybe it could still be made a
> little clearer for future reference?

Yes, sure, it should work, I tried it.
Thank you Mel.

>
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index c1d406f..ff621de 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -365,7 +365,7 @@ void xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
>  /* Assume pteval_t is equivalent to all the other *val_t types. */
>  static pteval_t pte_mfn_to_pfn(pteval_t val)
>  {
> -       if (val & _PAGE_PRESENT) {
> +       if ((val & _PAGE_PRESENT) || pteval_numa(val)) {
>                 unsigned long mfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
>                 unsigned long pfn = mfn_to_pfn(mfn);
>
> @@ -381,7 +381,7 @@ static pteval_t pte_mfn_to_pfn(pteval_t val)
>
>  static pteval_t pte_pfn_to_mfn(pteval_t val)
>  {
> -       if (val & _PAGE_PRESENT) {
> +       if ((val & _PAGE_PRESENT) || pteval_numa(val)) {
>                 unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
>                 pteval_t flags = val & PTE_FLAGS_MASK;
>                 unsigned long mfn;
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 8e4f41d..693fe00 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -654,10 +654,14 @@ static inline int pmd_trans_unstable(pmd_t *pmd)
>   * (because _PAGE_PRESENT is not set).
>   */
>  #ifndef pte_numa
> +static inline int pteval_numa(pteval_t pteval)
> +{
> +       return (pteval & (_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA;
> +}
> +
>  static inline int pte_numa(pte_t pte)
>  {
> -       return (pte_flags(pte) &
> -               (_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA;
> +       return pteval_numa(pte_flags(pte));
>  }
>  #endif
>



-- 
Elena
