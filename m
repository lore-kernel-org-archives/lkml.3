Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaCNM7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:59:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbaCNM7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:59:03 -0400
Date: Fri, 14 Mar 2014 08:58:37 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, jmario@redhat.com, jolsa@redhat.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: perf MMAP2 interface and COW faults
Message-ID: <20140314125837.GW25953@redhat.com>
References: <20140313200352.GU25953@redhat.com>
 <20140314111705.GU27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314111705.GU27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 12:17:05PM +0100, Peter Zijlstra wrote:
> On Thu, Mar 13, 2014 at 04:03:52PM -0400, Don Zickus wrote:
> > Hi Peter,
> > 
> > So we found another corner case with MMAP2 interface.  I don't think it is
> > a big hurdle to overcome, just wanted a suggestion.
> > 
> > Joe ran specjbb2013 (which creates about 10,000 java threads across 9
> > processes) and our c2c tool turned up some cacheline collision data on
> > libjvm.so.  This didn't make sense because you shouldn't be able to write
> > to a shared library.
> > 
> > Even worse, our tool said it affected all the java process and a majority
> > of the threads.  Which again didn't make sense because this shared library
> > should be local to each pid's memory.
> > 
> > Anyway, what we determined is that the shared library had mmap data that
> > was non-zero (because it was backed by a file, libjvm.so).  So the
> > assumption was if the major, minor, inode and inode generation numbers
> > were non-zero, this memory segment was shared across processes.
> > 
> > So perf setup its map files for the mmap area and then started sampling data
> > addresses.  A few hundred HITMs were to a virtual address that fell into
> > the libjvm.so memory segment (which was assumed to be mmap'd across
> > processes).
> > 
> > Coalescing all the data suggested that multiple pids/tids were contending
> > for a cacheline in a shared library.
> > 
> > After talking with Larry Woodman, we realized when you write to a 'data' or
> > 'bss' segment of a shared library, you incur a COW fault that maps to an
> > anonymous page in the pid's memory.  However, perf doesn't see this.
> > 
> > So when all the tids start writing to this 'data' or 'bss' segment they
> > generate HITMs within their pid (which is fine).  However the tool thinks
> > it affects other pids (which is not fine).
> > 
> > My question is, how can our tool determine if a virtual address is private
> > to a pid or not?  Originally it had to have a zero for maj, min, ino, and
> > ino gen.  But for file map'd libraries this doesn't always work because we
> > don't see COW faults in perf (and we may not want too :-) ).
> > 
> > Is there another technique we can use?  Perhaps during the reading of
> > /proc/<pid>/maps, if the protection is marked 'p' for private, we just tell
> > the sort algorithm to sort locally to the process but a 's' for shared can
> > be sorted globally based on data addresses?
> > 
> > Or something else that tells us that a virtual address has changed its
> > mapping?  Thoughts?
> 
> Very good indeed; we're missing the protection and flags bits.
> 
> How about something like the below; with that you can solve your problem
> by looking at mmap2.flags & MAP_PRIVATE.

Hmmm.  That will probably work for future mmap events.  My problem is for
synthesized mmap events.  We read the same protection bits from
/proc/<pid>/maps file, so I assume the same strategy can work for those
events too?

Let me incorporate this patch and hack up perf to handle it and let you
know how it goes.

Thanks!

Cheers,
Don

> 
> ---
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 853bc1ccb395..2ed502f5679f 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -699,6 +699,7 @@ enum perf_event_type {
>  	 *	u32				min;
>  	 *	u64				ino;
>  	 *	u64				ino_generation;
> +	 *	u32				prot, flags;
>  	 *	char				filename[];
>  	 * 	struct sample_id		sample_id;
>  	 * };
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 661951ab8ae7..6d50791d3d96 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5100,6 +5107,7 @@ struct perf_mmap_event {
>  	int			maj, min;
>  	u64			ino;
>  	u64			ino_generation;
> +	u32			prot, flags;
>  
>  	struct {
>  		struct perf_event_header	header;
> @@ -5141,6 +5149,8 @@ static void perf_event_mmap_output(struct perf_event *event,
>  		mmap_event->event_id.header.size += sizeof(mmap_event->min);
>  		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
>  		mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
> +		mmap_event->event_id.header.size += sizeof(mmap_event->prot);
> +		mmap_event->event_id.header.size += sizeof(mmap_event->flags);
>  	}
>  
>  	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
> @@ -5159,6 +5169,8 @@ static void perf_event_mmap_output(struct perf_event *event,
>  		perf_output_put(&handle, mmap_event->min);
>  		perf_output_put(&handle, mmap_event->ino);
>  		perf_output_put(&handle, mmap_event->ino_generation);
> +		perf_output_put(&handle, mmap_event->prot);
> +		perf_output_put(&handle, mmap_event->flags);
>  	}
>  
>  	__output_copy(&handle, mmap_event->file_name,
> @@ -5177,11 +5189,35 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
>  	struct file *file = vma->vm_file;
>  	int maj = 0, min = 0;
>  	u64 ino = 0, gen = 0;
> +	u32 prot = 0, flags = 0;
>  	unsigned int size;
>  	char tmp[16];
>  	char *buf = NULL;
>  	char *name;
>  
> +	if (event->attr.mmap2) {
> +		if (vma->vm_flags & VM_READ)
> +			prot |= PROT_READ;
> +		if (vma->vm_flags & VM_WRITE)
> +			prot |= PROT_WRITE;
> +		if (vma->vm_flags & VM_EXEC)
> +			prot |= PROT_EXEC;
> +
> +		if (vma->vm_flags & VM_MAYSHARE)
> +			flags = MAP_SHARED;
> +		else
> +			flags = MAP_PRIVATE;
> +
> +		if (vma->vm_flags & VM_DENYWRITE)
> +			flags |= MAP_DENYWRITE;
> +		if (vma->vm_flags & VM_MAYEXEC)
> +			flags |= MAP_EXECUTABLE;
> +		if (vma->vm_flags & VM_LOCKED)
> +			flags |= MAP_LOCKED;
> +		if (vma->vm_flags & VM_HUGETLB)
> +			flags |= MAP_HUGETLB;
> +	}
> +
>  	if (file) {
>  		struct inode *inode;
>  		dev_t dev;
> @@ -5247,6 +5283,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
>  	mmap_event->min = min;
>  	mmap_event->ino = ino;
>  	mmap_event->ino_generation = gen;
> +	mmap_event->prot = prot;
> +	mmap_event->flags = flags;
>  
>  	if (!(vma->vm_flags & VM_EXEC))
>  		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
> @@ -5287,6 +5325,8 @@ void perf_event_mmap(struct vm_area_struct *vma)
>  		/* .min (attr_mmap2 only) */
>  		/* .ino (attr_mmap2 only) */
>  		/* .ino_generation (attr_mmap2 only) */
> +		/* .prot (attr_mmap2 only) */
> +		/* .flags (attr_mmap2 only) */
>  	};
>  
>  	perf_event_mmap_event(&mmap_event);
