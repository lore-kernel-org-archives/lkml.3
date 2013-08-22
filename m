Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3HVP6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:58:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab3HVP6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:58:04 -0400
Date: Thu, 22 Aug 2013 12:57:49 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung.kim@lge.com,
        dsahern@gmail.com
Subject: Re: [PATCH v2 1/2] perf: add attr->mmap2 attribute to an event
Message-ID: <20130822155749.GC6319@infradead.org>
References: <1377079825-19057-1-git-send-email-eranian@google.com>
 <1377079825-19057-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377079825-19057-2-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 21, 2013 at 12:10:24PM +0200, Stephane Eranian escreveu:
> Adds a new PERF_RECORD_MMAP2 record type.
> 
> Used to request mmap records with more information about
> the mapping, including device major, minor and the inode
> number and generation for mappings associated with files
> or shared memory segments. Works for code and data
> (with attr->mmap_data set).
> 
> Existing PERF_RECORD_MMAP record is unmodified by this patch.

So this is exactly what we get from PERF_RECORD_MMAP + a few other
fields, right?

I think we should take the opportunity and remove the fields that are
in PERF_RECORD_MMAP but can be selectively asked for using
->sample_id_all, i.e. we use sample_type to ask for:

	PERF_SAMPLE_CPU
	PERF_SAMPLE_STREAM_ID
	PERF_SAMPLE_ID
	PERF_SAMPLE_TIME
	PERF_SAMPLE_TID

That should not be present in the PERF_RECORD_MMAP2 fixed payload.

This way we take the opportunity to compress the event by using an
existing facility: attr.sample_id_all and attr.sample_type.

But then this is "just" for the 8 bytes used for pid/tid, selectable via
PERF_SAMPLE_TID, so up to peterz, if you think its not worth the
complexity, Acked.

- Arnaldo
 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  include/uapi/linux/perf_event.h |   24 +++++++++++++++++++-
