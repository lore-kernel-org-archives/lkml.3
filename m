Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaGVCVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:21:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46489 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbaGVCU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:20:59 -0400
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, s.trumtrar@pengutronix.de,
        dinguyen@altera.com, cslee@altera.com
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 2/3] clk: Prevent a hanging pointer being abused
Date: Tue, 22 Jul 2014 14:20:33 +1200
Message-Id: <1405995634-3297-3-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
References: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock init structs are normally created on the stack.

If the pointer is left intact after clk_register then there is
opportunity for clk drivers to dereference the pointer.

This was causing a problem in socfpga/clk.c for instance.

Better to NULL out the pointer so it can't be abused.

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 drivers/clk/clk.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ec41922..9e92170 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1973,6 +1973,10 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 		clk->owner = NULL;
 
 	ret = __clk_init(dev, clk);
+
+	/* Prevent a hanging pointer being left around. */
+	hw->init = NULL;
+
 	if (ret)
 		return ERR_PTR(ret);
 
-- 
1.9.1

