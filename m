Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab3LFNC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:02:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44164 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3LFNCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 128/272] PM / runtime: Use pm_runtime_put_sync() in __device_release_driver()
Date: Fri,  6 Dec 2013 12:56:57 +0000
Message-Id: <1386334761-25517-129-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit baab52ded242c35a2290e1fa82e0cc147d0d8c1a upstream.

Commit fa180eb448fa (PM / Runtime: Idle devices asynchronously after
probe|release) modified __device_release_driver() to call
pm_runtime_put(dev) instead of pm_runtime_put_sync(dev) before
detaching the driver from the device.  However, that was a mistake,
because pm_runtime_put(dev) causes rpm_idle() to be queued up and
the driver may be gone already when that function is executed.
That breaks the assumptions the drivers have the right to make
about the core's behavior on the basis of the existing documentation
and actually causes problems to happen, so revert that part of
commit fa180eb448fa and restore the previous behavior of
__device_release_driver().

Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Fixes: fa180eb448fa (PM / Runtime: Idle devices asynchronously after probe|release)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/base/dd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 35fa368..0605176 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -499,7 +499,7 @@ static void __device_release_driver(struct device *dev)
 						     BUS_NOTIFY_UNBIND_DRIVER,
 						     dev);
 
-		pm_runtime_put(dev);
+		pm_runtime_put_sync(dev);
 
 		if (dev->bus && dev->bus->remove)
 			dev->bus->remove(dev);
-- 
1.8.3.2

