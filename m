Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968025Ab3HIQDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:03:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:55450 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934068Ab3HIQDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:03:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,846,1367996400"; 
   d="scan'208";a="344097470"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        david.daney@cavium.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] kbuild: Use single pass kallsyms
Date: Fri,  9 Aug 2013 09:03:19 -0700
Message-Id: <1376064199-8296-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376064199-8296-1-git-send-email-andi@firstfloor.org>
References: <1376064199-8296-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

kallsyms currenly links the kernel upto three times
(in addition to another one for modpost checks)

Linking can be a quite slow operation, especially when
the kernel has a lot of debug information (lots of IO),
or Link Time Optimization is used.

Final linking is also a non parallelizable bottlneck, so it's
always good to do it less.

Use a different kallsyms method to avoid this:
- generate a initial kallsyms table from the top level
object files
- This table is usually a super set of the final table,
but without final addresses and some extra symbols
(e.g. discard and local symbols)
- Use this table to link the vmlinux
- Then generate a new kallsyms table with padding so
that all symbols stay at the same offsets. This works
because the new table is smaller or the same than the
original one.
We let the first kallsyms generate a padding file and
then use it on the next link.
- Then finally patch in the new table into the vmlinux

The size difference between the two tables is typically
small, so the additional padding is not a problem
(a few hundred bytes in my kernels)

Right now we still do two links. One to generate
the kernel, and another one to generate the vmlinux.o
for modpost.

On my slowish laptop this cuts down the final serialized phase
of a moderate size kernel build (just relinking vmlinux) by 1/3,
from ~30s to 20s

Tested on x86, tests on other architectures would be appreciated.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/Makefile        |  2 +-
 scripts/elf_file_offset |  7 ++++
 scripts/link-vmlinux.sh | 86 ++++++++++++++++++-------------------------------
 scripts/patchfile.c     | 81 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 120 insertions(+), 56 deletions(-)
 create mode 100755 scripts/elf_file_offset
 create mode 100644 scripts/patchfile.c

diff --git a/scripts/Makefile b/scripts/Makefile
index 01e7adb..9c84464 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -10,7 +10,7 @@
 
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
-hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
+hostprogs-$(CONFIG_KALLSYMS)     += kallsyms patchfile
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
diff --git a/scripts/elf_file_offset b/scripts/elf_file_offset
new file mode 100755
index 0000000..1e31863
--- /dev/null
+++ b/scripts/elf_file_offset
@@ -0,0 +1,7 @@
+#!/bin/bash
+# find the file offset of a symbol in a ELF file
+
+ADDR=$(nm $1 | awk "/$2/ { print \$1 }")
+objdump -s -F --start-address=0x$ADDR $1  |
+awk '/Starting at file offset/ { sub(/)/, ""); print $9 ; exit(0); }'
+
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 0149949..c02ee0a 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # link vmlinux
 #
@@ -82,10 +82,13 @@ kallsyms()
 		kallsymopt="${kallsymopt} --all-symbols"
 	fi
 
+	kallsymopt="$kallsymopt $3"
+
 	local aflags="${KBUILD_AFLAGS} ${KBUILD_AFLAGS_KERNEL}               \
 		      ${NOSTDINC_FLAGS} ${LINUXINCLUDE} ${KBUILD_CPPFLAGS}"
 
 	${NM} -n ${1} | \
+		awk 'NF == 3 { print}' |
 		scripts/kallsyms ${kallsymopt} | \
 		${CC} ${aflags} -c -o ${2} -x assembler-with-cpp -
 }
@@ -162,51 +165,36 @@ ${MAKE} -f "${srctree}/scripts/Makefile.build" obj=init
 
 kallsymso=""
 kallsyms_vmlinux=""
-if [ -n "${CONFIG_KALLSYMS}" ]; then
-
-	# kallsyms support
-	# Generate section listing all symbols and add it into vmlinux
-	# It's a three step process:
-	# 1)  Link .tmp_vmlinux1 so it has all symbols and sections,
-	#     but __kallsyms is empty.
-	#     Running kallsyms on that gives us .tmp_kallsyms1.o with
-	#     the right size
-	# 2)  Link .tmp_vmlinux2 so it now has a __kallsyms section of
-	#     the right size, but due to the added section, some
-	#     addresses have shifted.
-	#     From here, we generate a correct .tmp_kallsyms2.o
-	# 2a) We may use an extra pass as this has been necessary to
-	#     woraround some alignment related bugs.
-	#     KALLSYMS_EXTRA_PASS=1 is used to trigger this.
-	# 3)  The correct ${kallsymso} is linked into the final vmlinux.
-	#
-	# a)  Verify that the System.map from vmlinux matches the map from
-	#     ${kallsymso}.
-
-	kallsymso=.tmp_kallsyms2.o
-	kallsyms_vmlinux=.tmp_vmlinux2
-
-	# step 1
-	vmlinux_link "" .tmp_vmlinux1
-	kallsyms .tmp_vmlinux1 .tmp_kallsyms1.o
-
-	# step 2
-	vmlinux_link .tmp_kallsyms1.o .tmp_vmlinux2
-	kallsyms .tmp_vmlinux2 .tmp_kallsyms2.o
-
-	# step 2a
-	if [ -n "${KALLSYMS_EXTRA_PASS}" ]; then
-		kallsymso=.tmp_kallsyms3.o
-		kallsyms_vmlinux=.tmp_vmlinux3
-
-		vmlinux_link .tmp_kallsyms2.o .tmp_vmlinux3
-
-		kallsyms .tmp_vmlinux3 .tmp_kallsyms3.o
-	fi
+
+if [ -n "${CONFIG_KALLSYMS}" ] ; then
+	# Generate kallsyms from the top level object files
+	# this is slightly off, and has wrong addresses,
+	# but gives us the conservative max length of the kallsyms
+	# table to link in something with the size.
+	info KALLSYMS1 .tmp_kallsyms1.o
+	kallsyms "${KBUILD_VMLINUX_INIT} ${KBUILD_VMLINUX_MAIN}" \
+		 .tmp_kallsyms1.o \
+		 "--pad-file=.kallsyms_pad"
+	kallsymsso=.tmp_kallsyms1.o
 fi
 
 info LD vmlinux
