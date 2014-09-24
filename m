Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaIXI1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:27:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28512 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaIXI1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:50 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-ac-5422808477c3
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 2/3] thermal: core: fix: Initialize the max_state variable to 0
Date: Wed, 24 Sep 2014 10:27:11 +0200
Message-id: <1411547232-21493-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t9jAd2WBqUQgwd/LC02zljPajH/yjVW
	izePuC3ePNzMaHF51xw2i8+9RxgtnjzsY3Ng99g56y67x+I9L5k81k17y+zRt2UVo8fnTXIB
	rFFcNimpOZllqUX6dglcGW9n3WUrWM5dsXnJG/YGxr2cXYycHBICJhKTNs5hg7DFJC7cWw9m
	CwksYpT4fiuzi5ELyO5iknjVvh8swSagJ/H57lOmLkYODhEBb4ktazhAapgFbjBKTOmfDBYX
	FvCXmHE5BKScRUBVYunfzcwgYV4BN4n9TVBrFSW6n00Am8gp4C5x8/czdoi1bhIHfx1kn8DI
	u4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcDg9k97BuKrB4hCjAAejEg/vBHGlECHW
	xLLiytxDjBIczEoivCdKgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphak
	FsFkmTg4pRoYO9ViXqwRy+3eFOXn4z/xcJHPwdsWryYZb9jUt/7jobuX7LKy1oj26nFNdPFd
	p5qpX+nS8m36QaljNqse5LnlZ/F4OF06K3XnfO5lu0zHb6GbfvXc5ejPCSz6dJIpZ2KpeeS/
	/g1yTL8u6ffeUXeaEqRfcjOqcgVj7c3Gd4uz1EVtgryLs/KVWIozEg21mIuKEwG6/sEwIwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointer to the uninitialized max_state variable is passed to get the
maximal cooling state.
For CPU cooling device (cpu_cooling.c) the cpufreq_get_max_state() is
called, which even when error occurs will return the max_state variable
unchanged.
Since error for ->get_max_state() is not checked, the automatically
allocated value of max_state is used for (upper > max_state) comparison.
For any possible max_state value it is very unlikely that it will be less
than upper.
As a consequence, the cooling device is bind even without the backed
cpufreq table initialized.

This initialization will prevent from accidental binding trip points to
cpu freq cooling frequencies when cpufreq driver itself is not yet fully
initialized.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/thermal_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 454884a..747618a 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -927,7 +927,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos;
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
-	unsigned long max_state;
+	unsigned long max_state = 0;
 	int result;
 
 	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
-- 
2.0.0.rc2

