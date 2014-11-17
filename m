Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaKQN6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:58:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbaKQN6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:58:16 -0500
Date: Mon, 17 Nov 2014 14:57:57 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH V3 2/3] perf tool: Move cpumode resolve code to
 add_callchain_ip
Message-ID: <20141117135757.GA21532@krava.brq.redhat.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
 <1415972652-17310-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415972652-17310-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 08:44:11AM -0500, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>

SNIP

> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1384,11 +1384,35 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
>  static int add_callchain_ip(struct thread *thread,
>  			    struct symbol **parent,
>  			    struct addr_location *root_al,
> -			    int cpumode,
> +			    u8 cpumode,
>  			    u64 ip)
>  {
>  	struct addr_location al;
>  
> +	if (ip >= PERF_CONTEXT_MAX) {
> +		switch (ip) {
> +		case PERF_CONTEXT_HV:
> +			cpumode = PERF_RECORD_MISC_HYPERVISOR;
> +			break;
> +		case PERF_CONTEXT_KERNEL:
> +			cpumode = PERF_RECORD_MISC_KERNEL;
> +			break;
> +		case PERF_CONTEXT_USER:
> +			cpumode = PERF_RECORD_MISC_USER;
> +			break;
> +		default:
> +			pr_debug("invalid callchain context: "
> +				 "%"PRId64"\n", (s64) ip);
> +			/*
> +			 * It seems the callchain is corrupted.
> +			 * Discard all.
> +			 */
> +			callchain_cursor_reset(&callchain_cursor);
> +			return 1;
> +		}
> +		return 0;	

extra whitespace         ^^^^^^^

> +	}
> +
>  	al.filtered = 0;
>  	al.sym = NULL;
>  	thread__find_addr_location(thread, cpumode, MAP__FUNCTION,

SNIP

> -				 * Discard all.
> -				 */
> -				callchain_cursor_reset(&callchain_cursor);
> -				return 0;
> -			}
> -			continue;
> -		}
> -
>  		err = add_callchain_ip(thread, parent, root_al,
>  				       cpumode, ip);

hm, why do we need to pass cpumode in here? it should be handled within
add_callchain_ip in add_callchain_ip function, right?

jirka
