Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaILNf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:35:29 -0400
Received: from shelob.surriel.com ([74.92.59.67]:59597 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaILNf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:35:28 -0400
X-Greylist: delayed 1344 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 09:35:27 EDT
From: riel@redhat.com
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, prarit@redhat.com,
        oleg@redhat.com, sgruszka@redhat.com
Subject: [PATCH -tip 1/2] seqlock: add irqsave variant of read_seqbegin_or_lock
Date: Fri, 12 Sep 2014 09:12:14 -0400
Message-Id: <1410527535-9814-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410527535-9814-1-git-send-email-riel@redhat.com>
References: <1410527535-9814-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

There are cases where read_seqbegin_or_lock needs to block irqs,
because the seqlock in question nests inside a lock that is also
be taken from irq context.

Add read_seqbegin_or_lock_irqsave and done_seqretry_irqrestore, which
are almost identical to read_seqbegin_or_lock and done_seqretry.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/seqlock.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index cc35963..4364cd3 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -456,4 +456,21 @@ read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
 
+static inline unsigned long read_seqbegin_or_lock_irqsave(seqlock_t *lock,
+							  int *seq)
+{
+	unsigned long flags = 0;
+	if (!(*seq & 1))	/* Even */
+		*seq = read_seqbegin(lock);
+	else			/* Odd */
+		read_seqlock_excl_irqsave(lock, flags);
+	return flags;
+}
+
+static inline void done_seqretry_irqrestore(seqlock_t *lock, int seq,
+					    unsigned long flags)
+{
+	if (seq & 1)
+		read_sequnlock_excl_irqrestore(lock, flags);
+}
 #endif /* __LINUX_SEQLOCK_H */
-- 
1.9.3

