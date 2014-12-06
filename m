Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaLFEQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:16:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaLFEQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:16:46 -0500
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au
Cc: kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
Subject: [PATCH v5 2/6] hw_random: move some code out mutex_lock for avoiding underlying deadlock
Date: Sat,  6 Dec 2014 12:16:38 +0800
Message-Id: <1417839402-13490-3-git-send-email-akong@redhat.com>
In-Reply-To: <1417839402-13490-1-git-send-email-akong@redhat.com>
References: <1417839402-13490-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In next patch, we use reference counting for each struct hwrng,
changing reference count also needs to take mutex_lock. Before
releasing the lock, if we try to stop a kthread that waits to
take the lock to reduce the referencing count, deadlock will
occur.

Signed-off-by: Amos Kong <akong@redhat.com>
---
 drivers/char/hw_random/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index b1b6042..a0905c8 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -474,12 +474,12 @@ void hwrng_unregister(struct hwrng *rng)
 		}
 	}
 	if (list_empty(&rng_list)) {
+		mutex_unlock(&rng_mutex);
 		unregister_miscdev();
 		if (hwrng_fill)
 			kthread_stop(hwrng_fill);
-	}
-
-	mutex_unlock(&rng_mutex);
+	} else
+		mutex_unlock(&rng_mutex);
 }
 EXPORT_SYMBOL_GPL(hwrng_unregister);
 
-- 
1.9.3

