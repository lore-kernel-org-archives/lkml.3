Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158Ab3DEBxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:53:42 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:43312 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161131Ab3DEBxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:53:40 -0400
X-AuditID: 85900ec0-d42c9b900000151e-74-515e2e1cf976
Subject: [PATCH 1/2] trace-cmd: Define general functions for
 outputting/inputting saved_cmdlines
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Fri, 05 Apr 2013 10:54:41 +0900
Message-ID: <20130405015441.19807.52303.stgit@yunodevel>
In-Reply-To: <20130405015439.19807.43932.stgit@yunodevel>
References: <20130405015439.19807.43932.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, trace-cmd outputs data of saved_cmdlines to a trace.dat file
in create_file_fd() and inputs the data from the file in tracecmd_init_data().
On the other hand, trace-cmd will also output and input data of trace_clock in
those functions in the patch "trace-cmd: Support trace_clock extraction".
The source code of the output/input of saved_cmdlines data can be reused when
extract trace_clock, so we define general functions for outputting/inputting a
file on debugfs.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-input.c  |   45 +++++++++++++++++++++++++++++------------
 trace-output.c |   62 ++++++++++++++++++++++++++++++++------------------------
 2 files changed, 67 insertions(+), 40 deletions(-)

diff --git a/trace-input.c b/trace-input.c
index 6f60409..ba3a21e 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -1758,6 +1758,37 @@ static int handle_options(struct tracecmd_input *handle)
 	return 0;
 }
 
+static int read_data_and_size(struct tracecmd_input *handle,
+				     char **data, unsigned long long *size)
+{
+	*size = read8(handle);
+	if (*size < 0)
+		return -1;
+	*data = malloc(*size + 1);
+	if (!*data)
+		return -1;
+	if (do_read_check(handle, *data, *size)) {
+		free(*data);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int read_and_parse_cmdlines(struct tracecmd_input *handle,
+							struct pevent *pevent)
+{
+	unsigned long long size;
+	char *cmdlines;
+
+	if (read_data_and_size(handle, &cmdlines, &size) < 0)
+		return -1;
+	cmdlines[size] = 0;
+	parse_cmdlines(pevent, cmdlines, size);
+	free(cmdlines);
+	return 0;
+}
+
 /**
  * tracecmd_init_data - prepare reading the data from trace.dat
  * @handle: input handle for the trace.dat file
@@ -1771,23 +1802,11 @@ int tracecmd_init_data(struct tracecmd_input *handle)
 	enum kbuffer_long_size long_size;
 	enum kbuffer_endian endian;
 	unsigned long long size;
-	char *cmdlines;
 	char buf[10];
 	int cpu;
 
-	size = read8(handle);
-	if (size < 0)
-		return -1;
-	cmdlines = malloc(size + 1);
-	if (!cmdlines)
+	if (read_and_parse_cmdlines(handle, pevent) < 0)
 		return -1;
-	if (do_read_check(handle, cmdlines, size)) {
-		free(cmdlines);
-		return -1;
-	}
-	cmdlines[size] = 0;
-	parse_cmdlines(pevent, cmdlines, size);
-	free(cmdlines);
 
 	handle->cpus = read4(handle);
 	if (handle->cpus < 0)
diff --git a/trace-output.c b/trace-output.c
index c4d668d..e0d4ff4 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -686,6 +686,39 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	return -1;
 }
 
+static int save_tracing_file_data(struct tracecmd_output *handle,
+						const char *filename)
+{
+	unsigned long long endian8;
+	char *file = NULL;
+	struct stat st;
+	off64_t check_size;
+	off64_t size;
+	int ret;
+
+	file = get_tracing_file(handle, filename);
+	ret = stat(file, &st);
+	if (ret >= 0) {
+		size = get_size(file);
+		endian8 = convert_endian_8(handle, size);
+		if (do_write_check(handle, &endian8, 8))
+			return -1;
+		check_size = copy_file(handle, file);
+		if (size != check_size) {
+			errno = EINVAL;
+			warning("error in size of file '%s'", file);
+			return -1;
+		}
+	} else {
+		size = 0;
+		endian8 = convert_endian_8(handle, size);
+		if (do_write_check(handle, &endian8, 8))
+			return -1;
+	}
+	put_tracing_file(file);
+	return 0;
+}
+
 static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
@@ -693,15 +726,9 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       struct tracecmd_event_list *list)
 {
 	struct tracecmd_output *handle;
-	unsigned long long endian8;
 	struct pevent *pevent;
 	char buf[BUFSIZ];
-	char *file = NULL;
-	struct stat st;
-	off64_t check_size;
-	off64_t size;
 	int endian4;
-	int ret;
 
 	handle = malloc(sizeof(*handle));
 	if (!handle)
@@ -774,27 +801,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	/*
 	 * Save the command lines;
 	 */
-	file = get_tracing_file(handle, "saved_cmdlines");
-	ret = stat(file, &st);
-	if (ret >= 0) {
-		size = get_size(file);
-		endian8 = convert_endian_8(handle, size);
-		if (do_write_check(handle, &endian8, 8))
-			goto out_free;
-		check_size = copy_file(handle, file);
-		if (size != check_size) {
-			errno = EINVAL;
-			warning("error in size of file '%s'", file);
-			goto out_free;
-		}
-	} else {
-		size = 0;
-		endian8 = convert_endian_8(handle, size);
-		if (do_write_check(handle, &endian8, 8))
-			goto out_free;
-	}
-	put_tracing_file(file);
-	file = NULL;
+	if (save_tracing_file_data(handle, "saved_cmdlines") < 0)
+		goto out_free;
 
 	return handle;
 

