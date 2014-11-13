Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbaKMSVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:21:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648AbaKMSVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:21:46 -0500
Date: Thu, 13 Nov 2014 19:21:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: kan.liang@intel.com
Cc: acme@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com
Subject: Re: [PATCH V2 2/3] perf tool: re-organize
 thread__resolve_callchain_sample
Message-ID: <20141113182123.GA6309@krava.redhat.com>
References: <1415837895-10275-1-git-send-email-kan.liang@intel.com>
 <1415837895-10275-3-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415837895-10275-3-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 07:18:14PM -0500, kan.liang@intel.com wrote:

SNIP

> +static inline int __thread__resolve_callchain_sample(struct thread *thread,
> +						     u64 ip, u8 *cpumode,
> +						     struct symbol **parent,
> +						     struct addr_location *root_al)
> +{
> +	struct addr_location al;
> +
> +	if (ip >= PERF_CONTEXT_MAX) {
> +		switch (ip) {
> +		case PERF_CONTEXT_HV:
> +			*cpumode = PERF_RECORD_MISC_HYPERVISOR;
> +			break;
> +		case PERF_CONTEXT_KERNEL:
> +			*cpumode = PERF_RECORD_MISC_KERNEL;
> +			break;
> +		case PERF_CONTEXT_USER:
> +			*cpumode = PERF_RECORD_MISC_USER;
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
> +	}
> +
> +	al.filtered = 0;
> +	thread__find_addr_location(thread, *cpumode,
> +				   MAP__FUNCTION, ip, &al);
> +	if (al.sym != NULL) {
> +		if (sort__has_parent && !*parent &&
> +		    symbol__match_regex(al.sym, &parent_regex))
> +			*parent = al.sym;
> +		else if (have_ignore_callees && root_al &&
> +		  symbol__match_regex(al.sym, &ignore_callees_regex)) {
> +			/* Treat this symbol as the root,
> +			   forgetting its callees. */
> +			*root_al = al;
> +			callchain_cursor_reset(&callchain_cursor);
> +		}
> +	}
> +
> +	return callchain_cursor_append(&callchain_cursor,
> +				       ip, al.map, al.sym);

you added slightly more than Andi ;-)
http://marc.info/?l=linux-kernel&m=141584439819848&w=2

Any chance you guys could sync on this? ..you're touching the
same code.. Andi, maybe you wouldn't mind having this patch
instead of your change.. looks like the only extra part is the
cpumode resolve.

thanks,
jirka
