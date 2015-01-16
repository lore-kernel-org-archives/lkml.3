Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbbAPDsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 22:48:04 -0500
Received: from [119.145.14.66] ([119.145.14.66]:22876 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbbAPDr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 22:47:57 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@linux.intel.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        <linux-ia64@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, <linux-alpha@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, Liviu Dudau <liviu@dudau.co.uk>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Yijing Wang" <wangyijing@huawei.com>
Subject: [PATCH 08/28] PCI: Introduce pci_host_assign_domain_nr() to assign domain
Date: Fri, 16 Jan 2015 09:44:06 +0800
Message-ID: <1421372666-12288-9-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54B889C1.0135,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: ac34f7c109f603b98b97e9f02bd0cef8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce pci_host_assign_domain_nr() to assign domain
number for pci_host_bridge. Later we will remove
pci_bus_assign_domain_nr().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pci.c   |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    4 ++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c419554..8b35e8e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4443,6 +4443,53 @@ int pci_get_new_domain_nr(void)
 }
 
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
+void pci_host_assign_domain_nr(struct pci_host_bridge *host)
+{
+	static int use_dt_domains = -1;
+	struct device *parent = host->dev.parent;
+	int domain = of_get_pci_domain_nr(parent->of_node);
+
+	/*
+	 * Check DT domain and use_dt_domains values.
+	 *
+	 * If DT domain property is valid (domain >= 0) and
+	 * use_dt_domains != 0, the DT assignment is valid since this means
+	 * we have not previously allocated a domain number by using
+	 * pci_get_new_domain_nr(); we should also update use_dt_domains to
+	 * 1, to indicate that we have just assigned a domain number from
+	 * DT.
+	 *
+	 * If DT domain property value is not valid (ie domain < 0), and we
+	 * have not previously assigned a domain number from DT
+	 * (use_dt_domains != 1) we should assign a domain number by
+	 * using the:
+	 *
+	 * pci_get_new_domain_nr()
+	 *
+	 * API and update the use_dt_domains value to keep track of method we
+	 * are using to assign domain numbers (use_dt_domains = 0).
+	 *
+	 * All other combinations imply we have a platform that is trying
+	 * to mix domain numbers obtained from DT and pci_get_new_domain_nr(),
+	 * which is a recipe for domain mishandling and it is prevented by
+	 * invalidating the domain value (domain = -1) and printing a
+	 * corresponding error.
+	 */
+	if (domain >= 0 && use_dt_domains) {
+		use_dt_domains = 1;
+	} else if (domain < 0 && use_dt_domains != 1) {
+		use_dt_domains = 0;
+		domain = pci_get_new_domain_nr();
+	} else {
+		dev_err(parent, "Node %s has inconsistent \"linux,pci-domain\" property in DT\n",
+			parent->of_node->full_name);
+		domain = -1;
+	}
+
+	host->domain_nr = domain;
+}
+
+
 void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
 {
 	static int use_dt_domains = -1;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c771508..1b9c799 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1316,11 +1316,15 @@ static inline int pci_domain_nr(struct pci_bus *bus)
 	return bus->domain_nr;
 }
 void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent);
+void pci_host_assign_domain_nr(struct pci_host_bridge *host);
 #else
 static inline void pci_bus_assign_domain_nr(struct pci_bus *bus,
 					struct device *parent)
 {
 }
+static inline void pci_host_assign_domain_nr(struct pci_host_bridge *host)
+{
+}
 #endif
 
 /* some architectures require additional setup to direct VGA traffic */
-- 
1.7.1

