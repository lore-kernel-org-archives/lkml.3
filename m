Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaJCV7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:59:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbaJCV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:59:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.16 286/357] powerpc: Add smp_mb()s to arch_spin_unlock_wait()
Date: Fri,  3 Oct 2014 14:31:12 -0700
Message-Id: <20141003212942.077046405@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit 78e05b1421fa41ae8457701140933baa5e7d9479 upstream.

Similar to the previous commit which described why we need to add a
barrier to arch_spin_is_locked(), we have a similar problem with
spin_unlock_wait().

We need a barrier on entry to ensure any spinlock we have previously
taken is visibly locked prior to the load of lock->slock.

It's also not clear if spin_unlock_wait() is intended to have ACQUIRE
semantics. For now be conservative and add a barrier on exit to give it
ACQUIRE semantics.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/lib/locks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/lib/locks.c
+++ b/arch/powerpc/lib/locks.c
@@ -70,12 +70,16 @@ void __rw_yield(arch_rwlock_t *rw)
 
 void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
+	smp_mb();
+
 	while (lock->slock) {
 		HMT_low();
 		if (SHARED_PROCESSOR)
 			__spin_yield(lock);
 	}
 	HMT_medium();
+
+	smp_mb();
 }
 
 EXPORT_SYMBOL(arch_spin_unlock_wait);


