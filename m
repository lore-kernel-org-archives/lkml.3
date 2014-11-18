Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaKRKQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:16:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51820 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaKRKQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:16:55 -0500
X-AuditID: cbfee61a-f79c06d000004e71-87-546b1c94a336
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v2] thermal:core:fix: Check return code of the
 ->get_max_state() callback
Date: Tue, 18 Nov 2014 11:16:30 +0100
Message-id: <1416305790-27746-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
References: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jAd0pMtkhBk1nZSw2zljPajH/yjVW
	i9OnFrBanHv1iMXibXOxxavDuxgt3jzitnjzcDOjxeVdc9gsPvceYbTo/DKLzeLB1WlsFk8e
	9rFZvDrYxmLxc9c8FotjJ2awOgh4PNl0kdFj56y77B6L97xk8lg37S2zx4HJ51g9epvfsXl8
	OzORxaNvyypGj6c/9jJ7fN4k57FxbmgAdxSXTUpqTmZZapG+XQJXxsY1e1gKJvJWtG+6ztrA
	+Iiri5GTQ0LAROL71I+sELaYxIV769m6GLk4hAQWMUr8bN/HCOF0MUncOP+aBaSKTUBP4vPd
	p0wgtoiAt8TrfdPBipgFXrNIHPrRwA6SEBaIlvjf8ZkRxGYRUJW4OOsAWAOvgJvE7klrGSHW
	KUp0P5vABmJzCrhLHD3xCaxXCKjm+PuV7BMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECA70Z1I7GFc2WBxiFOBgVOLhTZiaFSLEmlhWXJl7iFGCg1lJhPdcN1CINyWxsiq1KD++
	qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QD43GLXdKvNCwS976O/lRQUqH/
	jOvbh7lHFvnNv2h6+6PIM9sk3ee396QIevM99tXYuSNXrvL87sismzHM9qp3blhn/H5p/6or
	UaJXL0o33OLzoV/1S/PNz7Lzac1s2O316Oes5jOlX+7EM7N9tGaxrtNiF7wcFrgnd+G+Wfax
	xbclzkQd2X9fR4mlOCPRUIu5qDgRAMgg+jZwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return code from ->get_max_state() callback was not checked during
binding cooling device to thermal zone device.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v2:
- It turned out that patches from 1 to 6 from v1 are not needed, since
  they either already solve the problem (like imx_thermal.c) or not use
  cpufreq as a thermal cooling device.
- The patch 7 from v1 is also not needed since this patch on error exits
  this function without using max_state variable.
- In thermal driver probe the cpufreq_cooling_register() method presence
  is crucial to evaluate if the thermal driver needs any actions with 
  -EPROBE_DEFER.
---
 drivers/thermal/thermal_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 43b9070..8567929 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -928,7 +928,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
 	unsigned long max_state;
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

