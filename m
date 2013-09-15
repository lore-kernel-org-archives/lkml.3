Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab3IOJKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 05:10:35 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:35040 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab3IOJKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 05:10:33 -0400
Date: Sun, 15 Sep 2013 11:10:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] perf test-hack: Split out feature tests to cache them and to
 build them in parallel
Message-ID: <20130915091029.GA21465@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912204313.GA3259@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So, the discussion died down a bit, so just to demonstrate how feature 
tests should be done IMO, here's a quick hack to perf that adds a new 
'make feature-check' test-target and factors out 4 standalone feature 
tests:

 $ make feature-check
 ...
 Testing features:
 dwarf  support:  disabled
 ELF    support:  enabled
 glibc  support:  enabled
 Bionic support:  disabled

Repeat invocations only rebuild the testcases that failed. If no testcase 
fails then nothing is rebuilt and the features check runs very fast.

Even in the worst-case when most testcases are rebuilt there's a big 
improvement in runtime due to building the testcases in parallel.

NOTE: the new testcases are not fed back into perf's 
NO_DWARF/NO_LIBELF/etc. flag hierarchy yet, the patch only demonstrates 
that this method is a viable and fast method that solves most of our 
current problems in this area.

Other advantages over the current config/feature-tests.mak method:

 - The individual testcases can be built/tested in the feature-checks/ 
   directory as well, individually

 - The testcases are simple, plain, standalone C files, unlike
   config/feature-tests.mak which suffers from escaping complications.

'make clean' in feature-checks/ gets rid of all testcase binaries.

Thanks,

	Ingo

---------------------->

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3a0ff7f..e6398e7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -816,3 +816,17 @@ clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean
 .PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
+
+#
+# Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
+#
+feature-check-build:
+	@echo "Testing features:"
+	@-make -i -j -C feature-checks >/dev/null 2>&1
+
+feature-check: feature-check-build
+	@echo -n "dwarf  support:  "; [ -f feature-checks/test-dwarf  ] && echo enabled || echo disabled
+	@echo -n "ELF    support:  "; [ -f feature-checks/test-libelf ] && echo enabled || echo disabled
+	@echo -n "glibc  support:  "; [ -f feature-checks/test-glibc  ] && echo enabled || echo disabled
+	@echo -n "Bionic support:  "; [ -f feature-checks/test-bionic ] && echo enabled || echo disabled
+
diff --git a/tools/perf/feature-checks/Makefile b/tools/perf/feature-checks/Makefile
new file mode 100644
index 0000000..dea10c8
--- /dev/null
+++ b/tools/perf/feature-checks/Makefile
@@ -0,0 +1,26 @@
+
+FILES=test-hello test-dwarf test-libelf test-glibc test-bionic
+
+all: $(FILES)
+
+###############################
+
+test-hello: test-hello.c
+	$(CC) -o $@ $@.c
+
+test-dwarf: test-dwarf.c
+	$(CC) -o $@ $@.c -ldw
+
+test-libelf: test-libelf.c
+	$(CC) -o $@ $@.c -lelf
+
+test-glibc: test-glibc.c
+	$(CC) -o $@ $@.c
+
+test-bionic: test-bionic.c
+	$(CC) -o $@ $@.c
+
+###############################
+
+clean:
+	rm -f $(FILES)
diff --git a/tools/perf/feature-checks/test-bionic.c b/tools/perf/feature-checks/test-bionic.c
new file mode 100644
index 0000000..eac24e9
--- /dev/null
+++ b/tools/perf/feature-checks/test-bionic.c
@@ -0,0 +1,6 @@
+#include <android/api-level.h>
+
+int main(void)
+{
+	return __ANDROID_API__;
+}
diff --git a/tools/perf/feature-checks/test-dwarf.c b/tools/perf/feature-checks/test-dwarf.c
new file mode 100644
index 0000000..783dfcd
--- /dev/null
+++ b/tools/perf/feature-checks/test-dwarf.c
@@ -0,0 +1,9 @@
+#include <dwarf.h>
+#include <elfutils/libdw.h>
+#include <elfutils/version.h>
+
+int main(void)
+{
+	Dwarf *dbg = dwarf_begin(0, DWARF_C_READ);
+	return (long)dbg;
+}
diff --git a/tools/perf/feature-checks/test-glibc.c b/tools/perf/feature-checks/test-glibc.c
new file mode 100644
index 0000000..13c66a5
--- /dev/null
+++ b/tools/perf/feature-checks/test-glibc.c
@@ -0,0 +1,8 @@
+#include <gnu/libc-version.h>
+
+int main(void)
+{
+	const char *version = gnu_get_libc_version();
+	return (long)version;
+}
+
diff --git a/tools/perf/feature-checks/test-hello b/tools/perf/feature-checks/test-hello
new file mode 100755
index 0000000..6e9a668
Binary files /dev/null and b/tools/perf/feature-checks/test-hello differ
diff --git a/tools/perf/feature-checks/test-hello.c b/tools/perf/feature-checks/test-hello.c
new file mode 100644
index 0000000..c9f398d
--- /dev/null
+++ b/tools/perf/feature-checks/test-hello.c
@@ -0,0 +1,6 @@
+#include <stdio.h>
+
+int main(void)
+{
+	return puts("hi");
+}
diff --git a/tools/perf/feature-checks/test-libelf b/tools/perf/feature-checks/test-libelf
new file mode 100755
index 0000000..bafde82
Binary files /dev/null and b/tools/perf/feature-checks/test-libelf differ
diff --git a/tools/perf/feature-checks/test-libelf.c b/tools/perf/feature-checks/test-libelf.c
new file mode 100644
index 0000000..1a08f97
--- /dev/null
+++ b/tools/perf/feature-checks/test-libelf.c
@@ -0,0 +1,7 @@
+#include <libelf.h>
+
+int main(void)
+{
+	Elf *elf = elf_begin(0, ELF_C_READ, 0);
+	return (long)elf;
+}
