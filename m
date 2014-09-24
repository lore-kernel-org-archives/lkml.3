Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaIXI15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:27:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27973 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaIXI1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:54 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-b6-54228088c2ae
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 3/3] thermal: core: fix: Check return code of the
 ->get_max_state() callback
Date: Wed, 24 Sep 2014 10:27:12 +0200
Message-id: <1411547232-21493-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jAd2OBqUQg0PdPBYbZ6xntZh/5Rqr
	xZtH3BZvHm5mtLi8aw6bxefeI4wWTx72sTmwe+ycdZfdY/Gel0we66a9Zfbo27KK0ePzJrkA
	1igum5TUnMyy1CJ9uwSujCWX/zAWLOWs+HD8GEsD43X2LkZODgkBE4kbM+axQNhiEhfurWfr
	YuTiEBJYxCjROrWLCcLpYpLovrwcrIpNQE/i892nQAkODhEBb4ktazhAapgFbjBKTOmfzARS
	IywQJzH36UQwm0VAVeLWt0mMIDavgJvEsR9bobYpSnQ/m8AGYnMKuEvc/P0M7CIhoJqDvw6y
	T2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOKieSe9gXNVgcYhRgINRiYd3grhS
	iBBrYllxZe4hRgkOZiUR3hOlQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNT
	UwtSi2CyTBycUg2My4seJgkt9zhey7aM57PmBZtbV+p+mXS5n9E26spXPPU6XmBrvRRDQcCW
	F5tbrx1Lm83mtOhKimX8uZzoqE/8+nMi5X0lEny1j0z8e2/eQesnGUKHuDrtDU78sTD5dDBF
	cctKq2eCB8zFbFd9Wsa8d/HXkzzlVRufe930eOB+5NSJVtWzwcy8SizFGYmGWsxFxYkAV+Lv
	nSYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this check it was possible to execute cooling device binding code
even when wrong max cooling state was read.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/thermal_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 747618a..8a4dc35 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -928,7 +928,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
 	unsigned long max_state = 0;
-	int result;
+	int result, ret;
 
 	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
 		return -EINVAL;
@@ -945,7 +945,9 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	if (tz != pos1 || cdev != pos2)
 		return -EINVAL;
 
-	cdev->ops->get_max_state(cdev, &max_state);
+	ret = cdev->ops->get_max_state(cdev, &max_state);
+	if (ret)
+		return ret;
 
 	/* lower default 0, upper default max_state */
 	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
-- 
2.0.0.rc2

