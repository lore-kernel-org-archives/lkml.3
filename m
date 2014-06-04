Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaFDX4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:56:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaFDXXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.14 209/228] i2c: s3c2410: resume race fix
Date: Wed,  4 Jun 2014 16:23:58 -0700
Message-Id: <20140604232354.762939372@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-s3c2410.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1247,10 +1247,10 @@ static int s3c24xx_i2c_resume(struct dev
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
 
-	i2c->suspended = 0;
 	clk_prepare_enable(i2c->clk);
 	s3c24xx_i2c_init(i2c);
 	clk_disable_unprepare(i2c->clk);
+	i2c->suspended = 0;
 
 	return 0;
 }


