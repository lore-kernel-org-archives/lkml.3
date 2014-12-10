Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaLJKB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:01:59 -0500
Received: from ozlabs.org ([103.22.144.67]:46931 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbaLJKB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:01:57 -0500
Message-ID: <1418205715.9279.7.camel@ellerman.id.au>
Subject: Re: [RFC PATCH 4/8] perf probe powerpc: Handle powerpc dot symbols
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, ananth@in.ibm.com
Date: Wed, 10 Dec 2014 21:01:55 +1100
In-Reply-To: <6e97fb2cf77d91057fdcda0a75c58cfa63a7313c.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
	 <6e97fb2cf77d91057fdcda0a75c58cfa63a7313c.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 23:04 +0530, Naveen N. Rao wrote:
> Fix up various perf aspects related to ppc64's usage of dot functions:
> - ignore leading '.' when generating event names and when looking for
>   existing events.
> - use the proper prefix when ignoring SyS symbol lookups.
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index c7e01ef..d465f7c 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2080,6 +2080,10 @@ static int get_new_event_name(char *buf, size_t len, const char *base,
>  {
>  	int i, ret;
>  
> +	/* Skip the leading dot on powerpc */
> +	if (*base == '.')
> +		base++;
> +
>  	/* Try no suffix */
>  	ret = e_snprintf(buf, len, "%s", base);
>  	if (ret < 0) {
> @@ -2538,6 +2542,10 @@ int del_perf_probe_events(struct strlist *dellist)
>  			event = str;
>  		}
>  
> +		/* Skip the leading dot on powerpc */
> +		if (event && *event == '.')
> +			event++;

I'll defer to the perf guys, but I think you want these abstracted in an
architecture specific helper.

> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 0783311..cc04475 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -137,6 +137,12 @@ static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
>  	if (na >= 10 && !strncmp(syma->name, "compat_SyS", 10))
>  		return SYMBOL_B;
>  
> +	/* On powerpc, ignore the dot variants */
> +	if (na >= 4 && !strncmp(syma->name, ".SyS", 4))
> +		return SYMBOL_B;
> +	if (na >= 11 && !strncmp(syma->name, ".compat_SyS", 11))
> +		return SYMBOL_B;

And possibly this too.

cheers





