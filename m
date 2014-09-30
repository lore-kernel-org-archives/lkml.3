Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaI3NTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:19:47 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59903 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaI3NTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:19:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] of/pci: add pci_pio_to_address dummy for !CONFIG_OF
Date: Tue, 30 Sep 2014 15:19:05 +0200
Message-ID: <706416181.hbVGLDA3o6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0SmIMmY0RYykU1Lqgb7jOd1at2TEoitqeW5DtXCqbWb
 XJB5Y8LHjHP1P8qUxnGm1x+X/nktuJFWExLE6XyrOuFl+l79fZ
 0dFCJCsUmrtH3kwyDxWPZnxS49u6QIl72hWi71CDbVb9IOX4Nj
 nGnHeb8lrd34NDoF92dfOlQyJ2Kr/4vbx2sJ/2rsq5rlsCHgAs
 8DA9ZBYO2dfxiF0AGQVswV8KCsA5vEeIQRuo9w2iTodJ8O27yN
 nY2BK0voQItBaumOlnyIZJp59jhPDyKpIRtO2YDfucNo9hah9p
 G2XJJfJO9dYWoKJs0IIX5q1lWJF4JZB6f3OSzTeynZfywW0V6H
 pMTghSZmL8ppcNr1vCzU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci_register_io_range() and pci_pio_to_address() were recently
introduced to generalize the handling of memory mapped PCI I/O space,
but they are only valid when CONFIG_OF is set, leading to a possible
build error:

drivers/pci/host/pcie-rcar.c: In function 'rcar_pcie_setup_window':
drivers/pci/host/pcie-rcar.c:340:3: error: implicit declaration of function 'pci_pio_to_address' [-Werror=implicit-function-declaration]
   res_start = pci_pio_to_address(res->start);
   ^
drivers/pci/host/pcie-rcar.c: In function 'rcar_pcie_probe':
drivers/pci/host/pcie-rcar.c:945:3: error: implicit declaration of function 'of_pci_range_to_resource' [-Werror=implicit-function-declaration]
   err = of_pci_range_to_resource(&range, pdev->dev.of_node,
   ^
cc1: some warnings being treated as errors

This provides inline dummy implementations for the case that
CONFIG_OF is disabled, to allow better build testing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 279c5dd046 ("of/pci: Add pci_register_io_range() and pci_pio_to_address()")

diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 7ebb877b07c2..851097aab115 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -71,6 +71,11 @@ static inline const __be32 *of_get_address(struct device_node *dev, int index,
 	return NULL;
 }
 
+static inline phys_addr_t pci_pio_to_address(unsigned long pio)
+{
+	return 0;
+}
+
 static inline int of_pci_range_parser_init(struct of_pci_range_parser *parser,
 			struct device_node *node)
 {
@@ -144,6 +149,12 @@ static inline const __be32 *of_get_pci_address(struct device_node *dev,
 {
 	return NULL;
 }
+static inline int of_pci_range_to_resource(struct of_pci_range *range,
+					   struct device_node *np,
+					   struct resource *res)
+{
+	return -ENOSYS;
+}
 #endif /* CONFIG_OF_ADDRESS && CONFIG_PCI */
 
 #endif /* __OF_ADDRESS_H */

