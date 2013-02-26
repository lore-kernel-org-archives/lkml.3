Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363Ab3B0AEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:04:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511Ab3BZX7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Gaohuai Han <hangaohuai@huawei.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: [ 47/53] dca: check against empty dca_domains list before unregister provider
Date: Tue, 26 Feb 2013 15:58:16 -0800
Message-Id: <20130226235624.751198592@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dca/dca-core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -409,6 +409,11 @@ void unregister_dca_provider(struct dca_
 
 	spin_lock_irqsave(&dca_lock, flags);
 
+	if (list_empty(&dca_domains)) {
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
+		return;
+	}
+
 	list_del(&dca->node);
 
 	pci_rc = dca_pci_rc_from_dev(dev);


