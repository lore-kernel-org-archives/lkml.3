Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaJGWEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:04:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:64308 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaJGWEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,673,1406617200"; 
   d="scan'208";a="614788194"
Message-ID: <5434630C.3070006@intel.com>
Date: Tue, 07 Oct 2014 15:02:52 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        mgorman@suse.de, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 5/5] mm: poison page struct
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com> <1412041639-23617-6-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1412041639-23617-6-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 06:47 PM, Sasha Levin wrote:
>  struct page {
> +#ifdef CONFIG_DEBUG_VM_POISON
> +	u32 poison_start;
> +#endif
>  	/* First double word block */
>  	unsigned long flags;		/* Atomic flags, some possibly
>  					 * updated asynchronously */
> @@ -196,6 +199,9 @@ struct page {
>  #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
>  	int _last_cpupid;
>  #endif
> +#ifdef CONFIG_DEBUG_VM_POISON
> +	u32 poison_end;
> +#endif
>  }

Does this break slub's __cmpxchg_double_slab trick?  I thought it
required page->freelist and page->counters to be doubleword-aligned.

It's not like we really require this optimization when we're debugging,
but trying to use it will unnecessarily slow things down.

FWIW, if you're looking to trim down the number of lines of code, you
could certainly play some macro tricks and #ifdef tricks.

struct vm_poison {
#ifdef CONFIG_DEBUG_VM_POISON
	u32 val;
#endif	
};

Then, instead of #ifdefs in each structure, you do:

struct page {
	struct vm_poison poison_start;
	... other gunk
	struct vm_poison poison_end;
};
