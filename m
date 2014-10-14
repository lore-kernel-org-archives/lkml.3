Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaJNMX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:23:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14505 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaJNMVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:21:05 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ab-543d152db3c4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/8] power_supply: sysfs: Use power_supply_*() API for
 accessing function attrs
Date: Tue, 14 Oct 2014 14:20:40 +0200
Message-id: <1413289246-31650-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xq7q6orYhBr2zjCwObtW02DhjPavF
	pCfvmS0mrpzMbNF59gmzxesXhhZnm96wW9z/epTRYsqf5UwWmx5fY7W4vGsOm8Xn3iOMFk8W
	nmGyWHvkLrvF7cYVbBZ3Tx1lszjdzWpxeneJg5DHhP5PjB47Z91l99i8Qstj06pONo871/aw
	ecw7GeixeUm9x87vDewefVtWMXqsWP2d3ePzJrkA7igum5TUnMyy1CJ9uwSujC09x5kKHvBU
	3DtY1cC4j6uLkZNDQsBE4vmJv0wQtpjEhXvr2boYuTiEBJYySsz+/ZsVwuljkrjyvhusik3A
	WGLz8iVgVSIC15kkOldMYAFxmAUamSXeNTSDVQkLJErc+nwazGYRUJWYcAVkBwcHr4C7xKxl
	vBDr5CROHpvMCmJzCnhIrFx0hAXEFgIqaT95m20CI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGCEh/3UH49JjVocYBTgYlXh4CyJtQoRYE8uKK3MPMUpwMCuJ8Cpw2IYI8aYkVlal
	FuXHF5XmpBYfYmTi4JRqYBTr1Nx/cYNZLsuf3FmLfyzearT004/kQ2u7OoyvbP2fcPOgA/PH
	JVxrH3afzcxrZ9ZczRXerL3yarLewt6otSdkXyt8jbu5laG/bN/yKlaTR6fMP4cptV0VenvK
	QfV92Rr2yMiTS6+kfrzGciJG/5rkp557f7T+p94M/71S931fq8ori/oXzqVKLMUZiYZazEXF
	iQCiHXrUVwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access access in case of unregistering the power
supply (.e.g by removing the driver). Replace:
 - get_property -> power_supply_get_property
 - set_property -> power_supply_set_property
 - property_is_writeable -> power_supply_property_is_writeable

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/power_supply_sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 62653f50a524..f817aab80813 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -76,7 +76,7 @@ static ssize_t power_supply_show_property(struct device *dev,
 	if (off == POWER_SUPPLY_PROP_TYPE) {
 		value.intval = psy->type;
 	} else {
-		ret = psy->get_property(psy, off, &value);
+		ret = power_supply_get_property(psy, off, &value);
 
 		if (ret < 0) {
 			if (ret == -ENODATA)
@@ -125,7 +125,7 @@ static ssize_t power_supply_store_property(struct device *dev,
 
 	value.intval = long_val;
 
-	ret = psy->set_property(psy, off, &value);
+	ret = power_supply_set_property(psy, off, &value);
 	if (ret < 0)
 		return ret;
 
@@ -223,7 +223,7 @@ static umode_t power_supply_attr_is_visible(struct kobject *kobj,
 
 		if (property == attrno) {
 			if (psy->property_is_writeable &&
-			    psy->property_is_writeable(psy, property) > 0)
+			    power_supply_property_is_writeable(psy, property) > 0)
 				mode |= S_IWUSR;
 
 			return mode;
-- 
1.9.1

