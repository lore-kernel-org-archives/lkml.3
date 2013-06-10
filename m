Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3FJRRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:17:21 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:36440 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab3FJRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:17:19 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 2/6] ipc/sem.c: cacheline align the semaphore structures
Date: Mon, 10 Jun 2013 19:16:47 +0200
Message-Id: <1370884611-3861-3-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370884611-3861-2-git-send-email-manfred@colorfullife.com>
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com>
 <1370884611-3861-2-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As now each semaphore has it's own spinlock and parallel operations
are possible, give each semaphore it's own cacheline.

On a i3 laptop, this gives up to 28% better performance:

#semscale 10 | grep "interleave 2"
- before:
Cpus 1, interleave 2 delay 0: 36109234 in 10 secs
Cpus 2, interleave 2 delay 0: 55276317 in 10 secs
Cpus 3, interleave 2 delay 0: 62411025 in 10 secs
Cpus 4, interleave 2 delay 0: 81963928 in 10 secs

-after:
Cpus 1, interleave 2 delay 0: 35527306 in 10 secs
Cpus 2, interleave 2 delay 0: 70922909 in 10 secs <<< + 28%
Cpus 3, interleave 2 delay 0: 80518538 in 10 secs
Cpus 4, interleave 2 delay 0: 89115148 in 10 secs <<< + 8.7%

i3, with 2 cores and with hyperthreading enabled.
Interleave 2 in order use first the full cores.
HT partially hides the delay from cacheline trashing, thus
the improvement is "only" 8.7% if 4 threads are running.

Andrew: Could you merge it into -akpm and then forward it towards Linus' tree?

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 70480a3..1afbc57 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -96,7 +96,7 @@ struct sem {
 	int	sempid;		/* pid of last operation */
 	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
 	struct list_head sem_pending; /* pending single-sop operations */
-};
+} ____cacheline_aligned_in_smp;
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
-- 
1.8.1.4


