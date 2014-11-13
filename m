Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbaKMRDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:03:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50872 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933428AbaKMRDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:03:48 -0500
X-AuditID: cbfee61a-f79c06d000004e71-77-5464e472754d
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
Subject: [PATCH 8/8] thermal:core:fix: Check return code of the
 ->get_max_state() callback
Date: Thu, 13 Nov 2014 18:02:45 +0100
Message-id: <1415898165-27406-9-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jQd2iJykhBjt3GllsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbfHm4WZGi8u75rBZfO49wmjR+WUWm8WDq9PYLJ48
	7GOzeHWwjcXi5655LBbHTsxgdRDweLLpIqPHzll32T0W73nJ5LFu2ltmjwOTz7F69Da/Y/P4
	dmYii0ffllWMHk9/7GX2+LxJzmPj3NAA7igum5TUnMyy1CJ9uwSujK3XtrAULOWs2Ni4hKWB
	8Tp7FyMnh4SAicT355ugbDGJC/fWs3UxcnEICUxnlOg5fYkJwulikrg9oYERpIpNQE/i892n
	TCC2iIC3xOt90xlBipgFXrNIHPrRADZKWCBGYs37fjCbRUBVomXhF1YQm1fATeLhua2sEOsU
	JbqfTWADsTkF3CWOnvjEDrGtmVHic98s1gmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn
	525iBIf6M6kdjCsbLA4xCnAwKvHwvmBJCRFiTSwrrsw9xCjBwawkwlt9HyjEm5JYWZValB9f
	VJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qB0cnTR+rECy2DBS/mM/5j/X/u
	yP/zf+arpOfvaA94lfRFePeW5795Wwtjuxusnnr+Efh3Nl/NQcsp+tWfrUrs/IE6Dp8a43JV
	ug+pr26yPcVTFZO9a+mceM2kXS0bG+q7Mm6IWXW8keTsikgM+bIhg+/1W7lK6/mr2L6yXzoc
	ODWIn6Fj+w5/JZbijERDLeai4kQA84Lle3ECAAA=
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
index 413daa4..c1ddef1 100644
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

