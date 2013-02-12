Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3BLUfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:35:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3BLUfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gary Leshner <gary.s.leshner@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 06/61] IB/qib: Fix for broken sparse warning fix
Date: Tue, 12 Feb 2013 12:34:26 -0800
Message-Id: <20130212203418.895990053@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit d359f35430c4ea4dd4e24d809aeaeff1fa54c314 upstream.

Commit 1fb9fed6d489 ("IB/qib: Fix QP RCU sparse warning") broke QP
hash list deletion in qp_remove() badly.

This patch restores the former for loop behavior, while still fixing
the sparse warnings.

Reviewed-by: Gary Leshner <gary.s.leshner@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/qib/qib_qp.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -263,20 +263,15 @@ static void remove_qp(struct qib_ibdev *
 		struct qib_qp __rcu **qpp;
 
 		qpp = &dev->qp_table[n];
-		q = rcu_dereference_protected(*qpp,
-			lockdep_is_held(&dev->qpt_lock));
-		for (; q; qpp = &q->next) {
+		for (; (q = rcu_dereference_protected(*qpp,
+				lockdep_is_held(&dev->qpt_lock))) != NULL;
+				qpp = &q->next)
 			if (q == qp) {
 				atomic_dec(&qp->refcount);
 				*qpp = qp->next;
 				rcu_assign_pointer(qp->next, NULL);
-				q = rcu_dereference_protected(*qpp,
-					lockdep_is_held(&dev->qpt_lock));
 				break;
 			}
-			q = rcu_dereference_protected(*qpp,
-				lockdep_is_held(&dev->qpt_lock));
-		}
 	}
 
 	spin_unlock_irqrestore(&dev->qpt_lock, flags);


