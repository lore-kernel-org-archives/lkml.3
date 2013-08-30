Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3H3OzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:55:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37440 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab3H3OzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:55:19 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-46-5220b255bf82
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v6 4/5] clk: Assign module owner of a clock being registered
Date: Fri, 30 Aug 2013 16:53:21 +0200
Message-id: <1377874402-2944-5-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com>
References: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jAd2wTQpBBvcjLN5vnMdk0fOn0uJs
	0xt2i86JS9gtNj2+xmpxedccNosJUyexW8z5M4XZ4vZlXounEy6yWdxuXMFmcfhNO6vF+hmv
	WRx4PVqae9g8PnyM85jdMZPV4861PWweR1euZfLYvKTeY/fXJkaPvi2rGD0+b5IL4IzisklJ
	zcksSy3St0vgypj94hZ7wSrOilVzfrM1MF5g72Lk5JAQMJH4efsjK4QtJnHh3nq2LkYuDiGB
	RYwSz9Z0MkM4HUwSc/vmgnWwCRhK9B7tYwSxRQQ0JKZ0PWYHKWIWuMwkselLF1iRsICPxNqW
	V2wgNouAqsTXWa+YQGxeAVeJg59nA8U5gNYpSMyZZAMS5hRwk7gwbT1YuRBQyZwTqxgnMPIu
	YGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcsM+kdzCuarA4xCjAwajEw7tzuUKQEGti
	WXFl7iFGCQ5mJRHej4uBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQW
	wWSZODilGhgd5jUwHLWeXvOf+97H74q1Dhta1000/5K6dd7c1VP/FSrb2W50+zaJOcvyXdvx
	5SenrBE/NCvbQ+o4w8qaZTJCHlMLEmtPcDg+cVu0+GlDjlboxttvJR7/3PR7yaSTqj46uSee
	fQj+fVd/avzWZPmz4szfdFTtHH/s6Qg/O2O6wq6PnWrvuLOFlFiKMxINtZiLihMBwx91TFQC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev->driver->owner as the owner module of a clock, it ensures
reference on the module is taken in the __clk_get(), __clk_put()
helpers.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v5:
 - none.
---
 drivers/clk/clk.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index dcf061a..ac80e13 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1805,6 +1805,10 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 	clk->flags = hw->init->flags;
 	clk->parent_names = hw->init->parent_names;
 	clk->num_parents = hw->init->num_parents;
+	if (dev && dev->driver)
+		clk->owner = dev->driver->owner;
+	else
+		clk->owner = NULL;
 
 	ret = __clk_init(dev, clk);
 	if (ret)
@@ -1825,6 +1829,8 @@ static int _clk_register(struct device *dev, struct clk_hw *hw, struct clk *clk)
 		goto fail_name;
 	}
 	clk->ops = hw->init->ops;
+	if (dev && dev->driver)
+		clk->owner = dev->driver->owner;
 	clk->hw = hw;
 	clk->flags = hw->init->flags;
 	clk->num_parents = hw->init->num_parents;
-- 
1.7.9.5

