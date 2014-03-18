Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaCRO0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:26:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34244 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaCRO0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:26:52 -0400
Date: Tue, 18 Mar 2014 11:26:32 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        eranian@google.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] tools, perf: Add asprintf replacement
Message-ID: <20140318142632.GB6482@ghostprotocols.net>
References: <1394520204-22613-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394520204-22613-1-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 10, 2014 at 11:43:24PM -0700, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> asprintf corrupts memory on some older glibc versions.
> Provide a replacement. This fixes various segfaults
> with --branch-history on older Fedoras.

Humm, this unconditionally replaces it with an alternative that limits
the buffer to a fixed size :-\

Do you recall at least one of those old glibc version/release number?

A reproducer? So that I can try to reproduce it here and try to polish
this a bit more...

- Arnaldo
 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Makefile.perf   |  1 +
>  tools/perf/util/asprintf.c | 28 ++++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
>  create mode 100644 tools/perf/util/asprintf.c
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 1f7ec48..5174fb9 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -373,6 +373,7 @@ LIB_OBJS += $(OUTPUT)util/vdso.o
>  LIB_OBJS += $(OUTPUT)util/stat.o
>  LIB_OBJS += $(OUTPUT)util/record.o
>  LIB_OBJS += $(OUTPUT)util/srcline.o
> +LIB_OBJS += $(OUTPUT)util/asprintf.o
>  LIB_OBJS += $(OUTPUT)util/data.o
>  
>  LIB_OBJS += $(OUTPUT)ui/setup.o
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
> +	int len = vsnprintf(buf, sizeof buf, fmt, ap);
> +
> +	*str = malloc(len + 1);
> +	if (!*str)
> +		return -1;
> +	strcpy(*str, buf);
> +	return len;
> +}
> +
> +int asprintf(char **str, const char *fmt, ...)
> +{
> +	va_list ap;
> +	int ret;
> +
> +	va_start(ap, fmt);
> +	ret = vasprintf(str, fmt, ap);
> +	va_end(ap);
> +	return ret;
> +}
> -- 
> 1.8.5.3
