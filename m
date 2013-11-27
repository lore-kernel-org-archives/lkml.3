Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3K0Lie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:38:34 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:41743 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3K0Lic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:38:32 -0500
MIME-Version: 1.0
In-Reply-To: <20131101220649.696585269@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org> <20131101220649.696585269@linuxfoundation.org>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 27 Nov 2013 12:38:10 +0100
Message-ID: <CAJ75kXa=zh3NBRqR43nRv2s7WToDMNSmARs1PMABOE8-7hksDw@mail.gmail.com>
Subject: Re: [PATCH 3.11 54/66] mm: migration: do not lose soft dirty bit if
 page is in migration state
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I was wondering if v3.10.x stable branch was also concerned by this
patch since I did not found it in this later branch.
Maybe too hard to backport? (I saw that it requires new functions like
pte_swp_soft_dirty which is not present in v3.10.x)
Maybe it was planned in the future?

Thanks,

On Fri, Nov 1, 2013 at 11:07 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.11-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Cyrill Gorcunov <gorcunov@gmail.com>
>
> commit c3d16e16522fe3fe8759735850a0676da18f4b1d upstream.
>
> If page migration is turned on in config and the page is migrating, we
> may lose the soft dirty bit.  If fork and mprotect are called on
> migrating pages (once migration is complete) pages do not obtain the
> soft dirty bit in the correspond pte entries.  Fix it adding an
> appropriate test on swap entries.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  mm/memory.c   |    2 ++
>  mm/migrate.c  |    2 ++
>  mm/mprotect.c |    7 +++++--
>  3 files changed, 9 insertions(+), 2 deletions(-)
>
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -861,6 +861,8 @@ copy_one_pte(struct mm_struct *dst_mm, s
>                                          */
>                                         make_migration_entry_read(&entry);
>                                         pte = swp_entry_to_pte(entry);
> +                                       if (pte_swp_soft_dirty(*src_pte))
> +                                               pte = pte_swp_mksoft_dirty(pte);
>                                         set_pte_at(src_mm, addr, src_pte, pte);
>                                 }
>                         }
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -157,6 +157,8 @@ static int remove_migration_pte(struct p
>
>         get_page(new);
>         pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
> +       if (pte_swp_soft_dirty(*ptep))
> +               pte = pte_mksoft_dirty(pte);
>         if (is_write_migration_entry(entry))
>                 pte = pte_mkwrite(pte);
>  #ifdef CONFIG_HUGETLB_PAGE
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -94,13 +94,16 @@ static unsigned long change_pte_range(st
>                         swp_entry_t entry = pte_to_swp_entry(oldpte);
>
>                         if (is_write_migration_entry(entry)) {
> +                               pte_t newpte;
>                                 /*
>                                  * A protection check is difficult so
>                                  * just be safe and disable write
>                                  */
>                                 make_migration_entry_read(&entry);
> -                               set_pte_at(mm, addr, pte,
> -                                       swp_entry_to_pte(entry));
> +                               newpte = swp_entry_to_pte(entry);
> +                               if (pte_swp_soft_dirty(oldpte))
> +                                       newpte = pte_swp_mksoft_dirty(newpte);
> +                               set_pte_at(mm, addr, pte, newpte);
>                         }
>                         pages++;
>                 }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
William
