Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbbAMUgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:36:32 -0500
Received: from mga14.intel.com ([192.55.52.115]:28810 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbbAMUgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:36:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="511748605"
Message-ID: <54B581C7.50206@linux.intel.com>
Date: Tue, 13 Jan 2015 12:36:23 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
CC: linux-mm@kvack.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: rename mm->nr_ptes to mm->nr_pgtables
References: <1421176456-21796-1-git-send-email-kirill.shutemov@linux.intel.com> <1421176456-21796-2-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1421176456-21796-2-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 11:14 AM, Kirill A. Shutemov wrote:
>  	pgd_t * pgd;
>  	atomic_t mm_users;			/* How many users with user space? */
>  	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
> -	atomic_long_t nr_ptes;			/* Page table pages */
> +	atomic_long_t nr_pgtables;		/* Page table pages */
>  	int map_count;				/* number of VMAs */

One more crazy idea...

There are 2^9 possible pud pages, 2^18 pmd pages and 2^27 pte pages.
That's only 54 bits (technically minus one bit each because the upper
half of the address space is for the kernel).

That's enough to actually account for pte, pmd and pud pages separately
without increasing the size of the storage we need.  You could even
enforce that warning you were talking about at exit time for pte pages,
but just ignore pmd mismatches so you don't have false warnings on
hugetlbfs shared pmd pages.  Or, even better, strictly track pmd page
usage _unless_ hugetlbfs shared pmds are in play and track _that_ in
another bit.

On 32-bit PAE, that's 2 bits for PMD pages, and 11 for PTE pages, so it
should fit in an atomic_long_t there too.
