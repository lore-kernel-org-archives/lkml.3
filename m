Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaKXSUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:20:11 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10591 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbaKXSUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:20:08 -0500
Message-ID: <547376D3.7070709@sonymobile.com>
Date: Mon, 24 Nov 2014 10:20:03 -0800
From: Tim Bird <tim.bird@sonymobile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, <linux-api@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH v3] selftest: size: Add size test for Linux kernel
References: <546D084D.20002@sonymobile.com> <546D321F.2080405@sonymobile.com>
In-Reply-To: <546D321F.2080405@sonymobile.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This test shows the amount of memory used by the system.
Note that this is dependent on the user-space that is loaded
when this program runs.  Optimally, this program would be
run as the init program itself.

The program is optimized for size itself, to avoid conflating
its own execution with that of the system software.
The code is compiled statically, with no stdlibs. On my x86_64 system,
this results in a statically linked binary of less than 5K.

Changes from v2:
  - add return values to print routines
  - add .gitignore file

Changes from v1:
  - use more correct Copyright string in get_size.c

Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
---
 tools/testing/selftests/Makefile        |   1 +
 tools/testing/selftests/size/.gitignore |   1 +
 tools/testing/selftests/size/Makefile   |  21 +++++++
 tools/testing/selftests/size/get_size.c | 105 ++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+)
 create mode 100644 tools/testing/selftests/size/.gitignore
 create mode 100644 tools/testing/selftests/size/Makefile
 create mode 100644 tools/testing/selftests/size/get_size.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 45f145c..fa91aef 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -15,6 +15,7 @@ TARGETS += user
 TARGETS += sysctl
 TARGETS += firmware
 TARGETS += ftrace
+TARGETS += size
 
 TARGETS_HOTPLUG = cpu-hotplug
 TARGETS_HOTPLUG += memory-hotplug
diff --git a/tools/testing/selftests/size/.gitignore b/tools/testing/selftests/size/.gitignore
new file mode 100644
index 0000000..189b781
--- /dev/null
+++ b/tools/testing/selftests/size/.gitignore
@@ -0,0 +1 @@
+get_size
diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
new file mode 100644
index 0000000..51e5fbd
--- /dev/null
+++ b/tools/testing/selftests/size/Makefile
@@ -0,0 +1,21 @@
+#ifndef CC
+	CC = $(CROSS_COMPILE)gcc
+#endif
+
+#ifndef STRIP
+	STRIP = $(CROSS_COMPILE)strip
+#endif
+
+all: get_size
+
+get_size: get_size.c
+	$(CC) --static -ffreestanding -nostartfiles \
+		-Wl,--entry=main get_size.c -o get_size \
+		`cc -print-libgcc-file-name`
+	$(STRIP) -s get_size
+
+run_tests: all
+	./get_size
+
+clean:
+	$(RM) get_size
diff --git a/tools/testing/selftests/size/get_size.c b/tools/testing/selftests/size/get_size.c
new file mode 100644
index 0000000..9c8d3cd
--- /dev/null
+++ b/tools/testing/selftests/size/get_size.c
@@ -0,0 +1,105 @@
+/*
+ * Copyright 2014 Sony
+ *
+ * Licensed under the terms of the GNU GPL License version 2
+ *
+ * Selftest for runtime system size
+ *
+ * Prints the amount of RAM that the currently running system is using.
+ *
+ * This program tries to be as small as possible itself, to
+ * avoid perturbing the system memory utilization with its
+ * own execution.  It also attempts to have as few dependencies
+ * on kernel features as possible.
+ *
+ * It should be statically linked, with startup libs avoided.
+ * It uses no library calls, and only the following 3 syscalls:
+ *   sysinfo(), write(), and _exit()
+ *
+ * For output, it avoids printf (which in some C libraries
+ * has large external dependencies) by implementing its own
+ * strlen(), number output and print() routines.
+ */
+
+#include <sys/sysinfo.h>
+#include <unistd.h>
+
+#define STDOUT_FILENO 1
+
+int my_strlen(const char *s)
+{
+	int len = 0;
+
+	while (*s++)
+		len++;
+	return len;
+}
+
+/*
+ * num_to_str - put digits from num into *s, left to right
+ *   do this by dividing the number by powers of 10
+ *   the tricky part is to omit leading zeros
+ *   don't print zeros until we've started printing any numbers at all
+ */
+void num_to_str(unsigned long num, char *s)
+{
+	unsigned long long temp, div;
+	int started;
+
+	temp = num;
+	div = 1000000000000000000LL;
+	started = 0;
+	while (div) {
+		if (temp/div || started) {
+			*s++ = (unsigned char)(temp/div + '0');
+			started = 1;
+		}
+		temp -= (temp/div)*div;
+		div /= 10;
+	}
+	*s = 0;
+}
+
+int print_num(unsigned long num)
+{
+	char num_buf[30];
+
+	num_to_str(num, num_buf);
+	return write(STDOUT_FILENO, num_buf, my_strlen(num_buf));
+}
+
+int print(char *s)
+{
+	return write(STDOUT_FILENO, s, my_strlen(s));
+}
+
+void main(int argc, char **argv)
+{
+	int ccode;
+	unsigned long used;
+	struct sysinfo info;
+	unsigned long long temp;
+
+	print("Testing system size.\n");
+	print("1..1\n");
+
+	ccode = sysinfo(&info);
+	if (ccode < 0) {
+		print("not ok 1 get size runtime size\n");
+		print("# could not get sysinfo\n");
+		_exit(ccode);
+	}
+
+	/* ignore cache complexities for now */
+	temp = info.totalram - info.freeram - info.bufferram;
+	temp = temp * info.mem_unit;
+	temp = temp / 1024;
+
+	used = temp;
+
+	print("ok 1 get runtime size # size = ");
+	print_num(used);
+	print(" K\n");
+
+	_exit(0);
+}
-- 
1.8.2.2
