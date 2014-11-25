Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaKYKoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:44:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59300 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaKYKn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrey Vagin <avagin@openvz.org>, Mathias Krause <minipli@googlemail.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Joe Perches <joe@perches.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 253/254] ipc: always handle a new value of auto_msgmni
Date: Tue, 25 Nov 2014 10:40:03 +0000
Message-Id: <1416912004-5928-254-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

commit 1195d94e006b23c6292e78857e154872e33b6d7e upstream.

proc_dointvec_minmax() returns zero if a new value has been set.  So we
don't need to check all charecters have been handled.

Below you can find two examples.  In the new value has not been handled
properly.

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
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Joe Perches <joe@perches.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 ipc/ipc_sysctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index c3f0326e98db..e8075b247497 100644
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
2.1.0

