Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab3HNKv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:51:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab3HNKhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 32/75] powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)
Date: Wed, 14 Aug 2013 11:36:21 +0100
Message-Id: <1376476624-10011-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit fe956a1d4081ce1a959f87df397a15e252201f10 upstream.

slots-fan on G5 Xserve is always running at full speed with windfarm_rm31
driver, resulting in a very high acoustic noise level. It seems the fan
parameters are incorrect, and have been copied from the Drive Bay fan
(RPM, not present on rm31) of the legacy therm_pm72 driver. This patch
changes the parameters to match the Slots fan (PWM) of therm_pm72. With
the patch, slots-fan speed drops from 99% to 19% during normal use,
and slots-temp settle to ~42'C.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/macintosh/windfarm_rm31.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/macintosh/windfarm_rm31.c b/drivers/macintosh/windfarm_rm31.c
index 3eca6d4..e13d9fd 100644
--- a/drivers/macintosh/windfarm_rm31.c
+++ b/drivers/macintosh/windfarm_rm31.c
@@ -439,15 +439,15 @@ static void backside_setup_pid(void)
 
 /* Slots fan */
 static const struct wf_pid_param slots_param = {
-	.interval	= 5,
-	.history_len	= 2,
-	.gd		= 30 << 20,
-	.gp		= 5 << 20,
-	.gr		= 0,
-	.itarget	= 40 << 16,
-	.additive	= 1,
-	.min		= 300,
-	.max		= 4000,
+	.interval	= 1,
+	.history_len	= 20,
+	.gd		= 0,
+	.gp		= 0,
+	.gr		= 0x00100000,
+	.itarget	= 3200000,
+	.additive	= 0,
+	.min		= 20,
+	.max		= 100,
 };
 
 static void slots_fan_tick(void)
-- 
1.8.3.2

