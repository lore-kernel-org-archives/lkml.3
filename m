Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbaDYNSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:18:31 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60142 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaDYNSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:18:22 -0400
MIME-Version: 1.0
In-Reply-To: <1398346054-3322-3-git-send-email-namhyung@kernel.org>
References: <1398346054-3322-1-git-send-email-namhyung@kernel.org>
	<1398346054-3322-3-git-send-email-namhyung@kernel.org>
Date: Fri, 25 Apr 2014 15:18:21 +0200
Message-ID: <CABPqkBQfSftQRbnFMLvPUHSMa3Dv62ARmyeN530ee=3V2e80Cw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] perf tools: Get rid of on_exit() feature test
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>,
        Irina Tirdea <irina.tirdea@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 3:27 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> The on_exit() function was only used in perf record but it's gone in
> previous patch.
>
Acked-by: Stephane Eranian <eranian@google.com>

> Cc: Bernhard Rosenkraenzer <Bernhard.Rosenkranzer@linaro.org>
> Cc: Irina Tirdea <irina.tirdea@intel.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-record.c                     |   31 -----------------------
>  tools/perf/config/Makefile                      |    8 ------
>  tools/perf/config/feature-checks/Makefile       |    4 ---
>  tools/perf/config/feature-checks/test-all.c     |    5 ----
>  tools/perf/config/feature-checks/test-on-exit.c |   16 ------------
>  5 files changed, 64 deletions(-)
>  delete mode 100644 tools/perf/config/feature-checks/test-on-exit.c
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index b1523d8a6191..1c127806fcb1 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -30,37 +30,6 @@
>  #include <sched.h>
>  #include <sys/mman.h>
>
> -#ifndef HAVE_ON_EXIT_SUPPORT
> -#ifndef ATEXIT_MAX
> -#define ATEXIT_MAX 32
> -#endif
> -static int __on_exit_count = 0;
> -typedef void (*on_exit_func_t) (int, void *);
> -static on_exit_func_t __on_exit_funcs[ATEXIT_MAX];
> -static void *__on_exit_args[ATEXIT_MAX];
> -static int __exitcode = 0;
> -static void __handle_on_exit_funcs(void);
> -static int on_exit(on_exit_func_t function, void *arg);
> -#define exit(x) (exit)(__exitcode = (x))
> -
> -static int on_exit(on_exit_func_t function, void *arg)
> -{
> -       if (__on_exit_count == ATEXIT_MAX)
> -               return -ENOMEM;
> -       else if (__on_exit_count == 0)
> -               atexit(__handle_on_exit_funcs);
> -       __on_exit_funcs[__on_exit_count] = function;
> -       __on_exit_args[__on_exit_count++] = arg;
> -       return 0;
> -}
> -
> -static void __handle_on_exit_funcs(void)
> -{
> -       int i;
> -       for (i = 0; i < __on_exit_count; i++)
> -               __on_exit_funcs[i] (__exitcode, __on_exit_args[i]);
> -}
> -#endif
>
>  struct record {
>         struct perf_tool        tool;
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index ee21fa95ebcf..7b7003d11983 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -156,7 +156,6 @@ CORE_FEATURE_TESTS =                        \
>         libpython-version               \
>         libslang                        \
>         libunwind                       \
> -       on-exit                         \
>         stackprotector-all              \
>         timerfd                         \
>         libdw-dwarf-unwind
> @@ -182,7 +181,6 @@ VF_FEATURE_TESTS =                  \
>         libelf-getphdrnum               \
>         libelf-mmap                     \
>         libpython-version               \
> -       on-exit                         \
>         stackprotector-all              \
>         timerfd                         \
>         libunwind-debug-frame           \
> @@ -541,12 +539,6 @@ ifneq ($(filter -lbfd,$(EXTLIBS)),)
>    CFLAGS += -DHAVE_LIBBFD_SUPPORT
>  endif
>
> -ifndef NO_ON_EXIT
> -  ifeq ($(feature-on-exit), 1)
> -    CFLAGS += -DHAVE_ON_EXIT_SUPPORT
> -  endif
> -endif
> -
>  ifndef NO_BACKTRACE
>    ifeq ($(feature-backtrace), 1)
>      CFLAGS += -DHAVE_BACKTRACE_SUPPORT
> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> index 2da103c53f89..64c84e5f0514 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -24,7 +24,6 @@ FILES=                                        \
>         test-libslang.bin               \
>         test-libunwind.bin              \
>         test-libunwind-debug-frame.bin  \
> -       test-on-exit.bin                \
>         test-stackprotector-all.bin     \
>         test-timerfd.bin                \
>         test-libdw-dwarf-unwind.bin
> @@ -133,9 +132,6 @@ test-liberty-z.bin:
>  test-cplus-demangle.bin:
>         $(BUILD) -liberty
>
> -test-on-exit.bin:
> -       $(BUILD)
> -
>  test-backtrace.bin:
>         $(BUILD)
>
> diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
> index fc37eb3ca17b..fe5c1e5c952f 100644
> --- a/tools/perf/config/feature-checks/test-all.c
> +++ b/tools/perf/config/feature-checks/test-all.c
> @@ -69,10 +69,6 @@
>  # include "test-libbfd.c"
>  #undef main
>
> -#define main main_test_on_exit
> -# include "test-on-exit.c"
> -#undef main
> -
>  #define main main_test_backtrace
>  # include "test-backtrace.c"
>  #undef main
> @@ -110,7 +106,6 @@ int main(int argc, char *argv[])
>         main_test_gtk2(argc, argv);
>         main_test_gtk2_infobar(argc, argv);
>         main_test_libbfd();
> -       main_test_on_exit();
>         main_test_backtrace();
>         main_test_libnuma();
>         main_test_timerfd();
> diff --git a/tools/perf/config/feature-checks/test-on-exit.c b/tools/perf/config/feature-checks/test-on-exit.c
> deleted file mode 100644
> index 8e88b16e6ded..000000000000
> --- a/tools/perf/config/feature-checks/test-on-exit.c
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -#include <stdio.h>
> -#include <stdlib.h>
> -
> -static void exit_fn(int status, void *__data)
> -{
> -       printf("exit status: %d, data: %d\n", status, *(int *)__data);
> -}
> -
> -static int data = 123;
> -
> -int main(void)
> -{
> -       on_exit(exit_fn, &data);
> -
> -       return 321;
> -}
> --
> 1.7.9.2
>
