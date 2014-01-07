Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbaAGDEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:04:11 -0500
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:42059 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753005AbaAGDEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:04:08 -0500
MIME-Version: 1.0
In-Reply-To: <201401031049.20932.arnd@arndb.de>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
	<1387785725-24262-4-git-send-email-tinamdar@apm.com>
	<201401031049.20932.arnd@arndb.de>
Date: Mon, 6 Jan 2014 19:04:07 -0800
Message-ID: <CACoXjc=h8W=9jx4d2Y+F9hmgQsuMTgG4080jZGbtddv10OgtMA@mail.gmail.com>
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

On Fri, Jan 3, 2014 at 1:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 23 December 2013, Tanmay Inamdar wrote:
>> This patch adds the bindings for X-Gene PCIe driver. The driver resides
>> under 'drivers/pci/host/pcie-xgene.c' file.
>>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>>  .../devicetree/bindings/pci/xgene-pcie.txt         |   43 ++++++++++++++++++++
>>  1 file changed, 43 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/pci/xgene-pcie.txt
>>
>> diff --git a/Documentation/devicetree/bindings/pci/xgene-pcie.txt b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
>> new file mode 100644
>> index 0000000..d92da4f
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
>> @@ -0,0 +1,43 @@
>> +* AppliedMicro X-Gene PCIe interface
>> +
>> +Required properties:
>> +- status: Either "ok" or "disabled".
>> +- device_type: set to "pci"
>> +- compatible: should contain "xgene,pcie" to identify the core.
>> +- reg: base addresses and lengths of the pcie controller configuration
>> +     space register.
>> +- #address-cells: set to <3>
>> +- #size-cells: set to <2>
>> +- ranges: ranges for the PCI memory, I/O regions, config and MSI regions
>> +- #interrupt-cells: set to <1>
>> +- interrupt-map-mask and interrupt-map: standard PCI properties
>> +     to define the mapping of the PCIe interface to interrupt
>> +     numbers.
>> +- clocks: from common clock binding: handle to pci clock.
>> +- clock-names: from common clock binding. Should be "pcieclk".
>> +
>
> Better use an anonymous clock?

Sorry. Can you please elaborate?

>
> The driver also seems to use a phy that is not defined here.
>
>> +Example:
>> +
>> +SoC specific DT Entry:
>> +     pcie0: pcie@1f2b0000 {
>> +             status = "disabled";
>> +             device_type = "pci";
>> +             compatible = "xgene,pcie";
>> +             #interrupt-cells = <1>;
>> +             #size-cells = <2>;
>> +             #address-cells = <3>;
>> +             reg = < 0x00 0x1f2b0000 0x0 0x00010000>;
>> +             ranges = <0x02000000 0x0 0x00000000 0xe0 0x00000000 0x0 0x10000000 /* mem*/
>
> This is an awfully small memory space for a 64 bit machine. Is that a hardware bug you
> are working around? If not, please make it as large as you can to allow for arbitrary
> extension cards with large BARs, at least 4GB.

HW does support a lot more than 256MB. I will change it.

>
> Also, do you support no prefetchable memory?

HW has either IO or Memory regions for mapping device's memory space.
There is no separate prefetchable memory space.

>
>> +                       0x01000000 0x0 0x80000000 0xe0 0x80000000 0x0 0x00010000 /* io */
>
> I/O space at 0x80000000? That won't work with a lot of devices. Can you make it start
> at bus address 0?

Ok.

>
>> +                       0x00000000 0x0 0xd0000000 0xe0 0xd0000000 0x0 0x00200000 /* cfg */
>
> config space is not normally in the ranges property, and I think you will need
> it in the pcie node itself as a 'reg' property so the code can access it.

pcie-designware.c does it that way. I just followed their implementation.

>
>> +                       0x00000000 0x0 0x79000000 0x00 0x79000000 0x0 0x00800000>; /* msi */
>
> Same here. Also I suspect this is a separate irqchip that isn't actually part
> of the PCIe host. If they are separate devices, I'd strongly recommend modeling
> them as separate device-nodes in DT to make reuse easier.

You are right. However MSI irqchip needs PCIe core to map above
mentioned space. I will remove it for now and will send it along with
MSI patch.

>
>> +             interrupt-map-mask = <0x0 0x0 0x0 0x7>;
>> +             interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1>;
>
> Only one IRQ for all devices?

The node represents a port. I believe that Linux framework uses only
one of the legacy IRQs per port. Rest all remain unused. Hence I
removed them. Please correct me if I am wrong.

>
>> +             clocks = <&pcie0clk 0>;
>> +             clock-names = "pcieclk"
>> +     };
>> +
>> +Board specific DT Entry:
>> +     &pcie0 {
>> +             status = "ok";
>> +     };
>
>         Arnd
