Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaIXHJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:09:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaIXHJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:09:43 -0400
Date: Wed, 24 Sep 2014 09:09:39 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] mm, debug: mm-introduce-vm_bug_on_mm-fix-fix.patch
Message-ID: <20140924070939.GA26917@dhcp22.suse.cz>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
 <1411464279-20158-1-git-send-email-mhocko@suse.cz>
 <20140923112848.GA10046@dhcp22.suse.cz>
 <83907.1411489189@turing-police.cc.vt.edu>
 <20140923135258.faf628403a58701da5a981df@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923135258.faf628403a58701da5a981df@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-09-14 13:52:58, Andrew Morton wrote:
> On Tue, 23 Sep 2014 12:19:49 -0400 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Tue, 23 Sep 2014 13:28:48 +0200, Michal Hocko said:
> > > And there is another one hitting during randconfig. The patch makes my
> > > eyes bleed
> > 
> > Amen.  But I'm not seeing a better fix either.
> > 
> > >  #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
> > > -		"tlb_flush_pending %d\n",
> > > +		"tlb_flush_pending %d\n"
> > >  #endif
> > > -		mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
> > > +		, mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
> > 
> > I'm surprised that checkpatch doesn't explode on this.  And I'm starting
> > a pool on how soon somebody submits a patch to "fix" this. :)
> 
> It is all pretty godawful.  We can eliminate the tricks with the comma
> separators by adding an always-there, does-nothing argument:

yes, this is safer if we have more conditional fields in mm_struct later
on. It is also less awful. Thanks!

> 
> --- a/mm/debug.c~mm-debug-mm-introduce-vm_bug_on_mm-fix-fixpatch-fix
> +++ a/mm/debug.c
> @@ -197,7 +197,9 @@ void dump_mm(const struct mm_struct *mm)
>  #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
>  		"tlb_flush_pending %d\n"
>  #endif
> -		, mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
> +		"%s",	/* This is here to hold the comma */
> +
> +		mm, mm->mmap, mm->vmacache_seqnum, mm->task_size,
>  #ifdef CONFIG_MMU
>  		mm->get_unmapped_area,
>  #endif
> @@ -218,16 +220,17 @@ void dump_mm(const struct mm_struct *mm)
>  #ifdef CONFIG_MEMCG
>  		mm->owner,
>  #endif
> -		mm->exe_file
> +		mm->exe_file,
>  #ifdef CONFIG_MMU_NOTIFIER
> -		, mm->mmu_notifier_mm
> +		mm->mmu_notifier_mm,
>  #endif
>  #ifdef CONFIG_NUMA_BALANCING
> -		, mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq
> +		mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq,
>  #endif
>  #if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
> -		, mm->tlb_flush_pending
> +		mm->tlb_flush_pending,
>  #endif
> +		""		/* This is here to not have a comma! */
>  		);
>  
>  		dump_flags(mm->def_flags, vmaflags_names,
> _
> 

-- 
Michal Hocko
SUSE Labs
