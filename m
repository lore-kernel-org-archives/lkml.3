Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaBLOu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:50:28 -0500
Received: from ozlabs.org ([203.10.76.45]:42672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaBLOu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:50:27 -0500
Date: Thu, 13 Feb 2014 01:50:17 +1100
From: Anton Blanchard <anton@samba.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH 06/35] perf hists: Leave symbol addr hist bucket auto
 alloc to symbol layer
Message-ID: <20140213015017.12393bd4@kryten>
In-Reply-To: <20140212141837.GB7116@ghostprotocols.net>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
	<1387566550-3524-7-git-send-email-acme@infradead.org>
	<20140212182316.44a10ca6@kryten>
	<20140212141837.GB7116@ghostprotocols.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arnaldo,

> Can you try the following patch?
> 
> It should fix another problem, i.e. we were allocating, but annotation
> would fail in the !TUI case, as it would return at
> symbol__inc_addr_samples when use_browser != 1, now it will allocate
> and mark the right bucket.
> 
> I'll have this in perf/urgent and will do the optimization of not
> allocating those buckets in the report case when not doing integrated
> annotation, i.e. report --stdio doesn't provide a way to go to the
> annotation --stdio, so no point on allocating the buckets. Just on
> 'annotate --stdio' we should allocate it, etc.

This fixes the issue, thanks!

Tested-by: Anton Blanchard <anton@samba.org>

Anton
--

> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 469eb679fb9d..7cf522523c12 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -489,7 +489,7 @@ static int symbol__inc_addr_samples(struct symbol
> *sym, struct map *map, {
>  	struct annotation *notes;
>  
> -	if (sym == NULL || use_browser != 1 || !sort__has_sym)
> +	if (sym == NULL || !sort__has_sym)
>  		return 0;
>  
>  	notes = symbol__annotation(sym);
> 

