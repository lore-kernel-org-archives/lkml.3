Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaHAFDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 01:03:39 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33084 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaHAFDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 01:03:37 -0400
Date: Thu, 31 Jul 2014 22:01:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jerome Marchand <jmarchan@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-doc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 2/5] mm, shmem: Add shmem_locate function
In-Reply-To: <1406036632-26552-3-git-send-email-jmarchan@redhat.com>
Message-ID: <alpine.LSU.2.11.1407312201280.3912@eggly.anvils>
References: <1406036632-26552-1-git-send-email-jmarchan@redhat.com> <1406036632-26552-3-git-send-email-jmarchan@redhat.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Jerome Marchand wrote:

> The shmem subsytem is kind of a black box: the generic mm code can't

I'm happier with that black box than you are :)

> always know where a specific page physically is. This patch adds the
> shmem_locate() function to find out the physical location of shmem
> pages (resident, in swap or swapcache). If the optional argument count
> isn't NULL and the page is resident, it also returns the mapcount value
> of this page.
> This is intended to allow finer accounting of shmem/tmpfs pages.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  include/linux/mm.h |  7 +++++++
>  mm/shmem.c         | 29 +++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e69ee9d..34099fa 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1066,6 +1066,13 @@ extern bool skip_free_areas_node(unsigned int flags, int nid);
>  
>  int shmem_zero_setup(struct vm_area_struct *);
>  #ifdef CONFIG_SHMEM
> +
> +#define SHMEM_NOTPRESENT	1 /* page is not present in memory */
> +#define SHMEM_RESIDENT		2 /* page is resident in RAM */
> +#define SHMEM_SWAPCACHE		3 /* page is in swap cache */
> +#define SHMEM_SWAP		4 /* page is paged out */
> +
> +extern int shmem_locate(struct vm_area_struct *vma, pgoff_t pgoff, int *count);

Please place these, or what's needed of them, in include/linux/shmem_fs.h,
rather than in the very overloaded include/linux/mm.h.
You will need a !CONFIG_SHMEM stub for shmem_locate(),
or whatever it ends up being called.

>  bool shmem_mapping(struct address_space *mapping);

Oh, you're following a precedent, that's already bad placement.
And it (but not its !CONFIG_SHMEM stub) is duplicated in shmem_fs.h.
Perhaps because we were moving shmem_zero_setup() from mm.h to shmem_fs.h
some time ago, but never got around to cleaning up the old location.

Well, please place the new ones in shmem_fs.h, and I ought to clean
up the rest at a time which does not interfere with you.

>  #else
>  static inline bool shmem_mapping(struct address_space *mapping)
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b16d3e7..8aa4892 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1341,6 +1341,35 @@ static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	return ret;
>  }
>  
> +int shmem_locate(struct vm_area_struct *vma, pgoff_t pgoff, int *count)

I don't find that a helpful name; but in 5/5 I question the info you're
gathering here - maybe a good name will be more obvious once we've cut
down what it's gathering.

I just noticed that in 5/5 you're using a walk->pte_hole across
empty extents: perhaps I'm prematurely optimizing, but that feels very
inefficient, maybe here you should use a radix_tree lookup of the extent.

If all we had to look up were the number of swap entries, in the vast
majority of cases shmem.c could just see info->swapped is 0 and spend
no time on radix_tree lookups at all.

But what happens here depends on what really needs to be shown in 5/5.

Hugh
