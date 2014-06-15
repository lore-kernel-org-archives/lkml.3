Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaFONMM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:12:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaFONMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:12:03 -0400
Message-Id: <20140615130153.638054585@chello.nl>
User-Agent: quilt/0.61-1
Date: Sun, 15 Jun 2014 14:47:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 06/11] qspinlock: Optimize pending bit
References: <20140615124657.264658593@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-prolong-pending.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

XXX: merge into the pending bit patch..

It is possible so observe the pending bit without the locked bit when
the last owner has just released but the pending owner has not yet
taken ownership.

In this case we would normally queue -- because the pending bit is
already taken. However, in this case the pending bit is guaranteed to
be released 'soon', therefore wait for it and avoid queueing.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/locking/qspinlock.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/kernel/locking/qspinlock.c
===================================================================
--- linux-2.6.orig/kernel/locking/qspinlock.c
+++ linux-2.6/kernel/locking/qspinlock.c
@@ -226,6 +226,16 @@ void queue_spin_lock_slowpath(struct qsp
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
 	/*
+	 * wait for in-progress pending->locked hand-overs
+	 *
+	 * 0,1,0 -> 0,0,1
+	 */
+	if (val == _Q_PENDING_VAL) {
+		while ((val = atomic_read(&lock->val)) == _Q_PENDING_VAL)
+			cpu_relax();
+	}
+
+	/*
 	 * trylock || pending
 	 *
 	 * 0,0,0 -> 0,0,1 ; trylock


