Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaKSVec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:34:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590AbaKSVc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:32:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        Mathias Krause <minipli@googlemail.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Joe Perches <joe@perches.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 120/141] ipc: always handle a new value of auto_msgmni
Date: Wed, 19 Nov 2014 12:52:23 -0800
Message-Id: <20141119205154.649972355@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/ipc_sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -123,7 +123,6 @@ static int proc_ipcauto_dointvec_minmax(
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
-	size_t lenp_bef = *lenp;
 	int oldval;
 	int rc;
 
@@ -133,7 +132,7 @@ static int proc_ipcauto_dointvec_minmax(
 
 	rc = proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
 
-	if (write && !rc && lenp_bef == *lenp) {
+	if (write && !rc) {
 		int newval = *((int *)(ipc_table.data));
 		/*
 		 * The file "auto_msgmni" has correctly been set.


