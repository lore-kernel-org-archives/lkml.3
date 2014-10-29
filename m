Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaJ2Gjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:39:51 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51025 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaJ2Gjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:39:49 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anton Blanchard <anton@au1.ibm.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 01/32] perf tools powerpc: Cache the DWARF debug info
References: <1414503146-22789-1-git-send-email-acme@kernel.org>
	<1414503146-22789-2-git-send-email-acme@kernel.org>
Date: Wed, 29 Oct 2014 15:39:46 +0900
In-Reply-To: <1414503146-22789-2-git-send-email-acme@kernel.org> (Arnaldo
	Carvalho de Melo's message of "Tue, 28 Oct 2014 11:31:55 -0200")
Message-ID: <87egtr751p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Sukadev,

On Tue, 28 Oct 2014 11:31:55 -0200, Arnaldo Carvalho de Melo wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
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

Well, it can be freed when dso__delete() called at least. :)


> +			dwfl_end(dwfl);
> +			goto out;
> +		}
> +		dso->dwfl = dwfl;
>  	}
>  
>  	mod = dwfl_addrmodule(dwfl, pc);

I don't know how dwfl_report_offline() can make it to find out a mod
from pc as it's an (loaded) virtual address.  Maybe I miss something or
is your dso's are prelinked?

Thanks,
Namhyung


> @@ -194,7 +206,6 @@ static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
>  	rc = check_return_reg(ra_regno, frame);
>  
>  out:
> -	dwfl_end(dwfl);
>  	return rc;
>  }
>  
> @@ -246,7 +257,7 @@ int arch_skip_callchain_idx(struct machine *machine, struct thread *thread,
>  		return skip_slot;
>  	}
>  
> -	rc = check_return_addr(dso->long_name, ip);
> +	rc = check_return_addr(dso, ip);
>  
>  	pr_debug("DSO %s, nr %" PRIx64 ", ip 0x%" PRIx64 "rc %d\n",
>  				dso->long_name, chain->nr, ip, rc);
> diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
> index acb651acc7fd..3c9b391493f9 100644
> --- a/tools/perf/util/dso.h
> +++ b/tools/perf/util/dso.h
> @@ -127,6 +127,7 @@ struct dso {
>  	const char	 *long_name;
>  	u16		 long_name_len;
>  	u16		 short_name_len;
> +	void		*dwfl;			/* DWARF debug info */
>  
>  	/* dso data file */
>  	struct {
