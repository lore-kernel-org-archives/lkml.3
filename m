Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaJNLz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:55:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbaJNLzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:55:55 -0400
Date: Tue, 14 Oct 2014 13:55:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] mm, debug: mm-introduce-vm_bug_on_mm-fix-fix.patch
Message-ID: <20141014115554.GB8727@dhcp22.suse.cz>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
 <1411464279-20158-1-git-send-email-mhocko@suse.cz>
 <20140923112848.GA10046@dhcp22.suse.cz>
 <20140923201204.GB4252@redhat.com>
 <20141013185156.GA1959@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013185156.GA1959@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 13-10-14 14:51:56, Dave Jones wrote:
[...]
> diff --git a/mm/debug.c b/mm/debug.c
> index 5ce45c9a29b5..e04e2ae902a1 100644
> --- a/mm/debug.c
> +++ b/mm/debug.c
> @@ -164,74 +164,85 @@ void dump_vma(const struct vm_area_struct *vma)
>  }
>  EXPORT_SYMBOL(dump_vma);
>  
> +static char dumpmm_buffer[4096];
> +
>  void dump_mm(const struct mm_struct *mm)
>  {
> -	pr_emerg("mm %p mmap %p seqnum %d task_size %lu\n"
> -#ifdef CONFIG_MMU
> -		"get_unmapped_area %p\n"
> -#endif
> -		"mmap_base %lu mmap_legacy_base %lu highest_vm_end %lu\n"
> -		"pgd %p mm_users %d mm_count %d nr_ptes %lu map_count %d\n"
> -		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
> -		"pinned_vm %lx shared_vm %lx exec_vm %lx stack_vm %lx\n"
> -		"start_code %lx end_code %lx start_data %lx end_data %lx\n"
> -		"start_brk %lx brk %lx start_stack %lx\n"
> -		"arg_start %lx arg_end %lx env_start %lx env_end %lx\n"
> -		"binfmt %p flags %lx core_state %p\n"
> -#ifdef CONFIG_AIO
> -		"ioctx_table %p\n"
> -#endif
> -#ifdef CONFIG_MEMCG
> -		"owner %p "
> -#endif
> -		"exe_file %p\n"
> -#ifdef CONFIG_MMU_NOTIFIER
> -		"mmu_notifier_mm %p\n"
> -#endif
> -#ifdef CONFIG_NUMA_BALANCING
> -		"numa_next_scan %lu numa_scan_offset %lu numa_scan_seq %d\n"
> -#endif
> -#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
> -		"tlb_flush_pending %d\n"
> -#endif
> -		"%s",	/* This is here to hold the comma */
> +	char *p = dumpmm_buffer;
> +
> +	memset(dumpmm_buffer, 0, 4096);

I do not see any locking here. Previously we had internal printk log as
a natural synchronization. Now two threads are allowed to scribble over
their messages leaving an unusable output in a better case.

Besides that the %s with "" trick is not really that ugly and handles
the situation quite nicely. So do we really want to make it more
complicated?
-- 
Michal Hocko
SUSE Labs
