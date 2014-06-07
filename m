Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaFGBhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36015 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Olof Johansson" <olof@lixom.net>,
        "Wolfram Sang" <wsa@the-dreams.de>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Doug Anderson" <dianders@chromium.org>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.706556550@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 71/92] i2c: s3c2410: resume race fix
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-s3c2410.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1082,10 +1082,10 @@ static int s3c24xx_i2c_resume(struct dev
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
 
-	i2c->suspended = 0;
 	clk_enable(i2c->clk);
 	s3c24xx_i2c_init(i2c);
 	clk_disable(i2c->clk);
+	i2c->suspended = 0;
 
 	return 0;
 }

