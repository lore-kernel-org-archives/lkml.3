Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaA3SDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:03:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40042 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbaA3SDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:03:41 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <mturquette@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v2] clk: keystone: gate: fix clk_init_data initialization
Date: Thu, 30 Jan 2014 20:03:11 +0200
Message-ID: <1391104991-15000-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clk_init_data struct is allocated in the stack. All members of
this struct should be initialized before using otherwise it will
lead to unpredictable situation as it can contain garbage.

Ultimately the clk->flag field contains garbage. In my case it leads
that flag CLK_IGNORE_UNUSED is set for most of clocks. As result a
bunch of unused clocks cannot be disabled.

So initialize flags in this structure too.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
Based on
git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
keystone/master

v1..v2:
- updated commit description only

 drivers/clk/keystone/gate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/keystone/gate.c b/drivers/clk/keystone/gate.c
index 17a5983..86f1e36 100644
--- a/drivers/clk/keystone/gate.c
+++ b/drivers/clk/keystone/gate.c
@@ -179,6 +179,7 @@ static struct clk *clk_register_psc(struct device *dev,
 
 	init.name = name;
 	init.ops = &clk_psc_ops;
+	init.flags = 0;
 	init.parent_names = (parent_name ? &parent_name : NULL);
 	init.num_parents = (parent_name ? 1 : 0);
 
-- 
1.8.3.2

