Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3C1CzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 22:55:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48393 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab3C1CzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 22:55:09 -0400
Message-ID: <5153B0ED.8020309@huawei.com>
Date: Thu, 28 Mar 2013 10:54:37 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: <fenghua.yu@intel.com>
CC: <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH] ia64: Fix example error_injection_tool
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a "sched_setaffinity:: Invalid argument" error when using
err_injection_tool to inject error on a system with over 32 cpus.

Error information when injecting an error on a system with over 32 cpus:
$ ./err_injection_tool -i
/sys/devices/system/cpu/cpu0/err_inject//err_type_info
Begine at Tue Mar 26 11:20:08 2013
Configurations:
On cpu32: loop=10, interval=5(s) err_type_info=4101,err_struct_info=95
Error sched_setaffinity:: Invalid argument
All done

This because there is overflow when calculating the cpumask: the
type of (1<<k) is int, while mask[j] is unsigned long. When k > 31,
(1<<k) is truncated to ZERO, resulting in a unexpected cpumask.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 Documentation/ia64/err_inject.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/ia64/err_inject.txt b/Documentation/ia64/err_inject.txt
index 223e4f0..ec61ac1 100644
--- a/Documentation/ia64/err_inject.txt
+++ b/Documentation/ia64/err_inject.txt
@@ -882,7 +882,7 @@ int err_inj()
 			cpu=parameters[i].cpu;
 			k = cpu%64;
 			j = cpu/64;
-			mask[j]=1<<k;
+			mask[j] = (unsigned long)1<<k;

 			if (sched_setaffinity(0, MASK_SIZE*8, mask)==-1) {
 				perror("Error sched_setaffinity:");
-- 
1.6.0.2

