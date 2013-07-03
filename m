Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3GCCbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:31:03 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:34171 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3GCCaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:30:06 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-7b-51d388d901b4
X-Mailbox-Line: From nobody Wed Jul  3 10:46:16 2013
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [RFC PATCH 4/5] msghash: Add userland msghash tool
To: linux-kernel@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, kay@vrfy.org, davem@davemloft.net,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, "David S. Miller" <davem@davemloft.net>
Date: Wed, 03 Jul 2013 10:46:16 +0900
Message-ID: <20130703014616.18745.85336.stgit@localhost.localdomain>
In-Reply-To: <20130703014616.18745.34699.stgit@localhost.localdomain>
References: <20130703014616.18745.34699.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds scripts/msghash/msghash.  msghash scans a kmsg_meta
table between __start___kmsg_meta to __stop___kmsg_meta in the
target object file (vmlinux), computes a hash value for each
message format string, then replaces the format string with the
hash value.  Valid flags are also set to entries in the kmsg_meta
table.  When computing the hash value, prefixed loglevel characters
are ignored.

Even if configured with CONFIG_KMSG_HASH=y, without running msghash,
no hash values are output via /dev/kmsg.  So msghash is executed
during the build process, just after generating vmlinux.

msghash also generate a Hash-and-message catalog named
"<objfile>.msglist".  Each line in the .msglist file is output
in the form of:
<hash in hex>@<file>:<lineno>,<message format>

.msglist file is useful to match /dev/kmsg messages with messages
you concern.

Here is the example of .msglist:
...
b6be0058@init/main.c:180,"Parameter %s is obsolete, ignored"
72dfe336@init/main.c:403,"Malformed early option '%s'"
85788d36@init/do_mounts.c:573,"Waiting for root device %s..."
...

Currently, only vmlinux is supported.  msghash can't update
the kmsg_meta tables of kernel modules.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: "David S. Miller" <davem@davemloft.net>
---

 .gitignore                 |    1 
 Makefile                   |    7 +
 lib/Kconfig.debug          |    5 +
 scripts/Makefile           |    1 
 scripts/link-vmlinux.sh    |    5 +
 scripts/msghash/.gitignore |    1 
 scripts/msghash/Makefile   |    7 +
 scripts/msghash/msghash.c  |  241 ++++++++++++++++++++++++++++++++++++++++++++
 scripts/msghash/msghash.sh |   45 ++++++++
 9 files changed, 312 insertions(+), 1 deletions(-)
 create mode 100644 scripts/msghash/.gitignore
 create mode 100644 scripts/msghash/Makefile
 create mode 100644 scripts/msghash/msghash.c
 create mode 100755 scripts/msghash/msghash.sh

diff --git a/.gitignore b/.gitignore
index 3b8b9b3..3bb5735 100644
--- a/.gitignore
+++ b/.gitignore
@@ -32,6 +32,7 @@ modules.builtin
 *.lzo
 *.patch
 *.gcno
+*.msglist
 
 #
 # Top-level generic files
diff --git a/Makefile b/Makefile
index e5e3ba0..2693d7d 100644
--- a/Makefile
+++ b/Makefile
@@ -766,6 +766,10 @@ vmlinux-deps := $(KBUILD_LDS) $(KBUILD_VMLINUX_INIT) $(KBUILD_VMLINUX_MAIN)
       cmd_link-vmlinux = $(CONFIG_SHELL) $< $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux)
 quiet_cmd_link-vmlinux = LINK    $@
 
+# Remove old .msglist
+      cmd_rm-msglist = echo rm -f $@.msglist
+quiet_cmd_rm-msglist = CLEAN   $@.msglist
+
 # Include targets which we want to
 # execute if the rest of the kernel build went well.
 vmlinux: scripts/link-vmlinux.sh $(vmlinux-deps) FORCE
@@ -1273,7 +1277,8 @@ clean: $(clean-dirs)
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
 		-o -name modules.builtin -o -name '.tmp_*.o.*' \
-		-o -name '*.gcno' \) -type f -print | xargs rm -f
+		-o -name '*.gcno' -o -name '*.msglist' \) -type f -print |\
+		xargs rm -f
 
 # Generate tags for editors
 # ---------------------------------------------------------------------------
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9302ece..bd05088 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -11,6 +11,11 @@ config PRINTK_TIME
 	  to /dev/kmsg. This flag just specifies if the timestamp should
 	  be included, not that the timestamp is recorded.
 
+	  Hash values are calculated during the build process and
+	  put into a table in object files.  Hash-and-message catalogs
+	  named <objfile>.msglist are also generated for convenience
+	  in message handling in userland.
+
 	  The behavior is also controlled by the kernel command line
 	  parameter printk.time=1. See Documentation/kernel-parameters.txt
 
