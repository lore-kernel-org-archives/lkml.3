Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbaHEK67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:58:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44572 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaHEKsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:54 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-7a-53e0b694a1ab
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 04/29] drivers: base: add notifier for failed driver bind
Date: Tue, 05 Aug 2014 12:47:32 +0200
Message-id: <1407235677-26324-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xq7pTtj0INvj7WNzi76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlfFybitbwWaRiov/77E1MJ4X6GLk5JAQMJGY
	2b2KCcIWk7hwbz1bFyMXh5DAUkaJu9tesEA4fUwSr36uYgWpYhMwlOh62wVWJSLQyyjR3/SD
	CcRhFljHKrG/9zpQCweHsICnxLrjciAmi4CqxNUv1iC9vAIeEtdnrWGF2CYn8f/lCrDNnEDV
	h28eAIsLAdX83LCGfQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIXHzdQfj0mNW
	hxgFOBiVeHgV9t4NFmJNLCuuzD3EKMHBrCTCK7HmQbAQb0piZVVqUX58UWlOavEhRiYOTqkG
	xuDS8i8+3f6z7++J1el3W8pipDpXNDZ/r5MHO/+bA18+6DvZPTghvryq8++XD46/9sy9dvHv
	TvN6tW9chun1yxQ1TP6cZxK2y74xd96T4j29rY2bjaRMr6b7f6nofnJmk6CK5kqNQwVPBJxD
	rpy6pWN1dvccuSsMnI2TZSXVKl+90Tx4KkV5gRJLcUaioRZzUXEiAFwsL7d5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for getting a notify for failed device driver
bind, so all the items done in BUS_NOTIFY_BIND_DRIVER event can be
cleaned if the driver fails to bind.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dd.c      | 10 +++++++---
 include/linux/device.h |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e4ffbcf..541a41f 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -237,10 +237,14 @@ static int driver_sysfs_add(struct device *dev)
 	return ret;
 }
 
-static void driver_sysfs_remove(struct device *dev)
+static void driver_sysfs_remove(struct device *dev, int failed)
 {
 	struct device_driver *drv = dev->driver;
 
+	if (failed && dev->bus)
+		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
+					     BUS_NOTIFY_DRVBIND_FAILED, dev);
+
 	if (drv) {
 		sysfs_remove_link(&drv->p->kobj, kobject_name(&dev->kobj));
 		sysfs_remove_link(&dev->kobj, "driver");
@@ -316,7 +320,7 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 probe_failed:
 	devres_release_all(dev);
-	driver_sysfs_remove(dev);
+	driver_sysfs_remove(dev, true);
 	dev->driver = NULL;
 	dev_set_drvdata(dev, NULL);
 
@@ -509,7 +513,7 @@ static void __device_release_driver(struct device *dev)
 	if (drv) {
 		pm_runtime_get_sync(dev);
 
-		driver_sysfs_remove(dev);
+		driver_sysfs_remove(dev, false);
 
 		if (dev->bus)
 			blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
diff --git a/include/linux/device.h b/include/linux/device.h
index b387710..92daded 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -176,7 +176,7 @@ extern int bus_register_notifier(struct bus_type *bus,
 extern int bus_unregister_notifier(struct bus_type *bus,
 				   struct notifier_block *nb);
 
-/* All 4 notifers below get called with the target struct device *
+/* All 7 notifers below get called with the target struct device *
  * as an argument. Note that those functions are likely to be called
  * with the device lock held in the core, so be careful.
  */
@@ -189,6 +189,8 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 						      unbound */
 #define BUS_NOTIFY_UNBOUND_DRIVER	0x00000006 /* driver is unbound
 						      from the device */
+#define BUS_NOTIFY_DRVBIND_FAILED	0x00000007 /* driver failed to bind
+						      to device */
 
 extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);
-- 
1.9.2

