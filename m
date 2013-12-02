Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3LBUbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:31:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53541 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab3LBUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:31:02 -0500
Date: Mon, 2 Dec 2013 17:30:50 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131202203050.GG17149@ghostprotocols.net>
References: <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
 <20131122122701.GA1480@gmail.com>
 <20131122135034.GA20146@nazgul.tnic>
 <20131122153910.GA15636@gmail.com>
 <20131123130433.GA24148@pd.tnic>
 <20131126181745.GD9958@gmail.com>
 <20131127153944.GI32267@pd.tnic>
 <20131128121657.GB3728@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128121657.GB3728@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 28, 2013 at 01:16:57PM +0100, Borislav Petkov escreveu:
> On Wed, Nov 27, 2013 at 04:39:44PM +0100, Borislav Petkov wrote:
> > Ok, splitting them into topics actually makes sense.
> > 
> > > But stuffing them into types.a, formats.a, kernel.a, not so much.
> > 
> > Huh, why not? We take the corresponding .c files and create a single .a
> > archive per topic from them. This makes a whole lot of sense to me as a
> > compromise between having a single .a and one .a per compilation unit.
> > 
> > Remember, we still need to do the game with the *LK* variables above
> > with each new lib and path.
> 
> And this is how it could look like below.
> 
> We have a common tools/lib/api/ place where the Makefile lives and then
> we place the headers in subdirs. For example, all the fs-related stuff
> goes to tools/lib/api/fs/ from which we get libapikfs.a (acme, almost
> the naming you wanted :-)) and we link it into the tools which need it - in this
> case perf and tools/vm/page-types.

Looking just at the description above: I like it, does what I think Ingo
suggested and that is how I think it should be done.

Looking at the implementation, I think some tools can even link directly
to the .o files, avoiding the .a file altogether.

But that is just an optimization/finer granularity tools/lib/
cherrypicking that toolers can make use of.

- Arnaldo

