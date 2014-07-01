Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbaGAV5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:57:35 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:8238 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758880AbaGAVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:52 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 18/50] mars: add new file drivers/block/mars/lib_limiter.c
Date: Tue,  1 Jul 2014 23:46:58 +0200
Message-Id: <1404251250-22992-19-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 drivers/block/mars/lib_limiter.c | 103 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 drivers/block/mars/lib_limiter.c

diff --git a/drivers/block/mars/lib_limiter.c b/drivers/block/mars/lib_limiter.c
new file mode 100644
index 0000000..e8984b7
--- /dev/null
+++ b/drivers/block/mars/lib_limiter.c
@@ -0,0 +1,103 @@
+/*  (c) 2012 Thomas Schoebel-Theuer / 1&1 Internet AG */
+
+#include <linux/brick/lib_limiter.h>
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#define LIMITER_TIME_RESOLUTION		NSEC_PER_SEC
+
+int xio_limit(struct xio_limiter *lim, int amount)
+{
+	int delay = 0;
+	long long now;
+
+	now = cpu_clock(raw_smp_processor_id());
+
+	/* Compute the maximum delay along the path
+	 * down to the root of the hierarchy tree.
+	 */
+	while (lim != NULL) {
+		long long window = now - lim->lim_stamp;
+
+		/* Sometimes, raw CPU clocks may do weired things...
+		 * Smaller windows in the denominator than 1s could fake unrealistic rates.
+		 */
+		if (unlikely(lim->lim_min_window <= 0))
+			lim->lim_min_window = 1000;
+		if (unlikely(lim->lim_max_window <= lim->lim_min_window))
+			lim->lim_max_window = lim->lim_min_window + 8000;
+		if (unlikely(window < (long long)lim->lim_min_window * (LIMITER_TIME_RESOLUTION / 1000)))
+			window = (long long)lim->lim_min_window * (LIMITER_TIME_RESOLUTION / 1000);
+
+		/* Only use incremental accumulation at repeated calls, but
+		 * never after longer pauses.
+		 */
+		if (likely(lim->lim_stamp &&
+			   window < (long long)lim->lim_max_window * (LIMITER_TIME_RESOLUTION / 1000))) {
+			long long rate_raw;
+			int rate;
+
+			/* Races are possible, but taken into account.
+			 * There is no real harm from rarely lost updates.
+			 */
+			if (likely(amount > 0)) {
+				lim->lim_accu += amount;
+				lim->lim_cumul += amount;
+				lim->lim_count++;
+			}
+
+			rate_raw = lim->lim_accu * LIMITER_TIME_RESOLUTION / window;
+			rate = rate_raw;
+			if (unlikely(rate_raw > INT_MAX))
+				rate = INT_MAX;
+			lim->lim_rate = rate;
+
+			/*  limit exceeded? */
+			if (lim->lim_max_rate > 0 && rate > lim->lim_max_rate) {
+				int this_delay = (window * rate / lim->lim_max_rate - window) / (LIMITER_TIME_RESOLUTION / 1000);
+
+				/*  compute maximum */
+				if (this_delay > delay && this_delay > 0)
+					delay = this_delay;
+			}
+
+			/* Try to keep the next window below min_window
+			 */
+			window -= lim->lim_min_window * (LIMITER_TIME_RESOLUTION / 1000);
+			if (window > 0) {
+				long long used_up = (long long)lim->lim_rate * window / LIMITER_TIME_RESOLUTION;
+
+				if (used_up > 0) {
+					lim->lim_stamp += window;
+					lim->lim_accu -= used_up;
+					if (unlikely(lim->lim_accu < 0))
+						lim->lim_accu = 0;
+				}
+			}
+		} else { /*  reset, start over with new measurement cycle */
+			if (unlikely(amount < 0))
+				amount = 0;
+			lim->lim_accu = amount;
+			lim->lim_stamp = now - lim->lim_min_window * (LIMITER_TIME_RESOLUTION / 1000);
+			lim->lim_rate = 0;
+		}
+		lim = lim->lim_father;
+	}
+	return delay;
+}
+EXPORT_SYMBOL_GPL(xio_limit);
+
+void xio_limit_sleep(struct xio_limiter *lim, int amount)
+{
+	int sleep = xio_limit(lim, amount);
+
+	if (sleep > 0) {
+		if (unlikely(lim->lim_max_delay <= 0))
+			lim->lim_max_delay = 1000;
+		if (sleep > lim->lim_max_delay)
+			sleep = lim->lim_max_delay;
+		brick_msleep(sleep);
+	}
+}
+EXPORT_SYMBOL_GPL(xio_limit_sleep);
-- 
2.0.0

