Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbaHEK65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:58:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18304 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbaHEKsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:54 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-9c-53e0b692c947
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
Subject: [PATCH 02/29] ARM: Exynos: bind power domains earlier,
 on device creation
Date: Tue, 05 Aug 2014 12:47:30 +0200
Message-id: <1407235677-26324-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7qTtj0INtj6R83i76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlfFnxX2mgj6eipdrfzE2MHZydTFyckgImEi8
	2HiMDcIWk7hwbz2QzcUhJLCUUWLOvhtQTh+TxLJnH5lAqtgEDCW63naBJUQEehkl+pt+MIE4
	zALrWCX2915nAakSFgiRmLewEWwui4CqxL2l01lBbF4BD4m+Q/NYIfbJSfx/uQJsKqeAp8Th
	mwfA4kJANT83rGGfwMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZI7HzZwbj4mNUh
	RgEORiUeXoPTd4OFWBPLiitzDzFKcDArifBKrHkQLMSbklhZlVqUH19UmpNafIiRiYNTqoHR
	cYF+5PZTlt3G+/r0H7hFhkQ3l+tcbL8W7tky+1m/bY5a60+9aTM9cy7J+j/y3vZq9fZbaSlh
	C4X1Py+paXJ5N1dDKHP5pj2zqrarl2cbKi41nO/34/mfq+pdV56Zr3syxfTbn7plERd/8wUs
	Sv+/ceaNmT8+X538qHDK37mapyP86wM0n970VmIpzkg01GIuKk4EAMYdoxF7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches change initialization time of power domain driver from client
device driver bind to device creation. This lets other core drivers to
register power domain notifiers before client driver is bound.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-exynos/pm_domains.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index fd76e1b..1d368a2 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -159,13 +159,13 @@ static int exynos_pm_notifier_call(struct notifier_block *nb,
 	struct device *dev = data;
 
 	switch (event) {
-	case BUS_NOTIFY_BIND_DRIVER:
+	case BUS_NOTIFY_ADD_DEVICE:
 		if (dev->of_node)
 			exynos_read_domain_from_dt(dev);
 
 		break;
 
-	case BUS_NOTIFY_UNBOUND_DRIVER:
+	case BUS_NOTIFY_DEL_DEVICE:
 		exynos_remove_device_from_domain(dev);
 
 		break;
@@ -177,6 +177,13 @@ static struct notifier_block platform_nb = {
 	.notifier_call = exynos_pm_notifier_call,
 };
 
+static int exynos_pm_domain_add(struct device *dev, void *priv)
+{
+	if (dev->of_node)
+		exynos_read_domain_from_dt(dev);
+	return 0;
+}
+
 static __init int exynos4_pm_init_power_domain(void)
 {
 	struct platform_device *pdev;
@@ -236,6 +243,7 @@ no_clk:
 	}
 
 	bus_register_notifier(&platform_bus_type, &platform_nb);
+	bus_for_each_dev(&platform_bus_type, NULL, NULL, exynos_pm_domain_add);
 
 	return 0;
 }
-- 
1.9.2