>  kernel/events/core.c            |   46 +++++++++++++++++++++++++++++++++++----
>  2 files changed, 65 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 62c25a2..5268f78 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -275,8 +275,9 @@ struct perf_event_attr {
>  
>  				exclude_callchain_kernel : 1, /* exclude kernel callchains */
>  				exclude_callchain_user   : 1, /* exclude user callchains */
> +				mmap2          :  1, /* include mmap with inode data     */
>  
> -				__reserved_1   : 41;
> +				__reserved_1   : 40;
>  
>  	union {
>  		__u32		wakeup_events;	  /* wakeup every n events */
> @@ -638,6 +639,27 @@ enum perf_event_type {
>  	 */
>  	PERF_RECORD_SAMPLE			= 9,
>  
> +	/*
> +	 * The MMAP2 records are an augmented version of MMAP, they add
> +	 * maj, min, ino numbers to be used to uniquely identify each mapping
> +	 *
> +	 * struct {
> +	 *	struct perf_event_header	header;
> +	 *
> +	 *	u32				pid, tid;
> +	 *	u64				addr;
> +	 *	u64				len;
> +	 *	u64				pgoff;
> +	 *	u32				maj;
> +	 *	u32				min;
> +	 *	u64				ino;
> +	 *	u64				ino_generation;
> +	 *	char				filename[];
> +	 * 	struct sample_id		sample_id;
> +	 * };
> +	 */
> +	PERF_RECORD_MMAP2			= 10,
> +
>  	PERF_RECORD_MAX,			/* non-ABI */
>  };
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 928fae7..60a5bbd 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4767,7 +4767,7 @@ next:
>  /*
>   * task tracking -- fork/exit
>   *
> - * enabled by: attr.comm | attr.mmap | attr.mmap_data | attr.task
> + * enabled by: attr.comm | attr.mmap | attr.mmap2 | attr.mmap_data | attr.task
>   */
>  
>  struct perf_task_event {
> @@ -4787,8 +4787,9 @@ struct perf_task_event {
>  
>  static int perf_event_task_match(struct perf_event *event)
>  {
> -	return event->attr.comm || event->attr.mmap ||
> -	       event->attr.mmap_data || event->attr.task;
> +	return event->attr.comm  || event->attr.mmap ||
> +	       event->attr.mmap2 || event->attr.mmap_data ||
> +	       event->attr.task;
>  }
>  
>  static void perf_event_task_output(struct perf_event *event,
> @@ -4983,6 +4984,9 @@ struct perf_mmap_event {
>  
>  	const char		*file_name;
>  	int			file_size;
> +	int			maj, min;
> +	u64			ino;
> +	u64			ino_generation;
>  
>  	struct {
>  		struct perf_event_header	header;
> @@ -5003,7 +5007,7 @@ static int perf_event_mmap_match(struct perf_event *event,
>  	int executable = vma->vm_flags & VM_EXEC;
>  
>  	return (!executable && event->attr.mmap_data) ||
> -	       (executable && event->attr.mmap);
> +	       (executable && (event->attr.mmap || event->attr.mmap2));
>  }
>  
>  static void perf_event_mmap_output(struct perf_event *event,
> @@ -5018,6 +5022,13 @@ static void perf_event_mmap_output(struct perf_event *event,
>  	if (!perf_event_mmap_match(event, data))
>  		return;
>  
> +	if (event->attr.mmap2) {
> +		mmap_event->event_id.header.type = PERF_RECORD_MMAP2;
> +		mmap_event->event_id.header.size += sizeof(mmap_event->maj);
> +		mmap_event->event_id.header.size += sizeof(mmap_event->min);
> +		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
> +	}
> +
>  	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
>  	ret = perf_output_begin(&handle, event,
>  				mmap_event->event_id.header.size);
> @@ -5028,6 +5039,14 @@ static void perf_event_mmap_output(struct perf_event *event,
>  	mmap_event->event_id.tid = perf_event_tid(event, current);
>  
>  	perf_output_put(&handle, mmap_event->event_id);
> +
> +	if (event->attr.mmap2) {
> +		perf_output_put(&handle, mmap_event->maj);
> +		perf_output_put(&handle, mmap_event->min);
> +		perf_output_put(&handle, mmap_event->ino);
> +		perf_output_put(&handle, mmap_event->ino_generation);
> +	}
> +
>  	__output_copy(&handle, mmap_event->file_name,
>  				   mmap_event->file_size);
>  
> @@ -5042,6 +5061,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
>  {
>  	struct vm_area_struct *vma = mmap_event->vma;
>  	struct file *file = vma->vm_file;
> +	int maj = 0, min = 0;
> +	u64 ino = 0, gen = 0;
>  	unsigned int size;
>  	char tmp[16];
>  	char *buf = NULL;
> @@ -5050,6 +5071,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
>  	memset(tmp, 0, sizeof(tmp));
>  
>  	if (file) {
> +		struct inode *inode;
> +		dev_t dev;
>  		/*
>  		 * d_path works from the end of the rb backwards, so we
>  		 * need to add enough zero bytes after the string to handle
> @@ -5065,6 +5088,13 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
>  			name = strncpy(tmp, "//toolong", sizeof(tmp));
>  			goto got_name;
>  		}
> +		inode = file_inode(vma->vm_file);
> +		dev = inode->i_sb->s_dev;
> +		ino = inode->i_ino;
> +		gen = inode->i_generation;
> +		maj = MAJOR(dev);
> +		min = MINOR(dev);
> +
>  	} else {
>  		if (arch_vma_name(mmap_event->vma)) {
>  			name = strncpy(tmp, arch_vma_name(mmap_event->vma),
> @@ -5095,6 +5125,10 @@ got_name:
>  
>  	mmap_event->file_name = name;
>  	mmap_event->file_size = size;
> +	mmap_event->maj = maj;
> +	mmap_event->min = min;
> +	mmap_event->ino = ino;
> +	mmap_event->ino_generation = gen;
>  
>  	if (!(vma->vm_flags & VM_EXEC))
>  		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
> @@ -5131,6 +5165,10 @@ void perf_event_mmap(struct vm_area_struct *vma)
>  			.len    = vma->vm_end - vma->vm_start,
>  			.pgoff  = (u64)vma->vm_pgoff << PAGE_SHIFT,
>  		},
> +		/* .maj (attr_mmap2 only) */
> +		/* .min (attr_mmap2 only) */
> +		/* .ino (attr_mmap2 only) */
> +		/* .ino_generation (attr_mmap2 only) */
>  	};
>  
>  	perf_event_mmap_event(&mmap_event);
> -- 
> 1.7.10.4
