Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3JUWfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:35:09 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49474 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3JUWdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:33:55 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [RFC v2 2/6] percpu_rw_semaphore: add percpu_down_read_trylock()
Date: Tue, 22 Oct 2013 00:33:24 +0200
Message-Id: <1382394808-20611-3-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
References: <1382394808-20611-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically a copy of percpu_down_read() but does not sleep if a
writer is already active. Same semantics as classic down_read_trylock().

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 include/linux/percpu-rwsem.h |  1 +
 lib/percpu-rwsem.c           | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index 3e88c9a..2f752bd 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -16,6 +16,7 @@ struct percpu_rw_semaphore {
 };
 
 extern void percpu_down_read(struct percpu_rw_semaphore *);
+extern int percpu_down_read_trylock(struct percpu_rw_semaphore *);
 extern void percpu_up_read(struct percpu_rw_semaphore *);
 
 extern void percpu_down_write(struct percpu_rw_semaphore *);
diff --git a/lib/percpu-rwsem.c b/lib/percpu-rwsem.c
index 893586c..596f44b 100644
--- a/lib/percpu-rwsem.c
+++ b/lib/percpu-rwsem.c
@@ -92,6 +92,26 @@ void percpu_down_read(struct percpu_rw_semaphore *brw)
 }
 EXPORT_SYMBOL(percpu_down_read);
 
+int percpu_down_read_trylock(struct percpu_rw_semaphore *brw)
+{
+	int r;
+
+	if (likely(update_fast_ctr(brw, +1))) {
+		rwsem_acquire_read(&brw->rw_sem.dep_map, 0, 0, _RET_IP_);
+		return 1;
+	}
+
+	r = down_read_trylock(&brw->rw_sem);
+	if (r) {
+		atomic_inc(&brw->slow_read_ctr);
+		/* avoid up_read()->rwsem_release() */
+		__up_read(&brw->rw_sem);
+	}
+
+	return r;
+}
+EXPORT_SYMBOL(percpu_down_read_trylock);
+
 void percpu_up_read(struct percpu_rw_semaphore *brw)
 {
 	rwsem_release(&brw->rw_sem.dep_map, 1, _RET_IP_);
-- 
1.8.4.1

