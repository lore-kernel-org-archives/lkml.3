Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3FFJNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:13:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab3FFJNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:13:06 -0400
Date: Thu, 6 Jun 2013 11:12:06 +0200
From: Petr Matousek <pmatouse@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        meissner@suse.de, security@kernel.org, oss-security@lists.openwall.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf: fix hypervisor branch sampling permission check
Message-ID: <20130606091206.GV32700@dhcp-25-225.brq.redhat.com>
Mail-Followup-To: Stephane Eranian <eranian@google.com>,
	linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
	meissner@suse.de, security@kernel.org,
	oss-security@lists.openwall.com, ak@linux.intel.com
References: <20130606090204.GA3725@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606090204.GA3725@quad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 11:02:04AM +0200, Stephane Eranian wrote:
> 
> Commit 2b923c8 perf/x86: Check branch sampling priv level in generic code
> was missing the check for the hypervisor (HV) priv level, so add it back.
> 
> With this patch, we get the following correct behavior:
> 
>   # echo 2 >/proc/sys/kernel/perf_event_paranoid 
> 
>   $ perf record -j any,k noploop 1
>   Error:
>   You may not have permission to collect stats.
>   Consider tweaking /proc/sys/kernel/perf_event_paranoid:
>    -1 - Not paranoid at all
>     0 - Disallow raw tracepoint access for unpriv
>     1 - Disallow cpu events for unpriv
>     2 - Disallow kernel profiling for unpriv
> 
>    $ perf record -j any,hv noploop 1
>    Error:
>    You may not have permission to collect stats.
>    Consider tweaking /proc/sys/kernel/perf_event_paranoid:
>     -1 - Not paranoid at all
>      0 - Disallow raw tracepoint access for unpriv
>      1 - Disallow cpu events for unpriv
>      2 - Disallow kernel profiling for unpriv
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 95edd5a..f0880fb 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6501,8 +6501,8 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
>  			 */
>  			attr->branch_sample_type = mask;
>  		}
> -		/* kernel level capture: check permissions */
> -		if ((mask & PERF_SAMPLE_BRANCH_KERNEL)
> +		/* privileged levels capture (kernel, hv): check permissions */
> +		if ((mask & PERF_SAMPLE_BRANCH_PERM_PLM)
>  		    && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
>  			return -EACCES;
>  	}

Acked-by: Petr Matousek <pmatouse@redhat.com>

-- 
Petr Matousek / Red Hat Security Response Team
