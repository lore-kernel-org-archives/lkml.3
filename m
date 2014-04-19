Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaDSLoE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:44:04 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60713 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaDSLoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:44:00 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 2/4] ipc/shm.c: check for overflows of shm_tot
Date: Sat, 19 Apr 2014 13:43:39 +0200
Message-Id: <1397907821-29319-3-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397907821-29319-2-git-send-email-manfred@colorfullife.com>
References: <1397907821-29319-1-git-send-email-manfred@colorfullife.com>
 <1397907821-29319-2-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shm_tot counts the total number of pages used by shm segments.

If SHMALL is ULONG_MAX (or nearly ULONG_MAX), then the number
can overflow.  Subsequent calls to shmctl(,SHM_INFO,) would return
wrong values for shm_tot.

The patch adds a detection for overflows.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/shm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 382e2fb..2dfa3d6 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -493,7 +493,8 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (size < SHMMIN || size > ns->shm_ctlmax)
 		return -EINVAL;
 
-	if (ns->shm_tot + numpages > ns->shm_ctlall)
+	if (ns->shm_tot + numpages < ns->shm_tot ||
+			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
 
 	shp = ipc_rcu_alloc(sizeof(*shp));
-- 
1.9.0

