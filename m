Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab3HOSAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:00:22 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:43413 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756045Ab3HOSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:00:18 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, joe@perches.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, tony@atomide.com,
        ohad@wizery.com, andreas.herrmann@calxeda.com, will.deacon@arm.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: [PATCH 4/7] iommu: Change iommu driver to call attach_device_to_domain trace event
Date: Thu, 15 Aug 2013 11:59:26 -0600
Message-Id: <adcf434c5cc4714b12b3f54321308686ef3b6ebc.1376587770.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1376587770.git.shuah.kh@samsung.com>
References: <cover.1376587770.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change iommu driver to call attach_device_to_domain trace event. This
iommu_device class event can be enabled to trigger when devices are attached
to a domain. Trace information includes device name.

Testing:
Added trace calls to iommu_prepare_identity_map() for testing some of the
conditions that are hard to trigger. Here is the trace from the testing:

      swapper/0-1     [003] ....     1.854102: attach_device_to_domain: IOMMU: device=0000:00:02.0

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/iommu/iommu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 278055b..74c371c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -685,10 +685,14 @@ EXPORT_SYMBOL_GPL(iommu_domain_free);
 
 int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 {
+	int ret;
 	if (unlikely(domain->ops->attach_dev == NULL))
 		return -ENODEV;
 
-	return domain->ops->attach_dev(domain, dev);
+	ret = domain->ops->attach_dev(domain, dev);
+	if (!ret)
+		trace_attach_device_to_domain(dev);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_attach_device);
 
-- 
1.7.10.4

