Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaAVTsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:48:46 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:60181 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbaAVTso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:48:44 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] clk: Fix notifier documentation
Date: Wed, 22 Jan 2014 11:48:37 -0800
Message-Id: <1390420117-25930-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contradicting to documenation, the notifier callbacks do receive
the original clock rate in struct clk_notifier_data.old_rate and the new
frequency struct clk_notifier_data.new_rate, independent of the
notification reason.

This behavior also seems to make more sense, since callbacks can use the
same code to deterimine whether clocks are scaled up or down. Something
which would not even possible in the post-rate-change case if the
behavior was as documented.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Hi Mike,

I am working with some clock notifiers and if my results are correct the
notifiers behave differently from how they are documented.
I think the actual behavior makes more sense than the documented and my original
plan was to change the behavior, but it seems I might get away with a
doc-update.

	Thanks,
	Sören

 drivers/clk/clk.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2cf2ea6b77a1..26825db03e64 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1983,20 +1983,11 @@ EXPORT_SYMBOL_GPL(devm_clk_unregister);
  * re-enter into the clk framework by calling any top-level clk APIs;
  * this will cause a nested prepare_lock mutex.
  *
- * Pre-change notifier callbacks will be passed the current, pre-change
- * rate of the clk via struct clk_notifier_data.old_rate.  The new,
- * post-change rate of the clk is passed via struct
+ * In all notification cases cases (pre, post and abort rate change) the
+ * original clock rate is passed to the callback via struct
+ * clk_notifier_data.old_rate and the new frequency is passed via struct
  * clk_notifier_data.new_rate.
  *
- * Post-change notifiers will pass the now-current, post-change rate of
- * the clk in both struct clk_notifier_data.old_rate and struct
- * clk_notifier_data.new_rate.
- *
- * Abort-change notifiers are effectively the opposite of pre-change
- * notifiers: the original pre-change clk rate is passed in via struct
- * clk_notifier_data.new_rate and the failed post-change rate is passed
- * in via struct clk_notifier_data.old_rate.
- *
  * clk_notifier_register() must be called from non-atomic context.
  * Returns -EINVAL if called with null arguments, -ENOMEM upon
  * allocation failure; otherwise, passes along the return value of
-- 
1.8.5.3

