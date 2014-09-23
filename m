Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaIWJ7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:59:20 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62740 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaIWJ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:59:18 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] of: fdt: fix memory range check
Date: Tue, 23 Sep 2014 10:59:09 +0100
Message-Id: <1411466349-14166-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cases where board has below memory DT node

memory{
	device_type = "memory";
	reg = <0x80000000 0x80000000>;
};

Check on the memory range in fdt.c will always fail because it is
comparing MAX_PHYS_ADDR with base + size, in fact it should compare
it with base + size - 1.

This issue was originally noticed on Qualcomm IFC6410 board.
Without this patch kernel shows up noticed unnecessary warnings

[    0.000000] Machine model: Qualcomm APQ8064/IFC6410
[    0.000000] Ignoring memory range 0xffffffff - 0x100000000
[    0.000000] cma: Reserved 64 MiB at ab800000

as a result the size get reduced to 0x7fffffff which looks wrong.

This patch fixes the check involved in generating this warning and
as a result it also fixes the wrong size calculation.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 79cb831..3f5736c 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -937,7 +937,7 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 		return;
 	}
 
-	if (base + size > MAX_PHYS_ADDR) {
+	if (base + size - 1 > MAX_PHYS_ADDR) {
 		pr_warning("Ignoring memory range 0x%lx - 0x%llx\n",
 				ULONG_MAX, base + size);
 		size = MAX_PHYS_ADDR - base;
-- 
1.9.1

