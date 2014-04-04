Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaDDHvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:51:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60575 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaDDHvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:51:35 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-30-533e64831151
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] leds: 88pm860x: Fix missing refcount decrement for parent
 of_node
Date: Fri, 04 Apr 2014 09:51:20 +0200
Message-id: <1396597880-2325-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396597880-2325-1-git-send-email-k.kozlowski@samsung.com>
References: <1396597880-2325-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t/xy7otKXbBBp84LY7unMhk8fqFocXl
	XXPYLLa+WcdosXvXU1YHVo+ds+6ye+yZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDKm
	/u5nLdjHWXH52hrGBsYf7F2MnBwSAiYSnxrOMEPYYhIX7q1n62Lk4hASWMoo8X3yGXYIp49J
	YvuzZjaQKjYBY4nNy5eAVYkINDJKdD7azwSSYBYwlPj57g9QBweHsECExLyjwiBhFgFVidVL
	z7GA2LwCbhKtJ16ClUgIKEjMmWQDEuYUcJf4PnUH2HghoJJjtyexTWDkXcDIsIpRNLU0uaA4
	KT3XUK84Mbe4NC9dLzk/dxMjJGS+7GBcfMzqEKMAB6MSD29Cpm2wEGtiWXFl7iFGCQ5mJRHe
	vkC7YCHelMTKqtSi/Pii0pzU4kOMTBycUg2MjFbGPqInduRdmdczbZpy3/2E0+s5fpmFTmCP
	fn2/reS+QGVn0Mop05MXunlxulTqn9e16d6hs8N2u/qDEK4TYVPkVsl+aZ32bNIKLUWptYGT
	z+2XOq/tNV/Lpa/KJf3cnJUKlSfmLjs18eTt2RNaVdiP6Gulb7/E/ty1YcPyQz5zH9x4WlM6
	V4mlOCPRUIu5qDgRAJysYOX3AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver obtained the reference to parent->of_node but immediately it
was overwritten by reference to child node 'leds'. The of_node_put at
the end of DT parsing function decremented only the child 'leds' so
effectively the reference to parent of_node leaked.

Getting reference to parent->of_node is not needed at all so get rid of
it to fix the reference count.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/leds/leds-88pm860x.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index 2f9ee538f30d..fb7c310e9f20 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -131,10 +131,9 @@ static int pm860x_led_dt_init(struct platform_device *pdev,
 	struct device_node *nproot, *np;
 	int iset = 0;
 
-	nproot = of_node_get(pdev->dev.parent->of_node);
-	if (!nproot)
+	if (!pdev->dev.parent->of_node)
 		return -ENODEV;
-	nproot = of_get_child_by_name(nproot, "leds");
+	nproot = of_get_child_by_name(pdev->dev.parent->of_node, "leds");
 	if (!nproot) {
 		dev_err(&pdev->dev, "failed to find leds node\n");
 		return -ENODEV;
-- 
1.7.9.5

