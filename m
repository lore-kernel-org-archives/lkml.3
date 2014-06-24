Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaFXCXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:23:51 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:36413 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaFXCXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:23:48 -0400
X-AuditID: 85900ec0-d312bb9000001514-84-53a8e131479b
Subject: [PATCH 1/2] trace-cmd: [BUGFIX] Initialize handle->options list in
 tracecmd_attach_cpu_data_fd()
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Tue, 24 Jun 2014 02:23:43 +0000
Message-ID: <20140624022343.14037.69077.stgit@yuno-kbuild.novalocal>
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

This patch initializes handle->options list in tracecmd_attach_cpu_data_fd().

When recorder sends trace data via network, server recording process is
killed by SIGSEGV from the patch 71484a0854f7. This is because add_options()
uses handle->options list from the patch, but tracecmd_attach_cpu_data_fd()
calling add_options() does not initialize the list in spite of allocation of
new handle. As the result, the server recording process will be killed because
handle->options is cleared to zero in tracecmd_attach_cpu_data_fd().

<How to test>
1. Execute network(listen) server
 # trace-cmd listen -p 12345

2. Execute network client
 # trace-cmd record -e sched* -N <server IP>:12345

3. Stop the record on client
 ^C

 Here, network server should output a line "CPUX data recorded at offset=XXXX",
 but current network server aborts silently.

 Moreover the client's per-cpu files are separated. (Normally those files
 are merged into one trace file.)

4. Confirm error on network server
 #  dmesg | tail -1
[18551.537113] trace-cmd[23073]: segfault at ffffffffffffffe8 ip 0000000000432fd1 sp 00007fffffa4caa0 error 5 in trace-cmd[400000+47000]

 After we would introduce this patch, the server will be fully able to output
 the client's tracing data and we will not get this error.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 trace-output.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/trace-output.c b/trace-output.c
index ed81466..b033baa 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -1202,6 +1202,7 @@ int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files)
 	handle->pevent = tracecmd_get_pevent(ihandle);
 	pevent_ref(pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
+	list_head_init(&handle->options);
 
 	if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) >= 0)
 		ret = 0;

