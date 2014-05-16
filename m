Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbaEPJyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:54:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489AbaEPJyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:54:14 -0400
Date: Fri, 16 May 2014 11:53:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/9] tools, perf: Make srcline output address with -v
Message-ID: <20140516095340.GB19475@krava.brq.redhat.com>
References: <1399936829-28194-1-git-send-email-andi@firstfloor.org>
 <1399936829-28194-9-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399936829-28194-9-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 04:20:28PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Requested by Jiri.
> 

need more description, I can't send out patch with changelog like this

thanks,
jirka


> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/util/srcline.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
> index 36a7aff..a22be7c 100644
> --- a/tools/perf/util/srcline.c
> +++ b/tools/perf/util/srcline.c
> @@ -258,6 +258,12 @@ char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
>  	unsigned line = 0;
>  	char *srcline;
>  	const char *dso_name;
> +	char astr[50];
> +
> +	if (verbose)
> +		snprintf(astr, sizeof astr, " %#lx", addr);
> +	else
> +		astr[0] = 0;
>  
>  	if (!dso->has_srcline)
>  		goto out;
> @@ -276,7 +282,12 @@ char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
>  	if (!addr2line(dso_name, addr, &file, &line, dso))
>  		goto out;
>  
> -	if (asprintf(&srcline, "%s:%u", basename(file), line) < 0) {
> +	if (line == 0) {
> +		free(file);
> +		goto fallback;
> +	}
> +
> +	if (asprintf(&srcline, "%s:%u%s", basename(file), line, astr) < 0) {
>  		free(file);
>  		goto out;
>  	}
> @@ -291,9 +302,10 @@ out:
>  		dso->has_srcline = 0;
>  		dso__free_a2l(dso);
>  	}
> +fallback:
>  	if (sym) {
> -		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
> -					addr - sym->start) < 0)
> +		if (asprintf(&srcline, "%s+%ld%s", show_sym ? sym->name : "",
> +					addr - sym->start, astr) < 0)
>  			return SRCLINE_UNKNOWN;
>  	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
>  		return SRCLINE_UNKNOWN;
> -- 
> 1.9.0
> 
