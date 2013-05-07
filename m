Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3EGEEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:04:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760324Ab3EGD6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:54 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=yVUFf2L-LzoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ZxbRgH806-EA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=2LjLHKtCAAAA:8 a=U2LwS5Jzcp2OXw0c3YIA:9 a=dGJ0OcVc7YAA:10 a=C3PaYh0q9tsA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035844.736233801@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Fei <fei.li@intel.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [023/126] hwspinlock: fix __hwspin_lock_request error path
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0023-hwspinlock-fix-__hwspin_lock_request-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Li Fei <fei.li@intel.com>

[ Upstream commit c10b90d85a5126d25c89cbaa50dc9fdd1c4d001a ]

Even in failed case of pm_runtime_get_sync, the usage_count
is incremented. In order to keep the usage_count with correct
value and runtime power management to behave correctly, call
pm_runtime_put_noidle in such case.

In __hwspin_lock_request, module_put is also called before
return in pm_runtime_get_sync failed case.

Cc: stable@vger.kernel.org
Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
[edit commit log]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/hwspinlock/hwspinlock_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index db713c0..461a0d7 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -416,6 +416,8 @@ static int __hwspin_lock_request(struct hwspinlock *hwlock)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "%s: can't power on device\n", __func__);
+		pm_runtime_put_noidle(dev);
+		module_put(dev->driver->owner);
 		return ret;
 	}
 
-- 
1.7.10.4


