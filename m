Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaC1N5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:57:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58756 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaC1N5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:57:12 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH 21/28] ktap: add userspace/kp_reader.c
Date: Fri, 28 Mar 2014 09:47:42 -0400
Message-Id: <1396014469-5937-22-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is ktap ring buffer consumer, a thread poll content from
'/sys/kernel/debug/ktap/trace_pipe_%pid' debugfs file.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/userspace/kp_reader.c | 106 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)
 create mode 100644 tools/ktap/userspace/kp_reader.c

diff --git a/tools/ktap/userspace/kp_reader.c b/tools/ktap/userspace/kp_reader.c
new file mode 100644
index 0000000..103940e
--- /dev/null
+++ b/tools/ktap/userspace/kp_reader.c
@@ -0,0 +1,106 @@
+/*
+ * reader.c - ring buffer reader in userspace
+ *
+ * This file is part of ktap by Jovi Zhangwei.
+ *
+ * Copyright (C) 2012-2014 Jovi Zhangwei <jovi.zhangwei@gmail.com>.
+ *
+ * ktap is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * ktap is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/poll.h>
+#include <sys/signal.h>
+#include <fcntl.h>
+#include <pthread.h>
+
+#define MAX_BUFLEN  131072
+#define PATH_MAX 128
+
+#define handle_error(str) do { perror(str); exit(-1); } while(0)
+
+void sigfunc(int signo)
+{
+	/* should not not reach here */
+}
+
+static void block_sigint()
+{
+	sigset_t mask;
+
+	sigemptyset(&mask);
+	sigaddset(&mask, SIGINT);
+
+	pthread_sigmask(SIG_BLOCK, &mask, NULL);
+}
+
+static void *reader_thread(void *data)
+{
+	char buf[MAX_BUFLEN];
+	char filename[PATH_MAX];
+	const char *output = data; 
+	int failed = 0, fd, out_fd, len;
+
+	block_sigint();
+
+	if (output) {
+		out_fd = open(output, O_CREAT | O_WRONLY | O_TRUNC,
+					S_IRUSR|S_IWUSR);
+		if (out_fd < 0) {
+			fprintf(stderr, "Cannot open output file %s\n", output);
+			return NULL;
+		}
+	} else
+		out_fd = 1;
+
+	sprintf(filename, "/sys/kernel/debug/ktap/trace_pipe_%d", getpid());
+
+ open_again:
+	fd = open(filename, O_RDONLY);
+	if (fd < 0) {
+		usleep(10000);
+
+		if (failed++ == 10) {
+			fprintf(stderr, "Cannot open file %s\n", filename);
+			return NULL;
+		}
+		goto open_again;
+	}
+
+	while ((len = read(fd, buf, sizeof(buf))) > 0)
+		write(out_fd, buf, len);
+
+	close(fd);
+	close(out_fd);
+
+	return NULL;
+}
+
+int kp_create_reader(const char *output)
+{
+	pthread_t reader;
+
+	signal(SIGINT, sigfunc);
+
+	if (pthread_create(&reader, NULL, reader_thread, (void *)output) < 0)
+		handle_error("pthread_create reader_thread failed\n");
+
+	return 0;
+}
+
-- 
1.8.1.4

