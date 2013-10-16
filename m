Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671Ab3JPRqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761396Ab3JPRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 42/69] ipc/sem.c: cacheline align the semaphore structures
Date: Wed, 16 Oct 2013 10:44:51 -0700
Message-Id: <20131016174318.061947399@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manfred Spraul <manfred@colorfullife.com>

commit f5c936c0f267ec58641451cf8b8d39b4c207ee4d upstream.

As now each semaphore has its own spinlock and parallel operations are
possible, give each semaphore its own cacheline.

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

i3, with 2 cores and with hyperthreading enabled.  Interleave 2 in order
use first the full cores.  HT partially hides the delay from cacheline
trashing, thus the improvement is "only" 8.7% if 4 threads are running.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


