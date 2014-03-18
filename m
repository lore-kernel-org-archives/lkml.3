Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbaCRRVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:21:15 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53834 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059AbaCRRVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:21:12 -0400
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Aaron Tomlin <atomlin@redhat.com>, Andrew Shewmaker <agshew@gmail.com>,
        Li Zefan <lizefan@huawei.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/2] sysctl: fix incorrect write position handling
Date: Tue, 18 Mar 2014 10:17:59 -0700
Message-Id: <1395163080-6290-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395163080-6290-1-git-send-email-keescook@chromium.org>
References: <1395163080-6290-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to a sysctl string, each write, regardless of VFS position,
began writing the string from the start. This meant the contents of
the last write to the sysctl controlled the string contents instead of
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

This fixes the unexpected behavior for strings, and disallows non-zero
file position when writing numeric sysctls (similar to what is already
done when reading from non-zero file positions). Additionally cleans up
the void vs char arguments for better readability.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/sysctl.c |   41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 49e13e1f8fe6..ad40a1677b36 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1711,8 +1711,8 @@ int __init sysctl_init(void)
 
 #ifdef CONFIG_PROC_SYSCTL
 
-static int _proc_do_string(void* data, int maxlen, int write,
-			   void __user *buffer,
+static int _proc_do_string(char *data, int maxlen, int write,
+			   char __user *buffer,
 			   size_t *lenp, loff_t *ppos)
 {
 	size_t len;
@@ -1725,21 +1725,30 @@ static int _proc_do_string(void* data, int maxlen, int write,
 	}
 
 	if (write) {
+		size_t existing;
+		loff_t offset = *ppos;
+
+		existing = strlen(data);
+		if (existing > maxlen - 1)
+			existing = maxlen - 1;
+
+		*ppos += *lenp;
+
+		/* Ignore anything past the end. */
+		if (offset > existing)
+			return 0;
+
 		len = 0;
 		p = buffer;
-		while (len < *lenp) {
+		while (len < *lenp && offset < maxlen - 1) {
 			if (get_user(c, p++))
 				return -EFAULT;
 			if (c == 0 || c == '\n')
 				break;
+			data[offset++] = c;
 			len++;
 		}
-		if (len >= maxlen)
-			len = maxlen-1;
-		if(copy_from_user(data, buffer, len))
-			return -EFAULT;
-		((char *) data)[len] = 0;
-		*ppos += *lenp;
+		data[offset] = 0;
 	} else {
 		len = strlen(data);
 		if (len > maxlen)
@@ -1756,10 +1765,10 @@ static int _proc_do_string(void* data, int maxlen, int write,
 		if (len > *lenp)
 			len = *lenp;
 		if (len)
-			if(copy_to_user(buffer, data, len))
+			if (copy_to_user(buffer, data, len))
 				return -EFAULT;
 		if (len < *lenp) {
-			if(put_user('\n', ((char __user *) buffer) + len))
+			if (put_user('\n', buffer + len))
 				return -EFAULT;
 			len++;
 		}
@@ -1789,8 +1798,8 @@ static int _proc_do_string(void* data, int maxlen, int write,
 int proc_dostring(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	return _proc_do_string(table->data, table->maxlen, write,
-			       buffer, lenp, ppos);
+	return _proc_do_string((char *)(table->data), table->maxlen, write,
+			       (char __user *)buffer, lenp, ppos);
 }
 
 static size_t proc_skip_spaces(char **buf)
@@ -1964,6 +1973,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		conv = do_proc_dointvec_conv;
 
 	if (write) {
+		if (*ppos)
+			goto out;
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
 		page = __get_free_page(GFP_TEMPORARY);
@@ -2021,6 +2032,7 @@ free:
 			return err ? : -EINVAL;
 	}
 	*lenp -= left;
+out:
 	*ppos += *lenp;
 	return err;
 }
@@ -2213,6 +2225,8 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 	left = *lenp;
 
 	if (write) {
+		if (*ppos)
+			goto out;
 		if (left > PAGE_SIZE - 1)
 			left = PAGE_SIZE - 1;
 		page = __get_free_page(GFP_TEMPORARY);
@@ -2268,6 +2282,7 @@ free:
 			return err ? : -EINVAL;
 	}
 	*lenp -= left;
+out:
 	*ppos += *lenp;
 	return err;
 }
-- 
1.7.9.5

