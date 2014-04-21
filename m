Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaDUOb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:31:59 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:40541 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaDUObv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:31:51 -0400
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
Subject: [PATCH 4/4] ipc/shm.c: Increase the defaults for SHMALL, SHMMAX.
Date: Mon, 21 Apr 2014 16:26:37 +0200
Message-Id: <1398090397-2397-5-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398090397-2397-4-git-send-email-manfred@colorfullife.com>
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com>
 <1398090397-2397-2-git-send-email-manfred@colorfullife.com>
 <1398090397-2397-3-git-send-email-manfred@colorfullife.com>
 <1398090397-2397-4-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

System V shared memory

a) can be abused to trigger out-of-memory conditions and the standard
   measures against out-of-memory do not work:

    - it is not possible to use setrlimit to limit the size of shm segments.

    - segments can exist without association with any processes, thus
      the oom-killer is unable to free that memory.

b) is typically used for shared information - today often multiple GB.
   (e.g. database shared buffers)

The current default is a maximum segment size of 32 MB and a maximum total
size of 8 GB. This is often too much for a) and not enough for b), which
means that lots of users must change the defaults.

This patch increases the default limits (nearly) to the maximum, which is
perfect for case b). The defaults are used after boot and as the initial
value for each new namespace.

Admins/distros that need a protection against a) should reduce the limits
and/or enable shm_rmid_forced.

Further notes:
- The patch only changes default, overrides behave as before:
        # sysctl kernel.shmall=33554432
  would recreate the previous limit for SHMMAX (for the current namespace).

- Disabling sysv shm allocation is possible with:
        # sysctl kernel.shmall=0
  (not a new feature, also per-namespace)

- The limits are intentionally set to a value slightly less than ULONG_MAX,
  to avoid triggering overflows in user space apps.
  [not unreasonable, see http://marc.info/?l=linux-mm&m=139638334330127]

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: mtk.manpages@gmail.com
---
 include/linux/shm.h      | 3 +--
 include/uapi/linux/shm.h | 8 +++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/shm.h b/include/linux/shm.h
index 1e2cd2e..57d7770 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -3,9 +3,8 @@
 
 #include <asm/page.h>
 #include <uapi/linux/shm.h>
-
-#define SHMALL (SHMMAX/PAGE_SIZE*(SHMMNI/16)) /* max shm system wide (pages) */
 #include <asm/shmparam.h>
+
 struct shmid_kernel /* private to the kernel */
 {	
 	struct kern_ipc_perm	shm_perm;
diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
index 78b6941..74e786d 100644
--- a/include/uapi/linux/shm.h
+++ b/include/uapi/linux/shm.h
@@ -9,15 +9,13 @@
 
 /*
  * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
- * be increased by sysctl
+ * be modified by sysctl.
  */
 
-#define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
-#ifndef __KERNEL__
-#define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
-#endif
+#define SHMMAX (ULONG_MAX - (1L<<24))	 /* max shared seg size (bytes) */
+#define SHMALL (ULONG_MAX - (1L<<24))	 /* max shm system wide (pages) */
 #define SHMSEG SHMMNI			 /* max shared segs per process */
 
 
-- 
1.9.0

