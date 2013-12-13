Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3LMU2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:28:54 -0500
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:53529 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752378Ab3LMU2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:28:53 -0500
Date: Fri, 13 Dec 2013 15:31:30 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Subject: Re: [tip:perf/core] perf: Add generic transaction flags
In-Reply-To: <tip-fdfbbd07e91f8fe387140776f3fd94605f0c89e5@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1312131526550.10244@pianoman.cluster.toy>
References: <1379688044-14173-2-git-send-email-andi@firstfloor.org> <tip-fdfbbd07e91f8fe387140776f3fd94605f0c89e5@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.52AB6E04.0145,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Oct 2013, tip-bot for Andi Kleen wrote:

> Commit-ID:  fdfbbd07e91f8fe387140776f3fd94605f0c89e5
> Gitweb:     http://git.kernel.org/tip/fdfbbd07e91f8fe387140776f3fd94605f0c89e5
> Author:     Andi Kleen <ak@linux.intel.com>
> AuthorDate: Fri, 20 Sep 2013 07:40:39 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 4 Oct 2013 10:06:08 +0200
> 
> perf: Add generic transaction flags

...

>  extern void perf_output_sample(struct perf_output_handle *handle,
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 009a655..da48837 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -136,8 +136,9 @@ enum perf_event_sample_format {
>  	PERF_SAMPLE_WEIGHT			= 1U << 14,
>  	PERF_SAMPLE_DATA_SRC			= 1U << 15,
>  	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
> +	PERF_SAMPLE_TRANSACTION			= 1U << 17,
>  
> -	PERF_SAMPLE_MAX = 1U << 17,		/* non-ABI */
> +	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
>  };

I know this is a bit late, but isn't this patch missing something like
(not a real patch):


         *      { u64                   weight;   } && PERF_SAMPLE_WEIGHT
         *      { u64                   data_src; } && PERF_SAMPLE_DATA_SRC
+        *      { u64                   transaction; } && PERF_SAMPLE_TRANSACTION
         * };
         */

  
>  /*
> + * Values for the memory transaction event qualifier, mostly for
> + * abort events. Multiple bits can be set.
> + */
> +enum {
> +	PERF_TXN_ELISION        = (1 << 0), /* From elision */
> +	PERF_TXN_TRANSACTION    = (1 << 1), /* From transaction */
> +	PERF_TXN_SYNC           = (1 << 2), /* Instruction is related */
> +	PERF_TXN_ASYNC          = (1 << 3), /* Instruction not related */
> +	PERF_TXN_RETRY          = (1 << 4), /* Retry possible */
> +	PERF_TXN_CONFLICT       = (1 << 5), /* Conflict abort */
> +	PERF_TXN_CAPACITY_WRITE = (1 << 6), /* Capacity write abort */
> +	PERF_TXN_CAPACITY_READ  = (1 << 7), /* Capacity read abort */
> +
> +	PERF_TXN_MAX	        = (1 << 8), /* non-ABI */
> +
> +	/* bits 32..63 are reserved for the abort code */
> +
> +	PERF_TXN_ABORT_MASK  = (0xffffffffULL << 32),
> +	PERF_TXN_ABORT_SHIFT = 32,
> +};
> +
> +/*
>   * The format of the data returned by read() on a perf event fd,
>   * as specified by attr.read_format:
>   *
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index b25d65c..c716385 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1201,6 +1201,9 @@ static void perf_event__header_size(struct perf_event *event)
>  	if (sample_type & PERF_SAMPLE_DATA_SRC)
>  		size += sizeof(data->data_src.val);
>  
> +	if (sample_type & PERF_SAMPLE_TRANSACTION)
> +		size += sizeof(data->txn);
> +
>  	event->header_size = size;
>  }
>  
> @@ -4572,6 +4575,9 @@ void perf_output_sample(struct perf_output_handle *handle,
>  	if (sample_type & PERF_SAMPLE_DATA_SRC)
>  		perf_output_put(handle, data->data_src.val);
>  
> +	if (sample_type & PERF_SAMPLE_TRANSACTION)
> +		perf_output_put(handle, data->txn);
> +
>  	if (!event->attr.watermark) {
>  		int wakeup_events = event->attr.wakeup_events;
