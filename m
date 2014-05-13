Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaEMU2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:28:15 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:44754 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaEMU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:27:52 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: manfred@colorfullife.com, akpm@linux-foundation.org
Cc: davidlohr@hp.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] ipc,msg: loosen check for full queue
Date: Tue, 13 May 2014 13:27:37 -0700
Message-Id: <1400012857-11733-6-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sending a message, we must guarantee that there will be
enough room in the queue to add it, otherwise wait until space
becomes available -- which requires blocking the calling task.
Currently, this relies meeting both of the following conditions:

(i) The new msg size + current size is lower than the queue's max size.
(ii) The current amount of messages in the queue + 1 (this msg) is lower
     than the queue's max size.

While (i) is obvious and well documented in the msgsnd(2) manpage, the
second one is far more ambiguous and does not serve the purpose, as we do
not control the amount of messages in the queue (unlike posix queues do).
Thus remove (ii) and loosen how we check for space.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/msg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 956cd65..7d267d0 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -658,10 +658,8 @@ long do_msgsnd(int msqid, long mtype, void __user *mtext,
 		if (err)
 			goto out_unlock0;
 
-		if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
-				1 + msq->q_qnum <= msq->q_qbytes) {
-			break;
-		}
+		if (msgsz + msq->q_cbytes <= msq->q_qbytes)
+			break; /* there is space in the queue for this msg */
 
 		/* queue full, wait: */
 		if (msgflg & IPC_NOWAIT) {
-- 
1.8.1.4

