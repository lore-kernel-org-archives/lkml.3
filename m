Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3JIGaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:30:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37377 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3JIGao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:30:44 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-4b-5254f7f2e4a0
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, kgene.kim@samsung.com
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v2 1/5] thermal: exynos: Remove check for thermal device
 pointer at exynos_report_trigger()
Date: Wed, 09 Oct 2013 08:29:50 +0200
Message-id: <1381300194-13134-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jQd1P30OCDP790LVouBpisXHGelaL
	+UfOsVqs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbSYcX4fk8XtxhVsFmdO
	X2K1ePKwj81i/YzXLA78Hov3vGTyWDftLbPHlqvtLB59W1Yxehy/sZ3J4/MmuQC2KC6blNSc
	zLLUIn27BK6Mn9fvMxfM5amY+P8icwPjRq4uRg4OCQETifdzCrsYOYFMMYkL99azdTFycQgJ
	TGeU2POtlQXC6WKSaFmxnQWkik1AT+Lz3adMILaIQIbEqUuzmUCKmAX+Mktcn3YMrEhYIFfi
	5etGdhCbRUBV4vu+3awg23gF3CQmXcmG2CYv8fR+HxuIzSngLnHwzjt2iGXNjBKPLm5imcDI
	u4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcLA+k9rBuLLB4hCjAAejEg/vA/6QICHW
	xLLiytxDjBIczEoivHkLgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphak
	FsFkmTg4pRoYdezWv3nefIOJ7yPXwschM56InzqdlW8tYsATbHvosKMa44bGZbdeVblHLheX
	meDgwR6RwPPG7MWfpODUqwvb1/ou2JsZ1scukxJfWFes6DJJcf/Xgu7Y4nXPdz/RlXRL2qch
	0JPSvTP0RtvHqz51eouzXleeEP27h+m1WO4JqeZXHy8b+05TYinOSDTUYi4qTgQAbPCtb1IC	AAA=
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

It turns out, that after exynos thermal subsystem redesign (at v3.12) this
check is not needed, since it is not possible to register thermal zone
without valid thermal device.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

---
Changes for v2:
- Remove check for th_zone->therm_dev at exynos_report_trigger()

 drivers/thermal/samsung/exynos_thermal_common.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index f10a6ad..c2301da 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -310,8 +310,6 @@ void exynos_report_trigger(struct thermal_sensor_conf *conf)
 	}
 
 	th_zone = conf->pzone_data;
-	if (th_zone->therm_dev)
-		return;
 
 	if (th_zone->bind == false) {
 		for (i = 0; i < th_zone->cool_dev_size; i++) {
-- 
1.7.10.4

