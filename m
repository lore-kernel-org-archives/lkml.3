Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbbAEPsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:48:33 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55683 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbbAEPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:28 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-cf-54aab249ac49
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 17/19] power: bq2415x_charger: Decrement the power
 supply's device reference counter
Date: Mon, 05 Jan 2015 16:48:00 +0100
Message-id: <1420472882-10463-18-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7qem1aFGHybb2Ax6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4Mr437ub
	teA9R8WTZw9ZGxjPsncxcnJICJhIXFrznQnCFpO4cG89WxcjF4eQwFJGiV+9x5kgnD4miYn7
	37GAVLEJGEtsXr4ErEpE4AmTxPTWk2AJZgFDiZ/v/oCNFRbIkXg+fSVQnIODRUBVYst+G5Aw
	r4CHxNyGTkaIbXISJ49NZgWxOYHiTX8vgI0REnCX+PDsF+sERt4FjAyrGEVTS5MLipPScw31
	ihNzi0vz0vWS83M3MUKC8ssOxsXHrA4xCnAwKvHwepxYGSLEmlhWXJl7iFGCg1lJhPdV+qoQ
	Id6UxMqq1KL8+KLSnNTiQ4xMHJxSDYw1Vg2hXvf/a+RGRE2fvzOgtbE03W8CV31MezCTbM35
	+OSr7UvquuwCtP7/Xrxw3+6G65rMGwLK3zDN3/DN5evEZ6sL1z04eKJqn4lEwuzSH7nFdWud
	Pj3921vlmyAu97/muuJzn4+fZE5pbGLpcSh9Ifv4e72S5rIbiq7FvOJTueZP+LRa46ISS3FG
	oqEWc1FxIgCDdnbQKAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter (increased by power_supply_get_by_name() or
power_supply_get_by_phandle()).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/bq2415x_charger.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 2f80de0410d9..00809dcdd34e 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1686,6 +1686,8 @@ error_4:
 error_3:
 	bq2415x_power_supply_exit(bq);
 error_2:
+	if (!IS_ERR(bq->notify_psy))
+		power_supply_put(bq->notify_psy);
 	kfree(name);
 error_1:
 	mutex_lock(&bq2415x_id_mutex);
@@ -1701,8 +1703,10 @@ static int bq2415x_remove(struct i2c_client *client)
 {
 	struct bq2415x_device *bq = i2c_get_clientdata(client);
 
-	if (bq->notify_psy)
+	if (bq->notify_psy) {
 		power_supply_unreg_notifier(&bq->nb);
+		power_supply_put(bq->notify_psy);
+	}
 
 	bq2415x_sysfs_exit(bq);
 	bq2415x_power_supply_exit(bq);
-- 
1.9.1

