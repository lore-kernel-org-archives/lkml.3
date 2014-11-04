Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaKDBSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:18:09 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:32991 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaKDBRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:17:02 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/8] perf tools: Add gzip decompression support for kernel module
Date: Tue,  4 Nov 2014 10:14:28 +0900
Message-Id: <1415063674-17206-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now my Archlinux box shows module symbols correctly.

Before:
  $ perf report --stdio
  Failed to open /tmp/perf-3477.map, continuing without symbols
  no symbols found in /usr/bin/date, maybe install a debug package?
  No kallsyms or vmlinux with build-id 7b4ea0a49ae2111925857099aaf05c3246ff33e0 was found
  [drm] with build id 7b4ea0a49ae2111925857099aaf05c3246ff33e0 not found, continuing without symbols
  No kallsyms or vmlinux with build-id edd931629094b660ca9dec09a1b635c8d87aa2ee was found
  [jbd2] with build id edd931629094b660ca9dec09a1b635c8d87aa2ee not found, continuing without symbols
  No kallsyms or vmlinux with build-id a7b1eada671c34933e5610bb920b2ca4945a82c3 was found
  [ext4] with build id a7b1eada671c34933e5610bb920b2ca4945a82c3 not found, continuing without symbols
  No kallsyms or vmlinux with build-id d69511fa3e5840e770336ef45b06c83fef8d74e3 was found
  [scsi_mod] with build id d69511fa3e5840e770336ef45b06c83fef8d74e3 not found, continuing without symbols
  No kallsyms or vmlinux with build-id af0430af13461af058770ee9b87afc07922c2e77 was found
  [libata] with build id af0430af13461af058770ee9b87afc07922c2e77 not found, continuing without symbols
  No kallsyms or vmlinux with build-id aaeedff8160ce631a5f0333591c6ff291201d29f was found
  [libahci] with build id aaeedff8160ce631a5f0333591c6ff291201d29f not found, continuing without symbols
  No kallsyms or vmlinux with build-id c57907712becaf662dc4981824bb372c0441d605 was found
  [mac80211] with build id c57907712becaf662dc4981824bb372c0441d605 not found, continuing without symbols
  No kallsyms or vmlinux with build-id e0589077cc0ec8c3e4c40eb9f2d9e69d236bee8f was found
  [iwldvm] with build id e0589077cc0ec8c3e4c40eb9f2d9e69d236bee8f not found, continuing without symbols
  No kallsyms or vmlinux with build-id 2d86086bf136bf374a2f029cf85a48194f9b950b was found
  [cfg80211] with build id 2d86086bf136bf374a2f029cf85a48194f9b950b not found, continuing without symbols
  No kallsyms or vmlinux with build-id 4493c48599bdb3d91d0f8db5150e0be33fdd9221 was found
  [iwlwifi] with build id 4493c48599bdb3d91d0f8db5150e0be33fdd9221 not found, continuing without symbols
  ...
  #
  # Overhead  Command          Shared Object            Symbol
  # ........  ...............  .......................  ........................................................
  #
       0.03%  swapper          [ext4]                   [k] 0x000000000000fe2e
       0.03%  swapper          [kernel.kallsyms]        [k] account_entity_enqueue
       0.03%  swapper          [ext4]                   [k] 0x000000000000fc2b
       0.03%  irq/50-iwlwifi   [iwlwifi]                [k] 0x000000000000200b
       0.03%  swapper          [kernel.kallsyms]        [k] ktime_add_safe
       0.03%  swapper          [kernel.kallsyms]        [k] elv_completed_request
       0.03%  swapper          [libata]                 [k] 0x0000000000003997
       0.03%  swapper          [libahci]                [k] 0x0000000000001f25
       0.03%  swapper          [kernel.kallsyms]        [k] rb_next
       0.03%  swapper          [kernel.kallsyms]        [k] blk_finish_request
       0.03%  swapper          [ext4]                   [k] 0x0000000000010248
       0.00%  perf             [kernel.kallsyms]        [k] native_write_msr_safe

