Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaLINaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:30:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758AbaLINai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:30:38 -0500
Date: Tue, 9 Dec 2014 11:30:31 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        ak@linux.intel.com, Jiri Olsa <jolsa@redhat.com>, acme@kernel.org
Subject: Re: [PATCH v7 1/6] perf: add ability to sample machine state on
 interrupt
Message-ID: <20141209133031.GC2406@redhat.com>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
 <1411559322-16548-2-git-send-email-eranian@google.com>
 <20141121212631.GF5395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121212631.GF5395@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 21, 2014 at 07:26:31PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Sep 24, 2014 at 01:48:37PM +0200, Stephane Eranian escreveu:
> > Enable capture of interrupted machine state for each
> > sample.
> > 
> > Registers to sample are passed per event in the
> > sample_regs_intr bitmask.
> > 
> > To sample interrupt machine state, the
> > PERF_SAMPLE_INTR_REGS must be passed in
> > sample_type.
> > 
> > The list of available registers is arch
> > dependent and provided by asm/perf_regs.h
> > 
> > Registers are laid out as u64 in the order
> > of the bit order of sample_intr_regs.
> > 
> > This patch also adds a new ABI version
> > PERF_ATTR_SIZE_VER4 because we extend
> > the perf_event_attr struct with a new u64
> > field.

I think this problem is also related to this changeset:

[root@zoo ~]# perf test 15
15: struct perf_event_attr setup                           :FAILED
'/home/acme/libexec/perf-core/tests/attr/test-stat-default' - match
failure
 Ok
[root@zoo ~]# perf test -v 15
15: struct perf_event_attr setup                           :
--- start ---
test child forked, pid 17464
running
'/home/acme/libexec/perf-core/tests/attr/test-record-branch-filter-hv'
unsupp
'/home/acme/libexec/perf-core/tests/attr/test-record-branch-filter-hv'
running '/home/acme/libexec/perf-core/tests/attr/test-record-count'
unsupp  '/home/acme/libexec/perf-core/tests/attr/test-record-count'
running '/home/acme/libexec/perf-core/tests/attr/test-record-basic'
unsupp  '/home/acme/libexec/perf-core/tests/attr/test-record-basic'
running '/home/acme/libexec/perf-core/tests/attr/test-stat-default'
expected size=96, got 104
FAILED '/home/acme/libexec/perf-core/tests/attr/test-stat-default' -
match failure
test child finished with 0
---- end ----
struct perf_event_attr setup: Ok
[root@zoo ~]# uname -r
3.17.3-200.fc20.x86_64
[root@zoo ~]#

Checking if this is just a matter of updating the test entry.

- Arnaldo

