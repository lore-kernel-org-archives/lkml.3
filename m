Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbaEDQVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:21:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbaEDPmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3.14 157/158] USB: EHCI: tegra: set txfill_tuning
Date: Sun,  4 May 2014 11:41:06 -0400
Message-Id: <20140504154051.336764793@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 4f2fe2d27472f4a5dbd875888af4fc5175f3fdc5 upstream.

To avoid memory fetch underflows with larger USB transfers, Tegra SoCs
need txfill_tuning's txfifothresh register field set to a non-default
value. Add a custom reset override in order to set this up.

These values are recommended practice for all Tegra chips. However,
I've only noticed practical problems when not setting them this way on
systems using Tegra124. Hence, CC: stable only for recent kernels which
actually support Tegra124.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-tegra.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -513,8 +513,31 @@ static struct platform_driver tegra_ehci
 	}
 };
 
+static int tegra_ehci_reset(struct usb_hcd *hcd)
+{
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	int retval;
+	int txfifothresh;
+
+	retval = ehci_setup(hcd);
+	if (retval)
+		return retval;
+
+	/*
+	 * We should really pull this value out of tegra_ehci_soc_config, but
+	 * to avoid needing access to it, make use of the fact that Tegra20 is
+	 * the only one so far that needs a value of 10, and Tegra20 is the
+	 * only one which doesn't set has_hostpc.
+	 */
+	txfifothresh = ehci->has_hostpc ? 0x10 : 10;
+	ehci_writel(ehci, txfifothresh << 16, &ehci->regs->txfill_tuning);
+
+	return 0;
+}
+
 static const struct ehci_driver_overrides tegra_overrides __initconst = {
 	.extra_priv_size	= sizeof(struct tegra_ehci_hcd),
+	.reset			= tegra_ehci_reset,
 };
 
 static int __init ehci_tegra_init(void)


