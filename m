Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3JAMvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:51:22 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34242 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3JAMvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:51:20 -0400
Date: Tue, 1 Oct 2013 14:51:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] perf autodep: Speed up the 'all features are present' case
Message-ID: <20131001125116.GA19606@gmail.com>
References: <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
 <20130930175342.GI10293@ghostprotocols.net>
 <20130930190434.GA3427@gmail.com>
 <20131001113456.GA31331@gmail.com>
 <20131001120455.GA8001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001120455.GA8001@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> And the actual feature check is roughly 0.330 msecs of that:
> 
>  comet:~/tip/tools/perf/config/feature-checks> time ( make -j >/dev/null; \
>  for N in stackprotector-all volatile-register-var fortify-source libelf \
>  libelf-mmap glibc dwarf libelf-getphdrnum libunwind libaudit libslang gtk2 \
>  gtk2-infobar libperl libpython libpython-version libbfd on-exit backtrace \
>  libnuma; do make test-$N >/dev/null; done )
> 
>  real    0m0.330s
>  user    0m0.290s
>  sys     0m0.031s
> 
> With 0.150 msecs spent elsewhere.
> 
> So there's more speedups possible I think, for example we could 
> construct an 'optimistic' testcase that is generated live and includes a 
> concatenation of all the testcases.
> 
> If the build of that file succeeds then we have a really efficient 
> fast-path both in the first-build and in the repeat-build case.
> 
> If that build fails then we do the more finegrained feature check.
> 
> Thoughts?

So, something like the patch below. It contains test-all.c "testcase from 
hell" which will succeed on a well configured system.

