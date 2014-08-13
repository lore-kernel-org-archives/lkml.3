Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaHMW7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:59:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:54978 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaHMWtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:49:19 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alex Snast <asnast@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/41] perf trace: Add beautifier for mremap flags param
Date: Wed, 13 Aug 2014 19:47:55 -0300
Message-Id: <1407970107-24540-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Snast <asnast@gmail.com>

~/devel/kernel/tools/perf(branch:master*) » sudo ./perf trace ~/mremap_test
     0.543 ( 0.003 ms): mprotect(start: 0x600000, len: 4096, prot: READ      ) = 0
     0.550 ( 0.003 ms): mprotect(start: 0x7f441260d000, len: 4096, prot: READ) = 0
     0.561 ( 0.010 ms): munmap(addr: 0x7f44125e2000, len: 165572             ) = 0
     0.595 ( 0.012 ms): mmap(len: 12288, prot: READ|WRITE, flags: SHARED|ANONYMOUS|LOCKED, fd: -1) = 0x12608000
     0.603 ( 0.006 ms): mremap(addr: 0x7f4412608000, old_len: 4096, new_len: 4096, flags: MAYMOVE|FIXED, new_addr: 0x7f16da295000) = 0xda295000
     0.608 ( 0.003 ms): mremap(addr: 0x7f441260a000, old_len: 4096, new_len: 4096, flags: MAYMOVE|FIXED, new_addr: 0x7f16da297000) = 0xda297000
     0.612 ( 0.003 ms): mremap(addr: 0x7f4412609000, old_len: 4096, new_len: 4096, flags: MAYMOVE|FIXED, new_addr: 0x7f16da296000) = 0xda296000
     0.619 ( 0.000 ms): exit_group(

Signed-off-by: Alex Snast <asnast@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407944560-26924-1-git-send-email-asnast@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 36ae51d61be2..20fac5083771 100644
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
1.9.3

