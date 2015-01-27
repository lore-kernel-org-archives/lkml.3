Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbbA0PwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:52:12 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49919 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbbA0PwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:52:06 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e9-54c7b3924eae
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] power_supply: 88pm860x: Fix leaked power supply on probe fail
Date: Tue, 27 Jan 2015 16:51:54 +0100
Message-id: <1422373914-17235-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xa7qTNh8PMfj3wMRi0pP3zBYTV05m
	tnj9wtDi8q45bBafe48wWpzeXWKxYOMjRgd2j52z7rJ7bF6h5bFpVSebR9+WVYwenzfJBbBG
	cdmkpOZklqUW6dslcGWcmdzAXrCHrWLOt6+sDYyHWbsYOTkkBEwk7u/qZIawxSQu3FvP1sXI
	xSEksJRR4sn0ZawQTh+TxLslG9lBqtgEjCU2L18CViUisJtRYsLU5SwgCWYBT4l3fx+CFQkL
	+El8nt8FFOfgYBFQlXh5PQgkzCvgLjH71zs2iG1yEiePTWadwMi9gJFhFaNoamlyQXFSeq6h
	XnFibnFpXrpecn7uJkZIgHzZwbj4mNUhRgEORiUeXo6i4yFCrIllxZW5hxglOJiVRHj/bwAK
	8aYkVlalFuXHF5XmpBYfYmTi4JRqYDSxLwk4tfRd+987Vq6+0yVYg47XvpzHcNHw+uIgTcNv
	rhsaShUsTml+K1FxF5t4+9Ts1IOm6yIz7iyb757xLOvLxy/WzE4JodOXqge7v15z+ewBwTkf
	o/x9E62ZnsxrYP1zXUpmOfe3yZdOtiitUpjHk7f59ju7WfsFTzBeXLD78SGGKTbrL95TYinO
	SDTUYi4qTgQAyMvpO+4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver forgot to unregister power supply if request_threaded_irq()
failed in probe(). In such case the memory associated with power supply
leaked.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: a830d28b48bf ("power_supply: Enable battery-charger for 88pm860x")
Cc: <stable@vger.kernel.org>
---
 drivers/power/88pm860x_charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index 650930e4fa79..734ec4afa14d 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -711,6 +711,7 @@ static int pm860x_charger_probe(struct platform_device *pdev)
 	return 0;
 
 out_irq:
+	power_supply_unregister(&info->usb);
 	while (--i >= 0)
 		free_irq(info->irq[i], info);
 out:
-- 
1.9.1

