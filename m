Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3FJQOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:14:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29301 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3FJQOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:14:50 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: davidlohr.bueso@hp.com, riel@redhat.com, walken@google.com,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] ipc: don't allocate with GFP_KERNEL inside rcu read lock
Date: Mon, 10 Jun 2013 12:14:30 -0400
Message-Id: <1370880870-23833-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipc_addid() is protected by a rcu read lock, which means we can't allocate
using GFP_KERNEL inside it.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---

Another option would be to call idr_preload from outside the read lock,
but that complicates the code much more than this fix. If that's the
preferred method to fix it I can resend that solution instead.

 ipc/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/util.c b/ipc/util.c
index a746abb..00aca85 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -261,7 +261,7 @@ int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
-	idr_preload(GFP_KERNEL);
+	idr_preload(GFP_ATOMIC);
 
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
-- 
1.8.1.2

