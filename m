Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaCMIG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:06:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32859 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaCMIGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:06:22 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-31-532166f9d190
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regmap: irq: Set data pointer only on regmap_add_irq_chip
 success
Date: Thu, 13 Mar 2014 09:06:01 +0100
Message-id: <1394697961-4440-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xq7o/0xSDDRp7hCymPnzCZtG8eD2b
	xesXhhaXd81hc2Dx2LSqk81j/9w17B59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVse/hWtaC
	o1wVB9+sZWlgvMDRxcjJISFgIjF/cQ8zhC0mceHeerYuRi4OIYGljBIr9u9mh3D6mCRm3PrG
	AlLFJmAssXn5EjYQW0SgRGLPrSYmEJtZwFDi57s/7CC2sECIxIe3F8GmsgioSjSenAlUz8HB
	K+AmcWWlEIgpIaAgMWeSzQRG7gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQjz/ZQfj
	4mNWhxgFOBiVeHhXLFcIFmJNLCuuzD3EKMHBrCTC6+mjGCzEm5JYWZValB9fVJqTWnyIkYmD
	U6qB0Wmt5OWzTyYtPXz84Pdrn9mOLdgl71y4aNY9V48DNlu39O9l33zvicRnjRP/GpapF9QU
	LhC+Z8a2bg6fsMORF/NffVeOmSUh8uP49J97F/y6YXPo4dWIB9Nv3zzU3Pxw0R4zjsfmKRp/
	JIUeNSYYRizy1NZcYddx4cxihiv7KrLOfcmv052yqzJXiaU4I9FQi7moOBEA8Bf4AtoBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After setting the 'data' pointer (wchich is returned to the caller for
freeing later) the regmap_add_irq_chip() could still fail for various
reasons (ENOMEM, regmap_read or regmap_write failure). In such case the
memory under 'data' was freed in error path and error value was returned
but the 'data' variable was not changed.

This could lead to errors if the caller passed such 'data' to
regmap_del_irq_chip().

The 'data' pointer should be changed atomically from the caller
perspective - set it only on regmap_add_irq_chip() success.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/base/regmap/regmap-irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 82692068d3cb..6d5d04d473f1 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -368,8 +368,6 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	if (!d)
 		return -ENOMEM;
 
-	*data = d;
-
 	d->status_buf = kzalloc(sizeof(unsigned int) * chip->num_regs,
 				GFP_KERNEL);
 	if (!d->status_buf)
@@ -506,6 +504,8 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 		goto err_domain;
 	}
 
+	*data = d;
+
 	return 0;
 
 err_domain:
-- 
1.7.9.5

