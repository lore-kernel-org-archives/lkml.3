Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaDXJEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:04:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47155 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaDXI4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@nvidia.com>, Thierry Reding <treding@nvidia.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 176/182] gpu: host1x: handle the correct # of syncpt regs
Date: Thu, 24 Apr 2014 09:51:41 +0100
Message-Id: <1398329507-5911-177-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 22bbd5d949dc7fdd72a4e78e767fa09d8e54b446 upstream.

BIT_WORD() truncates rather than rounds, so the loops in
syncpt_thresh_isr() and _host1x_intr_disable_all_syncpt_intrs() use <=
rather than < in an attempt to process the correct number of registers
when rounding of the conversion of count of bits to count of words is
necessary. However, when rounding isn't necessary because the value is
already a multiple of the divisor (as is the case for all values of
nb_pts the code actually sees), this causes one too many registers to
be processed.

Solve this by using and explicit DIV_ROUND_UP() call, rather than
BIT_WORD(), and comparing with < rather than <=.

Fixes: 7ede0b0bf3e2 ("gpu: host1x: Add syncpoint wait and interrupts")
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-By: Terje Bergstrom <tbergstrom@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/host1x/hw/intr_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/hw/intr_hw.c b/drivers/gpu/host1x/hw/intr_hw.c
index b592eef..b083509 100644
--- a/drivers/gpu/host1x/hw/intr_hw.c
+++ b/drivers/gpu/host1x/hw/intr_hw.c
@@ -48,7 +48,7 @@ static irqreturn_t syncpt_thresh_isr(int irq, void *dev_id)
 	unsigned long reg;
 	int i, id;
 
-	for (i = 0; i <= BIT_WORD(host->info->nb_pts); i++) {
+	for (i = 0; i < DIV_ROUND_UP(host->info->nb_pts, 32); i++) {
 		reg = host1x_sync_readl(host,
 			HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS(i));
 		for_each_set_bit(id, &reg, BITS_PER_LONG) {
@@ -65,7 +65,7 @@ static void _host1x_intr_disable_all_syncpt_intrs(struct host1x *host)
 {
 	u32 i;
 
-	for (i = 0; i <= BIT_WORD(host->info->nb_pts); ++i) {
+	for (i = 0; i < DIV_ROUND_UP(host->info->nb_pts, 32); ++i) {
 		host1x_sync_writel(host, 0xffffffffu,
 			HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE(i));
 		host1x_sync_writel(host, 0xffffffffu,
-- 
1.9.1

