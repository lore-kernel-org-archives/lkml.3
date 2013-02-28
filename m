Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3B1IDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:03:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:9855 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3B1IDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:03:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,754,1355126400"; 
   d="scan'208";a="207211867"
Subject: [PATCH 5/5] hwspinlock/core: call pm_runtime_put in
 pm_runtime_get_sync failed case
From: Li Fei <fei.li@intel.com>
To: ohad@wizery.com
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
        fei.li@intel.com
In-Reply-To: <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Feb 2013 16:02:09 +0800
Message-ID: <1362038529.6212.22.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even in failed case of pm_runtime_get_sync, the usage_count
is incremented. In order to keep the usage_count with correct
value and runtime power management to behave correctly, call
pm_runtime_put(_sync) in such case.

In __hwspin_lock_request, module_put is also called before
return in pm_runtime_get_sync failed case.

Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 drivers/hwspinlock/hwspinlock_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index db713c0..5a5076d 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -416,6 +416,8 @@ static int __hwspin_lock_request(struct hwspinlock *hwlock)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "%s: can't power on device\n", __func__);
+		pm_runtime_put(dev);
+		module_put(dev->driver->owner);
 		return ret;
 	}
 
-- 
1.7.4.1



