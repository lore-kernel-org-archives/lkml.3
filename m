Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaBRCkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:40:43 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:17643 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaBRCkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:40:41 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com
Cc: linux-kernel@vger.kernel.org, davidlohr@hp.com
Subject: [PATCH 1/2] ipc,compat: remove sc_semopm macro
Date: Mon, 17 Feb 2014 18:40:29 -0800
Message-Id: <1392691230-16394-1-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro appears to have been introduced back in the 2.5 era for
semtimedop32 backward compatibility on ia32:

https://lkml.org/lkml/2003/4/28/78

Nowadays, this syscall in compat just defaults back to the code found in
sem.c, so it is no longer used and can thus be removed:

long compat_sys_semtimedop(int semid, struct sembuf __user *tsems,
		unsigned nsops, const struct compat_timespec __user *timeout)
{
	struct timespec __user *ts64;
	if (compat_convert_timespec(&ts64, timeout))
		return -EFAULT;
	return sys_semtimedop(semid, tsems, nsops, ts64);
}

Furthermore, there are no users in compat.c.  After this change, kernel
builds just fine with both CONFIG_SYSVIPC_COMPAT and CONFIG_SYSVIPC.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/compat.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index 1048522..8e27104 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -113,9 +113,6 @@ struct compat_shm_info {
 	compat_ulong_t swap_attempts, swap_successes;
 };
 
-extern int sem_ctls[];
-#define sc_semopm	(sem_ctls[2])
-
 static inline int compat_ipc_parse_version(int *cmd)
 {
 #ifdef	CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
-- 
1.8.1.4