With this final trick I got a ridiculous speedup in auto-detection speed, 
for the rebuild-again case:

 comet:~/tip/tools/perf> perf stat --null --repeat 5 make Makefile

 Auto-detecting system features:

 ...            stackprotector-all: [ on  ]
 ...         volatile-register-var: [ on  ]
 ...                fortify-source: [ on  ]
 ...                        libelf: [ on  ]
 ...                   libelf-mmap: [ on  ]
 ...                         glibc: [ on  ]
 ...                         dwarf: [ on  ]
 ...             libelf-getphdrnum: [ on  ]
 ...                     libunwind: [ on  ]
 ...                      libaudit: [ on  ]
 ...                      libslang: [ on  ]
 ...                          gtk2: [ on  ]
 ...                  gtk2-infobar: [ on  ]
 ...                       libperl: [ on  ]
 ...                     libpython: [ on  ]
 ...             libpython-version: [ on  ]
 ...                        libbfd: [ on  ]
 ...                       on-exit: [ on  ]
 ...                     backtrace: [ on  ]
 ...                       libnuma: [ on  ]

 make: Nothing to be done for `Makefile'.

  Performance counter stats for 'make Makefile' (5 runs):

       0.183843005 seconds time elapsed                                          ( +-  0.21% )

So the cached build time is down from 3.300 secs to 0.183 secs, an 18-fold 
speedup.

It's still full auto-detection, because the -MD dependency generation 
works for test-all.c as well. For example once I remove the 
'perl-ExtUtils-Embed' package, I immediately get the correct, adapted 
auto-dep output with the 'libperl' testcase showing 'OFF':

comet:~/tip/tools/perf> make Makefile

Auto-detecting system features:

...            stackprotector-all: [ on  ]
...         volatile-register-var: [ on  ]
...                fortify-source: [ on  ]
...                        libelf: [ on  ]
...                   libelf-mmap: [ on  ]
...                         glibc: [ on  ]
...                         dwarf: [ on  ]
...             libelf-getphdrnum: [ on  ]
...                     libunwind: [ on  ]
...                      libaudit: [ on  ]
...                      libslang: [ on  ]
...                          gtk2: [ on  ]
...                  gtk2-infobar: [ on  ]
...                       libperl: [ OFF ]
...                     libpython: [ on  ]
...             libpython-version: [ on  ]
...                        libbfd: [ on  ]
...                       on-exit: [ on  ]
...                     backtrace: [ on  ]
...                       libnuma: [ on  ]


Note that at this point this is just a proof-of-concept patch for 
performance testing, nothing mergable yet.

In particular I'm not happy yet with the current construction of 
test-all.c and its build method: it's the result of concatenation of files 
and build arguments plus further massaging.

That should probably be automated in some fashion, to make it easier to 
add new testcases and to make the whole construct more maintainable.

Thanks,

	Ingo

=========================>
Subject: perf autodep: Speed up the 'all features are present' case
From: Ingo Molnar <mingo@kernel.org>
Date: Tue Oct 1 14:14:31 CEST 2013

---
 tools/perf/config/Makefile                  |   18 ++
 tools/perf/config/feature-checks/Makefile   |    3 
 tools/perf/config/feature-checks/test-all.c |  196 ++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+), 2 deletions(-)

Index: tip/tools/perf/config/Makefile
===================================================================
--- tip.orig/tools/perf/config/Makefile
+++ tip/tools/perf/config/Makefile
@@ -94,16 +94,30 @@ define feature_check_code
   feature-$(1) := $(shell make -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
+feature_set = $(eval $(feature_set_code))
+define feature_set_code
+  feature-$(1) := 1
+endef
+
 #
 # Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
 #
 $(info )
 $(info Auto-detecting system features:)
-$(shell make -i -j -C config/feature-checks >/dev/null 2>&1)
 
 FEATURE_TESTS = stackprotector-all volatile-register-var fortify-source libelf libelf-mmap glibc dwarf libelf-getphdrnum libunwind libaudit libslang gtk2 gtk2-infobar libperl libpython libpython-version libbfd on-exit backtrace libnuma
 
-$(foreach feat,$(FEATURE_TESTS),$(call feature_check,$(feat)))
+#
+# Special fast-path for the 'all features are available' case:
+#
+$(call feature_check,all)
+
+ifeq ($(feature-all), 1)
+  $(foreach feat,$(FEATURE_TESTS),$(call feature_set,$(feat)))
+else
+  $(shell make -i -j -C config/feature-checks >/dev/null 2>&1)
+  $(foreach feat,$(FEATURE_TESTS),$(call feature_check,$(feat)))
+endif
 
 feature_print = $(eval $(feature_print_code))
 
Index: tip/tools/perf/config/feature-checks/Makefile
===================================================================
--- tip.orig/tools/perf/config/feature-checks/Makefile
+++ tip/tools/perf/config/feature-checks/Makefile
@@ -99,6 +99,9 @@ test-on-exit: test-on-exit.c
 test-backtrace: test-backtrace.c
 	$(CC) -o $@ $@.c
 
+test-all:
+	$(CC) -o $@ $@.c -Werror -fstack-protector -Wvolatile-register-var -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lunwind -lunwind-x86_64 -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='perf' -DPACKAGE=perf -lbfd -ldl
+
 -include *.d */*.d
 
 ###############################
Index: tip/tools/perf/config/feature-checks/test-all.c
===================================================================
--- /dev/null
+++ tip/tools/perf/config/feature-checks/test-all.c
@@ -0,0 +1,196 @@
+
+#pragma GCC diagnostic ignored "-Wstrict-prototypes"
+
+#include <Python.h>
+
+#include <EXTERN.h>
+#include <perl.h>
+
+#include <stdio.h>
+#include <libelf.h>
+#include <gnu/libc-version.h>
+#include <dwarf.h>
+#include <elfutils/libdw.h>
+#include <elfutils/version.h>
+#include <libelf.h>
+#include <libunwind.h>
+#include <stdlib.h>
+#include <libaudit.h>
+#include <slang.h>
+#include <gtk/gtk.h>
+#include <bfd.h>
+#include <stdio.h>
+#include <execinfo.h>
+#include <stdio.h>
+#include <numa.h>
+#include <numaif.h>
+
+#pragma GCC diagnostic error "-Wstrict-prototypes"
+
+int main1(void)
+{
+	return puts("hi");
+}
+
+int main2(void)
+{
+	return puts("hi");
+}
+
+int main3(void)
+{
+	return puts("hi");
+}
+
+int main4(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+	return (long)elf;
+}
+#
+int main5(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ_MMAP, 0);
+	return (long)elf;
+}
+
+int main6(void)
+{
+	const char *version = gnu_get_libc_version();
+	return (long)version;
+}
+
+int main7(void)
+{
+	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
+	return (long)dbg;
+}
+
+int main8(void)
+{
+	size_t dst;
+	return elf_getphdrnum(0, &dst);
+}
+
+extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
+                                      unw_word_t ip,
+                                      unw_dyn_info_t *di,
+                                      unw_proc_info_t *pi,
+                                      int need_unwind_info, void *arg);
+
+
+#define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
+
+int main9(void)
+{
+	unw_addr_space_t addr_space;
+	addr_space = unw_create_addr_space(NULL, 0);
+	unw_init_remote(NULL, addr_space, NULL);
+	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
+	return 0;
+}
+
+int main10(void)
+{
+	printf("error message: %s\n", audit_errno_to_name(0));
+	return audit_open();
+}
+
+int main11(void)
+{
+	return SLsmg_init_smg();
+}
+
+int main12(int argc, char *argv[])
+{
+        gtk_init(&argc, &argv);
+
+        return 0;
+}
+
+int main13(void)
+{
+	gtk_info_bar_new();
+
+	return 0;
+}
+
+int main14(void)
+{
+	perl_alloc();
+
+	return 0;
+}
+
+int main15(void)
+{
+	Py_Initialize();
+	return 0;
+}
+
+#if PY_VERSION_HEX >= 0x03000000
+	#error
+#endif
+
+int main16(void)
+{
+	return 0;
+}
+
+int main17(void)
+{
+	bfd_demangle(0, 0, 0);
+	return 0;
+}
+
+void exit_function(int x, void *y)
+{
+}
+
+int main18(void)
+{
+	return on_exit(exit_function, NULL);
+}
+
+int main19(void)
+{
+	void *backtrace_fns[1];
+	size_t entries;
+
+	entries = backtrace(backtrace_fns, 1);
+	backtrace_symbols(backtrace_fns, entries);
+
+	return 0;
+}
+
+int main20(void)
+{
+	numa_available();
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	main1();
+	main2();
+	main3();
+	main4();
+	main5();
+	main6();
+	main7();
+	main8();
+	main9();
+	main10();
+	main11();
+	main12(argc, argv);
+	main13();
+	main14();
+	main15();
+	main16();
+	main17();
+	main18();
+	main19();
+	main20();
+
+	return 0;
+}
