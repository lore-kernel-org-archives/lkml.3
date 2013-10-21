Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3JUOMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:12:36 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:33889 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3JUOMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:12:35 -0400
Date: Mon, 21 Oct 2013 11:12:28 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/19] perf tools: Fix 32-bit cross build
Message-ID: <20131021141228.GA2245@ghostprotocols.net>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
 <1382099356-4918-10-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382099356-4918-10-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 18, 2013 at 03:29:06PM +0300, Adrian Hunter escreveu:
> Setting EXTRA_CFLAGS=-m32 did not work because CFLAGS
> was not passed around.
 
<SNIP>

> index c873e03..699cdb7 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -706,7 +706,7 @@ $(LIB_FILE): $(LIB_OBJS)
>  TE_SOURCES = $(wildcard $(TRACE_EVENT_DIR)*.[ch])
>  
>  $(LIBTRACEEVENT): $(TE_SOURCES)
> -	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
> +	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) CFLAGS="-g -Wall $(EXTRA_CFLAGS)" libtraceevent.a

So are we unconditionally set -g and -Wall?

And by making CFLAGS be $(EXTRA_CFLAGS) implies EXTRA_CFLAGS already
contains "$(CFLAGS)?

- Arnaldo

>  
>  $(LIBTRACEEVENT)-clean:
>  	$(call QUIET_CLEAN, libtraceevent)
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index c516d6b..c94a06b 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -92,7 +92,7 @@ endif
>  
>  feature_check = $(eval $(feature_check_code))
>  define feature_check_code
> -  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
> +  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(CFLAGS)" LDFLAGS=$(LDFLAGS) -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
>  endef
>  
>  feature_set = $(eval $(feature_set_code))
> @@ -169,7 +169,7 @@ ifeq ($(feature-all), 1)
>    #
>    $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_set,$(feat)))
>  else
> -  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
> +  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CFLAGS="$(CFLAGS)" LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
>    $(foreach feat,$(CORE_FEATURE_TESTS),$(call feature_check,$(feat)))
>  endif
>  
> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> index 452b67c..353c00c 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -31,7 +31,7 @@ CC := $(CC) -MD
>  
>  all: $(FILES)
>  
> -BUILD = $(CC) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
> +BUILD = $(CC) $(CFLAGS) $(LDFLAGS) -o $(OUTPUT)$@ $@.c
>  
>  ###############################
>  
> -- 
> 1.7.11.7
