Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaITQbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:31:52 -0400
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:54350
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850AbaITQbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:31:49 -0400
X-WSS-ID: 0NC7KKV-07-WGO-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <liviu.dudau@arm.com>, <tglx@linutronix.de>,
        <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [V8 0/2] irqchip: gic: Introduce ARM GICv2m MSI(-X) support
Date: Sat, 20 Sep 2014 09:31:36 -0700
Message-ID: <1411230698-8081-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(66654002)(77096002)(47776003)(90102001)(48376002)(89996001)(50466002)(80022003)(81342003)(81542003)(74502003)(4396001)(97736003)(77982003)(79102003)(46102003)(74662003)(86362001)(31966008)(20776003)(105586002)(50226001)(68736004)(33646002)(95666004)(50986999)(21056001)(104166001)(102836001)(76482002)(83322001)(19580405001)(229853001)(19580395003)(107046002)(101416001)(83072002)(36756003)(64706001)(62966002)(85852003)(86152002)(92566001)(106466001)(15975445006)(99396002)(77156001)(53416004)(2201001)(87936001)(85306004)(44976005)(87286001)(92726001)(84676001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Forefront-PRVS: 0340850FCD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set introduces support for MSI(-X) in GICv2m specification,
which is implemented in some variation of GIC400.

This depends on and has been tested with the following patch set which
implements PCI supports for ARM64:

    [PATCH v11 00/10] Support for creating generic PCI host bridges from DT
    https://lkml.org/lkml/2014/9/17/732

    [PATCH v11] Add support for PCI in AArch64
    https://lkml.org/lkml/2014/9/17/736

This patch set is rebased from:
    git://git.infradead.org/users/jcooper/linux.git irqchip/core
 
Changes in V8:
    * Minor clean up suggested by Marc
    * Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Changes in V7:
    * Fix error handling logic in gicv2m_of_init() and gicv2m_init_one().
      per Marc suggestions.
    * Restructure the patch to integrate the multi-MSI support for V2m
      into the patch 2/2.
    * Introduce "arm,gic-v2m-frame" compatible ID for the v2m DT binding.
    * Introduce "arm,msi-base-spi" and "arm,msi-num-spi" property in the
      v2m DT binding for overwriting value in MSI_TYPER register.
    * Add irq-gic-v2m.c: is_msi_spi_valid() to validate the SPI base and
      number of SPIs.
    * Fix various comments from Marc (Many thanks).
    * Add the missing CONFIG_ARM_GICV2M (per Marcin Juszkiewicz comment)

Suravee Suthikulpanit (2):
  irqchip: gic: Add support for multiple MSI for ARM64
  irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)

 Documentation/devicetree/bindings/arm/gic.txt |  55 ++++
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/kernel/Makefile                    |   1 +
 arch/arm64/kernel/msi.c                       |  41 +++
 drivers/irqchip/Kconfig                       |   5 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/irq-gic-common.c              |  12 +
 drivers/irqchip/irq-gic-common.h              |   4 +
 drivers/irqchip/irq-gic-v2m.c                 | 356 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic.c                     |  82 +++---
 drivers/irqchip/irq-gic.h                     |  54 ++++
 11 files changed, 582 insertions(+), 30 deletions(-)
 create mode 100644 arch/arm64/kernel/msi.c
 create mode 100644 drivers/irqchip/irq-gic-v2m.c
 create mode 100644 drivers/irqchip/irq-gic.h

-- 
1.9.3

