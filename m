Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaDRATO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:19:14 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57159 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbaDRATH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:19:07 -0400
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
Subject: [PATCH v2 1/4] sysctl: clean up char buffer arguments
Date: Thu, 17 Apr 2014 17:16:20 -0700
Message-Id: <1397780183-24633-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397780183-24633-1-git-send-email-keescook@chromium.org>
References: <1397780183-24633-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The char buffer arguments are needlessly cast in weird places. Clean it up
so things are easier to read.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/sysctl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 74f5b580fe34..e7ff80a73c44 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1698,8 +1698,8 @@ int __init sysctl_init(void)
 
 #ifdef CONFIG_PROC_SYSCTL
 
-static int _proc_do_string(void* data, int maxlen, int write,
-			   void __user *buffer,
+static int _proc_do_string(char *data, int maxlen, int write,
+			   char __user *buffer,
 			   size_t *lenp, loff_t *ppos)
 {
 	size_t len;
@@ -1725,7 +1725,7 @@ static int _proc_do_string(void* data, int maxlen, int write,
 			len = maxlen-1;
 		if(copy_from_user(data, buffer, len))
 			return -EFAULT;
-		((char *) data)[len] = 0;
+		data[len] = 0;
 		*ppos += *lenp;
 	} else {
 		len = strlen(data);
@@ -1743,10 +1743,10 @@ static int _proc_do_string(void* data, int maxlen, int write,
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
@@ -1776,8 +1776,8 @@ static int _proc_do_string(void* data, int maxlen, int write,
 int proc_dostring(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	return _proc_do_string(table->data, table->maxlen, write,
-			       buffer, lenp, ppos);
+	return _proc_do_string((char *)(table->data), table->maxlen, write,
+			       (char __user *)buffer, lenp, ppos);
 }
 
 static size_t proc_skip_spaces(char **buf)
-- 
1.7.9.5