diff --git a/scripts/Makefile b/scripts/Makefile
index 01e7adb..7568e35 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -37,6 +37,7 @@ subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_DTC)         += dtc
+subdir-$(CONFIG_KMSG_HASH) += msghash
 
 # Let clean descend into subdirs
 subdir-	+= basic kconfig package selinux
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 0149949..575c2bb 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -228,5 +228,10 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
 	fi
 fi
 
+if [ -n "${CONFIG_KMSG_HASH}" ]; then
+	rm -f vmlinux.msglist
+	${srctree}/scripts/msghash/msghash.sh vmlinux || exit 1
+fi
+
 # We made a new kernel - delete old version file
 rm -f .old_version
diff --git a/scripts/msghash/.gitignore b/scripts/msghash/.gitignore
new file mode 100644
index 0000000..8bcfa1d
--- /dev/null
+++ b/scripts/msghash/.gitignore
@@ -0,0 +1 @@
+msghash
diff --git a/scripts/msghash/Makefile b/scripts/msghash/Makefile
new file mode 100644
index 0000000..add1e14
--- /dev/null
+++ b/scripts/msghash/Makefile
@@ -0,0 +1,7 @@
+hostprogs-y	:= msghash
+
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include -I$(srctree)/include
+
+always		:= $(hostprogs-y)
+clean-files	:= $(hostprogs-y)
+
diff --git a/scripts/msghash/msghash.c b/scripts/msghash/msghash.c
new file mode 100644
index 0000000..832fdb9
--- /dev/null
+++ b/scripts/msghash/msghash.c
@@ -0,0 +1,241 @@
+/*
+ * msghash.c: calculate hash values of printk messages and update the
+ *            kmsg_meta table in the target object file.
+ *
+ * Copyright 2013 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+typedef u_int8_t u8;
+typedef u_int16_t u16;
+typedef u_int32_t u32;
+typedef u_int64_t u64;
+
+#include <linux/kmsghash.h>
+#include <tools/jhash.h>
+
+#define KERN_SOH_ASCII	'\001'
+static inline char *printk_skip_level(char *buffer)
+{
+	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
+		switch (buffer[1]) {
+		case '0' ... '7':
+		case 'd':	/* KERN_DEFAULT */
+			return buffer + 2;
+		}
+	}
+	return buffer;
+}
+
+static unsigned long rodata_addr;
+static unsigned long rodata_off;
+static FILE *outfp;
+struct msghash_stat {
+	int updated;	/* number of entries updated successfully */
+	int skipped;	/* skipped entries because of having a valid hash */
+	int invalid;	/* entries whoes format string is not constant */
+} st;
+
+static inline unsigned long addr_to_offset(unsigned long addr)
+{
+	return  addr - rodata_addr + rodata_off;
+}
+
+static void usage(void)
+{
+	fprintf(stderr,
+	"Usage: msghash [-o <outfile>] <objfile> <start_meta> <stop_meta>\n"
+	"               <rodata_addr> <rodata_offset>\n");
+}
+
+/*
+ * Update the hash value of a given kmsg_meta object and write out
+ * a Hash-and-message line to the specified file.
+ */
+static void update_and_print_hash(char *buf, struct kmsg_meta *meta)
+{
+	static char fmtbuf[4096];
+	u_int32_t hash;
+	char *str;
+	int len;
+	int i, j, c;
+
+	if (meta->flags & KMSG_FLAGS_HASH_VALID) {
+		st.skipped++;
+		return;
+	}
+
+	/* Non-constant format case, skip it. */
+	if (!meta->u.format) {
+		st.invalid++;
+		return;
+	}
+
+	str = buf + addr_to_offset((unsigned long)meta->u.format);
+	str = printk_skip_level(str);
+	len = strlen(str);
+	hash = jhash(str, len, 0);
+	meta->u.format = 0;
+	meta->u.hash = hash;
+	meta->flags |= KMSG_FLAGS_HASH_VALID;
+
+	/*
+	 * We output the kmsg metadata info only if the hash value
+	 * has just been updated because a pointer to the format string
+	 * is overwritten with a hash value.
+	 */
+	if (outfp) {
+		/* Don't printout a newline at the tail. */
+		if (str[len - 1] == '\n')
+			len--;
+
+		/* Escape special codes same as reading /dev/kmsg */
+		for (i = 0, j = 0; i < len; i++) {
+			c = str[i];
+
+			if (c < ' ' || c >= 127 || c == '\\')
+				j += sprintf(fmtbuf + j, "\\x%02x", c);
+			else
+				fmtbuf[j++] = c;
+		}
+		fmtbuf[j] = 0;
+		fprintf(outfp, "%08x@%s:%d,\"%s\"\n", meta->u.hash,
+			buf + addr_to_offset((unsigned long)meta->filename),
+			meta->lineno, fmtbuf);
+	}
+
+	st.updated++;
+}
+
+/*
+ * Calculate hash values of printk message formats and replace it with
+ * the hash values.  This means we modify kmsg_meta table in .rodata
+ * section of the target file (vmlinux).
+ */
+static void walk_kmsg_meta(char *buf, unsigned long start, unsigned long end)
+{
+	char *p;
+
+	for (p = buf + start; p < buf + end; p += sizeof(struct kmsg_meta))
+		update_and_print_hash(buf, (struct kmsg_meta *)p);
+}
+
+static char *do_mmap_objfile(const char *filename, size_t *len)
+{
+	int fd;
+	struct stat sb;
+	char *buf;
+
+	fd = open(filename, O_RDWR | O_APPEND);
+	if (fd < 0) {
+		perror("msghash: open");
+		return NULL;
+	}
+
+	if (fstat(fd, &sb) < 0) {
+		perror("msghash: fstat");
+		return NULL;
+	}
+
+	buf = mmap(0, sb.st_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (buf == MAP_FAILED) {
+		perror("msghash: mmap");
+		return NULL;
+	}
+	*len = sb.st_size;
+
+	return buf;
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long start_meta, stop_meta, start, end;
+	char *outfile = NULL;
+	char *buf;
+	size_t len;
+	int total;
+	int c;
+	int ret;
+
+	while ((c = getopt(argc, argv, "o:")) >= 0) {
+		switch (c) {
+		case 'o':
+			outfile = optarg;
+			break;
+		default:
+			usage();
+			return 1;
+		}
+	}
+
+	if (argc - optind < 5) {
+		usage();
+		return 1;
+	}
+
+	start_meta = strtoul(argv[optind + 1], NULL, 0);
+	stop_meta = strtoul(argv[optind + 2], NULL, 0);
+	rodata_addr = strtoul(argv[optind + 3], NULL, 0);
+	rodata_off = strtoul(argv[optind + 4], NULL, 0);
+
+	/* Do some sanity checks. */
+	if (!start_meta || !stop_meta || start_meta > stop_meta) {
+		fprintf(stderr, "msghash: Invalid arguments\n");
+		fprintf(stderr, "  start_meta:  0x%08lx\n", start_meta);
+		fprintf(stderr, "  stop_meta:   0x%08lx\n", stop_meta);
+		fprintf(stderr, "  rodata_addr: 0x%08lx\n", rodata_addr);
+		fprintf(stderr, "  rodata_off:  0x%08lx\n", rodata_off);
+		return 1;
+	}
+
+	if (start_meta == stop_meta) {
+		/* There is nothing to do. */
+		return 0;
+	}
+
+	buf = do_mmap_objfile(argv[optind], &len);
+	if (!buf)
+		return 1;
+	outfp = fopen(outfile, "w");
+	if (outfp < 0) {
+		perror("msghash: fopen output file");
+		return 1;
+	}
+
+	start = addr_to_offset(start_meta);
+	end = addr_to_offset(stop_meta);
+
+	walk_kmsg_meta(buf, start, end);
+	ret = msync(buf, len, MS_SYNC);
+	if (ret < 0) {
+		perror("msghash: msync");
+		return 1;
+	}
+
+	total = st.updated + st.skipped + st.invalid;
+	printf("msghash: %d/%d entries updated, %d skipped, %d invalid\n",
+	       st.updated, total, st.skipped, st.invalid);
+
+	return 0;
+}
diff --git a/scripts/msghash/msghash.sh b/scripts/msghash/msghash.sh
new file mode 100755
index 0000000..a0b749f7
--- /dev/null
+++ b/scripts/msghash/msghash.sh
@@ -0,0 +1,45 @@
+#!/bin/sh
+#
+# msghash.sh -- calculate hash values of printk messages and update
+#               the kmsg_meta table in a given object file.
+#               A Message-and-hash catalog named <object file>.msglist
+#               is also created.
+#
+# Usage: msghash.sh <object file>
+#
+# Copyright 2013 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+
+MSGHASH=${srctree}/scripts/msghash/msghash
+target="$1"
+outfile="${target}.msglist"
+
+start_meta=`nm "$target" | grep ' __start___kmsg_meta' | awk '{print "0x"$1}'`
+stop_meta=`nm "$target" | grep ' __stop___kmsg_meta' | awk '{print "0x"$1}'`
+tmp=`objdump -h "$target" | grep ' .rodata '`
+eval `echo "$tmp" | awk '{print "rodata_addr=0x"$4"; rodata_offset=0x"$6}'`
+
+if [ -z "$start_meta" -o -z "$stop_meta" ]; then
+    echo "msghash: Couldn't find the kmsg_meta table."
+    exit 1
+fi
+if [ -z "$rodata_addr" -o -z "$rodata_offset" ]; then
+    echo "msghash: Failed to get .rodata section info."
+    exit 1
+fi
+
+$MSGHASH -o $outfile "$target" $start_meta $stop_meta $rodata_addr $rodata_offset
+
+exit $?


