Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab3EGNmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:42:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42645 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933421Ab3EGNmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 116/118] ipc: sysv shared memory limited to 8TiB
Date: Tue,  7 May 2013 14:39:22 +0100
Message-Id: <1367933964-1564-117-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Holt <holt@sgi.com>

commit d69f3bad4675ac519d41ca2b11e1c00ca115cecd upstream.

Trying to run an application which was trying to put data into half of
memory using shmget(), we found that having a shmall value below 8EiB-8TiB
would prevent us from using anything more than 8TiB.  By setting
kernel.shmall greater than 8EiB-8TiB would make the job work.

In the newseg() function, ns->shm_tot which, at 8TiB is INT_MAX.

ipc/shm.c:
 458 static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 459 {
...
 465         int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
...
 474         if (ns->shm_tot + numpages > ns->shm_ctlall)
 475                 return -ENOSPC;

[akpm@linux-foundation.org: make ipc/shm.c:newseg()'s numpages size_t, not int]
Signed-off-by: Robin Holt <holt@sgi.com>
Reported-by: Alex Thorlton <athorlton@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/ipc_namespace.h | 2 +-
 ipc/shm.c                     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 5499c92..c731973 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -42,8 +42,8 @@ struct ipc_namespace {
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
+	unsigned long	shm_tot;
 	int		shm_ctlmni;
-	int		shm_tot;
 	/*
 	 * Defines whether IPC_RMID is forced for _all_ shm segments regardless
 	 * of shmctl()
diff --git a/ipc/shm.c b/ipc/shm.c
index 41c1285..f5ba6ac 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -462,7 +462,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	size_t size = params->u.size;
 	int error;
 	struct shmid_kernel *shp;
-	int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	struct file * file;
 	char name[13];
 	int id;
-- 
1.8.1.2

