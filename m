Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbaJPHfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:35:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58025 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaJPHdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:33:35 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ee-543f74cdc49c
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
Subject: [PATCH v2 2/8] power_supply: sysfs: Use power_supply_*() API for
 accessing function attrs
Date: Thu, 16 Oct 2014 09:32:51 +0200
Message-id: <1413444777-24107-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
References: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7pnS+xDDN6eZbc4uFXTYuOM9awW
	k568Z7aYuHIys0Xn2SfMFq9fGFqcbXrDbnH/61FGiyl/ljNZbHp8jdXi8q45bBafe48wWjxZ
	eIbJYu2Ru+wWtxtXsFncPXWUzeJ0N6vF6d0lDkIeE/o/MXrsnHWX3WPzCi2PTas62TzuXNvD
	5jHvZKDH5iX1Hju/N7B79G1ZxeixYvV3do/Pm+QCuKO4bFJSczLLUov07RK4Mo4cKC/YxFtx
	4tM+xgbGdu4uRk4OCQETiVMT5jBB2GISF+6tZ+ti5OIQEljKKPF9YwuU08cksaBxEzNIFZuA
	scTm5UvAEiIC15kkOldMYAFxmAUamSXeNTSDzRIWSJG4eXMfWAeLgKrE04aLYHFeAXeJsycm
	skLsk5M4eWwymM0p4CEx/exVdhBbCKimccJ+tgmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al
	6yXn525ihAT91x2MS49ZHWIU4GBU4uHVCLYPEWJNLCuuzD3EKMHBrCTC21wIFOJNSaysSi3K
	jy8qzUktPsTIxMEp1cBourrAhLvZ5swq5wtTpz9/62oy+6C6s/FSPQmbk/Lli7lmMe6wPX96
	/Z39pxT8w1S4HLI+rZ3KY/t70bxSvxTxnHSJeSX/Z6x7zhCafN9/4cJ0RpVAzVk6u6e9O6dX
	wD0rb+qv42d5OTauL+5c0qgV8u//nrLYLdZOc51jojbn7EpQXCi3bc0uJZbijERDLeai4kQA
	ds+caFgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property
 - set_property -> power_supply_set_property
 - property_is_writeable -> power_supply_property_is_writeable

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
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

