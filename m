Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaLIVOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:14:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:56600 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbaLIVOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:14:04 -0500
Date: Tue, 9 Dec 2014 18:14:00 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au, ananth@in.ibm.com
Subject: Re: [RFC PATCH 8/8] perf probe powerpc: Fixup function entry if
 using kallsyms lookup
Message-ID: <20141209211400.GB8788@kernel.org>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <e5bfde8d51546041e50699c4ed3bad8c3c1bf84f.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5bfde8d51546041e50699c4ed3bad8c3c1bf84f.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 09, 2014 at 11:04:06PM +0530, Naveen N. Rao escreveu:
> On powerpc ABIv2, if no debug-info is found and we use kallsyms,
> we need to fixup the function entry to point to the local entry point.
> Use offset of 8 since current toolchains always generate 2
> instructions (8 bytes).

Hi Michael and Ananth, may I have your Acked-by or Reviewed-by for these
patches?

The ones, like this, that are affects only ppc I'm can assume was tested
and applying it won't break other arch users, but having a/rev-by from
ppc developers should speed up this process.

Thanks,

- Arnaldo
 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
>  tools/perf/util/probe-event.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index adcdbd2..0970e2a 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2318,6 +2318,15 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
>  		}
>  		/* Add one probe point */
>  		tp->address = map->unmap_ip(map, sym->start) + pp->offset;
> +#if defined(__powerpc64__) && defined(_CALL_ELF) && _CALL_ELF == 2
> +		/*
> +		 * If we used kallsyms, we should fixup the function entry address here.
> +		 * ppc64le ABIv2 local entry point is currently always 2 instructions (8 bytes)
> +		 * after the global entry point. Fix this if it ever changes.
> +		 */
> +		if (!pev->uprobes && map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS)
> +			tp->address += 8;
> +#endif
>  		if (reloc_sym) {
>  			tp->symbol = strdup_or_goto(reloc_sym->name, nomem_out);
>  			tp->offset = tp->address - reloc_sym->addr;
> -- 
> 2.1.3
