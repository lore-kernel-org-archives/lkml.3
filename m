Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaDRASj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:18:39 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55748 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaDRAS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:18:28 -0400
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andrew Shewmaker <agshew@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Jens Axboe <axboe@fb.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH v2 3/4] sysctl: allow for strict write position handling
Date: Thu, 17 Apr 2014 17:16:22 -0700
Message-Id: <1397780183-24633-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397780183-24633-1-git-send-email-keescook@chromium.org>
References: <1397780183-24633-1-git-send-email-keescook@chromium.org>
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
contents of the second write. Similarly, multiple short writes would not
append to the sysctl.

This provides CONFIG_PROC_SYSCTL_STRICT_WRITES as a way to make this
behavior act in a less surprising manner for strings, and disallows
non-zero file position when writing numeric sysctls (similar to what is
already done when reading from non-zero file positions).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/proc/Kconfig |   17 +++++++++++++++++
 kernel/sysctl.c |   17 +++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 2183fcf41d59..4a93cf8b7b9f 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -62,6 +62,23 @@ config PROC_SYSCTL
 	  building a kernel for install/rescue disks or your system is very
 	  limited in memory.
 
+config PROC_SYSCTL_STRICT_WRITES
+	bool "Perform strict writes to /proc/sys entries" if EXPERT
+	depends on PROC_SYSCTL
+	default n
+	---help---
+	  When writing to sysctl entries in /proc, each write syscall
+	  is expected to contain the entire sysctl value. For strings
+	  this means that writes do not append, and the contents of the
+	  buffer will be whatever was written last, regardless of the
+	  file position.
+
+	  When PROC_SYSCTL_STRICT_WRITES is enabled, writes to numeric
+	  sysctl entries must always be at file position 0 and the value
+	  must be fully contained in the buffer sent to the write syscall.
+	  For strings, file position is respected, though anything past
+	  the max length of the sysctl buffer will be ignored.
+
 config PROC_PAGE_MONITOR
  	default y
 	depends on PROC_FS && MMU
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0e08103a69c8..83902ae3e4e6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1712,8 +1712,19 @@ static int _proc_do_string(char *data, int maxlen, int write,
 	}
 
 	if (write) {
+#ifdef CONFIG_PROC_SYSCTL_STRICT_WRITES
+		/* Only continue writes not past the end of buffer. */
+		len = strlen(data);
+		if (len > maxlen - 1)
+			len = maxlen - 1;
+
+		if (*ppos > len)
+			return 0;
+		len = *ppos;
+#else
 		/* Start writing from beginning of buffer. */
 		len = 0;
+#endif
 		*ppos += *lenp;
 		p = buffer;
 		while ((p - buffer) < *lenp && len < maxlen - 1) {
@@ -1948,6 +1959,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		conv = do_proc_dointvec_conv;
 
 	if (write) {
+		if (IS_ENABLED(CONFIG_PROC_SYSCTL_STRICT_WRITES) && *ppos)
+			goto out;
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
 		page = __get_free_page(GFP_TEMPORARY);
@@ -2005,6 +2018,7 @@ free:
 			return err ? : -EINVAL;
 	}
 	*lenp -= left;
+out:
 	*ppos += *lenp;
 	return err;
 }
@@ -2197,6 +2211,8 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 	left = *lenp;
 
 	if (write) {
+		if (IS_ENABLED(CONFIG_PROC_SYSCTL_STRICT_WRITES) && *ppos)
+			goto out;
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
 		page = __get_free_page(GFP_TEMPORARY);
@@ -2252,6 +2268,7 @@ free:
 			return err ? : -EINVAL;
 	}
 	*lenp -= left;
+out:
 	*ppos += *lenp;
 	return err;
 }
-- 
1.7.9.5

