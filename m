Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaI3EyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:54:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:49519 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaI3EyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:54:06 -0400
Date: Mon, 29 Sep 2014 21:52:24 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/5] mm/hugetlb: fix getting refcount 0 page in
 hugetlb_fault()
In-Reply-To: <1410820799-27278-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.LSU.2.11.1409292132370.4640@eggly.anvils>
References: <1410820799-27278-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1410820799-27278-4-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2014, Naoya Horiguchi wrote:
> When running the test which causes the race as shown in the previous patch,
> we can hit the BUG "get_page() on refcount 0 page" in hugetlb_fault().

Two minor comments...

> @@ -3192,22 +3208,19 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> 	 * Note that locking order is always pagecache_page -> page,
>  	 * so no worry about deadlock.

That sentence of comment is stale and should be deleted,
now that you're only doing a trylock_page(page) here.

>  out_mutex:
>  	mutex_unlock(&htlb_fault_mutex_table[hash]);
> +	if (need_wait_lock)
> +		wait_on_page_locked(page);
>  	return ret;
>  }

It will be hard to trigger any problem from this (I guess it would
need memory hotremove), but you ought really to hold a reference to
page while doing a wait_on_page_locked(page).
