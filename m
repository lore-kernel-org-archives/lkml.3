Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaEAV2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:28:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56366 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbaEAV2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 1/4] sysctl: clean up char buffer arguments
Date: Thu,  1 May 2014 14:26:34 -0700
Message-Id: <1398979597-3589-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398979597-3589-1-git-send-email-keescook@chromium.org>
References: <1398979597-3589-1-git-send-email-keescook@chromium.org>
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

