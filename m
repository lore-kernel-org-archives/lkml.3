Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaGJHey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:34:54 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18281 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaGJHeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:34:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 Jul 2014 00:27:46 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/3] drm/nouveau/clk: make therm and volt devices optional
Date: Thu, 10 Jul 2014 16:34:35 +0900
Message-ID: <1404977677-22248-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404977677-22248-1-git-send-email-acourbot@nvidia.com>
References: <1404977677-22248-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the clock subsystem to operate even if voltage and thermal devices
are not set for the device (for people with watercooling! ;))

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/clock/base.c | 36 +++++++++++++++---------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
index 22351f594d2a..63b314a033cb 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
@@ -90,16 +90,20 @@ nouveau_cstate_prog(struct nouveau_clock *clk,
 		cstate = &pstate->base;
 	}
 
-	ret = nouveau_therm_cstate(ptherm, pstate->fanspeed, +1);
-	if (ret && ret != -ENODEV) {
-		nv_error(clk, "failed to raise fan speed: %d\n", ret);
-		return ret;
+	if (ptherm) {
+		ret = nouveau_therm_cstate(ptherm, pstate->fanspeed, +1);
+		if (ret && ret != -ENODEV) {
+			nv_error(clk, "failed to raise fan speed: %d\n", ret);
+			return ret;
+		}
 	}
 
-	ret = volt->set_id(volt, cstate->voltage, +1);
-	if (ret && ret != -ENODEV) {
-		nv_error(clk, "failed to raise voltage: %d\n", ret);
-		return ret;
+	if (volt) {
+		ret = volt->set_id(volt, cstate->voltage, +1);
+		if (ret && ret != -ENODEV) {
+			nv_error(clk, "failed to raise voltage: %d\n", ret);
+			return ret;
+		}
 	}
 
 	ret = clk->calc(clk, cstate);
@@ -108,13 +112,17 @@ nouveau_cstate_prog(struct nouveau_clock *clk,
 		clk->tidy(clk);
 	}
 
-	ret = volt->set_id(volt, cstate->voltage, -1);
-	if (ret && ret != -ENODEV)
-		nv_error(clk, "failed to lower voltage: %d\n", ret);
+	if (volt) {
+		ret = volt->set_id(volt, cstate->voltage, -1);
+		if (ret && ret != -ENODEV)
+			nv_error(clk, "failed to lower voltage: %d\n", ret);
+	}
 
-	ret = nouveau_therm_cstate(ptherm, pstate->fanspeed, -1);
-	if (ret && ret != -ENODEV)
-		nv_error(clk, "failed to lower fan speed: %d\n", ret);
+	if (ptherm) {
+		ret = nouveau_therm_cstate(ptherm, pstate->fanspeed, -1);
+		if (ret && ret != -ENODEV)
+			nv_error(clk, "failed to lower fan speed: %d\n", ret);
+	}
 
 	return 0;
 }
-- 
2.0.0

