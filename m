Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaDUJVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:21:12 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:59465 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaDUJVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:21:09 -0400
Message-ID: <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [RFC PATCH v5 1/2] Use lock_device_hotplug() in cpu_probe_store()
 and cpu_release_store()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Mon, 21 Apr 2014 17:20:59 +0800
In-Reply-To: <20140417151728.GK15326@htj.dyndns.org>
References: <20140410133116.GB25308@htj.dyndns.org>
	 <1397189445.3649.14.camel@ThinkPad-T5421>
	 <20140411102649.GB26252@mtj.dyndns.org>
	 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140414201315.GD16835@htj.dyndns.org>
	 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140415145017.GK1863@htj.dyndns.org>
	 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
	 <1397717444.4034.15.camel@ThinkPad-T5421>
	 <20140417151728.GK15326@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042109-3548-0000-0000-000008CE6481
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While auditing the usage of lock_device_hotplug_sysfs() for implementing
it in another way in following patch, it seems to me that the code here
is to add/remove device, and the files probe/release for cpu bus
themselves won't be removed. 

So it seems to me there is no s_active related deadlock here, and we
could just use lock_device_hotplug().

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
 


