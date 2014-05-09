Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaEIIkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:40:42 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:38230 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaEIIkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:40:40 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v6 1/2 ] Use lock_device_hotplug() in cpu_probe_store() and cpu_release_store()
Date: Fri,  9 May 2014 16:40:15 +0800
Message-Id: <1399624816-11127-1-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399624508.2630.11.camel@ThinkPad-T5421.cn.ibm.com>
References: <1399624508.2630.11.camel@ThinkPad-T5421.cn.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050908-5564-0000-0000-00000D95F0D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While auditing the usage of lock_device_hotplug_sysfs() for implementing
it in another way in following patch, it seems to me that the code here
is to add/remove device, and the files probe/release themselves won't be
removed.

lock_device_hotplug_sysfs() is used to solve the deadlocks of s_active of
the "online" file and the hotplug related locks.

So if one process trying to remove the device, the sysfs files for this device,
including "online" will be removed after device_hotplug_lock is grabbed.
So for another process which might concurrently write to the "online" file,
after it grabs s_active of the "online", it couldn't directly lock
device_hotplug_lock, instead, in *_sysfs() version, try lock is used, and if
it fails, the whole syscall is restarted.

But here the s_active of "probe/release" are not involved in the above process,
as they are not to be removed. So we could use lock_device_hotplug() here.

Cc: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/base/cpu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 006b1bc..9483225 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -88,9 +88,7 @@ static ssize_t cpu_probe_store(struct device *dev,
 	ssize_t cnt;
 	int ret;
 
-	ret = lock_device_hotplug_sysfs();
-	if (ret)
-		return ret;
+	lock_device_hotplug();
 
 	cnt = arch_cpu_probe(buf, count);
 
@@ -106,9 +104,7 @@ static ssize_t cpu_release_store(struct device *dev,
 	ssize_t cnt;
 	int ret;
 
-	ret = lock_device_hotplug_sysfs();
-	if (ret)
-		return ret;
+	lock_device_hotplug();
 
 	cnt = arch_cpu_release(buf, count);
 
-- 
1.8.1.4

