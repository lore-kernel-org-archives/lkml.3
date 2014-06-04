Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbaFEAqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:46:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaFDXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 3.14 027/228] gpu: host1x: handle the correct # of syncpt regs
Date: Wed,  4 Jun 2014 16:20:56 -0700
Message-Id: <20140604232348.956731170@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/host1x/hw/intr_hw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/host1x/hw/intr_hw.c
+++ b/drivers/gpu/host1x/hw/intr_hw.c
@@ -47,7 +47,7 @@ static irqreturn_t syncpt_thresh_isr(int
 	unsigned long reg;
 	int i, id;
 
-	for (i = 0; i <= BIT_WORD(host->info->nb_pts); i++) {
+	for (i = 0; i < DIV_ROUND_UP(host->info->nb_pts, 32); i++) {
 		reg = host1x_sync_readl(host,
 			HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS(i));
 		for_each_set_bit(id, &reg, BITS_PER_LONG) {
@@ -64,7 +64,7 @@ static void _host1x_intr_disable_all_syn
 {
 	u32 i;
 
-	for (i = 0; i <= BIT_WORD(host->info->nb_pts); ++i) {
+	for (i = 0; i < DIV_ROUND_UP(host->info->nb_pts, 32); ++i) {
 		host1x_sync_writel(host, 0xffffffffu,
 			HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE(i));
 		host1x_sync_writel(host, 0xffffffffu,


