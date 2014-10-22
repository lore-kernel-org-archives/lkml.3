Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaJVIRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaJVIRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:17:44 -0400
Date: Wed, 22 Oct 2014 10:17:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Anton Blanchard <anton@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/powerpc: Cache the DWARF debug info
Message-ID: <20141022081730.GB9860@krava.brq.redhat.com>
References: <20141021185610.GA18366@us.ibm.com>
 <20141021190839.GA4160@kernel.org>
 <20141022000958.GB2228@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022000958.GB2228@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 05:09:58PM -0700, Sukadev Bhattiprolu wrote:
> Arnaldo Carvalho de Melo [acme@kernel.org] wrote:
> | Em Tue, Oct 21, 2014 at 11:56:10AM -0700, Sukadev Bhattiprolu escreveu:
> | > >From 773a3608a0cd2daf02e244cb9ffbf5bb6a0e724e Mon Sep 17 00:00:00 2001
> | > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> | > Date: Tue, 21 Oct 2014 13:20:22 -0500
> | > Subject: [PATCH 1/1] perf/powerpc: Cache DWARF debug info
> | 
> | Jiri, isn't his related to that dsos caching thing you created?

well, yea.. but Sukadev needs dw handle on top of that

> | 
> | Anyway, there is a per machine struct (struct machine) where things like
> | this should be put, please do not add globals or static variables in
> | functions.
> 
> Good point. How about something like this:

yep, and the code got much shorter ;-)

SNIP

> --- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
> +++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
> @@ -145,7 +145,7 @@ static Dwarf_Frame *get_dwarf_frame(Dwfl_Module *mod, Dwarf_Addr pc)
>   *		yet used)
>   *	-1 in case of errors
>   */
> -static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
> +static int check_return_addr(struct dso *dso, Dwarf_Addr pc)
>  {
>  	int		rc = -1;
>  	Dwfl		*dwfl;
> @@ -156,15 +156,27 @@ static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
>  	Dwarf_Addr	end = pc;
>  	bool		signalp;
>  
> -	dwfl = dwfl_begin(&offline_callbacks);
> -	if (!dwfl) {
> -		pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
> -		return -1;
> -	}
> +	dwfl = dso->dwfl;
>  
> -	if (dwfl_report_offline(dwfl, "",  exec_file, -1) == NULL) {
> -		pr_debug("dwfl_report_offline() failed %s\n", dwarf_errmsg(-1));
> -		goto out;
> +	if (!dwfl) {
> +		dwfl = dwfl_begin(&offline_callbacks);
> +		if (!dwfl) {
> +			pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
> +			return -1;
> +		}
> +
> +		if (dwfl_report_offline(dwfl, "", dso->long_name, -1) == NULL) {
> +			pr_debug("dwfl_report_offline() failed %s\n",
> +						dwarf_errmsg(-1));
> +			/*
> +			 * We normally cache the DWARF debug info and never
> +			 * call dwfl_end(). But to prevent fd leak, free in
> +			 * case of error.
> +			 */
> +			dwfl_end(dwfl);
> +			goto out;
> +		}
> +		dso->dwfl = dwfl;

so by this we get powerpc arch code sharing dw handle via dso object,
but we have lot of generic code too ;-)

could you make this happen for unwind__get_entries.. probably
both sharing same generic code I guess

thanks,
jirka
