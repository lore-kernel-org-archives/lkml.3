Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaFXCYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:24:02 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:44318 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaFXCXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:23:50 -0400
X-AuditID: 85900ec0-d1328b9000001514-86-53a8e133be63
Subject: [PATCH 2/2] trace-cmd: [BUGFIX] Don't die if an instance does not
 have 'current_tracer' file
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Tue, 24 Jun 2014 02:23:45 +0000
Message-ID: <20140624022345.14037.44275.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140624022340.14037.63549.stgit@yuno-kbuild.novalocal>
References: <20140624022340.14037.63549.stgit@yuno-kbuild.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current trace-cmd requires 'current_tracer' file for an instance, and if
the file is nothing, trace-cmd dies. However, current_tracer file was
introduced from 607e2ea167e patch in Linux kernel 3.14-rc3, so current
trace-cmd cannot use multiple buffers for old kernels.

This patch avoids to die if current_tracer file is nothing in an instance
and the plugin name is "nop". This is because old kernels always trace
as nop mode in an instance.

<How to test>
1) # ./trace-cmd record -B foo -e sched

Before introducing this patch, following error message is output in an old
kernel:

 trace-cmd: Permission denied
   writing to '/sys/kernel/debug/tracing/instances/foo/current_tracer'

trace-cmd dies in disable_trace() calling set_plugin("nop").
After introducing this patch, trace-cmd works fine in both old kernels and
current kernel.

2) # ./trace-cmd record -B foo -e sched -p nop

It also works fine after introducing this patch in both old kernels and current
kernel.

3) # ./trace-cmd record -B foo -e sched -p function

For old kernels, it dies because an user should not set plugin tracer.
For current kernel, it works fine.

Note that this patch was tested for kernel 3.11.9-200 and 3.15.0-rc2+.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 trace-record.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/trace-record.c b/trace-record.c
index d3dd0c5..1912175 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -890,8 +890,18 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 
 	path = get_instance_file(instance, "current_tracer");
 	fp = fopen(path, "w");
-	if (!fp)
+	if (!fp) {
+		/*
+		 * Legacy kernels do not have current_tracer file, and they
+		 * always use nop. So, it doesn't need to try to change the
+		 * plugin for those if name is "nop".
+		 */
+		if (!strncmp(name, "nop", 3)) {
+			tracecmd_put_tracing_file(path);
+			return;
+		}
 		die("writing to '%s'", path);
+	}
 	tracecmd_put_tracing_file(path);
 
 	fwrite(name, 1, strlen(name), fp);

