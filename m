Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaDSLot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:44:49 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40985 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaDSLoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:44:02 -0400
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
Subject: [PATCH 3/4] ipc/shm.c: check for integer overflow during shmget.
Date: Sat, 19 Apr 2014 13:43:40 +0200
Message-Id: <1397907821-29319-4-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397907821-29319-3-git-send-email-manfred@colorfullife.com>
References: <1397907821-29319-1-git-send-email-manfred@colorfullife.com>
 <1397907821-29319-2-git-send-email-manfred@colorfullife.com>
 <1397907821-29319-3-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SHMMAX is the upper limit of a shared memory segment,
counted in bytes. The actual allocation is that size, rounded
up to the next full page.
Add a check that prevents the creation of segments where the
rounded up size causes an integer overflow.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/shm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ipc/shm.c b/ipc/shm.c
index 2dfa3d6..f000696 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -493,6 +493,9 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	if (size < SHMMIN || size > ns->shm_ctlmax)
 		return -EINVAL;
 
+	if (numpages << PAGE_SHIFT < size)
+		return -ENOSPC;
+
 	if (ns->shm_tot + numpages < ns->shm_tot ||
 			ns->shm_tot + numpages > ns->shm_ctlall)
 		return -ENOSPC;
-- 
1.9.0

