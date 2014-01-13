Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaAMRTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:19:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1587 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755629AbaAMRT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:19:29 -0500
From: Josef Bacik <jbacik@fb.com>
To: <mingo@kernel.org>, <linux-kernel@vger.kernel.org>, <peterz@infradead.org>
Subject: [PATCH 1/2] rwsem: add rwsem_is_contended
Date: Mon, 13 Jan 2014 12:18:50 -0500
Message-ID: <1389633531-1921-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-13_02:2014-01-13,2014-01-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jbacik@fusionio.com>

Btrfs needs a simple way to know if it needs to let go of it's read lock on a
rwsem.  Introduce rwsem_is_contended to check to see if there are any waiters on
this rwsem currently.  This is just a hueristic, it is meant to be light and not
100% accurate and called by somebody already holding on to the rwsem in either
read or write.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
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

