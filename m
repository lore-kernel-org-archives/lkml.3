Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3BFOs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:48:27 -0500
Received: from ozlabs.org ([203.10.76.45]:53767 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab3BFOsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:48:17 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3/3 v3] selftests/efivarfs: Add create-read test
Message-Id: <1360162088.143529.797155879961.3.gpush@pecola>
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

Test that reads from a newly-created efivarfs file (with no data
written) will return EOF.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
 tools/testing/selftests/efivarfs/Makefile      |    2 
 tools/testing/selftests/efivarfs/create-read.c |   38 +++++++++++++++++
 tools/testing/selftests/efivarfs/efivarfs.sh   |    7 +++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
index 1a943ee..b4a7aca 100644
--- a/tools/testing/selftests/efivarfs/Makefile
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -1,7 +1,7 @@
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall
 
-test_objs = open-unlink
+test_objs = open-unlink create-read
 
 all: $(test_objs)
 
diff --git a/tools/testing/selftests/efivarfs/create-read.c b/tools/testing/selftests/efivarfs/create-read.c
new file mode 100644
index 0000000..7feef18
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/create-read.c
@@ -0,0 +1,38 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+
+int main(int argc, char **argv)
+{
+	const char *path;
+	char buf[4];
+	int fd, rc;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: %s <path>\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	path = argv[1];
+
+	/* create a test variable */
+	fd = open(path, O_RDWR | O_CREAT, 0600);
+	if (fd < 0) {
+		perror("open(O_WRONLY)");
+		return EXIT_FAILURE;
+	}
+
+	rc = read(fd, buf, sizeof(buf));
+	if (rc != 0) {
+		fprintf(stderr, "Reading a new var should return EOF\n");
+		return EXIT_FAILURE;
+	}
+
+	return EXIT_SUCCESS;
+}
diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
index 3af4b37..880cdd5 100755
--- a/tools/testing/selftests/efivarfs/efivarfs.sh
+++ b/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -70,6 +70,12 @@ test_create_empty()
 	fi
 }
 
+test_create_read()
+{
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+	./create-read $file
+}
+
 test_delete()
 {
 	local attrs='\x07\x00\x00\x00'
@@ -125,6 +131,7 @@ rc=0
 
 run_test test_create
 run_test test_create_empty
+run_test test_create_read
 run_test test_delete
 run_test test_zero_size_delete
 run_test test_open_unlink
