Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaAGPfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:35:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaAGPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:35:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [RFC PATCH 3/3] dt-bindings: pci: xgene pcie device tree bindings
Date: Tue, 7 Jan 2014 16:35:01 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Masters <jcm@redhat.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com> <201401031049.20932.arnd@arndb.de> <CACoXjc=h8W=9jx4d2Y+F9hmgQsuMTgG4080jZGbtddv10OgtMA@mail.gmail.com>
In-Reply-To: <CACoXjc=h8W=9jx4d2Y+F9hmgQsuMTgG4080jZGbtddv10OgtMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401071635.02006.arnd@arndb.de>
X-Provags-ID: V02:K0:+5XXDkn1k1JhPLe48iHZv7dlZZkVKocQtirujO2WgL4
 27vhikgxlhS5lyWJz4rml80jy6rmmgZGWiN0dwZYn8w07Gavx9
 eJR4dZig3dLJp7MKxLpP9AQ2IrmPwygKMEXEOrrEkSqhkj2XQR
 i/fTXk7WtwR6cQHZ3BBeV0R6SRPwhdVthx9b2e44KQ8iZrouvh
 9xb2yQ7PhAIYqKeikIesWqF7JM0g5mrM2dnQrI8ADuuEHpNMDM
 ab+gbRJ3eH75La63cqco7yJFjQ9uFmDC3bxYAFKiwv+CcR7YqH
 NMvQLoH07qlHcJiiM5UfRNYEqWeHO12c/25iUZKlmCBKe7QAlJ
 McDnkOwIm5CJ1LX3EwaI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 January 2014, Tanmay Inamdar wrote:
> On Fri, Jan 3, 2014 at 1:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> +Required properties:
> >> +- status: Either "ok" or "disabled".
> >> +- device_type: set to "pci"
> >> +- compatible: should contain "xgene,pcie" to identify the core.
> >> +- reg: base addresses and lengths of the pcie controller configuration
> >> +     space register.
> >> +- #address-cells: set to <3>
> >> +- #size-cells: set to <2>
> >> +- ranges: ranges for the PCI memory, I/O regions, config and MSI regions
> >> +- #interrupt-cells: set to <1>
> >> +- interrupt-map-mask and interrupt-map: standard PCI properties
> >> +     to define the mapping of the PCIe interface to interrupt
> >> +     numbers.
> >> +- clocks: from common clock binding: handle to pci clock.
> >> +- clock-names: from common clock binding. Should be "pcieclk".
> >> +
> >
> > Better use an anonymous clock?
> 
> Sorry. Can you please elaborate?

I mean drop the "clock-names" property.

> >> +SoC specific DT Entry:
> >> +     pcie0: pcie@1f2b0000 {
> >> +             status = "disabled";
> >> +             device_type = "pci";
> >> +             compatible = "xgene,pcie";
> >> +             #interrupt-cells = <1>;
> >> +             #size-cells = <2>;
> >> +             #address-cells = <3>;
> >> +             reg = < 0x00 0x1f2b0000 0x0 0x00010000>;
> >> +             ranges = <0x02000000 0x0 0x00000000 0xe0 0x00000000 0x0 0x10000000 /* mem*/
> >
> >
> > Also, do you support no prefetchable memory?
> 
> HW has either IO or Memory regions for mapping device's memory space.
> There is no separate prefetchable memory space.

Are you sure the memory is non-prefetchable then? I would have expected
0x42000000 rather than 0x02000000, but I could be misremembering it.

> >
> >> +                       0x00000000 0x0 0xd0000000 0xe0 0xd0000000 0x0 0x00200000 /* cfg */
> >
> > config space is not normally in the ranges property, and I think you will need
> > it in the pcie node itself as a 'reg' property so the code can access it.
> 
> pcie-designware.c does it that way. I just followed their implementation.

I don't remember what led to that, it still seems wrong and I can't find anything
in the PCI binding for host bridges telling their config space this way.

> >> +             interrupt-map-mask = <0x0 0x0 0x0 0x7>;
> >> +             interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1>;
> >
> > Only one IRQ for all devices?
> 
> The node represents a port. I believe that Linux framework uses only
> one of the legacy IRQs per port. Rest all remain unused. Hence I
> removed them. Please correct me if I am wrong.

Any PCI device can normally have four interrupts (IntA through IntD), which are
traditionally separate pins on a PCI bus, but get emulated on PCIe. While it's
not common for any normal device to use more than one IRQ, a bridge device
will swizzle these (virtual) IRQ lines, so a device behind the bridge actually
gets a different host IRQ.

	Arnd
