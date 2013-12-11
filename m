Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3LKTY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:24:29 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:64210 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3LKTY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:24:27 -0500
Date: Wed, 11 Dec 2013 16:24:07 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 21/71] perf tools: Add feature test for
 __sync_val_compare_and_swap
Message-ID: <20131211192407.GD1458@ghostprotocols.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-22-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386765443-26966-22-git-send-email-alexander.shishkin@linux.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 11, 2013 at 02:36:33PM +0200, Alexander Shishkin escreveu:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> Add a feature test for __sync_val_compare_and_swap()
> and __sync_bool_compare_and_swap()

This makes the global feature tests to be rebuilt all the time, i.e. no
more caching on a relatively recent system:

[acme@ssdandy linux]$ gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.7.2/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info
--with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap
--enable-shared --enable-threads=posix --enable-checking=release
--disable-build-with-cxx --disable-build-poststage1-with-cxx
--with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions
--enable-gnu-unique-object --enable-linker-build-id
--with-linker-hash-style=gnu
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto
--enable-plugin --enable-initfini-array --enable-java-awt=gtk
--disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre
--enable-libgcj-multifile --enable-java-maintainer-mode
--with-ecj-jar=/usr/share/java/eclipse-ecj.jar
--disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic
--with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) 
[acme@ssdandy linux]$o

[acme@ssdandy linux]$ cat /etc/fedora-release 
Fedora release 18 (Spherical Cow)

Can you provide more info about these gcc builtins and what is the
minimum system where this test will succeed?

In this system it works, as I can see:

...         sync-compare-and-swap: [ on  ]

[acme@ssdandy linux]$ time make O=/tmp/build/perf -C tools/perf/
install-bin
make: Entering directory `/home/acme/git/linux/tools/perf'
  BUILD:   Doing 'make -j8' parallel build

Auto-detecting system features:
...                     backtrace: [ on  ]
...                         dwarf: [ on  ]
...                fortify-source: [ on  ]
...         sync-compare-and-swap: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                  gtk2-infobar: [ on  ]
...                      libaudit: [ on  ]
...                        libbfd: [ on  ]
...                        libelf: [ on  ]
...             libelf-getphdrnum: [ on  ]
...                   libelf-mmap: [ on  ]
...                       libnuma: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...                       on-exit: [ on  ]
...            stackprotector-all: [ on  ]
...                       timerfd: [ on  ]

  GEN      perf-archive

Please check the recent changes from Jean Pihet, I think he had similar
problems, i.e. caching stopped working.

- Arnaldo

 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/config/Makefile                                 |  5 +++++
>  tools/perf/config/feature-checks/Makefile                  |  4 ++++
>  tools/perf/config/feature-checks/test-all.c                |  5 +++++
>  .../config/feature-checks/test-sync-compare-and-swap.c     | 14 ++++++++++++++
>  4 files changed, 28 insertions(+)
>  create mode 100644 tools/perf/config/feature-checks/test-sync-compare-and-swap.c
> 
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index bae1072..43a2879 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -126,6 +126,7 @@ CORE_FEATURE_TESTS =			\
>  	backtrace			\
>  	dwarf				\
>  	fortify-source			\
> +	sync-compare-and-swap		\
>  	glibc				\
>  	gtk2				\
>  	gtk2-infobar			\
> @@ -234,6 +235,10 @@ CFLAGS += -I$(LIB_INCLUDE)
>  
>  CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
>  
> +ifeq ($(feature-sync-compare-and-swap), 1)
> +  CFLAGS += -DHAVE_SYNC_COMPARE_AND_SWAP_SUPPORT
> +endif
> +
>  ifndef NO_BIONIC
>    $(call feature_check,bionic)
>    ifeq ($(feature-bionic), 1)
> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> index b8bb749..b4b7bb2 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -5,6 +5,7 @@ FILES=					\
>  	test-bionic			\
>  	test-dwarf			\
>  	test-fortify-source		\
> +	test-sync-compare-and-swap	\
>  	test-glibc			\
>  	test-gtk2			\
>  	test-gtk2-infobar		\
> @@ -140,6 +141,9 @@ test-backtrace:
>  test-timerfd:
>  	$(BUILD)
>  
> +test-sync-compare-and-swap:
> +	$(BUILD)
> +
>  -include *.d
>  
>  ###############################
> diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
> index 9b8a544..5cfec18 100644
> --- a/tools/perf/config/feature-checks/test-all.c
> +++ b/tools/perf/config/feature-checks/test-all.c
> @@ -89,6 +89,10 @@
>  # include "test-stackprotector-all.c"
>  #undef main
>  
> +#define main main_test_sync_compare_and_swap
> +# include "test-sync-compare-and-swap.c"
> +#undef main
> +
>  int main(int argc, char *argv[])
>  {
>  	main_test_libpython();
> @@ -111,6 +115,7 @@ int main(int argc, char *argv[])
>  	main_test_libnuma();
>  	main_test_timerfd();
>  	main_test_stackprotector_all();
> +	main_test_sync_compare_and_swap();
>  
>  	return 0;
>  }
> diff --git a/tools/perf/config/feature-checks/test-sync-compare-and-swap.c b/tools/perf/config/feature-checks/test-sync-compare-and-swap.c
> new file mode 100644
> index 0000000..c34d4ca
> --- /dev/null
> +++ b/tools/perf/config/feature-checks/test-sync-compare-and-swap.c
> @@ -0,0 +1,14 @@
> +#include <stdint.h>
> +
> +volatile uint64_t x;
> +
> +int main(int argc, char *argv[])
> +{
> +	uint64_t old, new = argc;
> +
> +	argv = argv;
> +	do {
> +		old = __sync_val_compare_and_swap(&x, 0, 0);
> +	} while (!__sync_bool_compare_and_swap(&x, old, new));
> +	return old == new;
> +}
> -- 
> 1.8.5.1
