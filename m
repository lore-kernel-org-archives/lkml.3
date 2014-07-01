Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022AbaGAV7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:59:05 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:15252 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbaGAVxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:47 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 13/50] mars: add new file include/linux/brick/lib_rank.h
Date: Tue,  1 Jul 2014 23:46:53 +0200
Message-Id: <1404251250-22992-14-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/brick/lib_rank.h | 119 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 119 insertions(+)
 create mode 100644 include/linux/brick/lib_rank.h

diff --git a/include/linux/brick/lib_rank.h b/include/linux/brick/lib_rank.h
new file mode 100644
index 0000000..f0ba222
--- /dev/null
+++ b/include/linux/brick/lib_rank.h
@@ -0,0 +1,119 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+/*  (c) 2012 Thomas Schoebel-Theuer */
+
+#ifndef LIB_RANK_H
+#define LIB_RANK_H
+
+/* Generic round-robin scheduler based on ranking information.
+ */
+
+#define RKI_DUMMY			INT_MIN
+
+struct rank_info {
+	int rki_x;
+	int rki_y;
+};
+
+struct rank_data {
+	/*  public readonly */
+	long long rkd_current_points;
+
+	/*  private */
+	long long rkd_tmp;
+	long long rkd_got;
+};
+
+/* Ranking phase.
+ *
+ * Calls should follow the following usage pattern:
+ *
+ *     ranking_start(...);
+ *     for (...) {
+ *	       ranking_compute(&rkd[this_time], ...);
+ *	       // usually you need at least 1 call for each rkd[] element,
+ *	       // but you can call more often to include ranking information
+ *	       // from many different sources.
+ *	       // Note: instead / additionally, you may also use
+ *	       // ranking_add() or ranking_override().
+ *     }
+ *     ranking_stop(...);
+ *
+ * => now the new ranking values are computed and already active
+ * for the round-robin ranking_select() mechanism described below.
+ *
+ * Important: the rki[] array describes a ranking function at some
+ * example points (x_i, y_i) which must be ordered according to x_i
+ * in ascending order. And, of course, you need to supply at least
+ * two sample points (otherwise a linear function cannot
+ * be described).
+ * The array _must_ always end with a dummy record where the x_i has the
+ * value RKI_DUMMY.
+ */
+
+extern inline
+void ranking_start(struct rank_data rkd[], int rkd_count)
+{
+	int i;
+
+	for (i = 0; i < rkd_count; i++)
+		rkd[i].rkd_tmp = 0;
+}
+
+extern void ranking_compute(struct rank_data *rkd, const struct rank_info rki[], int x);
+
+/* This may be used to (exceptionally) add some extra salt...
+ */
+extern inline
+void ranking_add(struct rank_data *rkd, int y)
+{
+	rkd->rkd_tmp += y;
+}
+
+/* This may be used to (exceptionally) override certain ranking values.
+ */
+extern inline
+void ranking_override(struct rank_data *rkd, int y)
+{
+	rkd->rkd_tmp = y;
+}
+
+extern inline
+void ranking_stop(struct rank_data rkd[], int rkd_count)
+{
+	int i;
+
+	for (i = 0; i < rkd_count; i++)
+		rkd[i].rkd_current_points = rkd[i].rkd_tmp;
+}
+
+/* This is a round-robin scheduler taking her weights
+ * from the previous ranking phase (the more ranking points,
+ * the more frequently a candidate will be selected).
+ *
+ * Typical usage pattern (independent from the above ranking phase
+ * usage pattern):
+ *
+ *    while (__there_is_work_to_be_done(...)) {
+ *	      int winner = ranking_select(...);
+ *	      if (winner >= 0) {
+ *		      __do_something(winner);
+ *		      ranking_select_done(..., winner, 1); // or higher, winpoints >= 1 must hold
+ *	      }
+ *	      ...
+ *    }
+ *
+ */
+
+extern int ranking_select(struct rank_data rkd[], int rkd_count);
+
+extern inline
+void ranking_select_done(struct rank_data rkd[], int winner, int win_points)
+{
+	if (winner >= 0) {
+		if (win_points < 1)
+			win_points = 1;
+		rkd[winner].rkd_got += win_points;
+	}
+}
+
+#endif
-- 
2.0.0

