Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaFEAFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:05:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaFDXWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Kevin Hilman <khilman@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Willy Tarreau <w@1wt.eu>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 161/228] ARM: mvebu: mvebu-soc-id: keep clock enabled if PCIe unit is enabled
Date: Wed,  4 Jun 2014 16:23:10 -0700
Message-Id: <20140604232353.184598947@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit b25bcf1bcaf6687991ae08dd76cd784bf9fe3d05 upstream.

Since the mvebu-soc-id code in mach-mvebu/ was introduced, several
users have noticed a regression: the PCIe card connected in the first
PCIe interface is not detected properly.

This is due to the fact that the mvebu-soc-id code enables the PCIe
clock of the first PCIe interface, reads the SoC device ID and
revision number (yes this information is made available as part of
PCIe registers), and then disables the clock. However, by doing this,
we gate the clock and therefore loose the complex PCIe configuration
that was done by the bootloader.

Unfortunately, as of today, the kernel is not capable of doing this
complex configuration by itself, so we really need to keep the PCIe
clock enabled. However, we don't want to keep it enabled
unconditionally: if the PCIe interface is not enabled or PCI support
is not compiled into the kernel, there is no reason to keep the PCIe
clock running.

This issue was discussed with Kevin Hilman, and the suggested solution
was to make the mvebu-soc-id code keep the clock enabled in case it
will be needed for PCIe. This is therefore the solution implemented in
this patch.

Long term, we hope to make the kernel more capable in terms of PCIe
configuration for this platform, which will anyway be needed to
support the compilation of the PCIe host controller driver as a
module. In the mean time however, we don't have much other choice than
to implement the currently proposed solution.

Reported-by: Neil Greatorex <neil@fatboyfat.co.uk>
Cc: Neil Greatorex <neil@fatboyfat.co.uk>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1399903900-29977-3-git-send-email-thomas.petazzoni@free-electrons.com
Fixes: af8d1c63afcb ("ARM: mvebu: Add support to get the ID and the revision of a SoC")
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-mvebu/mvebu-soc-id.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-mvebu/mvebu-soc-id.c
+++ b/arch/arm/mach-mvebu/mvebu-soc-id.c
@@ -107,8 +107,18 @@ static int __init mvebu_soc_id_init(void
 	iounmap(pci_base);
 
 res_ioremap:
-	clk_disable_unprepare(clk);
-	clk_put(clk);
+	/*
+	 * If the PCIe unit is actually enabled and we have PCI
+	 * support in the kernel, we intentionally do not release the
+	 * reference to the clock. We want to keep it running since
+	 * the bootloader does some PCIe link configuration that the
+	 * kernel is for now unable to do, and gating the clock would
+	 * make us loose this precious configuration.
+	 */
+	if (!of_device_is_available(child) || !IS_ENABLED(CONFIG_PCI_MVEBU)) {
+		clk_disable_unprepare(clk);
+		clk_put(clk);
+	}
 
 clk_err:
 	of_node_put(child);


