Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbaE2SrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:47:24 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34279 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaE2SrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:47:22 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 1vier1@web.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 2/3] ipc/sem.c: increase SEMMSL, SEMMNI, SEMOPM
Date: Thu, 29 May 2014 20:46:39 +0200
Message-Id: <1401389200-6758-3-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401389200-6758-2-git-send-email-manfred@colorfullife.com>
References: <1401389200-6758-1-git-send-email-manfred@colorfullife.com>
 <1401389200-6758-2-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SysV can be abused to allocated locked kernel memory.
For most systems, a small limit doesn't make sense,
see the discussion with regards to SHMMAX.

Therefore: Increase the sysv sem limits to the maximum supported.

With regards to the maximum supported:
Some of the specified hard limits are not correct anymore.

Therefore here is an updated list:

- SEMMNI must stay below IPCMNI, which is 32768.
  As for SHMMAX: Stay a bit below this limit.

- SEMMSL was limited to 8k, to ensure that the kmalloc for the
  kernel array was limited to 16 kB (order=2)

  This doesn't apply anymore:
   - the allocation size isn't sizeof(short)*nsems anymore.
   - ipc_alloc falls back to vmalloc

- SEMOPM should stay below 1000, to limit the kmalloc in
  semtimedop() to an order=1 allocation.

  This might be a real issue: The Redhat documentation
  shows an example with SEMOPM=5010:

https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Setting_Semaphores-An_Example_of_Semaphore_Settings.html

  If Oracle really uses operations with SEMOPM 5000 and larger, then
  semtimedop() should be converted from kmalloc to ipc_alloc.

Note:
If an administrator must limit the memory allocations, then
he can set MSGMNI as necessary.

Or he can disable sysv entirely (as e.g. done with Android).
---
 include/uapi/linux/sem.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/sem.h b/include/uapi/linux/sem.h
index 541fce0..a4f47d9 100644
--- a/include/uapi/linux/sem.h
+++ b/include/uapi/linux/sem.h
@@ -63,10 +63,10 @@ struct  seminfo {
 	int semaem;
 };
 
-#define SEMMNI  128             /* <= IPCMNI  max # of semaphore identifiers */
-#define SEMMSL  250             /* <= 8 000 max num of semaphores per id */
+#define SEMMNI  32000           /* <= IPCMNI  max # of semaphore identifiers */
+#define SEMMSL  32000           /* <= INT_MAX max num of semaphores per id */
 #define SEMMNS  (SEMMNI*SEMMSL) /* <= INT_MAX max # of semaphores in system */
-#define SEMOPM  32	        /* <= 1 000 max num of ops per semop call */
+#define SEMOPM  1000	        /* <= 1 000 max num of ops per semop call */
 #define SEMVMX  32767           /* <= 32767 semaphore maximum value */
 #define SEMAEM  SEMVMX          /* adjust on exit max value */
 
-- 
1.9.3

