Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751AbaEFJzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:55:17 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60880 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558AbaEFJzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:55:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
Date: Tue, 06 May 2014 11:54:16 +0200
Message-ID: <5699845.615YLDid8d@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399347878.20388.96.camel@pasglop>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <CAErSpo6gYT34-sOvNgEdV+3wxv=Fdqtx7c1d-4577mFydLtZMg@mail.gmail.com> <1399347878.20388.96.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MPgLxv4XKXxAM0YqP15myCdxiZyqOtWvFLlhBiI1OUi
 0wZ4CpjVOkcOA/rFOWnUJuDOJkYpQt5ZL1UKMbsFskRpFVw9Da
 TW9OI9XOxxryG2A9g6h1J01qNV2LZScbld76RJyEB1zGTUlZHr
 7Ch3rC08410srBhFhd8xSIFTWYDxBszovrztVXsbiT96oPpbuJ
 LcpHbvipEQBGSwMa7IoIim09t/Sv+pUiHImJzvCevAZ9o3zllb
 C4Yd5c7XJvdiO7DnO4C+N+7cmQdT2sh/59qRcvaULL5A85/1Rw
 6HTaQKnjF6bXEUYPrO08yAvzILaeBENr4jG/wOz4sI9Kixw2QX
 kQrTFqcmZlEqaEWKPZQw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 13:44:38 Benjamin Herrenschmidt wrote:
> On Mon, 2014-05-05 at 16:28 -0600, Bjorn Helgaas wrote:
> > I still wonder whether arm, powerpc, and tile (and I just noticed
> > microblaze also has a similar dma_direct_map_page()) could all be
> > handled by attaching devices to a generic trivial IOMMU driver
> > parameterized with the appropriate constant offset.

It gets complex at that point, but it can be done. We are going to
need support for IOMMU and swiotlb in the same place, as well
as coherent and noncoherent ops, so the code here will be something
like

	/* default is noncoherent, non-offset, no iommu */
	if (offset) {
		if (coherent)
			set_arch_dma_coherent_offset_ops(dev);
		else
			set_arch_dma_offset_ops(dev);
	} else if (coherent)
		set_arch_dma_coherent_ops(dev);

	if (iommu) {
		if (coherent)
			set_arch_dma_coherent_iommu_ops(dev);
		else
			set_arch_dma_iommu_ops(dev);
	}

Doing it in the default ops would reduce the number of cases
from 5 to 3.

It may be easier to replace set_arch_dma_coherent_ops() with
a generic function that handles all cases:

int set_arch_dma_ops(struct device *dev, bool coherent,
		phys_addr_t offset, struct device_node *iommu);

and let the architecture handle the cases it needs.

> On powerpc, the offset is not constant, it can be per-device.

I think that's the case on all of them. The code under review here
is what parses the dma-ranges property in order to put the correct
value into the per-device structure.

	Arnd
