Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab3BZBie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:38:34 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:34129 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3BZBid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:38:33 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] idr: Don't WARN in idr_find
Date: Mon, 25 Feb 2013 20:37:12 -0500
Message-Id: <1361842632-29689-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since idr is used for syscall apis (to associate 'handles' with
internal structures), don't WARN with invalid input.

For example, POSIX timers are identified by timer_t id. These
ids are idr values. If userspace passes a representable timer_t id
value (eg, id < 0) but which was not previous allocated (since the
current idr api does not return negative idr values), then the
syscall properly returns an error; a WARN is unnecessary and
undesirable.

[  188.957053] WARNING: at /home/peter/src/kernels/next/lib/idr.c:669 idr_find_slowpath+0x151/0x170()
[  188.957055] Hardware name: Bochs
[  188.957105] Modules linked in: nfnetlink scsi_transport_iscsi can_raw ipt_ULOG
<...snip...>
[  188.957109] Pid: 2682, comm: trinity-child2 Not tainted 3.9.0-next-20130220+ldsem-xeon+lockdep #20130220+ldsem
[  188.957112] Call Trace:
[  188.957124]  [<ffffffff8105ecdf>] warn_slowpath_common+0x7f/0xc0
[  188.957126]  [<ffffffff8105ed3a>] warn_slowpath_null+0x1a/0x20
[  188.957129]  [<ffffffff813a8691>] idr_find_slowpath+0x151/0x170
[  188.957139]  [<ffffffff8108d787>] __lock_timer+0x97/0x2b0
[  188.957142]  [<ffffffff8108d6f5>] ? __lock_timer+0x5/0x2b0
[  188.957145]  [<ffffffff8108e0b7>] sys_timer_getoverrun+0x17/0x50
[  188.957152]  [<ffffffff817aeb99>] system_call_fastpath+0x16/0x1b
[  188.957156] ---[ end trace 25fe46b21eb9d42d ]---

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 lib/idr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/idr.c b/lib/idr.c
index 1a30272..8e9b1ac 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -666,7 +666,7 @@ void *idr_find_slowpath(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
-	if (WARN_ON_ONCE(id < 0))
+	if (id < 0)
 		return NULL;
 
 	p = rcu_dereference_raw(idp->top);
-- 
1.8.1.2

