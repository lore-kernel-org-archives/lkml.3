Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaHAMpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:45:22 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:49320 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaHAMpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:45:21 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] iommu: Always define struct iommu_ops
Date: Fri,  1 Aug 2014 14:45:12 +0200
Message-Id: <1406897113-20099-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

With this structure always defined, drivers can be always compiled,
irrespective of whether or not IOMMU_API is enabled. This helps to
increase compile coverage without having to build with two separate
configurations.

Unused code can still be discarded by the compiler if the IS_ENABLED()
macro is properly used in an if condition, such as shown below:

	static const struct iommu_ops iommu_ops = {
		...
	};

	static int iommu_setup(...)
	{
		...

		bus_set_iommu(..., &iommu_ops);

		...
	}

	...

	static int iommu_probe(...)
	{
		...

		if (IS_ENABLED(CONFIG_IOMMU_API)) {
			err = iommu_setup(...);
			...
		}

		...
	}

That pattern will allow the compiler to notice that setup_iommu() is
never called if IOMMU_API is not selected, which will allow it to
discard its code and all data referenced from it.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/iommu.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 20f9a527922a..0b5222c7ff97 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -83,8 +83,6 @@ enum iommu_attr {
 	DOMAIN_ATTR_MAX,
 };
 
-#ifdef CONFIG_IOMMU_API
-
 /**
  * struct iommu_ops - iommu ops and capabilities
  * @domain_init: init iommu domain
@@ -140,6 +138,8 @@ struct iommu_ops {
 #define IOMMU_GROUP_NOTIFY_UNBIND_DRIVER	5 /* Pre Driver unbind */
 #define IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER	6 /* Post Driver unbind */
 
+#ifdef CONFIG_IOMMU_API
+
 extern int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
@@ -242,9 +242,6 @@ static inline int report_iommu_fault(struct iommu_domain *domain,
 
 #else /* CONFIG_IOMMU_API */
 
-struct iommu_ops {};
-struct iommu_group {};
-
 static inline bool iommu_present(struct bus_type *bus)
 {
 	return false;
-- 
2.0.3

