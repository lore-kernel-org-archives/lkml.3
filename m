Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaFIV4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:56:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:59528 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbaFIV4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:56:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352713536"
Message-ID: <53962C4D.30600@intel.com>
Date: Mon, 09 Jun 2014 14:51:09 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] mm/pagewalk: replace mm_walk->skip with more general
 mm_walk->control
References: <1402095520-10109-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1402095520-10109-3-git-send-email-n-horiguchi@ah.jp.nec.com> <539612A8.8080303@intel.com> <1402349339-n9udlcv2@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1402349339-n9udlcv2@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 02:29 PM, Naoya Horiguchi wrote:
>   static int subpage_walk_pmd_entry(pmd_t *pmd, unsigned long addr,
>                                    unsigned long end, struct mm_walk *walk)
>   {
>          struct vm_area_struct *vma = walk->vma;
> +        spin_unlock(walk->ptl);
>          split_huge_page_pmd(vma, addr, pmd);
> +        spin_lock(walk->ptl);
>          return 0;
>   }
> 
> I thought it's straightforward but dirty, but my workaround in this patch
> was dirty too. So I'm fine to give up the control stuff and take this one.

I think there's essentially no way to fix this with the current
handlers.  This needs the locks to not be held, and everything else
needs them held so that they don't have to do it themselves.

Instead of a flag to control the walk directly, we could have one that
controls whether the locks are held, although that seems quite prone to
breakage.

I think this is rare-enough code that we can live with the hack that
you've got above, although we need to run it by the ppc folks.
