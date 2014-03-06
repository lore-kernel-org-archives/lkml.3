Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaCFJbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:31:35 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32858 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaCFJbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:31:31 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-68-53184070f718
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] gpio: max732x: Fix I2C dummy device resource leak on probe
 failure
Date: Thu, 06 Mar 2014 10:31:15 +0100
Message-id: <1394098276-11113-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t/xy7oFDhLBBj/+qVmce/WIxeL1C0OL
	KX+WM1lsnv+H0eLyrjlsDqweO2fdZfe4c20Pm0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	LNy/hrVgMlvFszmH2RoYJ7F2MXJwSAiYSKz9x9/FyAlkiklcuLeeDcQWEljKKHF3TUoXIxeQ
	3cck8WPNJnaQBJuAscTm5UvYQBIiAhMYJT61PWIESTALGEr8fPcHrEhYIFLix+bJLCA2i4Cq
	xO4Pf5i7GNk5eAXcJWbrQaxVkJgzyWYCI/cCRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GCH+/7qDcekxq0OMAhyMSjy8G/zEg4VYE8uKK3MPMUpwMCuJ8G4xlAgW4k1JrKxKLcqPLyrN
	SS0+xMjEwSnVwFjGe18m/GKr5uXMd1KFLRKaaltOfX9stuf34jqx9+rVxxmOiTqu3evx/M/U
	mWZryx1y+7IW/5f5JTeNre2IxtOgjxNWrdjh6XtgYUrcbCmdH1d0J3TfS1JTPr+CR8TsuIrp
	P0WnFzZsi7KnXC0rsX0wKy2Aleu9sP6P41ycS9uC07kswkN6c5RYijMSDbWYi4oTAehywLLd	AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In max732x_probe() driver allocates dummy I2C device (if number of ports
is greater than 8) however it is not unregistered if probe fails later.
Fix the leak by unregistering dummy I2C device if it was allocated.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/gpio/gpio-max732x.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpio/gpio-max732x.c b/drivers/gpio/gpio-max732x.c
index 36cb290764b6..74432daaf656 100644
--- a/drivers/gpio/gpio-max732x.c
+++ b/drivers/gpio/gpio-max732x.c
@@ -647,6 +647,8 @@ static int max732x_probe(struct i2c_client *client,
 	return 0;
 
 out_failed:
+	if (chip->client_dummy)
+		i2c_unregister_device(chip->client_dummy);
 	max732x_irq_teardown(chip);
 	return ret;
 }
-- 
1.7.9.5

