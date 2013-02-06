Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab3BFOsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:48:23 -0500
Received: from ozlabs.org ([203.10.76.45]:51476 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152Ab3BFOsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:48:17 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1/3 v3] selftests: Add tests for efivarfs
Message-Id: <1360162088.143076.913706486688.1.gpush@pecola>
In-Reply-To: <1360162088.142733.191120808822.0.gpush@pecola>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Lingzhu Xiang <lxiang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Wed, 06 Feb 2013 22:48:08 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a few initial efivarfs tests to the
tools/testing/selftests directory.

The open-unlink test is based on code from
Lingzhu Xiang <lxiang@redhat.com>.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
 tools/testing/selftests/Makefile               |    2 
 tools/testing/selftests/efivarfs/Makefile      |   12 +
 tools/testing/selftests/efivarfs/efivarfs.sh   |  119 +++++++++++++++++
 tools/testing/selftests/efivarfs/open-unlink.c |   63 +++++++++
 4 files changed, 195 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 85baf11..dee19dd 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
+TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
 
 all:
 	for TARGET in $(TARGETS); do \
diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
new file mode 100644
index 0000000..1a943ee
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -0,0 +1,12 @@
+CC = $(CROSS_COMPILE)gcc
+CFLAGS = -Wall
+
+test_objs = open-unlink
+
+all: $(test_objs)
+
+run_tests: all
+	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
+
+clean:
+	rm -f $(test_objs)
diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
new file mode 100755
index 0000000..e8c0d27
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -0,0 +1,119 @@
+#!/bin/bash
+
+efivarfs_mount=/sys/firmware/efi/efivars
+test_guid=210be57c-9849-4fc7-a635-e6382d1aec27
+
+check_prereqs()
+{
+	local msg="skip all tests:"
+
+	if [ $UID != 0 ]; then
+		echo $msg must be run as root >&2
+		exit 0
+	fi
+
+	if ! grep -q "^\S\+ $efivarfs_mount efivarfs" /proc/mounts; then
+		echo $msg efivarfs is not mounted on $efivarfs_mount >&2
+		exit 0
+	fi
+}
+
+run_test()
+{
+	local test="$1"
+
+	echo "--------------------"
+	echo "running $test"
+	echo "--------------------"
+
+	if [ "$(type -t $test)" = 'function' ]; then
+		( $test )
+	else
+		( ./$test )
+	fi
+
+	if [ $? -ne 0 ]; then
+		echo "  [FAIL]"
+		rc=1
+	else
+		echo "  [PASS]"
+	fi
+}
+
+test_create()
+{
+	local attrs='\x07\x00\x00\x00'
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+
+	printf "$attrs\x00" > $file
+
+	if [ ! -e $file ]; then
+		echo "$file couldn't be created" >&2
+		exit 1
+	fi
+
+	if [ $(stat -c %s $file) -ne 5 ]; then
+		echo "$file has invalid size" >&2
+		exit 1
+	fi
+}
+
+test_delete()
+{
+	local attrs='\x07\x00\x00\x00'
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+
+	printf "$attrs\x00" > $file
+
+	if [ ! -e $file ]; then
+		echo "$file couldn't be created" >&2
+		exit 1
+	fi
+
+	rm $file
+
+	if [ -e $file ]; then
+		echo "$file couldn't be deleted" >&2
+		exit 1
+	fi
+
+}
+
+# test that we can remove a variable by issuing a write with only
+# attributes specified
+test_zero_size_delete()
+{
+	local attrs='\x07\x00\x00\x00'
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+
+	printf "$attrs\x00" > $file
+
+	if [ ! -e $file ]; then
+		echo "$file does not exist" >&2
+		exit 1
+	fi
+
+	printf "$attrs" > $file
+
+	if [ -e $file ]; then
+		echo "$file should have been deleted" >&2
+		exit 1
+	fi
+}
+
+test_open_unlink()
+{
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+	./open-unlink $file
+}
+
+check_prereqs
+
+rc=0
+
+run_test test_create
+run_test test_delete
+run_test test_zero_size_delete
+run_test test_open_unlink
+
+exit $rc
diff --git a/tools/testing/selftests/efivarfs/open-unlink.c b/tools/testing/selftests/efivarfs/open-unlink.c
new file mode 100644
index 0000000..8c07644
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/open-unlink.c
@@ -0,0 +1,63 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+int main(int argc, char **argv)
+{
+	const char *path;
+	char buf[5];
+	int fd, rc;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: %s <path>\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	path = argv[1];
+
+	/* attributes: EFI_VARIABLE_NON_VOLATILE |
+	 *		EFI_VARIABLE_BOOTSERVICE_ACCESS |
+	 *		EFI_VARIABLE_RUNTIME_ACCESS
+	 */
+	*(uint32_t *)buf = 0x7;
+	buf[4] = 0;
+
+	/* create a test variable */
+	fd = open(path, O_WRONLY | O_CREAT);
+	if (fd < 0) {
+		perror("open(O_WRONLY)");
+		return EXIT_FAILURE;
+	}
+
+	rc = write(fd, buf, sizeof(buf));
+	if (rc != sizeof(buf)) {
+		perror("write");
+		return EXIT_FAILURE;
+	}
+
+	close(fd);
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		return EXIT_FAILURE;
+	}
+
+	if (unlink(path) < 0) {
+		perror("unlink");
+		return EXIT_FAILURE;
+	}
+
+	rc = read(fd, buf, sizeof(buf));
+	if (rc > 0) {
+		fprintf(stderr, "reading from an unlinked variable "
+				"shouldn't be possible\n");
+		return EXIT_FAILURE;
+	}
+
+	return EXIT_SUCCESS;
+}
