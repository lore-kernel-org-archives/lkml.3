Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbaJNMhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:37:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12315 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbaJNMhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:37:12 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e2-543d18f60c83
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 6/7] power: bq2415x_charger: Decrement the power supply's
 device reference counter
Date: Tue, 14 Oct 2014 14:35:16 +0200
Message-id: <1413290117-13082-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
References: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xK7rfJGxDDF7flLc4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoEr49e9X6wFJzgq/mzd
	ytLAuJq9i5GTQ0LAROLrty+sELaYxIV769m6GLk4hASWMkr0n5zKDuH0MUl8/XidBaSKTcBY
	YvPyJWBVIgKbWCW2rVjABOIwC1xnlFh99TbYXGGBFIm/v8+BzWURUJXY2XIPzOYVcJfYtWA7
	1G45iZPHJgPFOTg4BTwkJu5SAzGFgEpmPZOdwMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpe
	cn7uJkZIRH3Zwbj4mNUhRgEORiUe3oJImxAh1sSy4srcQ4wSHMxKIrwKHLYhQrwpiZVVqUX5
	8UWlOanFhxiZODilGhj7/P0t6286PXSv2rC4Q2emaMFW2eaM/9J7VxTnTvw9N8D7ZG9yMN+n
	CUZSiSKr7k9/IZHyqthxPvvt66FqLf7PuJ/N3rVl+YJX2bsmWEgE7mmUOc7Rnuk6l//0jthj
	nHLBft81gnnThZLEVQ9fjjTaGaKWtmqBWsbyl8p/Mj/3VE14maW6sU+JpTgj0VCLuag4EQAK
	pDazhgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter (increased by power_supply_get_by_name() or
power_supply_get_by_phandle()).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/bq2415x_charger.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 81a3a78b92d8..8bc9ca9e0275 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -1684,6 +1684,8 @@ error_4:
 error_3:
 	bq2415x_power_supply_exit(bq);
 error_2:
+	if (!IS_ERR(bq->notify_psy))
+		power_supply_put(bq->notify_psy);
 	kfree(name);
 error_1:
 	mutex_lock(&bq2415x_id_mutex);
@@ -1699,8 +1701,10 @@ static int bq2415x_remove(struct i2c_client *client)
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

