Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930Ab3KEFA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 00:00:29 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40607 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3KEFA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 00:00:27 -0500
Message-ID: <52787B67.6050100@gmail.com>
Date: Mon, 04 Nov 2013 22:00:23 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
CC: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf kvm: Disable live command if timerfd is not
 supported
References: <1383064996-20933-1-git-send-email-dsahern@gmail.com> <1383064996-20933-2-git-send-email-dsahern@gmail.com>
In-Reply-To: <1383064996-20933-2-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ditto

On 10/29/13, 10:43 AM, David Ahern wrote:
> If the OS does not have timerfd support (e.g., older OS'es like RHEL5)
> disable perf kvm stat live.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> ---
>   tools/perf/builtin-kvm.c                        | 12 ++++++++++++
>   tools/perf/config/Makefile                      |  7 +++++++
>   tools/perf/config/feature-checks/Makefile       |  6 +++++-
>   tools/perf/config/feature-checks/test-all.c     |  5 +++++
>   tools/perf/config/feature-checks/test-timerfd.c | 18 ++++++++++++++++++
>   5 files changed, 47 insertions(+), 1 deletion(-)
>   create mode 100644 tools/perf/config/feature-checks/test-timerfd.c
>
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index cb05f39d8a77..cd9f92078aba 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -20,7 +20,9 @@
>   #include "util/data.h"
>
>   #include <sys/prctl.h>
> +#ifdef HAVE_TIMERFD_SUPPORT
>   #include <sys/timerfd.h>
> +#endif
>
>   #include <termios.h>
>   #include <semaphore.h>
> @@ -337,6 +339,7 @@ static void init_kvm_event_record(struct perf_kvm_stat *kvm)
>   		INIT_LIST_HEAD(&kvm->kvm_events_cache[i]);
>   }
>
> +#ifdef HAVE_TIMERFD_SUPPORT
>   static void clear_events_cache_stats(struct list_head *kvm_events_cache)
>   {
>   	struct list_head *head;
> @@ -358,6 +361,7 @@ static void clear_events_cache_stats(struct list_head *kvm_events_cache)
>   		}
>   	}
>   }
> +#endif
>
>   static int kvm_events_hash_fn(u64 key)
>   {
> @@ -783,6 +787,7 @@ static void print_result(struct perf_kvm_stat *kvm)
>   		pr_info("\nLost events: %" PRIu64 "\n\n", kvm->lost_events);
>   }
>
> +#ifdef HAVE_TIMERFD_SUPPORT
>   static int process_lost_event(struct perf_tool *tool,
>   			      union perf_event *event __maybe_unused,
>   			      struct perf_sample *sample __maybe_unused,
> @@ -793,6 +798,7 @@ static int process_lost_event(struct perf_tool *tool,
>   	kvm->lost_events++;
>   	return 0;
>   }
> +#endif
>
>   static bool skip_sample(struct perf_kvm_stat *kvm,
>   			struct perf_sample *sample)
> @@ -872,6 +878,7 @@ static bool verify_vcpu(int vcpu)
>   	return true;
>   }
>
> +#ifdef HAVE_TIMERFD_SUPPORT
>   /* keeping the max events to a modest level to keep
>    * the processing of samples per mmap smooth.
>    */
> @@ -1213,6 +1220,7 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
>   out:
>   	return rc;
>   }
> +#endif
>
>   static int read_events(struct perf_kvm_stat *kvm)
>   {
> @@ -1379,6 +1387,7 @@ kvm_events_report(struct perf_kvm_stat *kvm, int argc, const char **argv)
>   	return kvm_events_report_vcpu(kvm);
>   }
>
> +#ifdef HAVE_TIMERFD_SUPPORT
>   static struct perf_evlist *kvm_live_event_list(void)
>   {
>   	struct perf_evlist *evlist;
> @@ -1566,6 +1575,7 @@ out:
>
>   	return err;
>   }
> +#endif
>
>   static void print_kvm_stat_usage(void)
>   {
> @@ -1604,8 +1614,10 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
>   	if (!strncmp(argv[1], "rep", 3))
>   		return kvm_events_report(&kvm, argc - 1 , argv + 1);
>
> +#ifdef HAVE_TIMERFD_SUPPORT
>   	if (!strncmp(argv[1], "live", 4))
>   		return kvm_events_live(&kvm, argc - 1 , argv + 1);
> +#endif
>
>   perf_stat:
>   	return cmd_stat(argc, argv, NULL);
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index c82772207e6e..afe4945e3e84 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -395,6 +395,13 @@ else
>     endif
>   endif
>
> +$(call feature_check,timerfd)
> +ifeq ($(feature-timerfd), 1)
> +  CFLAGS += -DHAVE_TIMERFD_SUPPORT
> +else
> +  msg := $(warning No timerfd support. Disables 'perf kvm stat live');
> +endif
> +
>   disable-python = $(eval $(disable-python_code))
>   define disable-python_code
>     CFLAGS += -DNO_LIBPYTHON
> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> index 452b67cc4d7b..a4d4173c576e 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -25,7 +25,8 @@ FILES=					\
>   	test-libunwind			\
>   	test-on-exit			\
>   	test-stackprotector-all		\
> -	test-stackprotector
> +	test-stackprotector		\
> +	test-timerfd
>
>   CC := $(CC) -MD
>
> @@ -136,6 +137,9 @@ test-on-exit:
>   test-backtrace:
>   	$(BUILD)
>
> +test-timerfd:
> +	$(BUILD)
> +
>   -include *.d
>
>   ###############################
> diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
> index 50d431892a0c..59e7a705e146 100644
> --- a/tools/perf/config/feature-checks/test-all.c
> +++ b/tools/perf/config/feature-checks/test-all.c
> @@ -81,6 +81,10 @@
>   # include "test-libnuma.c"
>   #undef main
>
> +#define main main_test_timerfd
> +# include "test-timerfd.c"
> +#undef main
> +
>   int main(int argc, char *argv[])
>   {
>   	main_test_libpython();
> @@ -101,6 +105,7 @@ int main(int argc, char *argv[])
>   	main_test_on_exit();
>   	main_test_backtrace();
>   	main_test_libnuma();
> +	main_test_timerfd();
>
>   	return 0;
>   }
> diff --git a/tools/perf/config/feature-checks/test-timerfd.c b/tools/perf/config/feature-checks/test-timerfd.c
> new file mode 100644
> index 000000000000..8c5c083b4d3c
> --- /dev/null
> +++ b/tools/perf/config/feature-checks/test-timerfd.c
> @@ -0,0 +1,18 @@
> +/*
> + * test for timerfd functions used by perf-kvm-stat-live
> + */
> +#include <sys/timerfd.h>
> +
> +int main(void)
> +{
> +	struct itimerspec new_value;
> +
> +	int fd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
> +	if (fd < 0)
> +		return 1;
> +
> +	if (timerfd_settime(fd, 0, &new_value, NULL) != 0)
> +		return 1;
> +
> +	return 0;
> +}
>

