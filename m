Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaEVKEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbaEVKET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:04:19 -0400
Date: Thu, 22 May 2014 12:04:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Maynard Johnson <mpjohn@us.ibm.com>, Ulrich.Weigand@de.ibm.com,
        Anton Blanchard <anton@au1.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au
Subject: Re: [PATCH 1/1] powerpc/perf: Adjust callchain based on DWARF debug
Message-ID: <20140522100404.GB4789@krava.brq.redhat.com>
References: <20140521012644.GA2890@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521012644.GA2890@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 06:26:44PM -0700, Sukadev Bhattiprolu wrote:

SNIP

> + * TODO:
> + *	Rather than returning an index into the callchain and have the
> + *	caller skip that entry, we could modify the callchain in-place
> + *	by putting a PERF_CONTEXT_IGNORE marker in the affected entry.
> + *
> + *	But @chain points to read-only mmap, so the caller needs to
> + *	duplicate the callchain to modify in-place - something like:
> + *
> + *		new_callchain = arch_duplicate_callchain();
> + *		arch_adjust_callchain(new_callchain);
> + *		...
> + *		arch_free_callchain(new_callchain);
> + *
> + *	Since we only expect to adjust <= 1 entry for now, just return
> + *	the index.
> + */
> +int arch_adjust_callchain(struct machine *machine, struct thread *thread,
> +				struct ip_callchain *chain)
> +{

so in case we dont do the real adjusting of the callchain (see the other email)
and just returning the index, I think we should rename this accordingly,
so it's not confusing.. arch_callchain_skip_idx ? ;-)

SNIP

> --- a/tools/perf/util/callchain.h
> +++ b/tools/perf/util/callchain.h
> @@ -165,4 +165,16 @@ int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *samp
>  
>  extern const char record_callchain_help[];
>  int parse_callchain_report_opt(const char *arg);
> +
> +#ifdef HAVE_ADJUST_CALLCHAIN
> +extern int arch_adjust_callchain(struct machine *machine,
> +			struct thread *thread, struct ip_callchain *chain);
> +#else
> +static inline int arch_adjust_callchain(struct machine *machine,
> +			struct thread *thread, struct ip_callchain *chain)

this needs 'maybe_unused' attribute at each parameter, otherwise
it won't compile for arch != ppc 

thanks,
jirka
