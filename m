Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3DVOea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:34:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51682 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755095Ab3DVOaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ohad Ben-Cohen" <ohad@wizery.com>,
        "Li Fei" <fei.li@intel.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.187307725@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [23/75] hwspinlock: fix __hwspin_lock_request error path
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Li Fei <fei.li@intel.com>

commit c10b90d85a5126d25c89cbaa50dc9fdd1c4d001a upstream.

Even in failed case of pm_runtime_get_sync, the usage_count
is incremented. In order to keep the usage_count with correct
value and runtime power management to behave correctly, call
pm_runtime_put_noidle in such case.

In __hwspin_lock_request, module_put is also called before
return in pm_runtime_get_sync failed case.

Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
[edit commit log]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwspinlock/hwspinlock_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -416,6 +416,8 @@ static int __hwspin_lock_request(struct
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "%s: can't power on device\n", __func__);
+		pm_runtime_put_noidle(dev);
+		module_put(dev->driver->owner);
 		return ret;
 	}
 

