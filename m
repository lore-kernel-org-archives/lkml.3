Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaCWTds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:33:48 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48784 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaCWTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:33:47 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: rcj@linux.vnet.ibm.com, mhcerri@linux.vnet.ibm.com, fin@linux.vnet.ibm.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/crypto: Use RCU_INIT_POINTER(x, NULL) in nx/nx-842.c
Date: Mon, 24 Mar 2014 01:02:42 +0530
Message-Id: <1395603162-16746-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/crypto/nx/nx-842.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 1e5481d..c4fcbf4 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -1234,7 +1234,7 @@ static int __exit nx842_remove(struct vio_dev *viodev)
 	old_devdata = rcu_dereference_check(devdata,
 			lockdep_is_held(&devdata_mutex));
 	of_reconfig_notifier_unregister(&nx842_of_nb);
-	rcu_assign_pointer(devdata, NULL);
+	RCU_INIT_POINTER(devdata, NULL);
 	spin_unlock_irqrestore(&devdata_mutex, flags);
 	synchronize_rcu();
 	dev_set_drvdata(&viodev->dev, NULL);
@@ -1285,7 +1285,7 @@ static void __exit nx842_exit(void)
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
 			lockdep_is_held(&devdata_mutex));
-	rcu_assign_pointer(devdata, NULL);
+	RCU_INIT_POINTER(devdata, NULL);
 	spin_unlock_irqrestore(&devdata_mutex, flags);
 	synchronize_rcu();
 	if (old_devdata)
-- 
1.7.9.5

