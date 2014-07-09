Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaGIPDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:03:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:59855 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaGIPDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:03:38 -0400
Date: Wed, 9 Jul 2014 12:03:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH 1/4] perf: add ability to sample machine state on
 interrupt
Message-ID: <20140709150329.GB2384@redhat.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <1404857759-25105-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404857759-25105-2-git-send-email-eranian@google.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 09, 2014 at 12:15:56AM +0200, Stephane Eranian escreveu:
> Enable capture of interrupted machine state in each
> sample.
> 
> Registers to sample are passed per event in the
> sample_regs_intr bitmask.
> 
> To sample interrupt machine state, the 
> PERF_SAMPLE_INTR_REGS must be passed in
> sample_type.
> 
> The list of available registers is arch
> dependent and provided by asm/perf_regs.h
> 
> Registers are laid out as u64 in the order
> of the bit order of sample_intr_regs.

I would have broken this into smaller pieces, with the first patch doing
the prep of renaming perf_regs_user to perf_regs, for instance.
 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  include/linux/perf_event.h      |  7 +++++--
>  include/uapi/linux/perf_event.h | 14 ++++++++++++-
>  kernel/events/core.c            | 44 +++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 60 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 707617a..4970c1d 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -78,7 +78,7 @@ struct perf_branch_stack {
>  	struct perf_branch_entry	entries[0];
>  };
>  
> -struct perf_regs_user {
> +struct perf_regs {
>  	__u64		abi;
>  	struct pt_regs	*regs;
>  };
> @@ -595,7 +595,8 @@ struct perf_sample_data {
>  	struct perf_callchain_entry	*callchain;
>  	struct perf_raw_record		*raw;
>  	struct perf_branch_stack	*br_stack;
> -	struct perf_regs_user		regs_user;
> +	struct perf_regs		regs_user;
> +	struct perf_regs		regs_intr;
>  	u64				stack_user_size;
>  	u64				weight;
>  	/*
> @@ -618,6 +619,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
>  	data->weight = 0;
>  	data->data_src.val = 0;
>  	data->txn = 0;
> +	data->regs_intr.abi = PERF_SAMPLE_REGS_ABI_NONE;
> +	data->regs_intr.regs = NULL;

Nit:

This would be better right after the equivalent ones for regs_user, I
had to go to perf_sample_data_init() to check if that was done, yes, it
is right before data->weight = 0 :-)

Reading on...
