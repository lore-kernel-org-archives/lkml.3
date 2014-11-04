Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaKDPLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:11:08 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57614 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbaKDPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:10:52 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-a3-5458ec7af008
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
Subject: [PATCH RESEND v2 5/7] power: 88pm860x_charger: Decrement the power
 supply's device reference counter
Date: Tue, 04 Nov 2014 16:10:34 +0100
Message-id: <1415113836-26098-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xy7pVbyJCDJ43Slgc3KppsXHGelaL
	JU0ZFpOevGe2mLhyMrPFtI3iFq9fGFosW/yU0eJs0xt2i/tfjzJaTPmznMli0+NrrBaXd81h
	s/jce4TR4uPSDawWa4/cZbe4dGABk8XdU0fZLB6veMtucbqb1eL07hKLzZumMlv82PCY1UHc
	Y0L/J0aPnbPusnss2FTqsXmFlsfiPS+ZPDat6mTzuHNtD5vHu3Pn2D3mnQz02Lyk3uPj01ss
	Hu/3XWXz6NuyitFjxerv7B6fN8l5nGj5whogEMVlk5Kak1mWWqRvl8CVcX1KUMFu7oq1Eyey
	NzAe5uxi5OSQEDCRWNO7nhnCFpO4cG89WxcjF4eQwFJGiUnHNzFBOH1MEo0PF7GAVLEJGEts
	Xr4ErEpEoJFV4tzWN2BVzAIdTBK3W3aydjFycAgL5Esc/+QE0sAioCpxbsltsBW8Au4SLzvu
	s0Ksk5M4eWwymM0p4CGxs+U/O4gtBFTzZuN21gmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al
	6yXn525ihETUlx2Mi49ZHWIU4GBU4uHNUI8IEWJNLCuuzD3EKMHBrCTCq/4YKMSbklhZlVqU
	H19UmpNafIiRiYNTqoGRs/HRV6dVbx8/s2HV+yeVs06PO2VFtfCPJfGvlcV7o3Y84p5Yu0zi
	8HPGjgXuWsl2rf/fJsUonJsh/VZk0+y90wJUZh9sqvcssEqT5N+ic7fi5t3b/zb0dpU9XBmY
	5P3Bc27xe42HNtmKwrWWF5ZlPM1MP71n+wXGij0fPq3bW/pXmvuZwG0uJZbijERDLeai4kQA
	qoRKPIYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/88pm860x_charger.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index 534b3e2e3487..48aa0d829cb0 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -298,13 +298,18 @@ static int set_charging_fsm(struct pm860x_charger_info *info)
 		return -EINVAL;
 	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW,
 			&data);
-	if (ret)
+	if (ret) {
+		power_supply_put(psy);
 		return ret;
+	}
 	vbatt = data.intval / 1000;
 
 	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_PRESENT, &data);
-	if (ret)
+	if (ret) {
+		power_supply_put(psy);
 		return ret;
+	}
+	power_supply_put(psy);
 
 	mutex_lock(&info->lock);
 	info->present = data.intval;
@@ -447,6 +452,7 @@ static irqreturn_t pm860x_temp_handler(int irq, void *data)
 
 	set_charging_fsm(info);
 out:
+	power_supply_put(psy);
 	return IRQ_HANDLED;
 }
 
@@ -507,6 +513,7 @@ static irqreturn_t pm860x_done_handler(int irq, void *data)
 
 out:
 	mutex_unlock(&info->lock);
+	power_supply_put(psy);
 	dev_dbg(info->dev, "%s, Allowed: %d\n", __func__, info->allowed);
 	set_charging_fsm(info);
 
-- 
1.9.1

