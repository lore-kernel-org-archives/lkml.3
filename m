Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbbALLFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:05:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbbALLFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:05:16 -0500
Date: Mon, 12 Jan 2015 12:04:43 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: acme@redhat.com, namhyung@kernel.org, peterz@infradead.org,
        jolsa@kernel.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexey.Brodkin@synopsys.com
Subject: Re: [PATCH v2 5/5] perf tools: [uclibc] provide stub for
 pthread_attr_setaffinity_np
Message-ID: <20150112110443.GB26229@krava.redhat.com>
References: <1420888254-17504-1-git-send-email-vgupta@synopsys.com>
 <1420888254-17504-6-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420888254-17504-6-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 04:40:54PM +0530, Vineet Gupta wrote:

SNIP

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

this does not works for me unless I add -lpthread (check patch below)
is it possible you pushed that through LDFLAGS?

otherwise I'm getting following error:
	---
	In file included from bench/futex-hash.c:17:0:
	bench/futex.h:73:19: error: conflicting types for ‘pthread_attr_setaffinity_np’
	 static inline int pthread_attr_setaffinity_np(pthread_attr_t *attr,
			   ^
	In file included from bench/futex.h:72:0,
			 from bench/futex-hash.c:17:
	/usr/include/pthread.h:407:12: note: previous declaration of ‘pthread_attr_setaffinity_np’ was here
	 extern int pthread_attr_setaffinity_np (pthread_attr_t *__attr,
		    ^
	make[1]: *** [bench/futex-hash.o] Error 1
	make[1]: *** Waiting for unfinished jobs....
	In file included from bench/futex-wake.c:17:0:
	bench/futex.h:73:19: error: conflicting types for ‘pthread_attr_setaffinity_np’
	 static inline int pthread_attr_setaffinity_np(pthread_attr_t *attr,
			   ^
	In file included from bench/futex.h:72:0,
			 from bench/futex-wake.c:17:
	/usr/include/pthread.h:407:12: note: previous declaration of ‘pthread_attr_setaffinity_np’ was here
	 extern int pthread_attr_setaffinity_np (pthread_attr_t *__attr,
		    ^
	make[1]: *** [bench/futex-wake.o] Error 1
	In file included from bench/futex-requeue.c:17:0:
	bench/futex.h:73:19: error: conflicting types for ‘pthread_attr_setaffinity_np’
	 static inline int pthread_attr_setaffinity_np(pthread_attr_t *attr,
			   ^
	In file included from bench/futex.h:72:0,
			 from bench/futex-requeue.c:17:
	/usr/include/pthread.h:407:12: note: previous declaration of ‘pthread_attr_setaffinity_np’ was here
	 extern int pthread_attr_setaffinity_np (pthread_attr_t *__attr,
		    ^
	make[1]: *** [bench/futex-requeue.o] Error 1
	make: *** [all] Error 2
	---

my system is x86_64 on F20

thanks,
jirka


diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index e9b99bb29348..42ac05aaf8ac 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -49,7 +49,7 @@ test-hello.bin:
 	$(BUILD)
 
 test-pthread-attr-setaffinity-np.bin:
-	$(BUILD) -Werror
+	$(BUILD) -Werror -lpthread
 
 test-stackprotector-all.bin:
 	$(BUILD) -Werror -fstack-protector-all
