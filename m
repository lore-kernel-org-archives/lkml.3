Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3DWQ3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:29:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab3DWQ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:29:11 -0400
Date: Tue, 23 Apr 2013 12:29:05 -0400
From: Rik van Riel <riel@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: [PATCH -mm] ipc,sem: fix locking in semctl_main
Message-ID: <20130423122905.33ac0d3c@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, here is the patch I promised :)

Everywhere else in the code, we check sma->sem_perm.deleted under
the semaphore array lock, so we should do teh same here.
The easy fix is to simply not drop and re-take the lock, but keep
it locked.

This patch can be folded into ipcsem-fine-grained-locking-for-semtimedop.patch

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 ipc/sem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 5711616..efdaee6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1243,10 +1243,9 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 				err = -EIDRM;
 				goto out_free;
 			}
-			sem_unlock(sma, -1);
-		}
+		} else
+			sem_lock(sma, NULL, -1);
 
-		sem_lock(sma, NULL, -1);
 		for (i = 0; i < sma->sem_nsems; i++)
 			sem_io[i] = sma->sem_base[i].semval;
 		sem_unlock(sma, -1);
