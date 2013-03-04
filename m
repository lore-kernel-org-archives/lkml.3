Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3CDESD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:18:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60798 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755485Ab3CDDmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:40 -0500
Message-Id: <20130304033708.379229021@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:14 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Gaohuai Han <hangaohuai@huawei.com>,
        Dan Williams <djbw@fb.com>
Subject: [ 007/153] dca: check against empty dca_domains list before unregister provider
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/dca/dca-core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -420,6 +420,11 @@ void unregister_dca_provider(struct dca_
 
 	raw_spin_lock_irqsave(&dca_lock, flags);
 
+	if (list_empty(&dca_domains)) {
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
+		return;
+	}
+
 	list_del(&dca->node);
 
 	pci_rc = dca_pci_rc_from_dev(dev);


