Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966920AbaFQVvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:51:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966897AbaFQVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 118/212] i2c: s3c2410: resume race fix
Date: Tue, 17 Jun 2014 14:43:32 -0700
Message-Id: <1403041506-13646-119-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olof Johansson <olof@lixom.net>

commit ce78cc071f5f541480e381cc0241d37590041a9d upstream.

Don't unmark the device as suspended until after it's been re-setup.

The main race would be w.r.t. an i2c driver that gets resumed at the same
time (asyncronously), that is allowed to do a transfer since suspended
is set to 0 before reinit, but really should have seen the -EIO return
instead.

Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-s3c2410.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index bf8fb94..2729e40 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1201,10 +1201,10 @@ static int s3c24xx_i2c_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
 
-	i2c->suspended = 0;
 	clk_prepare_enable(i2c->clk);
 	s3c24xx_i2c_init(i2c);
 	clk_disable_unprepare(i2c->clk);
+	i2c->suspended = 0;
 
 	return 0;
 }
-- 
1.9.1

