Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab3IZN0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:26:41 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:42062 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3IZN0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:26:39 -0400
X-ASG-Debug-ID: 1380201998-03d6a50f617c810001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
CC: <walken@google.com>, <linux-kernel@vger.kernel.org>, <mingo@kernel.org>,
        <peter@hurleysoftware.com>, <akpm@linux-foundation.org>
Subject: [PATCH 1/2] rwsem: add rwsem_is_contended V3
Date: Thu, 26 Sep 2013 09:26:35 -0400
X-ASG-Orig-Subj: [PATCH 1/2] rwsem: add rwsem_is_contended V3
Message-ID: <1380201996-17445-1-git-send-email-jbacik@fusionio.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1380201998
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140942
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btrfs needs a simple way to know if it needs to let go of it's read lock on a
rwsem.  Introduce rwsem_is_contended to check to see if there are any waiters on
this rwsem currently.  This is just a hueristic, it is meant to be light and not
100% accurate and called by somebody already holding on to the rwsem in either
read or write.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V2->V3: fixed the comment and simplified the function as per Peter's
suggestions.

V1->V2: took everybodys suggestions and simplified it to just one function in
rwsem.h so it works for both the spinlock case and non-spinlock case.

 include/linux/rwsem.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 0616ffe..03f3b05 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -75,6 +75,17 @@ do {								\
 } while (0)
 
 /*
+ * This is the same regardless of which rwsem implementation that is being used.
+ * It is just a heuristic meant to be called by somebody alreadying holding the
+ * rwsem to see if somebody from an incompatible type is wanting access to the
+ * lock.
+ */
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	return !list_empty(&sem->wait_list);
+}
+
+/*
  * lock for reading
  */
 extern void down_read(struct rw_semaphore *sem);
-- 
1.8.3.1

