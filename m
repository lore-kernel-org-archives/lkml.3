Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbaJUTIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:08:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:57553 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932667AbaJUTIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:08:46 -0400
Date: Tue, 21 Oct 2014 16:08:39 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/powerpc: Cache the DWARF debug info
Message-ID: <20141021190839.GA4160@kernel.org>
References: <20141021185610.GA18366@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021185610.GA18366@us.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 21, 2014 at 11:56:10AM -0700, Sukadev Bhattiprolu escreveu:
> >From 773a3608a0cd2daf02e244cb9ffbf5bb6a0e724e Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Tue, 21 Oct 2014 13:20:22 -0500
> Subject: [PATCH 1/1] perf/powerpc: Cache DWARF debug info

Jiri, isn't his related to that dsos caching thing you created?

Anyway, there is a per machine struct (struct machine) where things like
this should be put, please do not add globals or static variables in
functions.

- Arnaldo
 
> Cache the DWARF debug info for DSO so we don't have to rebuild it for
> each address in the DSO (duh!).
> 
> 	$ time /tmp/perf.orig report -g > /tmp/report.1
> 
> 	real	0m1.845s
> 	user	0m0.963s
> 	sys	0m0.879s
> 
> 	$ time /tmp/perf report -g > /tmp/report.2
> 
> 	real	0m0.089s
> 	user	0m0.082s
> 	sys	0m0.006s
> 
> 	$ diff /tmp/report.1 /tmp/report.2
> 	$
> 
> Reported-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  tools/perf/arch/powerpc/util/skip-callchain-idx.c | 91 ++++++++++++++++++++---
>  1 file changed, 82 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
> index d73ef8b..bfe254d 100644
> --- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
> +++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
> @@ -38,6 +38,63 @@ static const Dwfl_Callbacks offline_callbacks = {
>  	.section_address = dwfl_offline_section_address,
>  };
>  
> +struct list_head perf_dwfl_files;
> +
> +struct perf_dwfl_node {
> +	struct list_head node;
> +	char *exec_file;
> +	Dwfl *dwfl;
> +};
> +
> +static void perf_init_dwfl(void)
> +{
> +	static int dwfl_inited;
> +
> +	if (!dwfl_inited) {
> +		dwfl_inited = 1;
> +		INIT_LIST_HEAD(&perf_dwfl_files);
> +	}
> +}
> +
> +static Dwfl *perf_dwfl_find(const char *file_name)
> +{
> +	struct list_head *pos;
> +	struct perf_dwfl_node *node;
> +
> +	perf_init_dwfl();
> +
> +	list_for_each(pos, &perf_dwfl_files) {
> +		node = list_entry(pos, struct perf_dwfl_node, node);
> +		if (!strcmp(node->exec_file, file_name))
> +			return node->dwfl;
> +	}
> +
> +	return NULL;
> +}
> +
> +
> +/*
> + * Return 1 if were able to cache the DWARF debug info. 0 otherwise.
> + */
> +static int perf_dwfl_cache(const char *file_name, Dwfl *dwfl)
> +{
> +	struct perf_dwfl_node *dwfl_node;
> +
> +	dwfl_node = malloc(sizeof(struct perf_dwfl_node));
> +
> +	if (!dwfl_node) {
> +		pr_debug("%s(): Unable to alloc memory\n", __func__);
> +		return 0;
> +	}
> +	INIT_LIST_HEAD(&dwfl_node->node);
> +	dwfl_node->dwfl = dwfl;
> +	dwfl_node->exec_file = strdup(file_name);
> +
> +	list_add(&dwfl_node->node, &perf_dwfl_files);
> +
> +	return 1;
> +}
> +
>  
>  /*
>   * Use the DWARF expression for the Call-frame-address and determine
> @@ -155,16 +212,26 @@ static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
>  	Dwarf_Addr	start = pc;
>  	Dwarf_Addr	end = pc;
>  	bool		signalp;
> +	int		cached;
>  
> -	dwfl = dwfl_begin(&offline_callbacks);
> +	cached = 1;
> +	dwfl = perf_dwfl_find(exec_file);
>  	if (!dwfl) {
> -		pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
> -		return -1;
> -	}
> -
> -	if (dwfl_report_offline(dwfl, "",  exec_file, -1) == NULL) {
> -		pr_debug("dwfl_report_offline() failed %s\n", dwarf_errmsg(-1));
> -		goto out;
> +		dwfl = dwfl_begin(&offline_callbacks);
> +		if (!dwfl) {
> +			pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
> +			return -1;
> +		}
> +
> +		if (dwfl_report_offline(dwfl, "",  exec_file, -1) == NULL) {
> +			pr_debug("dwfl_report_offline() failed %s\n",
> +							dwarf_errmsg(-1));
> +			goto out;
> +		}
> +		/*
> +		 * If we fail to alloc memory, we lose the benefit of caching
> +		 */
> +		cached = perf_dwfl_cache(exec_file, dwfl);
>  	}
>  
>  	mod = dwfl_addrmodule(dwfl, pc);
> @@ -194,7 +261,13 @@ static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
>  	rc = check_return_reg(ra_regno, frame);
>  
>  out:
> -	dwfl_end(dwfl);
> +	/*
> +	 * In the unlikely event that we were unable to cache the debug
> +	 * info, release it so we don't leak fds.
> +	 */
> +	if (!cached)
> +		dwfl_end(dwfl);
> +
>  	return rc;
>  }
>  
> -- 
> 1.8.4.2
