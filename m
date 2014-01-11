Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbaAKAMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 19:12:41 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:38464 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753574AbaAKAMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 19:12:36 -0500
MIME-Version: 1.0
In-Reply-To: <201401071635.02006.arnd@arndb.de>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
	<201401031049.20932.arnd@arndb.de>
	<CACoXjc=h8W=9jx4d2Y+F9hmgQsuMTgG4080jZGbtddv10OgtMA@mail.gmail.com>
	<201401071635.02006.arnd@arndb.de>
Date: Fri, 10 Jan 2014 16:12:34 -0800
Message-ID: <CACoXjckkovQdB5Pk3Tn4uGkm5+HuEfWYb6E1MiUOPpuZ2b7qNA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] dt-bindings: pci: xgene pcie device tree bindings
From: Tanmay Inamdar <tinamdar@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 7:35 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 07 January 2014, Tanmay Inamdar wrote:
>> On Fri, Jan 3, 2014 at 1:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> +Required properties:
>> >> +- status: Either "ok" or "disabled".
>> >> +- device_type: set to "pci"
>> >> +- compatible: should contain "xgene,pcie" to identify the core.
>> >> +- reg: base addresses and lengths of the pcie controller configuration
>> >> +     space register.
>> >> +- #address-cells: set to <3>
>> >> +- #size-cells: set to <2>
>> >> +- ranges: ranges for the PCI memory, I/O regions, config and MSI regions
>> >> +- #interrupt-cells: set to <1>
>> >> +- interrupt-map-mask and interrupt-map: standard PCI properties
>> >> +     to define the mapping of the PCIe interface to interrupt
>> >> +     numbers.
>> >> +- clocks: from common clock binding: handle to pci clock.
>> >> +- clock-names: from common clock binding. Should be "pcieclk".
>> >> +
>> >
>> > Better use an anonymous clock?
>>
>> Sorry. Can you please elaborate?
>
> I mean drop the "clock-names" property.
>
Did you mean clock-names in pcie-clock node or pcie node? I can drop
clock-names from pcie clock node. However if I drop clock-names from
pcie node, then clk_get call from pcie host driver would result in
failure. Right?

>> >> +SoC specific DT Entry:
>> >> +     pcie0: pcie@1f2b0000 {
>> >> +             status = "disabled";
>> >> +             device_type = "pci";
>> >> +             compatible = "xgene,pcie";
>> >> +             #interrupt-cells = <1>;
>> >> +             #size-cells = <2>;
>> >> +             #address-cells = <3>;
>> >> +             reg = < 0x00 0x1f2b0000 0x0 0x00010000>;
>> >> +             ranges = <0x02000000 0x0 0x00000000 0xe0 0x00000000 0x0 0x10000000 /* mem*/
>> >
>> >
>> > Also, do you support no prefetchable memory?
>>
>> HW has either IO or Memory regions for mapping device's memory space.
>> There is no separate prefetchable memory space.
>
> Are you sure the memory is non-prefetchable then? I would have expected
> 0x42000000 rather than 0x02000000, but I could be misremembering it.
>
>> >
>> >> +                       0x00000000 0x0 0xd0000000 0xe0 0xd0000000 0x0 0x00200000 /* cfg */
>> >
>> > config space is not normally in the ranges property, and I think you will need
>> > it in the pcie node itself as a 'reg' property so the code can access it.
>>
>> pcie-designware.c does it that way. I just followed their implementation.
>
> I don't remember what led to that, it still seems wrong and I can't find anything
> in the PCI binding for host bridges telling their config space this way.
>
>> >> +             interrupt-map-mask = <0x0 0x0 0x0 0x7>;
>> >> +             interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1>;
>> >
>> > Only one IRQ for all devices?
>>
>> The node represents a port. I believe that Linux framework uses only
>> one of the legacy IRQs per port. Rest all remain unused. Hence I
>> removed them. Please correct me if I am wrong.
>
> Any PCI device can normally have four interrupts (IntA through IntD), which are
> traditionally separate pins on a PCI bus, but get emulated on PCIe. While it's
> not common for any normal device to use more than one IRQ, a bridge device
> will swizzle these (virtual) IRQ lines, so a device behind the bridge actually
> gets a different host IRQ.
>
>         Arnd
