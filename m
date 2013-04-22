Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3DVJmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:42:06 -0400
Received: from fallback.hitachi.co.jp ([133.145.228.50]:41338 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3DVJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:42:04 -0400
X-AuditID: 85900ec0-d42c9b900000151e-79-51750564a11b
Subject: [PATCH V2 1/3] trace-cmd: Define general functions for
 outputting/inputting saved_cmdlines
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Mon, 22 Apr 2013 18:43:09 +0900
Message-ID: <20130422094309.26615.46676.stgit@yunodevel>
In-Reply-To: <20130422094306.26615.70754.stgit@yunodevel>
References: <20130422094306.26615.70754.stgit@yunodevel>
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
those functions in the patch "trace-cmd: Add recording to trace_clock" and
"Add support for extracting trace_clock in report".

The source code of the output/input of saved_cmdlines data can be reused when
extract trace_clock, so we define general functions for outputting/inputting a
file on debugfs.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-input.c  |   46 +++++++++++++++++++++++++++++-------------
 trace-output.c |   62 ++++++++++++++++++++++++++++++++------------------------
 2 files changed, 67 insertions(+), 41 deletions(-)

diff --git a/trace-input.c b/trace-input.c
index 56a8e8d..232015a 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -1870,6 +1870,37 @@ static int read_cpu_data(struct tracecmd_input *handle)
 
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
@@ -1880,23 +1911,10 @@ static int read_cpu_data(struct tracecmd_input *handle)
 int tracecmd_init_data(struct tracecmd_input *handle)
 {
 	struct pevent *pevent = handle->pevent;
-	unsigned long long size;
-	char *cmdlines;
 	int ret;
 
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
index 460b773..8697976 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -687,6 +687,39 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
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
@@ -694,15 +727,9 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
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
@@ -775,27 +802,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
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
 

