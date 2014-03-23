Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaCWRu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 13:50:28 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64339 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaCWRu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 13:50:27 -0400
MIME-Version: 1.0
In-Reply-To: <1395436655-21670-3-git-send-email-john.stultz@linaro.org>
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <1395436655-21670-3-git-send-email-john.stultz@linaro.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sun, 23 Mar 2014 10:50:06 -0700
Message-ID: <CAHGf_=rUJwtM-DJ4-Xw9WR3UN3gsA6UdcEvwen=Ku7B03j_2JA@mail.gmail.com>
Subject: Re: [PATCH 2/5] vrange: Add purged page detection on setting memory non-volatile
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/**
> + * vrange_check_purged_pte - Checks ptes for purged pages
> + *
> + * Iterates over the ptes in the pmd checking if they have
> + * purged swap entries.
> + *
> + * Sets the vrange_walker.pages_purged to 1 if any were purged.
> + */
> +static int vrange_check_purged_pte(pmd_t *pmd, unsigned long addr,
> +                                       unsigned long end, struct mm_walk *walk)
> +{
> +       struct vrange_walker *vw = walk->private;
> +       pte_t *pte;
> +       spinlock_t *ptl;
> +
> +       if (pmd_trans_huge(*pmd))
> +               return 0;
> +       if (pmd_trans_unstable(pmd))
> +               return 0;
> +
> +       pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +       for (; addr != end; pte++, addr += PAGE_SIZE) {
> +               if (!pte_present(*pte)) {
> +                       swp_entry_t vrange_entry = pte_to_swp_entry(*pte);
> +
> +                       if (unlikely(is_vpurged_entry(vrange_entry))) {
> +                               vw->page_was_purged = 1;
> +                               break;

This function only detect there is vpurge entry or not. But
VRANGE_NONVOLATILE should remove all vpurge entries.
Otherwise, non-volatiled range still makes SIGBUS.

> +                       }
> +               }
> +       }
> +       pte_unmap_unlock(pte - 1, ptl);
> +       cond_resched();
> +
> +       return 0;
> +}
