Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaKDPLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:11:12 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16747 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbaKDPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:10:52 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-6c-5458ec7b27db
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v2 6/7] power: bq2415x_charger: Decrement the power
 supply's device reference counter
Date: Tue, 04 Nov 2014 16:10:35 +0100
Message-id: <1415113836-26098-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xy7rVbyJCDPqf81oc3KppsXHGelaL
	JU0ZFpOevGe2mLhyMrPFtI3iFq9fGFosW/yU0eJs0xt2i/tfjzJaTPmznMli0+NrrBaXd81h
	s/jce4TR4uPSDawWa4/cZbe4dGABk8XdU0fZLB6veMtucbqb1eL07hKLzZumMlv82PCY1UHc
	Y0L/J0aPnbPusnss2FTqsXmFlsfiPS+ZPDat6mTzuHNtD5vHu3Pn2D3mnQz02Lyk3uPj01ss
	Hu/3XWXz6NuyitFjxerv7B6fN8l5nGj5whogEMVlk5Kak1mWWqRvl8CV8b93N2vBe46KJ88e
	sjYwnmXvYuTgkBAwkdi2Wa2LkRPIFJO4cG89WxcjF4eQwFJGiQvLD0I5fUwSS1ffZAKpYhMw
	lti8fAlYQkSgkVXi3NY3TCAOs0AHk8Ttlp2sIFXCAnkSi3/sYgRZwSKgKnFskhiIySvgLnHk
	WRDENjmJk8cmg1VzCnhI7Gz5zw5iCwGVvNm4nXUCI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGCHx9HUH49JjVocYBTgYlXh4V8RHhAixJpYVV+YeYpTgYFYS4VV/DBTiTUmsrEot
	yo8vKs1JLT7EyMTBKdXAWPq8IqH0g0TZDonvldd49Noe6135HHOs5JqeU1mG/oyOhnur3rhb
	f2x7kOozWXGVZuOeQyfWTZYWu5bO/20P8xeVWXY9/zdHdzfoaLuGbfAWvh6eU/FgjsP6ex0z
	lJpuh01ZyLqyMvbSnmI/t99xM6e0bHwY1dYzPTv2dWquYNQG+Rr/50EflViKMxINtZiLihMB
	Ef+/sYUCAAA=
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

