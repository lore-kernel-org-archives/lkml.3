Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaG1P0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:26:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:5013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbaG1P0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:26:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,749,1400050800"; 
   d="scan'208";a="550183970"
Message-ID: <53D66BB1.8080905@linux.intel.com>
Date: Mon, 28 Jul 2014 08:26:41 -0700
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Sasha Levin <sasha.levin@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: don't allow fault_around_bytes to be 0
References: <53D07E96.5000006@oracle.com> <1406533400-6361-1-git-send-email-a.ryabinin@samsung.com> <20140728093611.GA3975@node.dhcp.inet.fi>
In-Reply-To: <20140728093611.GA3975@node.dhcp.inet.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 02:36 AM, Kirill A. Shutemov wrote:
> +++ b/mm/memory.c
> @@ -2786,7 +2786,8 @@ static int fault_around_bytes_set(void *data, u64 val)
>  {
>  	if (val / PAGE_SIZE > PTRS_PER_PTE)
>  		return -EINVAL;
> -	fault_around_bytes = val;
> +	/* rounddown_pow_of_two(0) is not defined */
> +	fault_around_bytes = max(val, PAGE_SIZE);
>  	return 0;
>  }

It's also possible to race and have fault_around_bytes change between
when fault_around_mask() and fault_around_pages() are called so that
they don't match any more.  The min()/max() in do_fault_around() should
keep this from doing anything _too_ nasty, but it's worth thinking about
at least.

The safest thing to do might be to use an ACCESS_ONCE() at the beginning
of do_fault_around() for fault_around_bytes and generate
fault_around_mask() from the ACCESS_ONCE() result.
