Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935885Ab3DJCj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 22:39:27 -0400
Received: from relay3.sgi.com ([192.48.152.1]:60063 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933440Ab3DJCj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 22:39:26 -0400
Date: Tue, 9 Apr 2013 21:39:24 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alex Thorlton <athorlton@sgi.com>
Subject: [PATCH] Sys V shared memory limited to 8TiB.
Message-ID: <20130410023924.GX3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to run an application which was trying to put data into half
of memory using shmget(), we found that having a shmall value below
8EiB-8TiB would prevent us from using anything more than 8TiB.  By setting
kernel.shmall greater that 8EiB-8TiB would make the job work.

In the newseg() function, ns->shm_tot which, at 8TiB is INT_MAX.

ipc/shm.c:
 458 static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 459 {
...
 465         int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
...
 474         if (ns->shm_tot + numpages > ns->shm_ctlall)
 475                 return -ENOSPC;

Signed-off-by: Robin Holt <holt@sgi.com>
Reported-by: Alex Thorlton <athorlton@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stable Kernel Maintainers <stable@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>

---

 include/linux/ipc_namespace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index ae221a7..ca62eca 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -43,8 +43,8 @@ struct ipc_namespace {
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
+	unsigned long	shm_tot;
 	int		shm_ctlmni;
-	int		shm_tot;
 	/*
 	 * Defines whether IPC_RMID is forced for _all_ shm segments regardless
 	 * of shmctl()
-- 
1.8.1.2

