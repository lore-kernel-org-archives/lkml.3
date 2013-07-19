Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab3GSOr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:47:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33313 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760265Ab3GSOr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:47:58 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-b6-51e9519c7ed6
From: Piotr Sarna <p.sarna@partner.samsung.com>
To: konrad.wilk@oracle.com
Cc: bob.liu@oracle.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        b.zolnierkie@samsung.com, Piotr Sarna <p.sarna@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] zcache: fix "zcache=" kernel parameter
Date: Fri, 19 Jul 2013 16:46:41 +0200
Message-id: <1374245201-24474-1-git-send-email-p.sarna@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xgO6cwJeBBhc3m1hsnLGe1aLr1FQW
	iz1nfrFbNC9ez2axbPFTRouzTW/YLS7vmsNmsWpRlAOHx719h1k89s9dw+7x8ektFo+D7/Yw
	efRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGnP0zGQs28FZcX63XwNjJ3cXIySEhYCKxYuky
	ZghbTOLCvfVsXYxcHEICixglPjw+zAzhtDNJ7Ho8lRGkik1AX+LL9TUsILaIgJTE6o33WEGK
	mAUeMUr8e/+cDSQhLGAuMatpCVgDi4CqRP+RbiYQm1fAW2Lqvh1AUzmA1ilIzJlkM4GRewEj
	wypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4LB5JrWDcWWDxSFGAQ5GJR7eB1+eBwqxJpYV
	V+YeYpTgYFYS4f2V/CJQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQi
	mCwTB6dUA2POwoiErRqpER7nlmSVB2fNSdDauyKBf2+olkT7hTOBedl/ZbSje6vWyN6fa78s
	WpE9K4/PROxNyg+fzb+Wzo4TLTsX37a3NF1XeeUkht3uAgl31n+Tv7xzpgDjmtx/yYu2MrnL
	pX10mtEnxm52JmnjjGm90dJrKvd4RFUqfM+3eHZs05zmMiWW4oxEQy3mouJEANNEnNQXAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 835f2f5 ("staging: zcache: enable zcache to be built/loaded as
a module") introduced an incorrect handling of "zcache=" parameter.

Inside zcache_comp_init() function, zcache_comp_name variable is
checked for being empty. If not empty, the above variable is tested
for being compatible with Crypto API. Unfortunately, after that
function ends unconditionally (by the "goto out" directive) and returns:
- non-zero value if verification succeeded, wrongly indicating an error
- zero value if verification failed, falsely informing that function
  zcache_comp_init() ended properly.

A solution to this problem is as following:
1. Move the "goto out" directive inside the "if (!ret)" statement
2. In case that crypto_has_comp() returned 0, change the value of ret
   to non-zero before "goto out" to indicate an error.

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/staging/zcache/zcache-main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index dcceed2..81972fa 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1811,10 +1811,12 @@ static int zcache_comp_init(void)
 #else
 	if (*zcache_comp_name != '\0') {
 		ret = crypto_has_comp(zcache_comp_name, 0, 0);
-		if (!ret)
+		if (!ret) {
 			pr_info("zcache: %s not supported\n",
 					zcache_comp_name);
-		goto out;
+			ret = 1;
+			goto out;
+		}
 	}
 	if (!ret)
 		strcpy(zcache_comp_name, "lzo");
-- 
1.7.9.5

