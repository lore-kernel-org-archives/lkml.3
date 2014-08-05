Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399AbaHEK6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:58:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18304 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbaHEKs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:48:56 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ad-53e0b6966202
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
Subject: [PATCH 06/29] drivers: iommu: add notify about failed bind
Date: Tue, 05 Aug 2014 12:47:34 +0200
Message-id: <1407235677-26324-7-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7rTtj0INph3mc3i76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlbH7u3DBB+6Kg7+vsjQwtnB1MXJySAiYSJy7
	focNwhaTuHBvPZDNxSEksJRR4uD1JawQTh+TxI+mm8wgVWwChhJdb7vAqkQEehkl+pt+MIE4
	zALrWCX2915nAakSFnCWOPZ6HthcFgFVib5tu1hBbF4BD4m1LQfYIfbJSfx/uYIJxOYU8JQ4
	fPMAWI0QUM3PDWvYJzDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREjlfdjAuPmZ1
	iFGAg1GJh9fg9N1gIdbEsuLK3EOMEhzMSiK8EmseBAvxpiRWVqUW5ccXleakFh9iZOLglGpg
	LJrGqLPqFO/cv7U17EqTNfunXPnyaNK/110J3b01Edf+rliyq8XNWGjXlj3+F/1Tl0/awRWf
	85DbvvtxcW3rRx8p48lni+f/XuY8eaqc7vkHybtWO/+P27TC49sepiqDeU2fvzKUrAm+dGyJ
	dN+VRVkXfZKv9fOefNa1PCl53VL74CWaBmxLE5RYijMSDbWYi4oTATjswiV6AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for forwarding recently introduced
BUS_NOTIFY_DRVBIND_FAILED event to iommu groups. This lets us getting a
notify for failed device driver bind, so all the items done in
IOMMU_GROUP_NOTIFY_BIND_DRIVER event can be cleaned if the driver fails
to bind.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/iommu.c | 3 +++
 include/linux/iommu.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1698360..516e93a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -758,6 +758,9 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 	case BUS_NOTIFY_UNBOUND_DRIVER:
 		group_action = IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER;
 		break;
+	case BUS_NOTIFY_DRVBIND_FAILED:
+		group_action = IOMMU_GROUP_NOTIFY_DRVBIND_FAILED;
+		break;
 	}
 
 	if (group_action)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 20f9a52..f9fdae5 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -139,6 +139,7 @@ struct iommu_ops {
 #define IOMMU_GROUP_NOTIFY_BOUND_DRIVER		4 /* Post Driver bind */
 #define IOMMU_GROUP_NOTIFY_UNBIND_DRIVER	5 /* Pre Driver unbind */
 #define IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER	6 /* Post Driver unbind */
+#define IOMMU_GROUP_NOTIFY_DRVBIND_FAILED	7 /* Driver failed to bind */
 
 extern int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
-- 
1.9.2

