Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3BCBWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:22:35 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58469 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab3BCBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:31 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org
Subject: [PATCH 39/62] ppp: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:40 -0800
Message-Id: <1359854463-2538-40-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-ppp@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/net/ppp/ppp_generic.c | 33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 0b2706a..7efdb91 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2946,46 +2946,21 @@ static void __exit ppp_cleanup(void)
  * by holding all_ppp_mutex
  */
 
-static int __unit_alloc(struct idr *p, void *ptr, int n)
-{
-	int unit, err;
-
-again:
-	if (!idr_pre_get(p, GFP_KERNEL)) {
-		pr_err("PPP: No free memory for idr\n");
-		return -ENOMEM;
-	}
-
-	err = idr_get_new_above(p, ptr, n, &unit);
-	if (err < 0) {
-		if (err == -EAGAIN)
-			goto again;
-		return err;
-	}
-
-	return unit;
-}
-
 /* associate pointer with specified number */
 static int unit_set(struct idr *p, void *ptr, int n)
 {
 	int unit;
 
-	unit = __unit_alloc(p, ptr, n);
-	if (unit < 0)
-		return unit;
-	else if (unit != n) {
-		idr_remove(p, unit);
-		return -EINVAL;
-	}
-
+	unit = idr_alloc(p, ptr, n, n + 1, GFP_KERNEL);
+	if (unit == -ENOSPC)
+		unit = -EINVAL;
 	return unit;
 }
 
 /* get new free unit number and associate pointer with it */
 static int unit_get(struct idr *p, void *ptr)
 {
-	return __unit_alloc(p, ptr, 0);
+	return idr_alloc(p, ptr, 0, 0, GFP_KERNEL);
 }
 
 /* put unit number back to a pool */
-- 
1.8.1

