Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaDLLs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 07:48:27 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:37774 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaDLLsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 07:48:25 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH] ipc/shm: disable SHMALL, SHMMAX
Date: Sat, 12 Apr 2014 13:48:04 +0200
Message-Id: <1397303284-2216-1-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shared memory segment can be abused to trigger out-of-memory conditions and
the standard measures against out-of-memory do not work:

- It is not possible to use setrlimit to limit the size of shm segments.

- Segments can exist without association with any processes, thus
  the oom-killer is unable to free that memory.

Therefore Linux always limited the size of segments by default to 32 MB.
As most systems do not need a protection against malicious user space apps,
a default that forces most admins and distros to change it doesn't make
sense.

The patch disables both limits by setting the limits to ULONG_MAX.

Admins who need a protection against out-of-memory conditions should
reduce the limits again and/or enable shm_rmid_forced.

Davidlohr: What do you think?

I prefer this approach: No need to update the man pages, smaller change
of the code, smaller risk of user space incompatibilities.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/shm.h      | 2 +-
 include/uapi/linux/shm.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/shm.h b/include/linux/shm.h
index 1e2cd2e..37bf9c6 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -4,7 +4,7 @@
 #include <asm/page.h>
 #include <uapi/linux/shm.h>
 
-#define SHMALL (SHMMAX/PAGE_SIZE*(SHMMNI/16)) /* max shm system wide (pages) */
+#define SHMALL ULONG_MAX /* max shm system wide (pages) */
 #include <asm/shmparam.h>
 struct shmid_kernel /* private to the kernel */
 {	
diff --git a/include/uapi/linux/shm.h b/include/uapi/linux/shm.h
index 78b6941..d9497b7 100644
--- a/include/uapi/linux/shm.h
+++ b/include/uapi/linux/shm.h
@@ -12,7 +12,7 @@
  * be increased by sysctl
  */
 
-#define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
+#define SHMMAX ULONG_MAX		 /* max shared seg size (bytes) */
 #define SHMMIN 1			 /* min shared seg size (bytes) */
 #define SHMMNI 4096			 /* max num of segs system wide */
 #ifndef __KERNEL__
-- 
1.9.0

