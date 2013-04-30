Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368Ab3D3LdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:33:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48052 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760270Ab3D3LdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:33:16 -0400
X-IronPort-AV: E=Sophos;i="4.87,581,1363104000"; 
   d="scan'208,223";a="7159406"
Message-ID: <517FAB89.6080702@cn.fujitsu.com>
Date: Tue, 30 Apr 2013 19:31:21 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, tangchen <tangchen@cn.fujitsu.com>,
        Lin Feng <linfeng@cn.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, guz.fnst@cn.fujitsu.com
Subject: [PATCH v2 1/4] PCI: Introduce pci_alloc_dev(struct pci_bus*) to replace
 alloc_pci_dev()
References: <516FB647.5030203@cn.fujitsu.com> <CAErSpo65ARR_fZwsGCZDJqbPWktHYUkufgPt-2mWwur=nPR1Qg@mail.gmail.com>
In-Reply-To: <CAErSpo65ARR_fZwsGCZDJqbPWktHYUkufgPt-2mWwur=nPR1Qg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 19:31:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 19:31:30,
	Serialize complete at 2013/04/30 19:31:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 888e824c01f9c039622a2ab74c3df3b884fd7b12 Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Mon, 22 Apr 2013 19:04:07 +0900
Subject: [PATCH v2 1/4] PCI: Introduce pci_alloc_dev(struct pci_bus*) to replace
 alloc_pci_dev()

Now here we introduce a new struct pci_dev *pci_alloc_dev(struct pci_bus *bus) to replace alloc_pci_dev().
It take a "struct pci_bus *" argument, so we can alloc a pci device on a target pci bus, and it acquire
the reference of the pci_bus.
We use pci_alloc_dev(NULL) to simplify the old alloc_pci_dev(), and keep it for a while but mark it as __deprecated.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 drivers/pci/probe.c |   13 ++++++++++++-
 include/linux/pci.h |    4 +++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 43ece5d..89db76a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1201,7 +1201,7 @@ static void pci_release_bus_bridge_dev(struct device *dev)
 	kfree(bridge);
 }
 
-struct pci_dev *alloc_pci_dev(void)
+struct pci_dev *pci_alloc_dev(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 
@@ -1211,8 +1211,19 @@ struct pci_dev *alloc_pci_dev(void)
 
 	INIT_LIST_HEAD(&dev->bus_list);
 
+	if (bus) {
+		get_device(&bus->dev);
+		dev->bus = bus;
+	}
+
 	return dev;
 }
+EXPORT_SYMBOL(pci_alloc_dev);
+
+struct pci_dev *alloc_pci_dev(void)
+{
+	return pci_alloc_dev(NULL);
+}
 EXPORT_SYMBOL(alloc_pci_dev);
 
 bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *l,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index e73dfa3..6c09949 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -364,7 +364,9 @@ static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
 	return dev;
 }
 
-struct pci_dev *alloc_pci_dev(void);
+struct pci_dev *pci_alloc_dev(struct pci_bus *bus);
+
+__deprecated struct pci_dev *alloc_pci_dev(void);
 
 #define	to_pci_dev(n) container_of(n, struct pci_dev, dev)
 #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
-- 
1.7.7