After:
  $ perf report --stdio
  Failed to open /tmp/perf-3477.map, continuing without symbols
  no symbols found in /usr/bin/tr, maybe install a debug package?
  ...
  #
  # Overhead  Command          Shared Object                Symbol
  # ........  ...............  ...........................  ......................................................
  #

       0.04%  kworker/u16:3    [ext4]                       [k] ext4_read_block_bitmap
       0.03%  kworker/u16:0    [mac80211]                   [k] ieee80211_sta_reset_beacon_monitor
       0.02%  irq/50-iwlwifi   [mac80211]                   [k] ieee80211_get_bssid
       0.02%  firefox          [e1000e]                     [k] __ew32_prepare
       0.02%  swapper          [libahci]                    [k] ahci_handle_port_interrupt
       0.02%  emacs            libglib-2.0.so.0.4000.0      [.] g_mutex_unlock
       0.02%  swapper          [e1000e]                     [k] e1000_clean_tx_irq
       0.02%  dwm              [kernel.kallsyms]            [k] __schedule
       0.02%  gnome-terminal-  [vdso]                       [.] __vdso_clock_gettime
       0.02%  swapper          [e1000e]                     [k] e1000_alloc_rx_buffers
       0.02%  irq/50-iwlwifi   [mac80211]                   [k] ieee80211_rx
       0.01%  firefox          [vdso]                       [.] __vdso_gettimeofday
       0.01%  irq/50-iwlwifi   [iwlwifi]                    [k] iwl_pcie_rxq_restock.part.13

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf                     |  7 +++
 tools/perf/config/Makefile                   | 15 +++++-
 tools/perf/config/feature-checks/Makefile    |  6 ++-
 tools/perf/config/feature-checks/test-all.c  |  5 ++
 tools/perf/config/feature-checks/test-zlib.c |  9 ++++
 tools/perf/util/dso.c                        | 10 ++--
 tools/perf/util/util.h                       |  5 ++
 tools/perf/util/zlib.c                       | 78 ++++++++++++++++++++++++++++
 8 files changed, 125 insertions(+), 10 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-zlib.c
 create mode 100644 tools/perf/util/zlib.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3caf7dab50e8..31a76ee92c93 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -66,6 +66,9 @@ include config/utilities.mak
 #
 # Define NO_PERF_READ_VDSOX32 if you do not want to build perf-read-vdsox32
 # for reading the x32 mode 32-bit compatibility VDSO in 64-bit mode
+#
+# Define NO_ZLIB if you do not want to support compressed kernel modules
+
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
@@ -582,6 +585,10 @@ ifndef NO_LIBNUMA
   BUILTIN_OBJS += $(OUTPUT)bench/numa.o
 endif
 
+ifndef NO_ZLIB
+  LIB_OBJS += $(OUTPUT)util/zlib.o
+endif
+
 ifdef ASCIIDOC8
   export ASCIIDOC8
 endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 71264e41fa85..79f906c7124e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -200,7 +200,8 @@ CORE_FEATURE_TESTS =			\
 	libunwind			\
 	stackprotector-all		\
 	timerfd				\
-	libdw-dwarf-unwind
+	libdw-dwarf-unwind		\
+	zlib
 
 LIB_FEATURE_TESTS =			\
 	dwarf				\
@@ -214,7 +215,8 @@ LIB_FEATURE_TESTS =			\
 	libpython			\
 	libslang			\
 	libunwind			\
-	libdw-dwarf-unwind
+	libdw-dwarf-unwind		\
+	zlib
 
 VF_FEATURE_TESTS =			\
 	backtrace			\
@@ -604,6 +606,15 @@ ifneq ($(filter -lbfd,$(EXTLIBS)),)
   CFLAGS += -DHAVE_LIBBFD_SUPPORT
 endif
 
+ifndef NO_ZLIB
+  ifeq ($(feature-zlib), 1)
+    CFLAGS += -DHAVE_ZLIB_SUPPORT
+    EXTLIBS += -lz
+  else
+    NO_ZLIB := 1
+  endif
+endif
+
 ifndef NO_BACKTRACE
   ifeq ($(feature-backtrace), 1)
     CFLAGS += -DHAVE_BACKTRACE_SUPPORT
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 7c68ec74a808..9ced746a139a 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -29,7 +29,8 @@ FILES=					\
 	test-timerfd.bin		\
 	test-libdw-dwarf-unwind.bin	\
 	test-compile-32.bin		\
-	test-compile-x32.bin
+	test-compile-x32.bin		\
+	test-zlib.bin
 
 CC := $(CROSS_COMPILE)gcc -MD
 PKG_CONFIG := $(CROSS_COMPILE)pkg-config
@@ -139,6 +140,9 @@ FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 test-compile-x32.bin:
 	$(CC) -mx32 -o $(OUTPUT)$@ test-compile.c
 
