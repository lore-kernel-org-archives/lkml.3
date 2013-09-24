Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3IXIIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:08:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44855 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3IXIIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:08:43 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-56-52414887ca89
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 1/6] thermal: exynos: fix: Return from exynos_report_trigger()
 when therm_dev is NULL
Date: Tue, 24 Sep 2013 10:08:17 +0200
Message-id: <1380010102-25817-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jAd12D8cgg/Vr9S0aroZYbJyxntVi
	/pFzrBZr9v9ksug8+4TZ4s0jbos3DzczWlzeNYfN4nPvEUaLGef3MVncblzBZtG/sJfJ4snD
	PjaL9TNeszjweSze85LJY920t8wefVtWMXo8WtzC6HH8xnYmj8+b5ALYorhsUlJzMstSi/Tt
	Ergyrq/8wFown6tiV8cjlgbGZxxdjJwcEgImEvumdDBD2GISF+6tZ+ti5OIQEljEKHFn9ksW
	CKeLSaL/VRsbSBWbgJ7E57tPmUASIgJNjBI/jnwDa2cWOMYs8WWVCIgtLJAu0blmBxOIzSKg
	KtF2YgkriM0r4CZx/+RXRoh18hJP7/eBDeUUcJdofzoFLC4EVPP20VaWCYy8CxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEB+kz6R2MqxosDjEKcDAq8fBeSHAIEmJNLCuuzD3EKMHB
	rCTCe8PWMUiINyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QD
	Y9m36KLb8ao3J67uiHhzedfju29/a1s/ePUgtnHH5almbB0JVz7k+aQVhidZHP13pvvhRafy
	p1/XL/pt7hq7c9fGAAaDsEaDa/FxEr/zT7wO8dNcctbFUfbmvlm7Jh13Ewu0Zo60Fku+fuqT
	utme+PwHVZoFN3c/uB4gWWovurd05uens4+zLldiKc5INNRiLipOBACwpWUhTgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 4de0bdaa9677d11406c9becb70c60887c957e1f0
("thermal: exynos: Add support for instance based register/unregister")
broke check for presence of therm_dev at global thermal zone in
exynos_report_trigger().

The resulting wrong test prevents thermal_zone_device_update() call, which
calls handlers for situation when trip points are passed.
Such behavior prevents thermal driver from proper reaction (when TMU interrupt
is raised) in a situation when overheating is detected at TMU hardware.
This patch fixes it.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index f10a6ad..55a912a 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -310,7 +310,7 @@ void exynos_report_trigger(struct thermal_sensor_conf *conf)
 	}
 
 	th_zone = conf->pzone_data;
-	if (th_zone->therm_dev)
+	if (!th_zone->therm_dev)
 		return;
 
 	if (th_zone->bind == false) {
-- 
1.7.10.4