> Thoughts?
> 
> --
> From: Borislav Petkov <bp@suse.de>
> Subject: [PATCH] tools: Convert to new topic libraries
> 
> Move debugfs.* to api/fs/
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  tools/lib/{lk => api}/Makefile     |  6 +++---
>  tools/lib/{lk => api/fs}/debugfs.c |  0
>  tools/lib/{lk => api/fs}/debugfs.h |  0
>  tools/perf/Makefile.perf           | 30 +++++++++++++++---------------
>  tools/perf/builtin-kvm.c           |  2 +-
>  tools/perf/builtin-probe.c         |  2 +-
>  tools/perf/perf.c                  |  2 +-
>  tools/perf/tests/parse-events.c    |  2 +-
>  tools/perf/util/evlist.c           |  2 +-
>  tools/perf/util/evsel.c            |  2 +-
>  tools/perf/util/parse-events.c     |  2 +-
>  tools/perf/util/probe-event.c      |  2 +-
>  tools/perf/util/setup.py           |  4 ++--
>  tools/perf/util/trace-event-info.c |  2 +-
>  tools/perf/util/util.h             |  2 +-
>  tools/vm/Makefile                  | 14 +++++++-------
>  tools/vm/page-types.c              |  2 +-
>  17 files changed, 38 insertions(+), 38 deletions(-)
>  rename tools/lib/{lk => api}/Makefile (90%)
>  rename tools/lib/{lk => api/fs}/debugfs.c (100%)
>  rename tools/lib/{lk => api/fs}/debugfs.h (100%)
> 
> diff --git a/tools/lib/lk/Makefile b/tools/lib/api/Makefile
> similarity index 90%
> rename from tools/lib/lk/Makefile
> rename to tools/lib/api/Makefile
> index 3dba0a4aebbf..d749cdc8e1d4 100644
> --- a/tools/lib/lk/Makefile
> +++ b/tools/lib/api/Makefile
> @@ -7,11 +7,11 @@ AR = $(CROSS_COMPILE)ar
>  LIB_H=
>  LIB_OBJS=
>  
> -LIB_H += debugfs.h
> +LIB_H += fs/debugfs.h
>  
> -LIB_OBJS += $(OUTPUT)debugfs.o
> +LIB_OBJS += $(OUTPUT)fs/debugfs.o
>  
> -LIBFILE = liblk.a
> +LIBFILE = libapikfs.a
>  
>  CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
>  EXTLIBS = -lelf -lpthread -lrt -lm
> diff --git a/tools/lib/lk/debugfs.c b/tools/lib/api/fs/debugfs.c
> similarity index 100%
> rename from tools/lib/lk/debugfs.c
> rename to tools/lib/api/fs/debugfs.c
> diff --git a/tools/lib/lk/debugfs.h b/tools/lib/api/fs/debugfs.h
> similarity index 100%
> rename from tools/lib/lk/debugfs.h
> rename to tools/lib/api/fs/debugfs.h
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index e416ccc7d831..5f8a8de62ddd 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -86,7 +86,7 @@ FLEX    = flex
>  BISON   = bison
>  STRIP   = strip
>  
> -LK_DIR          = $(srctree)/tools/lib/lk/
> +LIB_DIR          = $(srctree)/tools/lib/api/
>  TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
>  
>  # include config/Makefile by default and rule out
> @@ -127,20 +127,20 @@ strip-libs = $(filter-out -l%,$(1))
>  ifneq ($(OUTPUT),)
>    TE_PATH=$(OUTPUT)
>  ifneq ($(subdir),)
> -  LK_PATH=$(OUTPUT)/../lib/lk/
> +  LIB_PATH=$(OUTPUT)/../lib/api/
>  else
> -  LK_PATH=$(OUTPUT)
> +  LIB_PATH=$(OUTPUT)
>  endif
>  else
>    TE_PATH=$(TRACE_EVENT_DIR)
> -  LK_PATH=$(LK_DIR)
> +  LIB_PATH=$(LIB_DIR)
>  endif
>  
>  LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
>  export LIBTRACEEVENT
>  
> -LIBLK = $(LK_PATH)liblk.a
> -export LIBLK
> +LIBAPIKFS = $(LIB_PATH)libapikfs.a
> +export LIBAPIKFS
>  
>  # python extension build directories
>  PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
> @@ -151,7 +151,7 @@ export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
>  python-clean := $(call QUIET_CLEAN, python) $(RM) -r $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
>  
>  PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
> -PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBLK)
> +PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBAPIKFS)
>  
>  $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
>  	$(QUIET_GEN)CFLAGS='$(CFLAGS)' $(PYTHON_WORD) util/setup.py \
> @@ -438,7 +438,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
>  BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
>  
> -PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
> +PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
>  
>  # We choose to avoid "if .. else if .. else .. endif endif"
>  # because maintaining the nesting to match is a pain.  If
> @@ -717,19 +717,19 @@ $(LIBTRACEEVENT)-clean:
>  	$(call QUIET_CLEAN, libtraceevent)
>  	@$(MAKE) -C $(TRACE_EVENT_DIR) O=$(OUTPUT) clean >/dev/null
>  
> -LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])
> +LIBAPIKFS_SOURCES = $(wildcard $(LIB_PATH)fs/*.[ch])
>  
>  # if subdir is set, we've been called from above so target has been built
>  # already
> -$(LIBLK): $(LIBLK_SOURCES)
> +$(LIBAPIKFS): $(LIBAPIKFS_SOURCES)
>  ifeq ($(subdir),)
> -	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) liblk.a
> +	$(QUIET_SUBDIR0)$(LIB_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libapikfs.a
>  endif
>  
> -$(LIBLK)-clean:
> +$(LIBAPIKFS)-clean:
>  ifeq ($(subdir),)
> -	$(call QUIET_CLEAN, liblk)
> -	@$(MAKE) -C $(LK_DIR) O=$(OUTPUT) clean >/dev/null
> +	$(call QUIET_CLEAN, LIBAPIKFS)
> +	@$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
>  endif
>  
>  help:
> @@ -868,7 +868,7 @@ config-clean:
>  	$(call QUIET_CLEAN, config)
>  	@$(MAKE) -C config/feature-checks clean >/dev/null
>  
> -clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean config-clean
> +clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
>  	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
>  	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
>  	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index f8bf5f244d77..252b6ed507b7 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -13,7 +13,7 @@
>  #include "util/parse-options.h"
>  #include "util/trace-event.h"
>  #include "util/debug.h"
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include "util/tool.h"
>  #include "util/stat.h"
>  #include "util/top.h"
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 6ea9e85bdc00..c98ccb570509 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -37,7 +37,7 @@
>  #include "util/strfilter.h"
>  #include "util/symbol.h"
>  #include "util/debug.h"
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include "util/parse-options.h"
>  #include "util/probe-finder.h"
>  #include "util/probe-event.h"
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index 8b38b4e80ec2..431798a4110d 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -13,7 +13,7 @@
>  #include "util/quote.h"
>  #include "util/run-command.h"
>  #include "util/parse-events.h"
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include <pthread.h>
>  
>  const char perf_usage_string[] =
> diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
> index 3cbd10496087..e4ce8aed29d3 100644
> --- a/tools/perf/tests/parse-events.c
> +++ b/tools/perf/tests/parse-events.c
> @@ -3,7 +3,7 @@
>  #include "evsel.h"
>  #include "evlist.h"
>  #include "fs.h"
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include "tests.h"
>  #include <linux/hw_breakpoint.h>
>  
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 76fa76431329..a07d86397adf 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -7,7 +7,7 @@
>   * Released under the GPL v2. (and only v2, not any later version)
>   */
>  #include "util.h"
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include <poll.h>
>  #include "cpumap.h"
>  #include "thread_map.h"
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index b5fe7f9b2e15..2268c80ba0d0 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -9,7 +9,7 @@
>  
>  #include <byteswap.h>
>  #include <linux/bitops.h>
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include <traceevent/event-parse.h>
>  #include <linux/hw_breakpoint.h>
>  #include <linux/perf_event.h>
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 969cb8f0d88d..094c28ba2fae 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -10,7 +10,7 @@
>  #include "symbol.h"
>  #include "cache.h"
>  #include "header.h"
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include "parse-events-bison.h"
>  #define YY_EXTRA_TYPE int
>  #include "parse-events-flex.h"
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 9c6989ca2bea..8cd98ef628be 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -40,7 +40,7 @@
>  #include "color.h"
>  #include "symbol.h"
>  #include "thread.h"
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include "trace-event.h"	/* For __maybe_unused */
>  #include "probe-event.h"
>  #include "probe-finder.h"
> diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
> index 58ea5ca6c255..d0aee4b9dfd4 100644
> --- a/tools/perf/util/setup.py
> +++ b/tools/perf/util/setup.py
> @@ -25,7 +25,7 @@ cflags += ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-parameter'
>  build_lib = getenv('PYTHON_EXTBUILD_LIB')
>  build_tmp = getenv('PYTHON_EXTBUILD_TMP')
>  libtraceevent = getenv('LIBTRACEEVENT')
> -liblk = getenv('LIBLK')
> +libapikfs = getenv('LIBAPIKFS')
>  
>  ext_sources = [f.strip() for f in file('util/python-ext-sources')
>  				if len(f.strip()) > 0 and f[0] != '#']
> @@ -34,7 +34,7 @@ perf = Extension('perf',
>  		  sources = ext_sources,
>  		  include_dirs = ['util/include'],
>  		  extra_compile_args = cflags,
> -		  extra_objects = [libtraceevent, liblk],
> +		  extra_objects = [libtraceevent, libapikfs],
>                   )
>  
>  setup(name='perf',
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index f3c9e551bd35..c354b95a2348 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -38,7 +38,7 @@
>  
>  #include "../perf.h"
>  #include "trace-event.h"
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include "evsel.h"
>  
>  #define VERSION "0.5"
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index c8f362daba87..eb75bbb106e9 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -71,7 +71,7 @@
>  #include <linux/magic.h>
>  #include "types.h"
>  #include <sys/ttydefaults.h>
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  #include <termios.h>
>  
>  extern const char *graph_line;
> diff --git a/tools/vm/Makefile b/tools/vm/Makefile
> index 24e9ddd93fa4..3d907dacf2ac 100644
> --- a/tools/vm/Makefile
> +++ b/tools/vm/Makefile
> @@ -2,21 +2,21 @@
>  #
>  TARGETS=page-types slabinfo
>  
> -LK_DIR = ../lib/lk
> -LIBLK = $(LK_DIR)/liblk.a
> +LIB_DIR = ../lib/api
> +LIBS = $(LIB_DIR)/libapikfs.a
>  
>  CC = $(CROSS_COMPILE)gcc
>  CFLAGS = -Wall -Wextra -I../lib/
> -LDFLAGS = $(LIBLK)
> +LDFLAGS = $(LIBS)
>  
> -$(TARGETS): liblk
> +$(TARGETS): $(LIBS)
>  
> -liblk:
> -	make -C $(LK_DIR)
> +$(LIBS):
> +	make -C $(LIB_DIR)
>  
>  %: %.c
>  	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
>  
>  clean:
>  	$(RM) page-types slabinfo
> -	make -C ../lib/lk clean
> +	make -C $(LIB_DIR) clean
> diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
> index d5e9d6d185c8..f9be24d9efac 100644
> --- a/tools/vm/page-types.c
> +++ b/tools/vm/page-types.c
> @@ -36,7 +36,7 @@
>  #include <sys/statfs.h>
>  #include "../../include/uapi/linux/magic.h"
>  #include "../../include/uapi/linux/kernel-page-flags.h"
> -#include <lk/debugfs.h>
> +#include <api/fs/debugfs.h>
>  
>  #ifndef MAX_PATH
>  # define MAX_PATH 256
> -- 
> 1.8.4
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
