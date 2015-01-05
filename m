Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbbAEPzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:55:17 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbbAEPsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:21 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-9a-54aab243e9fc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 04/19] power_supply: sysfs: Use power_supply_*() API for
 accessing function attrs
Date: Mon, 05 Jan 2015 16:47:47 +0100
Message-id: <1420472882-10463-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7rOm1aFGPSuYbeY9OQ9s8XElZOZ
	LV6/MLTY+fAtm8Xyff2MFpseX2O1uLxrDpvF594jjBZ3Tx1lszhz+hKrxendJQ7cHjtn3WX3
	2LxCy2PTqk42j81L6j22XG1n8ejbsorRY8Xq7+wenzfJBXBEcdmkpOZklqUW6dslcGUcOVBe
	sIm34sSnfYwNjO3cXYycHBICJhKPzvcwQthiEhfurWfrYuTiEBJYyijx8UIjM4TTxyRxc/t1
	NpAqNgFjic3Ll4BViQg8YZKY3nqSBSTBLGAo8fPdH3YQW1ggU2LRsWZmEJtFQFViQ9NWsBpe
	AXeJb9OXsEOsk5M4eWwyK4jNKeAh0fT3AliNEFDNh2e/WCcw8i5gZFjFKJpamlxQnJSea6hX
	nJhbXJqXrpecn7uJERKUX3YwLj5mdYhRgINRiYfX48TKECHWxLLiytxDjBIczEoivK/SV4UI
	8aYkVlalFuXHF5XmpBYfYmTi4JRqYKwv0X3nov1tkcv/7hUlK4/82R5kd6V0uWNcpsErYzt3
	pfKKiJcyBwwVXliU6a15H7JbdNNztdLLTIWHtJe7xj5cp9+0XKDRLijd5GeessPem1PlF5jw
	Ci6dvGcPS2+p49rCdItvq0/WOG5648J9pnrtTAejZL6fDpfzi35L/1h385wcyzzDdiWW4oxE
	Qy3mouJEAGbFKlcoAgAA
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

