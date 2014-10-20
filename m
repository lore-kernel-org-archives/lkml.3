Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaJTS2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaJTS2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:28:36 -0400
Date: Mon, 20 Oct 2014 20:28:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] tools, perf: Add asprintf replacement
Message-ID: <20141020182818.GE9913@krava.brq.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-9-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411774636-6870-9-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:37:16PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> asprintf corrupts memory on some older glibc versions.
> Provide a replacement. This fixes various segfaults
> with --branch-history on older Fedoras.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Makefile.perf    |  1 +
>  tools/perf/builtin-report.c |  3 ++-
>  tools/perf/util/asprintf.c  | 28 ++++++++++++++++++++++++++++
>  3 files changed, 31 insertions(+), 1 deletion(-)
>  create mode 100644 tools/perf/util/asprintf.c
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 171f4e6..5bdb960 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -377,6 +377,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
>  LIB_OBJS += $(OUTPUT)util/stat.o
>  LIB_OBJS += $(OUTPUT)util/record.o
>  LIB_OBJS += $(OUTPUT)util/srcline.o
> +LIB_OBJS += $(OUTPUT)util/asprintf.o
>  LIB_OBJS += $(OUTPUT)util/data.o
>  LIB_OBJS += $(OUTPUT)util/tsc.o
>  LIB_OBJS += $(OUTPUT)util/cloexec.o
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index cd87a40..96bc166 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -756,7 +756,8 @@ repeat:
>  		callchain_param.branch_callstack = 1;
>  		callchain_param.key = CCKEY_ADDRESS;
>  		symbol_conf.use_callchain = true;
> -		callchain_register_param(&callchain_param);
> +		if (callchain_register_param(&callchain_param) < 0)
> +			pr_err("Cannot register callchain parameters");

how is this hunk related to the patchset?

>  		if (sort_order == default_sort_order)
>  			sort_order = "srcline,symbol,dso";
>  		branch_mode = 0;
> diff --git a/tools/perf/util/asprintf.c b/tools/perf/util/asprintf.c
> new file mode 100644
> index 0000000..9aafaca
> --- /dev/null
> +++ b/tools/perf/util/asprintf.c
> @@ -0,0 +1,28 @@
> +/* Replacement for asprintf as it's buggy in older glibc versions */
> +#include <stdio.h>
> +#include <stdarg.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +int vasprintf(char **str, const char *fmt, va_list ap)
> +{
> +	char buf[1024];

could you please make it work for generic buf len?

> +	int len = vsnprintf(buf, sizeof buf, fmt, ap);

WARNING: sizeof buf should be sizeof(buf)

> +
> +	*str = malloc(len + 1);
> +	if (!*str)
> +		return -1;
> +	strcpy(*str, buf);
> +	return len;
> +}

thanks,
jirka
