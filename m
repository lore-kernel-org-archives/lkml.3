Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaJ0CLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:11:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28103 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJ0CLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:11:14 -0400
From: HuKeping <hukeping@huawei.com>
To: <linux@arm.linux.org.uk>, <will.deacon@arm.com>, <dave.martin@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>, <sdu.liu@huawei.com>, <wangnan0@huawei.com>
Subject: [PATCH v2] ARM: kexec: Fix validating CPU hotplug support
Date: Mon, 27 Oct 2014 10:09:09 +0800
Message-ID: <1414375749-42552-1-git-send-email-hukeping@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2:
 -do some source format	

Due to commit:2103f6cba61a8b8bea3fc1b63661d830a2125e76, there is
a hotplug checking in machine_kexec_prepare(), but it will lead
a failure when loading the crash-kernel in some cases.

Kexec utility can load the crash kernel by two ways:
1. kexec -l kernel-image --append=command-line-options --initrd=initrd-image
2. kexec -p kernel-image --append=command-line-options --initrd=initrd-image

In case #1, it's ok to do the hotplug checking things, for it will cut off
cpus in _cpu_down() later when command "kexec -e" be sended, function _cpu_down()
needs the support of cpu hotplug.

In case #2, it is no need to do the checking, because we actually do not
shut the cpus down, but just keep them invoking cpu_relax(), the whole routing
has no business with cpu cutting off. That means, even if the CONFIG_HOTPLUG_CPU
was not selected, it can also load and reboot the crash-kernel successfully if
we use "kexec -p ..."  and then a crash came to trigger the kexec.

Prior to this patch, if the first kernel is not support the CPU hotplug, we can not
use kexec utility.

Signed-off-by: Hu Keping <hukeping@huawei.com>
---
 arch/arm/kernel/machine_kexec.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 8cf0996..f5ebccb 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -41,12 +41,19 @@ int machine_kexec_prepare(struct kimage *image)
 	int i, err;
 
 	/*
-	 * Validate that if the current HW supports SMP, then the SW supports
-	 * and implements CPU hotplug for the current HW. If not, we won't be
-	 * able to kexec reliably, so fail the prepare operation.
+	 * When it is a * crash * triggered the kexec, we do not really shut the
+	 * cpus down but just let them keep invoking cpu_relax(), so there is no need
+	 * to do the hotplug checking things.
 	 */
-	if (num_possible_cpus() > 1 && !platform_can_cpu_hotplug())
-		return -EINVAL;
+	if (image->type != KEXEC_TYPE_CRASH) {
+		/*
+		 * Validate that if the current HW supports SMP, then the SW supports
+		 * and implements CPU hotplug for the current HW. If not, we won't be
+		 * able to kexec reliably, so fail the prepare operation.
+		 */
+		if (num_possible_cpus() > 1 && !platform_can_cpu_hotplug())
+			return -EINVAL;
+	}
 
 	/*
 	 * No segment at default ATAGs address. try to locate
-- 
1.8.5.5

