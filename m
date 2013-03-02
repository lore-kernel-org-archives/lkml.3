Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3CBAcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 19:32:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14115 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3CBAcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 19:32:20 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=j1elf0Sz7wMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=R21XNUEkRdcA:10 a=ipMJ9Fi02BOBQUBO2eEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362184337.1231.49.camel@gandalf.local.home>
Subject: [URGENT] trace-cmd: Fix for all stable versions for up coming fix
 in Linux v3.10
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-trace-users <linux-trace-users@vger.kernel.org>
Cc: John Kacur <jkacur@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        ubuntu-motu@lists.ubuntu.com,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@canonical.com>,
        Neependra Kumar Khare <nkhare@redhat.com>,
        Mel Gorman <mgorman@suse.de>, David Sharp <dhsharp@google.com>
Date: Fri, 01 Mar 2013 19:32:17 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently fixed a long standing bug in the splice code for ftrace. This
was something that I wanted fixed so that trace-cmd would work better.
The fix is to finally have the splice system call block until data is
available, instead of having trace-cmd poll reading the trace_pipe_raw
data file.

This fix is queued to go in to mainline for v3.10. Unfortunately, even
though I've wanted this for trace-cmd since day one, my trace-cmd
implementation to use this had a bug in it, that the kernel fix now
triggers. Basically, when tracing is finished (when the command that is
being recorded is done), trace-cmd stops tracing, signals the recording
threads to finish and then waits for the recording threads to exit.

Well, there's a race where the recording threads may make one last read
of the splice system call. The problem is that this read is blocking.
Now that tracing has been disabled by the main thread, this read will
block indefinitely as there is no more data to read. The main thread
waiting for the recorder threads to finish will continue to wait.
Hitting Ctrl-C kicks it and the threads all finish, but that's not what
should happen. The threads should finish when tracing is done, and not
require input from the user.

The fix is quite simple, and has been included in the latest trace-cmd
repo. I back ported the fix to the following versions, and tested all of
them running on a kernel with the splice fix. Without this update, all
the versions can end up blocked on splice and require user input to
continue. With the fix, they all work fine.

Here's the new stable trace-cmd versions that contain the fix:

  v1.0.7
  v1.1.2
  v1.2.3
  v2.0.3
  v2.1.1

and the main repo has it as well.

-- Steve

>From 4b04db879a99d600988bc302e7ac88e8c012f98f Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Thu, 28 Feb 2013 11:29:43 -0500
Subject: [PATCH] trace-cmd: Do not block on reads when record is finished

Starting with Linux v3.10, trace_pipe_raw will block on reads.
We need to make sure that when the trace is done, the reads do
not block, and flushing finishes reading the ring buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-recorder.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/trace-recorder.c b/trace-recorder.c
index 1b9723d..4e15b86 100644
--- a/trace-recorder.c
+++ b/trace-recorder.c
@@ -249,9 +249,15 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 
 void tracecmd_stop_recording(struct tracecmd_recorder *recorder)
 {
+	long flags;
+
 	if (!recorder)
 		return;
 
+	/* Do not block on reads for flushing */
+	flags = fcntl(recorder->trace_fd, F_GETFL);
+	fcntl(recorder->trace_fd, F_SETFL, flags | O_NONBLOCK);
+
 	recorder->stop = 1;
 }
 
-- 
1.7.10.4



