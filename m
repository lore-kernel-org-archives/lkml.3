Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938Ab3HOTb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:31:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48878 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab3HOTbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:31:25 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: nomadik: shut up a warning for flags
Date: Thu, 15 Aug 2013 21:31:15 +0200
Message-Id: <1376595075-791-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq flags variable gets a warning like this after
commit bf4dae5ce1b95a5932e43036edcf3f1b324758c6
"pinctrl: nomadik: delete ancient pin control API":

In file included from include/linux/seqlock.h:29:0,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from
drivers/pinctrl/pinctrl-nomadik.c:14:
drivers/pinctrl/pinctrl-nomadik.c: In function 'nmk_pmx_enable':
include/linux/spinlock.h:348:122: warning:
'flags' may be used uninitialized in this function
[-Wmaybe-uninitialized]
  raw_spin_unlock_irqrestore(&lock->rlock, flags);
                                                   ^
drivers/pinctrl/pinctrl-nomadik.c:1515:16: note:
'flags' was declared here
  unsigned long flags;

The function is question was never changed but it appears
the semantic checker could previously determine that the code
path that would use the flags was going to either use it or
not, but now it can't for some reason. Just fix it up.

Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 89280bc..a8b8a53 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1512,7 +1512,7 @@ static int nmk_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
 	const struct nmk_pingroup *g;
 	static unsigned int slpm[NUM_BANKS];
-	unsigned long flags;
+	unsigned long flags = 0;
 	bool glitch;
 	int ret = -EINVAL;
 	int i;
-- 
1.8.1.4

