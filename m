Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaCEKaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:30:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaCEKaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:30:22 -0500
Date: Wed, 5 Mar 2014 11:29:48 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] perf, tools: Support handling complete branch stacks
 as histograms v4
Message-ID: <20140305102948.GB1835@krava.brq.redhat.com>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
 <1393561352-23448-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393561352-23448-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:22:26PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 

SNIP

> +
>  static int machine__resolve_callchain_sample(struct machine *machine,
>  					     struct thread *thread,
>  					     struct ip_callchain *chain,
> +					     struct branch_stack *branch,
>  					     struct symbol **parent,
>  					     struct addr_location *root_al,
>  					     int max_stack)
> @@ -1283,17 +1365,73 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  	int chain_nr = min(max_stack, (int)chain->nr);
>  	int i;
>  	int err;
> +	int first_call = 0;
>  
>  	callchain_cursor_reset(&callchain_cursor);
>  
> +	/*
> +	 * Add branches to call stack for easier browsing. This gives
> +	 * more context for a sample than just the callers.
> +	 *
> +	 * This uses individual histograms of paths compared to the
> +	 * aggregated histograms the normal LBR mode uses.
> +	 *
> +	 * Limitations for now:
> +	 * - No extra filters
> +	 * - No annotations (should annotate somehow)
> +	 */
> +
> +	if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
> +		pr_warning("corrupted branch chain. skipping...\n");
> +		return 0;
> +	}

segfaults here..

[jolsa@krava perf]$ ./perf record -g sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.013 MB perf.data (~567 samples) ]
[jolsa@krava perf]$ ./perf report
perf: Segmentation fault
[jolsa@krava perf]$ 

jirka
