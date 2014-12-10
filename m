Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaLJKRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:17:23 -0500
Received: from ozlabs.org ([103.22.144.67]:56053 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbaLJKRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:17:22 -0500
Message-ID: <1418206640.9279.10.camel@ellerman.id.au>
Subject: Re: [RFC PATCH 7/8] perf probe powerpc: Use DWARF info only if
 necessary
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Date: Wed, 10 Dec 2014 21:17:20 +1100
In-Reply-To: <50dd0fedb50e3a56ff8f25c44098db3e2a2d6374.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
	 <50dd0fedb50e3a56ff8f25c44098db3e2a2d6374.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 23:04 +0530, Naveen N. Rao wrote:
> Use symbol table lookups by default if DWARF is not necessary, since
> powerpc ABIv2 encodes local entry points in the symbol table and the
> function entry address in DWARF may not be appropriate for kprobes,
> as described here:
> https://sourceware.org/bugzilla/show_bug.cgi?id=17638

Needs a better changelog.

> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 174c22e..adcdbd2 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2382,6 +2382,14 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
>  		}
>  	}
>  
> +#if defined(__powerpc64__) && defined(_CALL_ELF) && _CALL_ELF == 2
> +	if (!perf_probe_event_need_dwarf(pev)) {
> +		ret = find_probe_trace_events_from_map(pev, tevs, max_tevs, target);
> +		if (ret > 0)
> +			return ret;	/* Found in symbol table */
> +	}
> +#endif

And should be in an arch helper, not a big powerpc wart dropped in the middle
of the generic code.

cheers


