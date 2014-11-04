Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaKDJmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:42:47 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:8407 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaKDJmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:42:43 -0500
From: HuKeping <hukeping@huawei.com>
To: <swarren@nvidia.com>, <ebiederm@xmission.com>, <linux@arm.linux.org.uk>,
        <rmk+kernel@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <sdu.liu@huawei.com>, <wangnan0@huawei.com>, <peifeiyue@huawei.com>
Subject: [RESEND PATCH] ARM: kexec: Fix validating CPU hotplug support
Date: Tue, 4 Nov 2014 17:40:25 +0800
Message-ID: <1415094025-66180-1-git-send-email-hukeping@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020207.54589F91.0198,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 0956f6ba8881a59e97b5690830023778
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2103f6cba61a8b8bea3fc1b63661d830a2125e76 added a hotplug checking in
machine_kexec_prepare(), but it will lead a failure when loading the
crash-kernel in some cases.

Kexec utility can load the crash kernel by two ways:
1. kexec -l kernel-image
2. kexec -p kernel-image

In case #1, for rapid reboot, it's correct to do the hotplug checking things,
for it will shut down cpus in _cpu_down() later when command "kexec -e" be
sent, this routine needs the support of cpu hotplug.

In case #2, for use on panic, it's unnecessary to do the same thing, the whole
routing has no business with cpu shutting down. Check for cpu hot plug will
lead a failure to load the kernel.

Prior to this patch, if the first kernel is not support the CPU hotplug, when
a crash come, the kexec utility will not work.

Signed-off-by: Hu Keping <hukeping@huawei.com>
---
 arch/arm/kernel/machine_kexec.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 8cf0996..7706c67 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -41,11 +41,16 @@ int machine_kexec_prepare(struct kimage *image)
 	int i, err;
 
 	/*
+	 * For rapid reboot:
 	 * Validate that if the current HW supports SMP, then the SW supports
 	 * and implements CPU hotplug for the current HW. If not, we won't be
 	 * able to kexec reliably, so fail the prepare operation.
+	 *
+	 * For use on panic:
+	 * It is unnecessary to check the cpu hot plug. 
 	 */
-	if (num_possible_cpus() > 1 && !platform_can_cpu_hotplug())
+	if (image->type != KEXEC_TYPE_CRASH &&
+		(num_possible_cpus() > 1 && !platform_can_cpu_hotplug()))
 		return -EINVAL;
 
 	/*
-- 
1.8.5.5

