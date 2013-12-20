Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3LTSst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:48:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52477 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3LTSs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:48:29 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-a7-52b490fcda26
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, lenb@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 9/9] cpuidle: remove state_count field from struct
 cpuidle_device
Date: Fri, 20 Dec 2013 19:47:31 +0100
Message-id: <1387565251-7051-10-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t9jQd0/E7YEGex5IWaxccZ6Vot5n2Ut
	zja9YbfY+fAtm8XlXXPYLD73HmG0mHF+H5PF7+//WC3OnL7E6sDpsWlVJ5vHnWt72DzOz1jI
	6LHlajuLR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGW0v//LXHBIoGLSpovsDYwPebsYOTkk
	BEwk7vZ/YYGwxSQu3FvPBmILCUxnlDh8taiLkQvI7mKSuPNsMStIgk3ASmJi+ypGEFtEQFTi
	8u4JLCBFzAKPGSVmN01hBkkIC4RJbDiwA8xmEVCV+LznFlgzr4CHxNGNZ5ggtilKdD+bALaN
	Eyg++9VyJojN7hInun4zT2DkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOOSeSe9g
	XNVgcYhRgINRiYdXInJLkBBrYllxZe4hRgkOZiUR3pttQCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2MK170LFd4xqi6YPpSBpfkSLP8H9WdsSLrXPM/
	7Wzx4b11vt/ums29+32BXW7si+YcCg46//K5SvLt4teHzh1hKRFL/vRnvmPzAq6n0u82Heee
	XZE3yfLAvWmVXFf2bXXadfvo4qf/mPOF9L7M8rg0MeKaoGqR4+qzLHsqpl1vn7xe7mdCR22Z
	iRJLcUaioRZzUXEiAJs00+g1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev->state_count is now always equal to drv->state_count so
it can be removed.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/cpuidle/cpuidle.c | 3 ---
 drivers/cpuidle/sysfs.c   | 5 +++--
 include/linux/cpuidle.h   | 1 -
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a55e68f..e3d2052 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -252,9 +252,6 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 	if (!dev->registered)
 		return -EINVAL;
 
-	if (!dev->state_count)
-		dev->state_count = drv->state_count;
-
 	ret = cpuidle_add_device_sysfs(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index e918b6d..dcaae4c 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -398,7 +398,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(device);
 
 	/* state statistics */
-	for (i = 0; i < device->state_count; i++) {
+	for (i = 0; i < drv->state_count; i++) {
 		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
 		if (!kobj)
 			goto error_state;
@@ -430,9 +430,10 @@ error_state:
  */
 static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
 {
+	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(device);
 	int i;
 
-	for (i = 0; i < device->state_count; i++)
+	for (i = 0; i < drv->state_count; i++)
 		cpuidle_free_state_kobj(device, i);
 }
 
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 50fcbb0..d133817 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -69,7 +69,6 @@ struct cpuidle_device {
 	unsigned int		cpu;
 
 	int			last_residency;
-	int			state_count;
 	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 	struct cpuidle_driver_kobj *kobj_driver;
-- 
1.8.2.3

