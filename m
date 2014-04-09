Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbaDIJ4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:56:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60684 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbaDIJ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:56:32 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-a1-5345194c0429
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] extcon: max14577: Fix probe failure on successful work queue
Date: Wed, 09 Apr 2014 11:56:09 +0200
Message-id: <1397037369-24995-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJMWRmVeSWpSXmKPExsVy+t/xq7o+kq7BBqs7OSyuf3nOavH6haHF
	5V1z2CxuN65gs1iw8RGjA6tH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVwZezb94W1oJG7YvHP
	t2wNjKs4uxg5OSQETCQO7XrIBGGLSVy4t56ti5GLQ0hgKaPEgq8boZw+Jok/y/6wgFSxCRhL
	bF6+hA3EFhEolHiy4SqYzSzgKfHu70N2EFtYwFdix7uvYPUsAqoSa3vOM3cxcnDwCrhLfN/o
	C7FMQWLZl7XMExi5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQI8fiXHYyLj1kdYhTg
	YFTi4VWwdAkWYk0sK67MPcQowcGsJML7nM01WIg3JbGyKrUoP76oNCe1+BAjEwenVANjNxv7
	0cKeNoYfpcbnUmZwp89P8k+tv/4tVLZzmVvEKb0d+/aqbGr9Kpfoutv+8P/TexfseaoUG9h1
	2kKn0vVk+wXr2ti4d+uufp3Rmbbp/Zdn71mCpwbUXhG77H7Px3hdqnTZ5Uv9Sy9eZKttbDpy
	Kj0k+rPJjhNbhaqfT5r78mB2wFSWW/xzlViKMxINtZiLihMBC5d7FtYBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In probe the driver queued delayed work for cable detection and
returned the result of queue_delayed_work() call. However the return
value of queue_delayed_work() does not indicate an error and in normal
condition it returns true which means successful work queue.
This effectively resulted in probe failure:
[    2.088204] max14577-muic: probe of max77836-muic failed with error 1

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 962e56bfcf0b ("extcon: max14577: Add extcon-max14577 driver...")
---
 drivers/extcon/extcon-max14577.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 3846941801b8..1fef08dc7c0f 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -710,13 +710,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	 * driver should notify cable state to upper layer.
 	 */
 	INIT_DELAYED_WORK(&info->wq_detcable, max14577_muic_detect_cable_wq);
-	ret = queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
+	queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
 			delay_jiffies);
-	if (ret < 0) {
-		dev_err(&pdev->dev,
-			"failed to schedule delayed work for cable detect\n");
-		goto err_extcon;
-	}
 
 	return ret;
 
-- 
1.8.3.2

