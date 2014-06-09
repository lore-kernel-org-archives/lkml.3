Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbaFIJJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:09:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58451 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754889AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 024/146] gpu: host1x: handle the correct # of syncpt regs
Date: Mon,  9 Jun 2014 10:49:19 +0200
Message-Id: <5fc7e548c184705e46aac7d5149febc95001691f.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/host1x/hw/intr_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/hw/intr_hw.c b/drivers/gpu/host1x/hw/intr_hw.c
index b592eef1efcb..b083509325e4 100644
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
1.9.3

