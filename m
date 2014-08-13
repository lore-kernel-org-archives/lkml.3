Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaHMNWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:22:33 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37111 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbaHMNWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:22:32 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathias Krause <minipli@googlemail.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Joe Perches <joe@perches.com>, Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH] ipc: always handle a new value of auto_msgmni
Date: Wed, 13 Aug 2014 17:21:57 +0400
Message-Id: <1407936117-2985-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_dointvec_minmax() returns zero, if a new value has been set.
So we don't need to check all charectes have been handled.

Below you can find two examples. In the new value has not been
handled properly.

$ strace ./a.out
open("/proc/sys/kernel/auto_msgmni", O_WRONLY) = 3
write(3, "0\n\0", 3)                    = 2
close(3)                                = 0
exit_group(0)
$ cat /sys/kernel/debug/tracing/trace

$strace ./a.out
open("/proc/sys/kernel/auto_msgmni", O_WRONLY) = 3
write(3, "0\n", 2)                      = 2
close(3)                                = 0

$ cat /sys/kernel/debug/tracing/trace
a.out-697   [000] ....  3280.998235: unregister_ipcns_notifier <-proc_ipcauto_dointvec_minmax

Fixes: 9eefe520c814 ("ipc: do not use a negative value to re-enable msgmni automatic recomputin")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Joe Perches <joe@perches.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 ipc/ipc_sysctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index c3f0326..e8075b2 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -123,7 +123,6 @@ static int proc_ipcauto_dointvec_minmax(struct ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
-	size_t lenp_bef = *lenp;
 	int oldval;
 	int rc;
 
@@ -133,7 +132,7 @@ static int proc_ipcauto_dointvec_minmax(struct ctl_table *table, int write,
 
 	rc = proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
 
-	if (write && !rc && lenp_bef == *lenp) {
+	if (write && !rc) {
 		int newval = *((int *)(ipc_table.data));
 		/*
 		 * The file "auto_msgmni" has correctly been set.
-- 
1.9.3

