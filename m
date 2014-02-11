Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaBKKEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:04:04 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22473 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaBKKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:03:54 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-84-52f9f58752eb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 2/7] mfd: 88pm860x: Fix I2C device resource leak on regmap init
 fail
Date: Tue, 11 Feb 2014 11:03:30 +0100
Message-id: <1392113015-11180-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
References: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t/xK7rtX38GGRw8KW2xccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGGyWLDxEaMDl8eda3vYPOadDPTo
	27KK0ePzJrkAligum5TUnMyy1CJ9uwSujN1NDgUz2CvOThRsYGxk62Lk5JAQMJH49XMrM4Qt
	JnHh3nqgOBeHkMBSRol99/sZIZw+Jol/c26AVbEJGEtsXr4ErEpEYDOjxOLvV1lBHGaBu4wS
	zXffM4JUCQuESay9+ZUdxGYRUJVouHCbFcTmFXCX2NS3j6WLkQNon4LEnEk2IGFOAQ+JFR/O
	gC0QAipp7b/LOoGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkBD7uoNx6TGrQ4wC
	HIxKPLwaX38ECbEmlhVX5h5ilOBgVhLhVTr+M0iINyWxsiq1KD++qDQntfgQIxMHp1QDo5Q8
	v/n2hJTAV34fMy3iPJk9ezPuHn9h38qxuTCo7dchBe6bmnIuxRlTObjWrS65ukomf4N1p59c
	0eWHjS/7H028fPv+O+lTiwyu//FOfXzL/OOt6Kp6Q4HKvzeq5opOO6y90+y8welHE0/9t941
	/eziTzbpHdmbF8orqkYtlkzqXvjP3uGytRJLcUaioRZzUXEiAN2+zuAPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe the driver allocates dummy I2C device for companion chip
and then allocates a regmap for it. If regmap_init_i2c() fails then the
I2C driver (allocated with i2c_new_dummy()) is not freed and this
resource leaks.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/88pm860x-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index e456be9a7c67..bcfc9e85b4a0 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1190,6 +1190,7 @@ static int pm860x_probe(struct i2c_client *client,
 			ret = PTR_ERR(chip->regmap_companion);
 			dev_err(&chip->companion->dev,
 				"Failed to allocate register map: %d\n", ret);
+			i2c_unregister_device(chip->companion);
 			return ret;
 		}
 		i2c_set_clientdata(chip->companion, chip);
-- 
1.7.9.5

