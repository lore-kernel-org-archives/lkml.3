Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbaEPNgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:36:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaEPNgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:36:08 -0400
Date: Fri, 16 May 2014 06:35:10 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-3dfd442e5ffc6c488e34b6f1028bbb0ce310e6c4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        cmetcalf@tilera.com, tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154337.873477334@linutronix.de>
References: <20140507154337.873477334@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] tile: hvc: Use irq_alloc/free_hwirq
Git-Commit-ID: 3dfd442e5ffc6c488e34b6f1028bbb0ce310e6c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3dfd442e5ffc6c488e34b6f1028bbb0ce310e6c4
Gitweb:     http://git.kernel.org/tip/3dfd442e5ffc6c488e34b6f1028bbb0ce310e6c4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:15 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:20 +0200

tile: hvc: Use irq_alloc/free_hwirq

No functional change. Just convert to the new interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20140507154337.873477334@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/tty/hvc/hvc_tile.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/hvc/hvc_tile.c b/drivers/tty/hvc/hvc_tile.c
index af8cdaa..147d49e 100644
--- a/drivers/tty/hvc/hvc_tile.c
+++ b/drivers/tty/hvc/hvc_tile.c
@@ -133,14 +133,14 @@ static int hvc_tile_probe(struct platform_device *pdev)
 	int tile_hvc_irq;
 
 	/* Create our IRQ and register it. */
-	tile_hvc_irq = create_irq();
-	if (tile_hvc_irq < 0)
+	tile_hvc_irq = irq_alloc_hwirq(-1);
+	if (!tile_hvc_irq)
 		return -ENXIO;
 
 	tile_irq_activate(tile_hvc_irq, TILE_IRQ_PERCPU);
 	hp = hvc_alloc(0, tile_hvc_irq, &hvc_tile_get_put_ops, 128);
 	if (IS_ERR(hp)) {
-		destroy_irq(tile_hvc_irq);
+		irq_free_hwirq(tile_hvc_irq);
 		return PTR_ERR(hp);
 	}
 	dev_set_drvdata(&pdev->dev, hp);
@@ -155,7 +155,7 @@ static int hvc_tile_remove(struct platform_device *pdev)
 
 	rc = hvc_remove(hp);
 	if (rc == 0)
-		destroy_irq(hp->data);
+		irq_free_hwirq(hp->data);
 
 	return rc;
 }
