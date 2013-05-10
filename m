Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3EJOhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:37:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57128 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936Ab3EJOVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Robin Holt" <holt@sgi.com>, "Alex Thorlton" <athorlton@sgi.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.240724534@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [070/118] ipc: sysv shared memory limited to 8TiB
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ipc_namespace.h |    2 +-
 ipc/shm.c                     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -450,7 +450,7 @@ static int newseg(struct ipc_namespace *
 	size_t size = params->u.size;
 	int error;
 	struct shmid_kernel *shp;
-	int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	struct file * file;
 	char name[13];
 	int id;

