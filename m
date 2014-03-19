Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaCSSyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:54:41 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34323 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaCSSyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:54:38 -0400
Date: Wed, 19 Mar 2014 12:54:23 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pekka Enberg <penberg@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding
 disabled
Message-ID: <20140319185423.GA5514@google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Ming, Rusty, Pekka, Sasha]

On Wed, Feb 26, 2014 at 12:37:57PM -0700, Bjorn Helgaas wrote:
> Don't rely on BAR contents when the command register says the BAR is
> disabled.
> 
> If we receive a PCI device from firmware (or a hot-added device that was
> just powered up) with the MEMORY or IO enable bits in the PCI command
> register cleared, there's no reason to believe the BARs contain valid
> addresses.
> 
> In that case, we still know the type and size of the BAR, but this
> patch marks the resource as "unset" so we have a chance to reassign it.
> 
> Historically, we often used "BAR == 0" to decide the BAR is invalid.  But 0
> is a legal BAR value, especially if the host bridge translates addresses,
> so I think it's better to decide based on the PCI command register, and
> store the conclusion in the IORESOURCE_UNSET bit.

I plan to replace this patch with the following, which only sets
IORESOURCE_UNSET when we already have been clearing the bus region start
address.  (This probably should have been a separate patch to begin with,
mea culpa.)

This is intended for the v3.15 merge window, so I made the minimal change
to reduce risk.

Thanks to Ming Lei for prompting me to look at this; I think the issue he
reported with the original patch is really a problem somewhere else that
the patch just happened to expose, but the original patch was more
aggressive than necessary, so this revision tones it down a bit.

Bjorn


PCI: Mark 64-bit resource as IORESOURCE_UNSET if we only support 32-bit

From: Bjorn Helgaas <bhelgaas@google.com>

If we don't support 64-bit addresses, i.e., CONFIG_PHYS_ADDR_T_64BIT is not
set, we can't deal with BARs above 4GB.  In this case we already pretend
the BAR contained zero; this patch also sets IORESOURCE_UNSET so we can try
to reallocate it later.

I don't think this is exactly correct: what we care about here are *bus*
addresses, not CPU addresses, so the tests of sizeof(resource_size_t)
probably should be on sizeof(dma_addr_t) instead.  But this is what's been
in -next, so we'll fix that later.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6e34498ec9f0..78335efbbb74 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -252,6 +252,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 			/* Address above 32-bit boundary; disable the BAR */
 			pci_write_config_dword(dev, pos, 0);
 			pci_write_config_dword(dev, pos + 4, 0);
+			res->flags |= IORESOURCE_UNSET;
 			region.start = 0;
 			region.end = sz64;
 			bar_disabled = true;
