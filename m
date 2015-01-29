Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbbA2Fx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:53:56 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40151 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbbA2Fxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:53:54 -0500
Date: Thu, 29 Jan 2015 11:23:10 +0530
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: linux-afs@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] AFS: Correctly use 64-bit time for UUID
Message-ID: <20150129055310.GA3033@tinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UUID calculation uses 'struct timespec' whose seconds will overflow
in year 2038 and beyond for 32-bit systems. This patch removes the
dependency on 'struct timespec' by using ktime_get_real_ns().
While the patch does not fix a 'bug' as such, it is part of a larger
effort to remove instances of 'struct timespec' and other data-structures
suffering from y2038 problem from the kernel.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
 fs/afs/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/afs/main.c b/fs/afs/main.c
index 35de0c0..7a9c2e6 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/completion.h>
 #include <linux/sched.h>
+#include <linux/ktime.h>
 #include "internal.h"
 
 MODULE_DESCRIPTION("AFS Client File System");
@@ -37,7 +38,6 @@ struct workqueue_struct *afs_wq;
  */
 static int __init afs_get_client_UUID(void)
 {
-	struct timespec ts;
 	u64 uuidtime;
 	u16 clockseq;
 	int ret;
@@ -48,9 +48,7 @@ static int __init afs_get_client_UUID(void)
 	if (ret < 0)
 		return ret;
 
-	getnstimeofday(&ts);
-	uuidtime = (u64) ts.tv_sec * 1000 * 1000 * 10;
-	uuidtime += ts.tv_nsec / 100;
+	uuidtime = ktime_get_real_ns() / 100;
 	uuidtime += AFS_UUID_TO_UNIX_TIME;
 	afs_uuid.time_low = uuidtime;
 	afs_uuid.time_mid = uuidtime >> 32;
-- 
2.2.0.rc0.207.ga3a616c

