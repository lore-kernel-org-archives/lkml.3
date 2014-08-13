Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaHMPmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:42:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33230 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaHMPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:42:49 -0400
From: Alex Snast <asnast@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alex Snast <asnast@gmail.com>
Subject: [PATCH] perf trace: Add beautifier for mremap flags param
Date: Wed, 13 Aug 2014 18:42:40 +0300
Message-Id: <1407944560-26924-1-git-send-email-asnast@gmail.com>
X-Mailer: git-send-email 2.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

~/devel/kernel/tools/perf(branch:master*) » sudo ./perf trace ~/mremap_test
     0.543 ( 0.003 ms): mprotect(start: 0x600000, len: 4096, prot: READ                       ) = 0
     0.550 ( 0.003 ms): mprotect(start: 0x7f441260d000, len: 4096, prot: READ                 ) = 0
     0.561 ( 0.010 ms): munmap(addr: 0x7f44125e2000, len: 165572                              ) = 0
     0.595 ( 0.012 ms): mmap(len: 12288, prot: READ|WRITE, flags: SHARED|ANONYMOUS|LOCKED, fd: -1) = 0x12608000
     0.603 ( 0.006 ms): mremap(addr: 0x7f4412608000, old_len: 4096, new_len: 4096, flags: MAYMOVE|FIXED, new_addr: 0x7f16da295000) = 0xda295000
     0.608 ( 0.003 ms): mremap(addr: 0x7f441260a000, old_len: 4096, new_len: 4096, flags: MAYMOVE|FIXED, new_addr: 0x7f16da297000) = 0xda297000
     0.612 ( 0.003 ms): mremap(addr: 0x7f4412609000, old_len: 4096, new_len: 4096, flags: MAYMOVE|FIXED, new_addr: 0x7f16da296000) = 0xda296000
     0.619 ( 0.000 ms): exit_group(

Signed-off-by: Alex Snast <asnast@gmail.com>
---
 tools/perf/builtin-trace.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a6c3752..717d7dc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -402,6 +402,31 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size,

 #define SCA_MMAP_FLAGS syscall_arg__scnprintf_mmap_flags

+static size_t syscall_arg__scnprintf_mremap_flags(char *bf, size_t size,
+						  struct syscall_arg *arg)
+{
+	int printed = 0, flags = arg->val;
+
+#define P_MREMAP_FLAG(n) \
+	if (flags & MREMAP_##n) { \
+		printed += scnprintf(bf + printed, size - printed, "%s%s", printed ? "|" : "", #n); \
+		flags &= ~MREMAP_##n; \
+	}
+
+	P_MREMAP_FLAG(MAYMOVE);
+#ifdef MREMAP_FIXED
+	P_MREMAP_FLAG(FIXED);
+#endif
+#undef P_MREMAP_FLAG
+
+	if (flags)
+		printed += scnprintf(bf + printed, size - printed, "%s%#x", printed ? "|" : "", flags);
+
+	return printed;
+}
+
+#define SCA_MREMAP_FLAGS syscall_arg__scnprintf_mremap_flags
+
 static size_t syscall_arg__scnprintf_madvise_behavior(char *bf, size_t size,
 						      struct syscall_arg *arg)
 {
@@ -1004,6 +1029,7 @@ static struct syscall_fmt {
 			     [2] = SCA_MMAP_PROT, /* prot */ }, },
 	{ .name	    = "mremap",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */
+			     [3] = SCA_MREMAP_FLAGS, /* flags */
 			     [4] = SCA_HEX, /* new_addr */ }, },
 	{ .name	    = "munlock",    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
--
2.0.4