+test-zlib.bin:
+	$(BUILD) -lz
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index a7d022e161c0..652e0098eba6 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -93,6 +93,10 @@
 # include "test-sync-compare-and-swap.c"
 #undef main
 
+#define main main_test_zlib
+# include "test-zlib.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -116,6 +120,7 @@ int main(int argc, char *argv[])
 	main_test_stackprotector_all();
 	main_test_libdw_dwarf_unwind();
 	main_test_sync_compare_and_swap(argc, argv);
+	main_test_zlib();
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-zlib.c b/tools/perf/config/feature-checks/test-zlib.c
new file mode 100644
index 000000000000..e111fff6240e
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-zlib.c
@@ -0,0 +1,9 @@
+#include <zlib.h>
+
+int main(void)
+{
+	z_stream zs;
+
+	inflateInit(&zs);
+	return 0;
+}
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 36a607cf8f50..3bf67fc34ed9 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -141,17 +141,13 @@ int dso__read_binary_type_filename(const struct dso *dso,
 	return ret;
 }
 
-static int decompress_dummy(const char *input __maybe_unused,
-			    int output __maybe_unused)
-{
-	return -1;
-}
-
 static const struct {
 	const char *fmt;
 	int (*decompress)(const char *input, int output);
 } compressions[] = {
-	{ "gz", decompress_dummy },
+#ifdef HAVE_ZLIB_SUPPORT
+	{ "gz", gzip_decompress_to_file },
+#endif
 	{ NULL, },
 };
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 80bfdaa0e2a4..7dc44cfe25b3 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -351,4 +351,9 @@ void mem_bswap_32(void *src, int byte_size);
 
 const char *get_filename_for_perf_kvm(void);
 bool find_process(const char *name);
+
+#ifdef HAVE_ZLIB_SUPPORT
+int gzip_decompress_to_file(const char *input, int output_fd);
+#endif
+
 #endif /* GIT_COMPAT_UTIL_H */
diff --git a/tools/perf/util/zlib.c b/tools/perf/util/zlib.c
new file mode 100644
index 000000000000..495a449fc25c
--- /dev/null
+++ b/tools/perf/util/zlib.c
@@ -0,0 +1,78 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <zlib.h>
+
+#include "util/util.h"
+#include "util/debug.h"
+
+
+#define CHUNK_SIZE  16384
+
+int gzip_decompress_to_file(const char *input, int output_fd)
+{
+	int ret = Z_STREAM_ERROR;
+	int input_fd;
+	void *ptr;
+	int len;
+	struct stat stbuf;
+	unsigned char buf[CHUNK_SIZE];
+	z_stream zs = {
+		.zalloc		= Z_NULL,
+		.zfree		= Z_NULL,
+		.opaque		= Z_NULL,
+		.avail_in	= 0,
+		.next_in	= Z_NULL,
+	};
+
+	input_fd = open(input, O_RDONLY);
+	if (input_fd < 0)
+		return -1;
+
+	if (fstat(input_fd, &stbuf) < 0)
+		goto out_close;
+
+	ptr = mmap(NULL, stbuf.st_size, PROT_READ, MAP_PRIVATE, input_fd, 0);
+	if (ptr == MAP_FAILED)
+		goto out_close;
+
+	if (inflateInit2(&zs, 16 + MAX_WBITS) != Z_OK)
+		goto out_unmap;
+
+	zs.next_in = ptr;
+	zs.avail_in = stbuf.st_size;
+
+	do {
+		zs.next_out = buf;
+		zs.avail_out = CHUNK_SIZE;
+
+		ret = inflate(&zs, Z_NO_FLUSH);
+		switch (ret) {
+		case Z_NEED_DICT:
+			ret = Z_DATA_ERROR;
+			/* fall through */
+		case Z_DATA_ERROR:
+		case Z_MEM_ERROR:
+			goto out;
+		default:
+			break;
+		}
+
+		len = CHUNK_SIZE - zs.avail_out;
+		if (writen(output_fd, buf, len) != len) {
+			ret = Z_DATA_ERROR;
+			goto out;
+		}
+
+	} while (ret != Z_STREAM_END);
+
+out:
+	inflateEnd(&zs);
+out_unmap:
+	munmap(ptr, stbuf.st_size);
+out_close:
+	close(input_fd);
+
+	return ret == Z_STREAM_END ? 0 : -1;
+}
-- 
2.1.2

