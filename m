Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaDNOiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:38:11 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62560 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaDNOiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:38:09 -0400
Date: Mon, 14 Apr 2014 16:38:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 14/17] perf tools: Fix metrics calculation with event
 qualifiers
Message-ID: <20140414143805.GA22659@gmail.com>
References: <1397485061-17215-1-git-send-email-jolsa@redhat.com>
 <1397485061-17215-15-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397485061-17215-15-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Currently in perf IPC and other metrics cannot be directly shown
> separately for both user and kernel in a single run. The problem was
> that the metrics matching code did not check event qualifiers.
> 
> With this patch the following case works correctly.
> 
> % perf stat -e cycles:k,cycles:u,instructions:k,instructions:u true
> 
>  Performance counter stats for 'true':
> 
>            531,718      cycles:k
>            203,895      cycles:u
>            338,151      instructions:k            #    0.64  insns per cycle
>            105,961      instructions:u            #    0.52  insns per cycle
> 
>        0.002989739 seconds time elapsed
> 
> Previously it would misreport the ratios because they were matching
> the wrong value.
> 
> The patch is fairly big, but quite mechanic as it just
> adds context indexes everywhere.
> 
> I didn't support Hypervisor. It's not clear it's worth it.

> +static int evsel_context(struct perf_evsel *evsel)
> +{
> +	if (evsel->attr.exclude_kernel)
> +		return CTX_USER;
> +	if (evsel->attr.exclude_user)
> +		return CTX_KERNEL;
> +	/* Handle hypervisor too? */
> +	return CTX_ALL;

This fix is incomplete, as there are a whole lot of other cases:

                                exclude_user   :  1, /* don't count user      */
                                exclude_kernel :  1, /* ditto kernel          */
                                exclude_hv     :  1, /* ditto hypervisor      */
                                exclude_idle   :  1, /* don't count when idle */

                                exclude_host   :  1, /* don't count in host   */
                                exclude_guest  :  1, /* don't count in guest  */

Many of which can be triggered via current event selectors.

Thanks,

	Ingo
