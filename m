Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaBSWPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:15:22 -0500
Received: from top.free-electrons.com ([176.31.233.9]:53022 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754348AbaBSWPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:15:18 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>
Subject: [PATCH 1/2] of: Allows to use the PCI translator without the PCI core
Date: Wed, 19 Feb 2014 23:14:55 +0100
Message-Id: <1392848096-17838-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392848096-17838-1-git-send-email-gregory.clement@free-electrons.com>
References: <1392848096-17838-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Translating an address from a PCI node of the device-tree into a CPU
physical address doesn't require the core PCI support. Those
translations are just related to the device tree itself.

The use case to translate an address from a PCI node without actually
using the PCI core support is when one needs to access the PCI
controller without accessing any PCI devices.

Marvell SoCs, such as Kirkwood, Dove or Armada XP for instance, come
with an IP of a PCI controller. In the registers of this controller
are stored the ID and the revision of a SoC. With this patch it will
be possible to read the SoC ID of a board without any PCI device and
then without the PCI core support.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/of/Kconfig   | 4 ++++
 drivers/of/address.c | 8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index c6973f101a3e..ffdcb11f75fb 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -44,6 +44,10 @@ config OF_DYNAMIC
 config OF_ADDRESS
 	def_bool y
 	depends on !SPARC
+	select OF_ADDRESS_PCI if PCI
+
+config OF_ADDRESS_PCI
+	bool
 
 config OF_IRQ
 	def_bool y
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 1a54f1ffaadb..cb4242a69cd5 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -91,7 +91,7 @@ static unsigned int of_bus_default_get_flags(const __be32 *addr)
 	return IORESOURCE_MEM;
 }
 
-#ifdef CONFIG_PCI
+#ifdef CONFIG_OF_ADDRESS_PCI
 /*
  * PCI bus specific translator
  */
@@ -166,7 +166,9 @@ static int of_bus_pci_translate(__be32 *addr, u64 offset, int na)
 {
 	return of_bus_default_translate(addr + 1, offset, na - 1);
 }
+#endif /* CONFIG_OF_ADDRESS_PCI */
 
+#ifdef CONFIG_PCI
 const __be32 *of_get_pci_address(struct device_node *dev, int bar_no, u64 *size,
 			unsigned int *flags)
 {
@@ -356,7 +358,7 @@ static unsigned int of_bus_isa_get_flags(const __be32 *addr)
  */
 
 static struct of_bus of_busses[] = {
-#ifdef CONFIG_PCI
+#ifdef CONFIG_OF_ADDRESS_PCI
 	/* PCI */
 	{
 		.name = "pci",
@@ -367,7 +369,7 @@ static struct of_bus of_busses[] = {
 		.translate = of_bus_pci_translate,
 		.get_flags = of_bus_pci_get_flags,
 	},
-#endif /* CONFIG_PCI */
+#endif /* CONFIG_OF_ADDRESS_PCI */
 	/* ISA */
 	{
 		.name = "isa",
-- 
1.8.1.2

