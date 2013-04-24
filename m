Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3DXXJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:09:45 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38511 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3DXXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:09:40 -0400
X-AuditID: 85900ec0-d42c9b900000151e-4e-517866324102
Subject: [PATCH V3 2/3] trace-cmd: Add recording to trace_clock
To: Steven Rostedt <rostedt@goodmis.org>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Thu, 25 Apr 2013 08:13:02 +0900
Message-ID: <20130424231302.14877.24340.stgit@yunodevel>
In-Reply-To: <20130424231257.14877.77172.stgit@yunodevel>
References: <20130424231257.14877.77172.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch, trace-cmd reads trace_clock on debugfs in the record mode and
outputs the data to trace.dat file. This patch defines a flag
TRACECMD_OPTION_TRACECLOCK for using the option feature. For supporting
multiple buffers, this patch doesn't store data of trace_clock when trace-cmd
adds the flag to trace.dat. This is because the flag is globally used, but
trace_clock can be changed for each buffer. So, this patch stores data of
trace_clock after adding data information of each CPU. The binary format
of trace.data is changed as follows:

<Current binary format>
...
"flyrecord"                     -----+
[total cpu numer]                    |
[file offset and size of cpu0]       |
...                                  +--- info. of normal buffer
[file offset and size of cpuX]       |
--skip--                             |
[data of CPU0]                       |
...                             -----+
--skip--
"flyrecord"                     -----+
[total cpu numer]                    |
[file offset and size of cpu0]       |
...                                  +--- info. of sub-buffer
[file offset and size of cpuX]       |
--skip--                             |
[data of CPU0]                       |
...                             -----+

<Changed binary format>
...
"flyrecord"                     -----+
[total cpu numer]                    |
[file offset and size of cpu0]       |
...                                  +--- info. of normal buffer
[file offset and size of cpuX]       |
[size of trace_clock]  <== add       |
[trace_clock contents] <== add       |
--skip--                             |
[data of CPU0]                       |
...                             -----+
--skip--
"flyrecord"                     -----+
[total cpu numer]                    |
[file offset and size of cpu0]       |
...                                  +--- info. of sub-buffer
[file offset and size of cpuX]       |
[size of trace_clock]  <== add       |
[trace_clock contents] <== add       |
--skip--                             |
[data of CPU0]                       |
...                             -----+

Changes in v2:
 - Define TRACECMD_OPTION_TRACECLOCK for extracting trace_clock

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
---
 trace-cmd.h    |    1 +
 trace-output.c |    3 +++
 trace-record.c |    3 +++
 3 files changed, 7 insertions(+)

diff --git a/trace-cmd.h b/trace-cmd.h
index 116c2f6..0745dad 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -81,6 +81,7 @@ enum {
 	TRACECMD_OPTION_DATE,
 	TRACECMD_OPTION_CPUSTAT,
 	TRACECMD_OPTION_BUFFER,
+	TRACECMD_OPTION_TRACECLOCK,
 };
 
 enum {
diff --git a/trace-output.c b/trace-output.c
index cc71adf..bdb478d 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -1067,6 +1067,9 @@ static int __tracecmd_append_cpu_data(struct tracecmd_output *handle,
 			goto out_free;
 	}
 
+	if (save_tracing_file_data(handle, "trace_clock") < 0)
+		goto out_free;
+
 	for (i = 0; i < cpus; i++) {
 		fprintf(stderr, "CPU%d data recorded at offset=0x%llx\n",
 			i, (unsigned long long) offsets[i]);
diff --git a/trace-record.c b/trace-record.c
index 0025cf3..407576f 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -1804,6 +1804,9 @@ static void record_data(char *date2ts, struct trace_seq *s)
 			tracecmd_add_option(handle, TRACECMD_OPTION_CPUSTAT,
 					    s[i].len+1, s[i].buffer);
 
+		tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK,
+				    0, NULL);
+
 		if (buffers) {
 			buffer_options = malloc_or_die(sizeof(*buffer_options) * buffers);
 			i = 0;

