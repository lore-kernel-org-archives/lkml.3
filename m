Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3JITdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab3JITdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:33:41 -0400
Date: Wed, 9 Oct 2013 16:33:22 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        dsahern@gmail.com, ak@linux.intel.com, jolsa@redhat.com,
        hughd@google.com, keescook@chromium.org, akpm@linux-foundation.org
Subject: Re: [PATCH] perf: disable mmap2 support
Message-ID: <20131009193322.GA3794@infradead.org>
References: <20131009161743.GA3022@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009161743.GA3022@quad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 09, 2013 at 06:17:43PM +0200, Stephane Eranian escreveu:
> This patch disables the mmap2 record format support
> for now. The support needs a bit more work to cover
> VM_CLONE cases.
> 
> The patch leaves attr->mmap2 defined, but returns
> an error if it is set. That ensures no PERF_RECORD_MMAP2
> record can be generated. Yet it minimizes the reverts in
> the perf tool.

Would be interesting to have a simple new tool that would detect all the
mmaps that are shared in a given perf.data file, using the
PERF_RECORD_MMAP2 information, and that tool should come together with
the reworked kernel ABI, showing how it is used.

A 'perf test' entry, based on the test programs you guys are using to
test this functionality would be even better, showing that all cases
you've been striving to cover are in fact covered by the new ABI.

- Arnaldo
 
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  include/uapi/linux/perf_event.h |   18 +-----------------
>  kernel/events/core.c            |    4 ++++
>  2 files changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index da48837..8074b29 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -682,23 +682,7 @@ enum perf_event_type {
>  	PERF_RECORD_SAMPLE			= 9,
>  
>  	/*
> -	 * The MMAP2 records are an augmented version of MMAP, they add
> -	 * maj, min, ino numbers to be used to uniquely identify each mapping
> -	 *
> -	 * struct {
> -	 *	struct perf_event_header	header;
> -	 *
> -	 *	u32				pid, tid;
> -	 *	u64				addr;
> -	 *	u64				len;
> -	 *	u64				pgoff;
> -	 *	u32				maj;
> -	 *	u32				min;
> -	 *	u64				ino;
> -	 *	u64				ino_generation;
> -	 *	char				filename[];
> -	 * 	struct sample_id		sample_id;
> -	 * };
> +	 * reserved, do not use
>  	 */
>  	PERF_RECORD_MMAP2			= 10,
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index c716385..d7152a6 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6782,6 +6782,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
>  	if (attr->read_format & ~(PERF_FORMAT_MAX-1))
>  		return -EINVAL;
>  
> +	/* disable for now */
> +	if (attr->mmap2)
> +		return -EINVAL;
> +
>  	if (attr->sample_type & PERF_SAMPLE_BRANCH_STACK) {
>  		u64 mask = attr->branch_sample_type;
>  
> -- 
> 1.7.10.4
