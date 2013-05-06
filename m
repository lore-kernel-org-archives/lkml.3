Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab3EFBbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 21:31:13 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:43148 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830Ab3EFBbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 21:31:12 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <thierry.reding@avionic-design.de>, <linux-kernel@vger.kernel.org>,
        <xiechao.mail@gmail.com>, <eric.y.miao@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V4 2/3] pwm: pxa: use module_platform_driver()
Date: Sun, 5 May 2013 21:30:00 -0400
Message-ID: <1367803801-17111-3-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1367803801-17111-1-git-send-email-chao.xie@marvell.com>
References: <1367803801-17111-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old pwm-pxa.c will register driver by arch_initcall. Then other
drivers based on the PWM driver can successully call old
pwm_request because arch_initcall make sure the PWM driver will
be registered earlier.
Now, pwm_request is re-written and done by common layer code. It
will return -EPROBE_DEFER if the PWM device is not probed.
The driver based on PWM driver can make use of -EPROBE_DEFER
to delay its probing.
So arch_initcall can be replaced by module_platform_driver.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/pwm/pwm-pxa.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
index dee6ab55..aa4bea7 100644
--- a/drivers/pwm/pwm-pxa.c
+++ b/drivers/pwm/pwm-pxa.c
@@ -187,16 +187,6 @@ static struct platform_driver pwm_driver = {
 	.id_table	= pwm_id_table,
 };
 
-static int __init pwm_init(void)
-{
-	return platform_driver_register(&pwm_driver);
-}
-arch_initcall(pwm_init);
-
-static void __exit pwm_exit(void)
-{
-	platform_driver_unregister(&pwm_driver);
-}
-module_exit(pwm_exit);
+module_platform_driver(pwm_driver);
 
 MODULE_LICENSE("GPL v2");
-- 
1.7.4.1

