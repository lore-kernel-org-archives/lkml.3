Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3HWQGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:06:18 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49780 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3HWQGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:06:15 -0400
Date: Fri, 23 Aug 2013 10:06:12 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: avoid unnecessary writing of the command register
 during probe
Message-ID: <20130823160612.GA13605@google.com>
References: <1377209958-26362-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377209958-26362-1-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 11:19:18PM +0100, Zoltan Kiss wrote:
> While I tracked an another bug, I noticed that the PCI command register is
> quite often updated here unnecessarily.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

I applied this to pci/misc with minor tweaks as follows.  Let me know
if you see anything wrong.

Bjorn


PCI: Disable decoding for BAR sizing only when it was actually enabled

From: Zoltan Kiss <zoltan.kiss@citrix.com>

We disable BARs while sizing them so we don't cause conflicts with other
devices (see 253d2e5498 and bbffe43524).  But if device decoding is already
disabled before we size the BAR, we don't need to disable it again.

[bhelgaas: changelog, add PCI_COMMAND_DECODING_ENABLE for readability]
Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cf57fe7..2c6f328 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -165,6 +165,8 @@ static inline unsigned long decode_bar(struct pci_dev *dev, u32 bar)
  *
  * Returns 1 if the BAR is 64-bit, or 0 if 32-bit.
  */
+#define PCI_COMMAND_DECODE_ENABLE	(PCI_COMMAND_MEMORY | PCI_COMMAND_IO)
+
 int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 			struct resource *res, unsigned int pos)
 {
@@ -178,8 +180,10 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	/* No printks while decoding is disabled! */
 	if (!dev->mmio_always_on) {
 		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
-		pci_write_config_word(dev, PCI_COMMAND,
-			orig_cmd & ~(PCI_COMMAND_MEMORY | PCI_COMMAND_IO));
+		if (orig_cmd & PCI_COMMAND_DECODE_ENABLE) {
+			pci_write_config_word(dev, PCI_COMMAND,
+				orig_cmd & ~PCI_COMMAND_DECODE_ENABLE);
+		}
 	}
 
 	res->name = pci_name(dev);
@@ -293,7 +297,8 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 fail:
 	res->flags = 0;
 out:
-	if (!dev->mmio_always_on)
+	if (!dev->mmio_always_on &&
+	    (orig_cmd & PCI_COMMAND_DECODE_ENABLE))
 		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
 
 	if (bar_too_big)
