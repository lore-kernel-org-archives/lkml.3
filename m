Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3IYPZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:25:07 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54121 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3IYPZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:25:05 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Mike Galbraith <efault@gmx.de>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc/sem.c: Synchronize the proc interface
Date: Wed, 25 Sep 2013 17:24:49 +0200
Message-Id: <1380122689-6789-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The proc interface is not aware of sem_lock(), it calls
ipc_lock_object() directly.
This means that simple semop() operations can run in parallel with the
proc interface.
Right now, this is uncritical, because the implementation doesn't
do anything that requires a proper synchronization.

But it is dangerous and therefore should be fixed.

Andrew:
- Could you include the patch in -mm and push it towards Linus?
- The patch depends on ipc-semc-fix-race-in-sem_lock.patch

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/ipc/sem.c b/ipc/sem.c
index 4a92c04..e5d9bb8 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2095,6 +2095,14 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 	struct sem_array *sma = it;
 	time_t sem_otime;
 
+	/*
+	 * The proc interface isn't aware of sem_lock(), it calls
+	 * ipc_lock_object() directly (in sysvipc_find_ipc).
+	 * In order to stay compatible with sem_lock(), we must wait until
+	 * all simple semop() calls have left their critical regions.
+	 */
+	sem_wait_array(sma);
+
 	sem_otime = get_semotime(sma);
 
 	return seq_printf(s,
-- 
1.8.3.1

