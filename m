Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab3B1OtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:49:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab3B1OtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>, Dan Williams <djbw@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 081/139] dca: check against empty dca_domains list before unregister provider
Date: Thu, 28 Feb 2013 14:43:51 +0000
Message-Id: <1362062689-2567-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Sosnowski <maciej.sosnowski@intel.com>

commit c419fcfd071cf34ba00f9f65282583772d2655e7 upstream.

When providers get blocked unregister_dca_providers() is called ending up
with dca_providers and dca_domain lists emptied. Dca should be prevented from
trying to unregister any provider if dca_domain list is found empty.

Reported-by: Jiang Liu <jiang.liu@huawei.com>
Tested-by: Gaohuai Han <hangaohuai@huawei.com>
Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <djbw@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dca/dca-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index bc6f5fa..819dfda 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -420,6 +420,11 @@ void unregister_dca_provider(struct dca_provider *dca, struct device *dev)
 
 	raw_spin_lock_irqsave(&dca_lock, flags);
 
+	if (list_empty(&dca_domains)) {
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
+		return;
+	}
+
 	list_del(&dca->node);
 
 	pci_rc = dca_pci_rc_from_dev(dev);
-- 
1.8.1.2

