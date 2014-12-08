Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaLHIvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:51:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbaLHIvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:51:36 -0500
From: Amos Kong <akong@redhat.com>
To: linux-crypto@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, herbert@gondor.apana.org.au,
        rusty@rustcorp.com.au, kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH v5 REPOST 2/6] hw_random: move some code out mutex_lock for avoiding underlying deadlock
Date: Mon,  8 Dec 2014 16:50:36 +0800
Message-Id: <1418028640-4891-3-git-send-email-akong@redhat.com>
In-Reply-To: <1418028640-4891-1-git-send-email-akong@redhat.com>
References: <1418028640-4891-1-git-send-email-akong@redhat.com>
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