> 
> So, trying to bisect a problem with how the TUI hist_entries browser
> renders callchains I got stuck with:
> 
> [root@zoo acme]# perf report 
> incompatible file format (rerun with -v to learn more)
> 
> [root@zoo acme]# perf report -v
> file uses a more recent and unsupported ABI (8 bytes extra)
> 
> Because the perf.data file was generated with HEAD of perf/core and
> probably the above warning comes from a simple check against the ABI
> version...
> 
> I wonder if we can't just check that there are no sample_types that we
> don't know and if not, just process the file anyway, i.e. the sample
> will be parseable, no?
> 
> For now, in this case, I'll just regenerate the perf.data file with an
> older tool...
> 
> - Arnaldo
>  
> > Reviewed-by: Jiri Olsa <jolsa@redhat.com>
> > Reviewed-by: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> > ---
> >  include/linux/perf_event.h      |    7 ++++--
> >  include/uapi/linux/perf_event.h |   15 ++++++++++++-
> >  kernel/events/core.c            |   46 +++++++++++++++++++++++++++++++++++++--
> >  3 files changed, 63 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index 893a0d0..68d46d5 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -79,7 +79,7 @@ struct perf_branch_stack {
> >  	struct perf_branch_entry	entries[0];
> >  };
> >  
> > -struct perf_regs_user {
> > +struct perf_regs {
> >  	__u64		abi;
> >  	struct pt_regs	*regs;
> >  };
> > @@ -600,7 +600,8 @@ struct perf_sample_data {
> >  	struct perf_callchain_entry	*callchain;
> >  	struct perf_raw_record		*raw;
> >  	struct perf_branch_stack	*br_stack;
> > -	struct perf_regs_user		regs_user;
> > +	struct perf_regs		regs_user;
> > +	struct perf_regs		regs_intr;
> >  	u64				stack_user_size;
> >  	u64				weight;
> >  	/*
> > @@ -630,6 +631,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
> >  	data->weight = 0;
> >  	data->data_src.val = PERF_MEM_NA;
> >  	data->txn = 0;
> > +	data->regs_intr.abi = PERF_SAMPLE_REGS_ABI_NONE;
> > +	data->regs_intr.regs = NULL;
> >  }
> >  
> >  extern void perf_output_sample(struct perf_output_handle *handle,
> > diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> > index 9269de2..48d4a01 100644
> > --- a/include/uapi/linux/perf_event.h
> > +++ b/include/uapi/linux/perf_event.h
> > @@ -137,8 +137,9 @@ enum perf_event_sample_format {
> >  	PERF_SAMPLE_DATA_SRC			= 1U << 15,
> >  	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
> >  	PERF_SAMPLE_TRANSACTION			= 1U << 17,
> > +	PERF_SAMPLE_REGS_INTR			= 1U << 18,
> >  
> > -	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
> > +	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
> >  };
> >  
> >  /*
> > @@ -238,6 +239,7 @@ enum perf_event_read_format {
> >  #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
> >  #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
> >  					/* add: sample_stack_user */
> > +#define PERF_ATTR_SIZE_VER4	104	/* add: sample_regs_intr */
> >  
> >  /*
> >   * Hardware event_id to monitor via a performance monitoring event:
> > @@ -334,6 +336,15 @@ struct perf_event_attr {
> >  
> >  	/* Align to u64. */
> >  	__u32	__reserved_2;
> > +	/*
> > +	 * Defines set of regs to dump for each sample
> > +	 * state captured on:
> > +	 *  - precise = 0: PMU interrupt
> > +	 *  - precise > 0: sampled instruction
> > +	 *
> > +	 * See asm/perf_regs.h for details.
> > +	 */
> > +	__u64	sample_regs_intr;
> >  };
> >  
> >  #define perf_flags(attr)	(*(&(attr)->read_format + 1))
> > @@ -686,6 +697,8 @@ enum perf_event_type {
> >  	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
> >  	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
> >  	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
> > +	 *	{ u64			abi; # enum perf_sample_regs_abi
> > +	 *	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_INTR
> >  	 * };
> >  	 */
> >  	PERF_RECORD_SAMPLE			= 9,
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index eaa636e..7941343 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -4430,7 +4430,7 @@ perf_output_sample_regs(struct perf_output_handle *handle,
> >  	}
> >  }
> >  
> > -static void perf_sample_regs_user(struct perf_regs_user *regs_user,
> > +static void perf_sample_regs_user(struct perf_regs *regs_user,
> >  				  struct pt_regs *regs)
> >  {
> >  	if (!user_mode(regs)) {
> > @@ -4446,6 +4446,14 @@ static void perf_sample_regs_user(struct perf_regs_user *regs_user,
> >  	}
> >  }
> >  
> > +static void perf_sample_regs_intr(struct perf_regs *regs_intr,
> > +				  struct pt_regs *regs)
> > +{
> > +	regs_intr->regs = regs;
> > +	regs_intr->abi  = perf_reg_abi(current);
> > +}
> > +
> > +
> >  /*
> >   * Get remaining task size from user stack pointer.
> >   *
> > @@ -4827,6 +4835,23 @@ void perf_output_sample(struct perf_output_handle *handle,
> >  	if (sample_type & PERF_SAMPLE_TRANSACTION)
> >  		perf_output_put(handle, data->txn);
> >  
> > +	if (sample_type & PERF_SAMPLE_REGS_INTR) {
> > +		u64 abi = data->regs_intr.abi;
> > +		/*
> > +		 * If there are no regs to dump, notice it through
> > +		 * first u64 being zero (PERF_SAMPLE_REGS_ABI_NONE).
> > +		 */
> > +		perf_output_put(handle, abi);
> > +
> > +		if (abi) {
> > +			u64 mask = event->attr.sample_regs_intr;
> > +
> > +			perf_output_sample_regs(handle,
> > +						data->regs_intr.regs,
> > +						mask);
> > +		}
> > +	}
> > +
> >  	if (!event->attr.watermark) {
> >  		int wakeup_events = event->attr.wakeup_events;
> >  
> > @@ -4913,7 +4938,7 @@ void perf_prepare_sample(struct perf_event_header *header,
> >  		 * in case new sample type is added, because we could eat
> >  		 * up the rest of the sample size.
> >  		 */
> > -		struct perf_regs_user *uregs = &data->regs_user;
> > +		struct perf_regs *uregs = &data->regs_user;
> >  		u16 stack_size = event->attr.sample_stack_user;
> >  		u16 size = sizeof(u64);
> >  
> > @@ -4934,6 +4959,21 @@ void perf_prepare_sample(struct perf_event_header *header,
> >  		data->stack_user_size = stack_size;
> >  		header->size += size;
> >  	}
> > +
> > +	if (sample_type & PERF_SAMPLE_REGS_INTR) {
> > +		/* regs dump ABI info */
> > +		int size = sizeof(u64);
> > +
> > +		perf_sample_regs_intr(&data->regs_intr, regs);
> > +
> > +		if (data->regs_intr.regs) {
> > +			u64 mask = event->attr.sample_regs_intr;
> > +
> > +			size += hweight64(mask) * sizeof(u64);
> > +		}
> > +
> > +		header->size += size;
> > +	}
> >  }
> >  
> >  static void perf_event_output(struct perf_event *event,
> > @@ -7134,6 +7174,8 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
> >  			ret = -EINVAL;
> >  	}
> >  
> > +	if (attr->sample_type & PERF_SAMPLE_REGS_INTR)
> > +		ret = perf_reg_validate(attr->sample_regs_intr);
> >  out:
> >  	return ret;
> >  
> > -- 
> > 1.7.9.5