-vmlinux_link "${kallsymso}" vmlinux
+vmlinux_link "${kallsymsso}" vmlinux
+if [ -n "${CONFIG_KALLSYMS}" ] ; then
+	# Now regenerate the kallsyms table and patch it into the
+	# previously linked file. We tell kallsyms to pad it
+	# to the previous length, so that no symbol changes.
+	info KALLSYMS2 .tmp_kallsyms2.o
+	kallsyms vmlinux .tmp_kallsyms2.o $(<.kallsyms_pad)
+
+	info OBJCOPY .tmp_kallsyms2.bin
+	${OBJCOPY} -O binary .tmp_kallsyms2.o .tmp_kallsyms2.bin
+
+	info PATCHFILE vmlinux
+	scripts/patchfile vmlinux \
+		$(./source/scripts/elf_file_offset vmlinux kallsyms_offset) \
+		.tmp_kallsyms2.bin
+fi
 
 if [ -n "${CONFIG_BUILDTIME_EXTABLE_SORT}" ]; then
 	info SORTEX vmlinux
@@ -216,17 +204,5 @@ fi
 info SYSMAP System.map
 mksysmap vmlinux System.map
 
-# step a (see comment above)
-if [ -n "${CONFIG_KALLSYMS}" ]; then
-	mksysmap ${kallsyms_vmlinux} .tmp_System.map
-
-	if ! cmp -s System.map .tmp_System.map; then
-		echo >&2 Inconsistent kallsyms data
-		echo >&2 Try "make KALLSYMS_EXTRA_PASS=1" as a workaround
-		cleanup
-		exit 1
-	fi
-fi
-
 # We made a new kernel - delete old version file
 rm -f .old_version
diff --git a/scripts/patchfile.c b/scripts/patchfile.c
new file mode 100644
index 0000000..1a3414d
--- /dev/null
+++ b/scripts/patchfile.c
@@ -0,0 +1,81 @@
+/* Patch file at specific offset
+ * patchfile file-to-patch offset patch-file [len-of-patch]
+ */
+#define _GNU_SOURCE 1
+#include <sys/mman.h>
+#include <unistd.h>
+#include <sys/fcntl.h>
+#include <sys/stat.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+
+#define ROUNDUP(x, y) (((x) + (y) - 1) & ~((y) - 1))
+
+static void *mmapfile(char *file, size_t *size)
+{
+	int pagesize = sysconf(_SC_PAGESIZE);
+	int fd = open(file, O_RDONLY);
+	void *res = NULL;
+	struct stat st;
+
+	*size = 0;
+	if (fd < 0)
+		return NULL;
+	if (fstat(fd, &st) >= 0) {
+		*size = st.st_size;
+		res = mmap(NULL, ROUNDUP(st.st_size, pagesize),
+				PROT_READ, MAP_SHARED,
+				fd, 0);
+		if (res == (void *)-1)
+			res = NULL;
+	}
+	close(fd);
+	return res;
+}
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: patchfile file-to-patch offset file-to-patch-in\n");
+	exit(1);
+}
+
+static size_t get_num(char *s)
+{
+	char *endp;
+	size_t v = strtoul(s, &endp, 0);
+	if (s == endp)
+		usage();
+	return v;
+}
+
+int main(int ac, char **av)
+{
+	char *patch;
+	size_t patchsize;
+	int infd;
+	size_t offset;
+
+	if (ac != 5 && ac != 4)
+		usage();
+	offset = get_num(av[2]);
+	patch = mmapfile(av[3], &patchsize);
+	if (av[4]) {
+		size_t newsize = get_num(av[4]);
+		if (newsize > patchsize)
+			fprintf(stderr, "kallsyms: warning, size larger than patch\n");
+		if (newsize < patchsize)
+			patchsize = newsize;
+	}
+	infd = open(av[1], O_RDWR);
+	if (infd < 0) {
+		fprintf(stderr, "Cannot open %s\n", av[1]);
+		exit(1);
+	}
+	if (pwrite(infd, patch, patchsize, offset) != patchsize) {
+		fprintf(stderr, "Cannot write patch to %s\n", av[1]);
+		exit(1);
+	}
+	close(infd);
+	return 0;
+}
-- 
1.8.3.1

