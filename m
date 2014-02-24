Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaBXLA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:00:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54445 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaBXLA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:00:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <damm@opensource.se>, linux-pci@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: DMABOUNCE in pci-rcar
Date: Mon, 24 Feb 2014 12:00:21 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402241200.21944.arnd@arndb.de>
X-Provags-ID: V02:K0:IHNPIB3JMggk6YkdEVxLQKMnJkMCSitsphB4nv3K1Nt
 rM352K/oX+oCUBivHBg46krR2ixBVNJFZVE5iL5/sX0CoR11sb
 DkZqd5Rmhq0gNxzYX883W7eoRxUoVnamRAalLyBqgnNWdUQ1Xt
 wIQtx6LZNOixsjiJJguLmnfKCAA3akfYzS4nq8FeLmo4f3LLzi
 6TB5dB2yCfzN/hJq3Gych7DihksjBE+Wh8khuvfMgIQFUzSFOt
 4ii/eL1dW/MApxshKzoQnfmNLlquR7c1SUzzHUZatmsseimZHx
 w73Tvfh5zTmlk528ByNbgAknlToljW8CkEN7pCHVFlZNPogCdx
 XSLEbTPk9+RarUHt2Bpk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

I noticed during randconfig testing that you enabled DMABOUNCE for the
pci-rcar-gen2 driver as posted in this patch https://lkml.org/lkml/2014/2/5/30

I didn't see the original post unfortunately, but I fear we have to
revert it and come up with a better solution, as your approach seems
wrong on a number of levels:

* We really don't want any new users of DMABOUNCE on ARM but instead leave
  it to the PXA/IXP/SA1100 based platforms using it today.

* If your SoCs have an IOMMU, you should really use it, as that would
  give you much better performance than bounce buffers anyway

* If the hardware is so screwed up that you have to use bounce buffers,
  use the SWIOTLB code that is reasonably modern.

* The window base and size in the driver should not be hardcoded, as
  this is likely not a device specific property but rather an artifact of
  how it's connected. Use the standard "dma-ranges" property.

* You should not need your own dma_map_ops in the driver. What you
  do there isn't really specific to your host but should live in some
  place where it can be shared with other drivers.

* The implementation of the dma_map_ops is wrong: at the very least,
  you cannot use the dma_mask of the pci host when translating
  calls from the device, since each pci device can have a different
  dma mask that is set by the driver if it needs larger or smaller
  than 32-bit DMA space.

* The block bounce code can't be enabled if CONFIG_BLOCK is disabled,
  this is how I noticed your changes.

* The block layer assumes that it will bounce any highmem pages,
  but that isn't necessarily what you want here: if you have 2GB
  of lowmem space (CONFIG_VMSPLIT_2G) or more, you will also have
  lowmem pages that need bouncing.

* (completely unrelated, I noticed you set up a bogus I/O space
  window. Don't do that, you will get get a panic if a device happens
  to use it. Not providing an resource should work fine though)

On the bright side, your other changes in the same series all look
good. Thanks especially for sorting out the probe() function, I was
already wondering if we could change that the way you did.

	Arnd
