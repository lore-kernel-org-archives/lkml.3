Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbbAHH65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 02:58:57 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48117 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbbAHH6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 02:58:54 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 8 Jan 2015 16:56:53 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: acme@redhat.com, peterz@infradead.org, jolsa@kernel.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        bp@suse.de, linux-arch@vger.kernel.org, Alexey.Brodkin@synopsys.com
Subject: Re: [PATCH 5/5] perf tools: [uclibc] provide stub for
 pthread_attr_setaffinity_np
Message-ID: <20150108075653.GG7268@sejong>
References: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
 <1420552335-26886-6-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420552335-26886-6-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 07:22:15PM +0530, Vineet Gupta wrote:
> uClibc Linuxthreads.old doesnt support pthread_attr_setaffinity_np()
> call
> 
> ----------------->8-----------------------
>   CC       bench/futex-hash.o
>   CC       bench/futex-wake.o
> bench/futex-hash.c: In function 'bench_futex_hash':
> bench/futex-hash.c:161:3: error: implicit declaration of function
> 'pthread_attr_setaffinity_np' [-Werror=implicit-function-declaration]
>    ret = pthread_attr_setaffinity_np(&thread_attr, sizeof(cpu_set_t),
> &cpu);
>    ^
> bench/futex-hash.c:161:3: error: nested extern declaration of
> 'pthread_attr_setaffinity_np' [-Werror=nested-externs]
> ----------------->8-----------------------
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  tools/perf/bench/futex.h                    | 13 +++++++++++++
>  tools/perf/config/Makefile                  |  6 ++++++
>  tools/perf/config/feature-checks/Makefile   |  4 ++++
>  tools/perf/config/feature-checks/test-all.c |  5 +++++
>  4 files changed, 28 insertions(+)

It seems that you fotgot to add the real test file
(test-pthread_attr_setaffinity_np.c?) here..

Thanks,
Namhyung


> 
> diff --git a/tools/perf/bench/futex.h b/tools/perf/bench/futex.h
> index 71f2844cf97f..7ed22ff1e1ac 100644
> --- a/tools/perf/bench/futex.h
> +++ b/tools/perf/bench/futex.h
> @@ -68,4 +68,17 @@ futex_cmp_requeue(u_int32_t *uaddr, u_int32_t val, u_int32_t *uaddr2, int nr_wak
>  		 val, opflags);
>  }
>  
> +#ifndef HAVE_PTHREAD_ATTR_SETAFFINITY_NP
> +#include <pthread.h>
> +static inline int pthread_attr_setaffinity_np(pthread_attr_t *attr,
> +					      size_t cpusetsize,
> +					      cpu_set_t *cpuset)
> +{
> +	attr = attr;
> +	cpusetsize = cpusetsize;
> +	cpuset = cpuset;
> +	return 0;
> +}
> +#endif
> +
>  #endif /* _FUTEX_H */
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 5d4b039fe1ed..6b59662136fa 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -198,6 +198,7 @@ CORE_FEATURE_TESTS =			\
>  	libpython-version		\
>  	libslang			\
>  	libunwind			\
> +	pthread-attr-setaffinity-np	\
>  	stackprotector-all		\
>  	timerfd				\
>  	libdw-dwarf-unwind		\
> @@ -226,6 +227,7 @@ VF_FEATURE_TESTS =			\
>  	libelf-getphdrnum		\
>  	libelf-mmap			\
>  	libpython-version		\
> +	pthread-attr-setaffinity-np	\
>  	stackprotector-all		\
>  	timerfd				\
>  	libunwind-debug-frame		\
> @@ -301,6 +303,10 @@ ifeq ($(feature-sync-compare-and-swap), 1)
>    CFLAGS += -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT
>  endif
>  
> +ifeq ($(feature-pthread-attr-setaffinity-np), 1)
> +  CFLAGS += -DHAVE_PTHREAD_ATTR_SETAFFINITY_NP
> +endif
> +
>  ifndef NO_BIONIC
>    $(call feature_check,bionic)
>    ifeq ($(feature-bionic), 1)
> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> index 53f19b5dbc37..e9b99bb29348 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -25,6 +25,7 @@ FILES=					\
>  	test-libslang.bin		\
>  	test-libunwind.bin		\
>  	test-libunwind-debug-frame.bin	\
> +	test-pthread-attr-setaffinity-np.bin	\
>  	test-stackprotector-all.bin	\
>  	test-timerfd.bin		\
>  	test-libdw-dwarf-unwind.bin	\
> @@ -47,6 +48,9 @@ test-all.bin:
>  test-hello.bin:
>  	$(BUILD)
>  
> +test-pthread-attr-setaffinity-np.bin:
> +	$(BUILD) -Werror
> +
>  test-stackprotector-all.bin:
>  	$(BUILD) -Werror -fstack-protector-all
>  
> diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
> index 652e0098eba6..6d4d09323922 100644
> --- a/tools/perf/config/feature-checks/test-all.c
> +++ b/tools/perf/config/feature-checks/test-all.c
> @@ -97,6 +97,10 @@
>  # include "test-zlib.c"
>  #undef main
>  
> +#define main main_test_pthread_attr_setaffinity_np
> +# include "test-pthread_attr_setaffinity_np.c"
> +#undef main
> +
>  int main(int argc, char *argv[])
>  {
>  	main_test_libpython();
> @@ -121,6 +125,7 @@ int main(int argc, char *argv[])
>  	main_test_libdw_dwarf_unwind();
>  	main_test_sync_compare_and_swap(argc, argv);
>  	main_test_zlib();
> +	main_test_pthread_attr_setaffinity_np();
>  
>  	return 0;
>  }
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
