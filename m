Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab3LBU7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:59:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3LBTNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3.10 077/173] PM / runtime: Use pm_runtime_put_sync() in __device_release_driver()
Date: Mon,  2 Dec 2013 11:11:00 -0800
Message-Id: <20131202191152.182463681@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/dd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -499,7 +499,7 @@ static void __device_release_driver(stru
 						     BUS_NOTIFY_UNBIND_DRIVER,
 						     dev);
 
-		pm_runtime_put(dev);
+		pm_runtime_put_sync(dev);
 
 		if (dev->bus && dev->bus->remove)
 			dev->bus->remove(dev);


