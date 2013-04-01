Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab3DAW0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 18:26:20 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58161 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab3DAW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:26:19 -0400
Subject: Re: [PATCH 05/27] perf tools: Move compiler and linker flags check
 into config/Makefile
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>
In-Reply-To: <1364843930-17974-6-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
	 <1364843930-17974-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Apr 2013 07:20:25 +0900
Message-ID: <1364854825.1728.19.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-04-01 (월), 21:18 +0200, Jiri Olsa:
> Moving compiler and linker flags check into config/Makefile.

[SNIP]

> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 8dd3320..dcae71b 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -52,6 +52,20 @@ include config/utilities.mak
>  #
>  # Define NO_LIBNUMA if you do not want numa perf benchmark
>  
> +ifeq ($(srctree),)
> +srctree := $(patsubst %/,%,$(dir $(shell pwd)))
> +srctree := $(patsubst %/,%,$(dir $(srctree)))
> +#$(info Determined 'srctree' to be $(srctree))
> +endif
> +
> +ifneq ($(objtree),)
> +#$(info Determined 'objtree' to be $(objtree))
> +endif
> +
> +ifneq ($(OUTPUT),)
> +#$(info Determined 'OUTPUT' to be $(OUTPUT))
> +endif
> +

Question, what's the difference between objtree and OUTPUT?


> +ifndef PERF_DEBUG
> +	CFLAGS_OPTIMIZE = -O6
> +endif

Is this -O6 really supported by gcc?

> +
> +ifdef PARSER_DEBUG
> +	PARSER_DEBUG_BISON  := -t
> +	PARSER_DEBUG_FLEX   := -d
> +	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
> +endif
> +
> +CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)

Please break this line into multiple CFLAGS += ... lines as Sam said.


> +EXTLIBS = -lpthread -lrt -lelf -lmmktemp
> +ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
> +ALL_LDFLAGS = $(LDFLAGS)
> +
> +ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
> +	CFLAGS := $(CFLAGS) -fstack-protector-all
> +endif
> +
> +ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
> +	CFLAGS := $(CFLAGS) -Wstack-protector
> +endif
> +
> +ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
> +	CFLAGS := $(CFLAGS) -Wvolatile-register-var
> +endif
> +
> +ifndef PERF_DEBUG
> +	ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
> +		CFLAGS := $(CFLAGS) -D_FORTIFY_SOURCE=2
> +	endif
> +endif
> +
> +BASIC_CFLAGS = \
> +	-Iutil/include \
> +	-Iarch/$(ARCH)/include \
> +	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
> +	-I$(srctree)/arch/$(ARCH)/include/uapi \
> +	-I$(srctree)/arch/$(ARCH)/include \
> +	$(if $(objtree),-I$(objtree)/include/generated/uapi) \
> +	-I$(srctree)/include/uapi \
> +	-I$(srctree)/include \
> +	-I$(OUTPUT)util \
> +	-Iutil \
> +	-I. \
> +	-I$(TRACE_EVENT_DIR) \
> +	-I../lib/ \mktemp
> +	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE

And this too.  Btw do we really need this many include directories?

Thanks,
Namhyung


> +
> +BASIC_LDFLAGS =
> +
> +ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
> +	BIONIC := 1
> +	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
> +	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
> +	BASIC_CFLAGS += -I.
> +endif



