Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbbAERVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:21:39 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:53997 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbbAERVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:21:38 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] stagin: clocking-wizard: Handle invalid clk in notifier
Date: Mon,  5 Jan 2015 09:21:29 -0800
Message-Id: <1420478489-20538-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.1.1.gb42cc81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though it should never happen, handle the case that the clock
notifier is called with an unexpected clock handle. This avoids the
compiler warning:
   drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c: In function 'clk_wzrd_clk_notifier':
>> drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c:99:6: warning: 'max' may be used uninitialized in this function [-Wmaybe-uninitialized]
      if (ndata->new_rate > max)
         ^

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
index 471d0877f382..048247fa9e34 100644
--- a/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
+++ b/drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
@@ -91,8 +91,10 @@ static int clk_wzrd_clk_notifier(struct notifier_block *nb, unsigned long event,
 
 	if (ndata->clk == clk_wzrd->clk_in1)
 		max = clk_wzrd_max_freq[clk_wzrd->speed_grade - 1];
-	if (ndata->clk == clk_wzrd->axi_clk)
+	else if (ndata->clk == clk_wzrd->axi_clk)
 		max = WZRD_ACLK_MAX_FREQ;
+	else
+		return NOTIFY_DONE;	/* should never happen */
 
 	switch (event) {
 	case PRE_RATE_CHANGE:
-- 
2.2.1.1.gb42cc81

