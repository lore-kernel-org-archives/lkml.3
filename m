Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161461Ab3FUNIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 09:08:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39099 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161315Ab3FUNIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 09:08:09 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-3b-51c45037aef6
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] clk: Handle CLK_GET_RATE_NOCACHE flag in clk_set_rate()
Date: Fri, 21 Jun 2013 15:07:35 +0200
Message-id: <1371820055-14147-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t9jQV3zgCOBBjN6tS3ONr1ht9j0+Bqr
	xeVdc9gsnk64yGZx+E07qwOrx51re9g8Ni+p9+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	gy2vmQoaOSpuLLrH2MB4nK2LkZNDQsBEYm3XD2YIW0ziwr31QHEuDiGB6YwSrT9OMkM4HUwS
	N372sIJUsQkYSvQe7WMEsUUEJCUefJ7OAlLELLCIUeLgm6VgRcICHhKTjz4CGsXBwSKgKrGv
	LwokzCvgJtF04AIrSFhCQEFiziSbCYzcCxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE
	B8Ez6R2MqxosDjEKcDAq8fAGKB0OFGJNLCuuzD3EKMHBrCTCG3wHKMSbklhZlVqUH19UmpNa
	fIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoExO3e2f1D5coZmp8NHDvsIJB/T7GKb
	Pf+W0C4F3cVWnLovg8UeN7c/sbk03/MSi8pNdvcbLsXLnlkWnfR84uYguGfnZ8nIgFQfG9HX
	wc+sTrp4KNw497D03iW5yxIVC40nTjLTn/LLqrzrXfTTKW4P5Ss2bJWe+alWPiO0VW7xy7Jw
	0cxkGUYlluKMREMt5qLiRADJ6Ce9/gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a clock has CLK_GET_RATE_NOCACHE flag set the rate needs to
be recalculated, rather than referencing the cached value.

Currently cached clk->rate is compared with new value to see if
anything needs to be done in clk_set_rate(). This may cause required
clock controller registers update to not happen when same clock
frequency value is being set subsequently.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/clk.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 1144e8c..ffa304e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1215,6 +1215,9 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	/* prevent racing with updates to the clock topology */
 	clk_prepare_lock();

+	if (clk->flags & CLK_GET_RATE_NOCACHE)
+		__clk_recalc_rates(clk, 0);
+
 	/* bail early if nothing to do */
 	if (rate == clk->rate)
 		goto out;
--
1.7.9.5

