Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaIAFvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:51:47 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:3504 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaIAFvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:51:46 -0400
From: Wang Long <long.wanglong@huawei.com>
To: <linux@arm.linux.org.uk>, <santosh.shilimkar@ti.com>,
        <victor.kamensky@linaro.org>, <nico@linaro.org>,
        <ben.dooks@codethink.co.uk>, <cov@codeaurora.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <long.wanglong@huawei.com>
Subject: [SMP BUG?] the return value of is_smp() is bug?
Date: Mon, 1 Sep 2014 13:49:23 +0800
Message-ID: <1409550563-92081-1-git-send-email-long.wanglong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.200]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,all

In kernel 3.17-rc2, when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y 
in .config file. the secondary core can not boot.

when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = n in .config file,
the secondary core can boot.

But this does not happen in kernel 3.10 lts kernel, Whether the 
CONFIG_SMP_ON_UP is set yes or no ,the secondary core can boot.

Does the meaning of CONFIG_SMP_ON_UP changed or this is a bug in kernel 3.17-rc2 ? 


I write the following patch to test the return value of is_smp().

----------------------------------------

Signed-off-by: Wang Long <long.wanglong@huawei.com>
---
 arch/arm/kernel/setup.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 84db893d..fbeb67f 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -925,6 +925,11 @@ void __init setup_arch(char **cmdline_p)
 	arm_dt_init_cpu_maps();
 	psci_init();
 #ifdef CONFIG_SMP
+	
+	if (is_smp() == 1)
+		printk("is_smp() return true;\n");
+	else if (is_smp() == 0)
+		printk("is_smp() return false;\n");
 	if (is_smp()) {
 		if (!mdesc->smp_init || !mdesc->smp_init()) {
 			if (psci_smp_available())

kernel version: 3.17-rc2

config:     set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y
command:    # qemu-system-arm -M vexpress-a9 -smp 2  -m 128M -kernel arch/arm/boot/zImage -nographic
The output:

..........
is_smp() return false;
CPU: Testing write buffer coherency: ok
missing device node for CPU 0
CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Setting up static identity map for 0x604643d8 - 0x60464430
Brought up 1 CPUs
SMP: Total of 1 processors activated.
CPU: All CPU(s) started in SVC mode.
...........

config:     set CONFIG_HAVE_SMP = y and not set CONFIG_SMP_ON_UP 
command:    # qemu-system-arm -M vexpress-a9 -smp 2  -m 128M -kernel arch/arm/boot/zImage -nographic
The output:

.....
 Memory policy: Data cache writealloc
is_smp() return true;
sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956969942ns
......
......
CPU: Testing write buffer coherency: ok
missing device node for CPU 0
missing device node for CPU 1
CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Setting up static identity map for 0x60463ef8 - 0x60463f50
CPU1: Booted secondary processor
CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
Brought up 2 CPUs
SMP: Total of 2 processors activated.
CPU: All CPU(s) started in SVC mode.
devtmpfs: initialized
.......

Any ideas?


-- 
1.7.9.5
