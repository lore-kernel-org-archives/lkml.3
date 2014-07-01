Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbaGAVxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:53:43 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:38912 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831AbaGAVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:41 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 14/50] mars: add new file drivers/block/mars/lib_rank.c
Date: Tue,  1 Jul 2014 23:46:54 +0200
Message-Id: <1404251250-22992-15-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 drivers/block/mars/lib_rank.c | 73 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 drivers/block/mars/lib_rank.c

diff --git a/drivers/block/mars/lib_rank.c b/drivers/block/mars/lib_rank.c
new file mode 100644
index 0000000..384cb61
--- /dev/null
+++ b/drivers/block/mars/lib_rank.c
@@ -0,0 +1,73 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+/*  (c) 2012 Thomas Schoebel-Theuer */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <linux/brick/lib_rank.h>
+
+void ranking_compute(struct rank_data *rkd, const struct rank_info rki[], int x)
+{
+	int points = 0;
+	int i;
+
+	for (i = 0; ; i++) {
+		int x0;
+		int x1;
+		int y0;
+		int y1;
+
+		x0 = rki[i].rki_x;
+		if (x < x0)
+			break;
+
+		x1 = rki[i+1].rki_x;
+
+		if (unlikely(x1 == RKI_DUMMY)) {
+			points = rki[i].rki_y;
+			break;
+		}
+
+		if (x > x1)
+			continue;
+
+		y0 = rki[i].rki_y;
+		y1 = rki[i+1].rki_y;
+
+		/*  linear interpolation */
+		points = ((long long)(x - x0) * (long long)(y1 - y0)) / (x1 - x0) + y0;
+		break;
+	}
+	rkd->rkd_tmp += points;
+}
+EXPORT_SYMBOL_GPL(ranking_compute);
+
+int ranking_select(struct rank_data rkd[], int rkd_count)
+{
+	int res = -1;
+	long long max = LLONG_MIN / 2;
+	int i;
+
+	for (i = 0; i < rkd_count; i++) {
+		struct rank_data *tmp = &rkd[i];
+		long long rest = tmp->rkd_current_points;
+
+		if (rest <= 0)
+			continue;
+		/* rest -= tmp->rkd_got; */
+		if (rest > max) {
+			max = rest;
+			res = i;
+		}
+	}
+	/* Prevent underflow in the long term
+	 * and reset the "clocks" after each round of
+	 * weighted round-robin selection.
+	 */
+	if (max < 0 && res >= 0) {
+		for (i = 0; i < rkd_count; i++)
+			rkd[i].rkd_got += max;
+	}
+	return res;
+}
+EXPORT_SYMBOL_GPL(ranking_select);
-- 
2.0.0

