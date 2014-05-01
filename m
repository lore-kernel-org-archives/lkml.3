Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaEAV2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:28:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44924 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaEAV2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:28:19 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Aaron Tomlin <atomlin@redhat.com>,
        Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dario Faggioli <raistlin@linux.it>, Jens Axboe <axboe@fb.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>, linux-doc@vger.kernel.org
Subject: [PATCH 3/4] sysctl: allow for strict write position handling
Date: Thu,  1 May 2014 14:26:36 -0700
Message-Id: <1398979597-3589-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398979597-3589-1-git-send-email-keescook@chromium.org>
References: <1398979597-3589-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to a sysctl string, each write, regardless of VFS position,
begins writing the string from the start. This means the contents of
the last write to the sysctl controls the string contents instead of
the first:

open("/proc/sys/kernel/modprobe", O_WRONLY)   = 1
write(1, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"..., 4096) = 4096
write(1, "/bin/true", 9)                = 9
close(1)                                = 0

$ cat /proc/sys/kernel/modprobe
/bin/true

Expected behaviour would be to have the sysctl be "AAAA..." capped at
maxlen (in this case KMOD_PATH_LEN: 256), instead of truncating to the
contents of the second write. Similarly, multiple short writes would
not append to the sysctl.

The old behavior is unlike regular POSIX files enough that doing audits of
software that interact with sysctls can end up in unexpected or dangerous
situations. For example, "as long as the input starts with a trusted
path" turns out to be an insufficient filter, as what must also happen
is for the input to be entirely contained in a single write syscall --
not a common consideration, especially for high level tools.

This provides kernel.sysctl_writes_strict as a way to make this behavior
act in a less surprising manner for strings, and disallows non-zero
file position when writing numeric sysctls (similar to what is already
done when reading from non-zero file positions). For now, the default
(0) is to warn about non-zero file position use, but retain the legacy
behavior. Setting this to -1 disables the warning, and setting this to
1 enables the file position respecting behavior.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/sysctl/kernel.txt |   21 ++++++++++++
 kernel/sysctl.c                 |   69 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 9886c3d57fc2..708bb7f1b7e0 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -77,6 +77,7 @@ show up in /proc/sys/kernel:
 - shmmni
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
+- sysctl_writes_strict
 - tainted
 - threads-max
 - unknown_nmi_panic
@@ -762,6 +763,26 @@ without users and with a dead originative process will be destroyed.
 
 ==============================================================
 
+sysctl_writes_strict:
+
+Control how file position affects the behavior of updating sysctl values
+via the /proc/sys interface:
+
+  -1 - Legacy per-write sysctl value handling, with no printk warnings.
+       Each write syscall must fully contain the sysctl value to be
+       written, and multiple writes on the same sysctl file descriptor
+       will rewrite the sysctl value, regardless of file position.
+   0 - (default) Same behavior as above, but warn about processes that
+       perform writes to a sysctl file descriptor when the file position
+       is not 0.
+   1 - Respect file position when writing sysctl strings. Multiple writes
+       will append to the sysctl value buffer. Anything past the max length
+       of the sysctl value buffer will be ignored. Writes to numeric sysctl
+       entries must always be at file position 0 and the value must be
+       fully contained in the buffer sent in the write syscall.
+
+==============================================================
+
 tainted:
 
 Non-zero if the kernel has been tainted.  Numeric values, which
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0e08103a69c8..d5bee7949e4a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -173,6 +173,13 @@ extern int no_unaligned_warning;
 #endif
 
 #ifdef CONFIG_PROC_SYSCTL
+
+#define SYSCTL_WRITES_LEGACY	-1
+#define SYSCTL_WRITES_WARN	 0
+#define SYSCTL_WRITES_STRICT	 1
+
+static int sysctl_writes_strict = SYSCTL_WRITES_WARN;
+
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 static int proc_taint(struct ctl_table *table, int write,
@@ -495,6 +502,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_taint,
 	},
+	{
+		.procname	= "sysctl_writes_strict",
+		.data		= &sysctl_writes_strict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &neg_one,
+		.extra2		= &one,
+	},
 #endif
 #ifdef CONFIG_LATENCYTOP
 	{
@@ -1712,8 +1728,20 @@ static int _proc_do_string(char *data, int maxlen, int write,
 	}
 
 	if (write) {
-		/* Start writing from beginning of buffer. */
-		len = 0;
+		if (sysctl_writes_strict == SYSCTL_WRITES_STRICT) {
+			/* Only continue writes not past the end of buffer. */
+			len = strlen(data);
+			if (len > maxlen - 1)
+				len = maxlen - 1;
+
+			if (*ppos > len)
+				return 0;
+			len = *ppos;
+		} else {
+			/* Start writing from beginning of buffer. */
+			len = 0;
+		}
+
 		*ppos += *lenp;
 		p = buffer;
 		while ((p - buffer) < *lenp && len < maxlen - 1) {
@@ -1753,6 +1781,14 @@ static int _proc_do_string(char *data, int maxlen, int write,
 	return 0;
 }
 
+static void warn_sysctl_write(struct ctl_table *table)
+{
+	pr_warn("%s wrote to %s when file position was not 0!\n",
+		current->task_comm, table->procname);
+	pr_warn("This will not be supported in the future.\n");
+	pr_warn("To silence warning, set kernel.sysctl_writes_strict = -1\n");
+}
+
 /**
  * proc_dostring - read a string sysctl
  * @table: the sysctl table
@@ -1773,6 +1809,9 @@ static int _proc_do_string(char *data, int maxlen, int write,
 int proc_dostring(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
+	if (write && *ppos && sysctl_writes_strict == SYSCTL_WRITES_WARN)
+		warn_sysctl_write(table);
+
 	return _proc_do_string((char *)(table->data), table->maxlen, write,
 			       (char __user *)buffer, lenp, ppos);
 }
@@ -1948,6 +1987,18 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		conv = do_proc_dointvec_conv;
 
 	if (write) {
+		if (*ppos) {
+			switch (sysctl_writes_strict) {
+			case SYSCTL_WRITES_STRICT:
+				goto out;
+			case SYSCTL_WRITES_WARN:
+				warn_sysctl_write(table);
+				break;
+			default:
+				break;
+			}
+		}
+
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
 		page = __get_free_page(GFP_TEMPORARY);
@@ -2005,6 +2056,7 @@ free:
 			return err ? : -EINVAL;
 	}
 	*lenp -= left;
+out:
 	*ppos += *lenp;
 	return err;
 }
@@ -2197,6 +2249,18 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 	left = *lenp;
 
 	if (write) {
+		if (*ppos) {
+			switch (sysctl_writes_strict) {
+			case SYSCTL_WRITES_STRICT:
+				goto out;
+			case SYSCTL_WRITES_WARN:
+				warn_sysctl_write(table);
+				break;
+			default:
+				break;
+			}
+		}
+
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
 		page = __get_free_page(GFP_TEMPORARY);
@@ -2252,6 +2316,7 @@ free:
 			return err ? : -EINVAL;
 	}
 	*lenp -= left;
+out:
 	*ppos += *lenp;
 	return err;
 }
-- 
1.7.9.5

