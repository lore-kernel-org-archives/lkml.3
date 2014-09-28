Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaI1Uyu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 16:54:50 -0400
Received: from mail-by2on0123.outbound.protection.outlook.com ([207.46.100.123]:56592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753525AbaI1Uyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 16:54:45 -0400
X-WSS-ID: 0NCMQ2Y-08-OWM-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <will.deacon@arm.com>, <liviu.dudau@arm.com>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <catalin.marinas@arm.com>,
        <jason@lakedaemon.net>, <tglx@linutronix.de>, <robh+dt@kernel.org>,
        <bhelgaas@google.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: [RFC 3/4] arm64: Do not call enable PCI resources when specify PCI_PROBE_ONLY
Date: Sun, 28 Sep 2014 15:53:29 -0500
Message-ID: <1411937610-22125-4-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(10300001)(86362001)(20776003)(120916001)(93916002)(64706001)(85852003)(102836001)(101416001)(50986999)(89996001)(85306004)(21056001)(88136002)(105586002)(47776003)(31966008)(19580395003)(95666004)(44976005)(87286001)(83072002)(53416004)(62966002)(48376002)(76482002)(83322001)(19580405001)(229853001)(50466002)(86152002)(92566001)(87936001)(92726001)(50226001)(97736003)(84676001)(36756003)(2201001)(33646002)(4396001)(104166001)(79102003)(80022003)(106466001)(99396003)(74502003)(76176999)(77156001)(107046002)(81342003)(77982003)(90102001)(68736004)(81542003)(46102003)(77096002)(74662003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

When specify PCI_PROBE_ONLY, the resource parent does not get assigned.
Therefore, pci_enable_resources() return error saying that
"BAR x not claimed".

Note: This same logic is also used in the arch/arm/kernel/bios32.c

Cc: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 arch/arm64/kernel/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
index ce5836c..7fd4d2b 100644
--- a/arch/arm64/kernel/pci.c
+++ b/arch/arm64/kernel/pci.c
@@ -68,3 +68,11 @@ void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
 	bus->domain_nr = domain;
 }
 #endif
+
+int pcibios_enable_device(struct pci_dev *dev, int mask)
+{
+	if (pci_has_flag(PCI_PROBE_ONLY))
+		return 0;
+
+	return pci_enable_resources(dev, mask);
+}
-- 
1.9.3

