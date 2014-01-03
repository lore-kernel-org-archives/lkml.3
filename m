Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaACJti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:49:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaACJtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:49:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 3/3] dt-bindings: pci: xgene pcie device tree bindings
Date: Fri, 3 Jan 2014 10:49:20 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tanmay Inamdar <tinamdar@apm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org, patches@apm.com,
        linux-kernel@vger.kernel.org, jcm@redhat.com
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com> <1387785725-24262-4-git-send-email-tinamdar@apm.com>
In-Reply-To: <1387785725-24262-4-git-send-email-tinamdar@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401031049.20932.arnd@arndb.de>
X-Provags-ID: V02:K0:bxEk9cyrVlOGVq1uea5IeKYnh0CixPaXMHP9snij13l
 NaxJYW8VkS74EaTGyYdvdtmiJzvLQtjStPAYhd0CwivetA1PwV
 5FHpMMSqqH26CtiNXtKghYv6gQW3eoyImc+SwBWRP67okQ9F+K
 kvGIl5wvg/PQGHxt8jmY5IIz8Jtg6Fl8hmAwrnPYZ7WryEaoIK
 DIUORjlD4DsHK1xm5p+V1luuj2kmLdLZEkBQMMiN+8c3oTU4YS
 dr54zeWMWaMDLlimjLPTCkRpD+IRUhi0g2BImXwb8C1YWyefQG
 53nUDGLbv1J++yIExia/ODIa4UJtUnuu/YjWNuFiSK0yAkdLkM
 5asLG+Z/Trsn5mk7UCEA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 December 2013, Tanmay Inamdar wrote:
> This patch adds the bindings for X-Gene PCIe driver. The driver resides
> under 'drivers/pci/host/pcie-xgene.c' file.
> 
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  .../devicetree/bindings/pci/xgene-pcie.txt         |   43 ++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pci/xgene-pcie.txt
> 
> diff --git a/Documentation/devicetree/bindings/pci/xgene-pcie.txt b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
> new file mode 100644
> index 0000000..d92da4f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pci/xgene-pcie.txt
> @@ -0,0 +1,43 @@
> +* AppliedMicro X-Gene PCIe interface
> +
> +Required properties:
> +- status: Either "ok" or "disabled".
> +- device_type: set to "pci"
> +- compatible: should contain "xgene,pcie" to identify the core.
> +- reg: base addresses and lengths of the pcie controller configuration
> +	space register.
> +- #address-cells: set to <3>
> +- #size-cells: set to <2>
> +- ranges: ranges for the PCI memory, I/O regions, config and MSI regions
> +- #interrupt-cells: set to <1>
> +- interrupt-map-mask and interrupt-map: standard PCI properties
> +	to define the mapping of the PCIe interface to interrupt
> +	numbers.
> +- clocks: from common clock binding: handle to pci clock.
> +- clock-names: from common clock binding. Should be "pcieclk".
> +

Better use an anonymous clock?

The driver also seems to use a phy that is not defined here.

> +Example:
> +
> +SoC specific DT Entry:
> +	pcie0: pcie@1f2b0000 {
> +		status = "disabled";
> +		device_type = "pci";
> +		compatible = "xgene,pcie";
> +		#interrupt-cells = <1>;
> +		#size-cells = <2>;
> +		#address-cells = <3>;
> +		reg = < 0x00 0x1f2b0000 0x0 0x00010000>;
> +		ranges = <0x02000000 0x0 0x00000000 0xe0 0x00000000 0x0 0x10000000 /* mem*/

This is an awfully small memory space for a 64 bit machine. Is that a hardware bug you
are working around? If not, please make it as large as you can to allow for arbitrary
extension cards with large BARs, at least 4GB.

Also, do you support no prefetchable memory?

> +			  0x01000000 0x0 0x80000000 0xe0 0x80000000 0x0 0x00010000 /* io */

I/O space at 0x80000000? That won't work with a lot of devices. Can you make it start
at bus address 0?

> +			  0x00000000 0x0 0xd0000000 0xe0 0xd0000000 0x0 0x00200000 /* cfg */

config space is not normally in the ranges property, and I think you will need
it in the pcie node itself as a 'reg' property so the code can access it.

> +			  0x00000000 0x0 0x79000000 0x00 0x79000000 0x0 0x00800000>; /* msi */

Same here. Also I suspect this is a separate irqchip that isn't actually part
of the PCIe host. If they are separate devices, I'd strongly recommend modeling
them as separate device-nodes in DT to make reuse easier.

> +		interrupt-map-mask = <0x0 0x0 0x0 0x7>;
> +		interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1>;

Only one IRQ for all devices?

> +		clocks = <&pcie0clk 0>;
> +		clock-names = "pcieclk"
> +	};
> +
> +Board specific DT Entry:
> +	&pcie0 {
> +		status = "ok";
> +	};

	Arnd
