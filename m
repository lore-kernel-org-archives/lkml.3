Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaIHOHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:07:50 -0400
Received: from dliviu.plus.com ([80.229.23.120]:42781 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbaIHOHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:07:49 -0400
Date: Mon, 8 Sep 2014 14:59:18 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tanmay Inamdar <tinamdar@apm.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH v6 0/4] APM X-Gene PCIe host controller
Message-ID: <20140908135918.GA1296@bart.dudau.co.uk>
References: <1409963143-11951-1-git-send-email-tinamdar@apm.com>
 <CAErSpo643rAAqR0AAy5CwSkMv28Cw8Y55EYrYo0AHvQZxgvgXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo643rAAqR0AAy5CwSkMv28Cw8Y55EYrYo0AHvQZxgvgXg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Sep  8 15:07:47 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,540db8323391538511859
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 08:17:43AM -0600, Bjorn Helgaas wrote:
> On Fri, Sep 5, 2014 at 6:25 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> > This patch adds support for AppliedMicro X-Gene PCIe host controller. The
> > driver is tested on X-Gene platform with different gen1/2/3 PCIe endpoint
> > cards.
> >
> > X-Gene PCIe controller driver has depedency on the pcie arm64 arch support.
> > Liviu Dudau from ARM has sent a patch set for pcie arm64 arch support and
> > support for creating generic pcie bridge from device tree. Liviu's patches
> > are available here
> > 1. https://lkml.org/lkml/2014/8/12/361
> 
> I'm hoping to merge Liviu's patches and this X-Gene support for v3.18.
> I'm currently waiting for Liviu's v10 series (hopefully based on
> v3.17-rc2), and since your series depends on that, I'm going to wait
> for a v7 of your series that is rebased on top of Liviu's v10.  Does
> that make sense?

Hi Bjorn,

I've sent v10 based on v3.17-rc4, hope this is OK.

Tanmay, unfortunately the API has changed again. I've put in the cover letter
of the series how the probe function needs changing. Basically, you need to
stop relying on the host bridge being created and use just the resource list
coming out of the of_pci_get_host_bridge_resources().

Best regards,
Liviu

> 
> > If someone wishes to test PCIe on X-Gene with this patch set, above mentioned
> > patches from Liviu must be applied before the patches in this patch set. Also
> > please use latest xgene u-boot firmware.
> >
> > changes since V5:
> > 1. Port driver to changed interface of 'of_create_pci_host_bridge'
> > 2. Fix the prefetch bit setting
> > 3. Removed bunch of register programming which is already done by firmware
> >
> > changes since V4:
> > 1. fix section mismatch warnings
> > 2. fix the patch description
> > 3. fix indentation
> > 4. update read/write cfg functions by passing both addr and offset.
> > 5. use 'time_before' for timeout.
> > 6. remove unnecessary 'IS_ERR_OR_NULL'. Keep 'IS_ERR' for 'clk_get'
> > 7. remove BUG_ON for pci_ioremap_io.
> >
> > changes since V3:
> > 1. remove 'struct hw_pci' and supporting ops in hw_pci
> > 2. add code to create the host bridge from dts
> > 3. add code to scan the the host bridge
> > 4. modify outbound windows setup function to get resource information from
> >    'bridge->windows'
> > 5. add compatible string in pcie dts node with current X-Gene SOC name.
> >
> > changes since V2:
> > 1. redefined each PCI port in different PCI domain correctly.
> > 2. removed setup_lane and setup_link functions from driver.
> > 3. removed scan_bus wrapper and set_primary_bus hack.
> > 4. added pci_ioremap_io for io resources.
> >
> > changes since V1:
> > 1. added PCI domain support
> > 2. reading cpu and pci addresses from device tree to configure regions.
> > 3. got rid of unnecessary wrappers for readl and writel.
> > 4. got rid of endpoint configuration code.
> > 5. added 'dma-ranges' property support to read inbound region configuration.
> > 6. renamed host driver file to 'pci-xgene.c' from 'pcie-xgene.c'
> > 7. dropped 'clock-names' property from bindings
> > 8. added comments whereever requested.
> >
> > Tanmay Inamdar (4):
> >   pci:host: APM X-Gene PCIe controller driver
> >   arm64: dts: APM X-Gene PCIe device tree nodes
> >   dt-bindings: pci: xgene pcie device tree bindings
> >   MAINTAINERS: entry for APM X-Gene PCIe host driver
> >
> >  .../devicetree/bindings/pci/xgene-pci.txt          |  55 ++
> >  MAINTAINERS                                        |   8 +
> >  arch/arm64/boot/dts/apm-mustang.dts                |   8 +
> >  arch/arm64/boot/dts/apm-storm.dtsi                 | 160 ++++++
> >  drivers/pci/host/Kconfig                           |  10 +
> >  drivers/pci/host/Makefile                          |   1 +
> >  drivers/pci/host/pci-xgene.c                       | 638 +++++++++++++++++++++
> >  7 files changed, 880 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pci/xgene-pci.txt
> >  create mode 100644 drivers/pci/host/pci-xgene.c
> >
> > --
> > 1.9.1
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

