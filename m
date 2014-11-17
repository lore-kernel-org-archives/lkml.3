Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaKQOBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:01:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbaKQOBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:01:00 -0500
Date: Mon, 17 Nov 2014 15:00:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH V3 2/3] perf tool: Move cpumode resolve code to
 add_callchain_ip
Message-ID: <20141117140043.GB21532@krava.brq.redhat.com>
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

SNIP

> -	int i;
> -	int j;
> -	int err;
> +	int i, j, err = 0;
>  	int skip_idx __maybe_unused;
>  
>  	callchain_cursor_reset(&callchain_cursor);
> @@ -1467,39 +1489,13 @@ static int thread__resolve_callchain_sample(struct thread *thread,
>  #endif
>  		ip = chain->ips[j];
>  
> -		if (ip >= PERF_CONTEXT_MAX) {
> -			switch (ip) {
> -			case PERF_CONTEXT_HV:
> -				cpumode = PERF_RECORD_MISC_HYPERVISOR;
> -				break;
> -			case PERF_CONTEXT_KERNEL:
> -				cpumode = PERF_RECORD_MISC_KERNEL;
> -				break;
> -			case PERF_CONTEXT_USER:
> -				cpumode = PERF_RECORD_MISC_USER;
> -				break;
> -			default:
> -				pr_debug("invalid callchain context: "
> -					 "%"PRId64"\n", (s64) ip);
> -				/*
> -				 * It seems the callchain is corrupted.
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
> -		if (err == -EINVAL)
> -			break;

yea, I was wondering, why we did not spot this nop before ;-)

>  		if (err)
> -			return err;
> +			goto exit;

I dont understand this change seems like extra nop complication..
why not return in here and rather recheck at the end again?

jirka

>  	}
> -
> -	return 0;
> +exit:
> +	return (err < 0) ? err : 0;
>  }
