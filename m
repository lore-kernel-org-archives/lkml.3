Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3JCQ6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:58:46 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:44966 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3JCQ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:58:45 -0400
Date: Thu, 3 Oct 2013 13:58:32 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] perf tool: more user-friendly errors from trace
Message-ID: <20131003165832.GA2436@ghostprotocols.net>
References: <1380788891-31908-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1380788891-31908-1-git-send-email-artagnon@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Thu, Oct 03, 2013 at 01:58:11PM +0530, Ramkumar Ramachandra escreveu:
> Currently, execution of 'perf trace' reports the following cryptic
> message to the user:
> 
> $ perf trace
> Couldn't read the raw_syscalls tracepoints information!
> 
> Now, it prints a detailed message:

What about the one attached instead? It 

[acme@zoo ~]$ mount | grep debugfs
[acme@zoo ~]$ 
[acme@zoo ~]$ perf trace usleep 1
Is debugfs mounted? Try 'sudo mount -t debugfs nodev /sys/kernel/debug'
[acme@zoo ~]$ sudo mkdir /d
[acme@zoo ~]$ sudo mount -t debugfs nodev /d
[acme@zoo ~]$ mount | grep debugfs
nodev on /d type debugfs (rw,relatime)
[acme@zoo ~]$ 
[acme@zoo ~]$ perf trace usleep 1
Couldn't access debugfs. Try 'sudo mount -o remount,mode=755 /d'
[acme@zoo ~]$ sudo mount -o remount,mode=755 /d
[acme@zoo ~]$ perf trace -e mmap usleep 1
     0.956 ( 0.004 ms): mmap(len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295) = 0x46dfc000
     0.995 ( 0.004 ms): mmap(len: 125871, prot: READ, flags: PRIVATE, fd: 3                   ) = 0x46ddd000
     1.045 ( 0.005 ms): mmap(addr: 0x3da4800000, len: 2135088, prot: EXEC|READ, flags: PRIVATE|DENYWRITE, fd: 3) = 0xa4800000
     1.068 ( 0.005 ms): mmap(addr: 0x3da4a08000, len: 8192, prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 32768) = 0xa4a08000
     1.109 ( 0.005 ms): mmap(addr: 0x3d93400000, len: 3896312, prot: EXEC|READ, flags: PRIVATE|DENYWRITE, fd: 3) = 0x93400000
     1.125 ( 0.006 ms): mmap(addr: 0x3d937ad000, len: 24576, prot: READ|WRITE, flags: PRIVATE|DENYWRITE|FIXED, fd: 3, off: 1757184) = 0x937ad000
     1.134 ( 0.004 ms): mmap(addr: 0x3d937b3000, len: 17400, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS|FIXED, fd: 4294967295) = 0x937b3000
     1.147 ( 0.003 ms): mmap(len: 4096, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295) = 0x46ddc000
     1.160 ( 0.003 ms): mmap(len: 8192, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: 4294967295) = 0x46dda000
[acme@zoo ~]$

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="tracepoint_error_message.patch"

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1bb8f15..8a35943 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1501,17 +1501,13 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	}
 
 	if (perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_enter", trace__sys_enter) ||
-	    perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit)) {
-		fprintf(trace->output, "Couldn't read the raw_syscalls tracepoints information!\n");
-		goto out_delete_evlist;
-	}
+	    perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit))
+		goto out_error_tp;
 
 	if (trace->sched &&
 	    perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
-				   trace__sched_stat_runtime)) {
-		fprintf(trace->output, "Couldn't read the sched_stat_runtime tracepoint information!\n");
-		goto out_delete_evlist;
-	}
+				   trace__sched_stat_runtime))
+		goto out_error_tp;
 
 	err = perf_evlist__create_maps(evlist, &trace->opts.target);
 	if (err < 0) {
@@ -1628,6 +1624,23 @@ out_delete_evlist:
 out:
 	trace->live = false;
 	return err;
+out_error_tp:
+	switch (errno) {
+	case ENOENT:
+		fputs("Is debugfs mounted? Try 'sudo mount -t debugfs nodev /sys/kernel/debug'\n", trace->output);
+		break;
+	case EACCES:
+		fprintf(trace->output,
+			"Couldn't access debugfs. Try 'sudo mount -o remount,mode=755 %s'\n",
+			debugfs_mountpoint);
+		break;
+	default:
+		fprintf(trace->output, "Can't trace: %s!\n", sys_errlist[errno]);
+		break;
+
+	}
+
+	goto out_unmap_evlist;
 }
 
 static int trace__replay(struct trace *trace)

--ReaqsoxgOBHFXBhH--
