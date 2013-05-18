Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab3ERDDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:03:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32671 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819Ab3ERDAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:32 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=x_axqWY2tKUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=8VEGwN_I9RoA:10 a=eJfxgxciAAAA:8 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=W39ifWXXhksA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021653.231152589@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Robin Holt <holt@sgi.com>, Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 071/136 ] ipc: sysv shared memory limited to 8TiB
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0071-ipc-sysv-shared-memory-limited-to-8TiB.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Robin Holt <holt@sgi.com>

[ Upstream commit d69f3bad4675ac519d41ca2b11e1c00ca115cecd ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ipc_namespace.h |    2 +-
 ipc/shm.c                     |    2 +-
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
index 00faa05..9f753fc4 100644
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
1.7.10.4


