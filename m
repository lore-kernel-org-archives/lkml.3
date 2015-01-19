Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbbASTQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:16:34 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:65438 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbbASTQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:16:31 -0500
Message-ID: <54BD580C.6030701@gmail.com>
Date: Mon, 19 Jan 2015 11:16:28 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Vinita Gupta <vgupta@caviumnetworks.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] SATA: OCTEON: support SATA on OCTEON platform
References: <1421681040-3392-1-git-send-email-aleksey.makarov@auriga.com> <20150119154357.GH21553@leverpostej>
In-Reply-To: <20150119154357.GH21553@leverpostej>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 07:43 AM, Mark Rutland wrote:
> On Mon, Jan 19, 2015 at 03:23:58PM +0000, Aleksey Makarov wrote:
>> The OCTEON SATA controller is currently found on cn71XX devices.
>>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>> Signed-off-by: Vinita Gupta <vgupta@caviumnetworks.com>
>> [aleksey.makarov@auriga.com: preparing for submission,
>> conflict resolution, fixes for the platform code]
>> Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
>> ---
>>   .../devicetree/bindings/ata/ahci-platform.txt      |   1 +
>>   .../devicetree/bindings/mips/cavium/sata-uctl.txt  |  31 ++++++
>>   arch/mips/cavium-octeon/octeon-platform.c          |   1 +
>>   drivers/ata/Kconfig                                |   9 ++
>>   drivers/ata/Makefile                               |   1 +
>>   drivers/ata/ahci_platform.c                        |  10 ++
>>   drivers/ata/sata_octeon.c                          | 107 +++++++++++++++++++++
>>   7 files changed, 160 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/mips/cavium/sata-uctl.txt
>>   create mode 100644 drivers/ata/sata_octeon.c
>>
>> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
>> index 4ab09f2..1a5d3be 100644
>> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
>> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
>> @@ -11,6 +11,7 @@ Required properties:
>>   - compatible        : compatible string, one of:
>>     - "allwinner,sun4i-a10-ahci"
>>     - "hisilicon,hisi-ahci"
>> +  - "cavium,octeon-7130-ahci"
>>     - "ibm,476gtr-ahci"
>>     - "marvell,armada-380-ahci"
>>     - "snps,dwc-ahci"
>> diff --git a/Documentation/devicetree/bindings/mips/cavium/sata-uctl.txt b/Documentation/devicetree/bindings/mips/cavium/sata-uctl.txt
>> new file mode 100644
>> index 0000000..222e66e
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mips/cavium/sata-uctl.txt
>> @@ -0,0 +1,31 @@
>> +* UCTL SATA controller glue
>
> I'm not sure I follow. What does this mean?

Well, UCTL is the internal name of the hardware block.  It functions to 
connect a standard AHCI controller to the internal busses of the OCTEON SoC.

>
>> +
>> +Properties:
>> +- compatible: "cavium,octeon-7130-sata-uctl"
>> +
>> +  Compatibility with the cn7130 SOC.
>> +
>> +- reg: The base address of the UCTL register bank.
>> +
>> +- #address-cells: Must be <2>.
>> +
>> +- #size-cells: Must be <2>.
>> +
>> +- ranges: Empty to signify direct mapping of the children.
>
> Why can't these be any values which are sufficient to map children?

They can.  It happens to be the case that it is always empty.


>
>> +
>> +Example:
>> +
>> +	uctl@118006c000000 {
>> +	        compatible = "cavium,octeon-7130-sata-uctl";
>> +	        reg = <0x00011800 0x6c000000 0x00000000 0x00000100>;
>> +	        ranges;
>> +	        #address-cells = <0x00000002>;
>> +	        #size-cells = <0x00000002>;
>
> No need for all the zero-padding on these, they aren't addresses.

OK.

>
>> +	        sata@16c00 {
>> +	                compatible = "cavium,octeon-7130-ahci";
>> +	                reg = <0x00016c00 0x00000000 0x00000000 0x00000200>;
>> +	                interrupt-parent = <0x0000000d>;
>> +	                interrupts = <0x00000002 0x00000004>;
>> +	                cavium,qlm-trim-alias = "sata";
>
> What's this property for? It wasn't documented above, and doesn't exist
> in mainline.

It is not a part of the public interface, we will remove this line.

>
> [...]
>
>> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
>> index ae41107..4a0e5e3 100644
>> --- a/drivers/ata/Makefile
>> +++ b/drivers/ata/Makefile
>> @@ -17,6 +17,7 @@ obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
>>   obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
>>   obj-$(CONFIG_AHCI_TEGRA)	+= ahci_tegra.o libahci.o libahci_platform.o
>>   obj-$(CONFIG_AHCI_XGENE)	+= ahci_xgene.o libahci.o libahci_platform.o
>> +obj-$(CONFIG_SATA_OCTEON)	+= sata_octeon.o
>>
>>   # SFF w/ custom DMA
>>   obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
>> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
>> index 18d5398..bb36396 100644
>> --- a/drivers/ata/ahci_platform.c
>> +++ b/drivers/ata/ahci_platform.c
>> @@ -22,6 +22,12 @@
>>   #include <linux/ahci_platform.h>
>>   #include "ahci.h"
>>
>> +#if IS_ENABLED(CONFIG_SATA_OCTEON)
>> +void ahci_octeon_config(struct platform_device *pdev);
>> +#else
>> +static inline void ahci_octeon_config(struct platform_device *pdev) {}
>> +#endif
>> +
>>   static const struct ata_port_info ahci_port_info = {
>>   	.flags		= AHCI_FLAG_COMMON,
>>   	.pio_mask	= ATA_PIO4,
>> @@ -46,6 +52,9 @@ static int ahci_probe(struct platform_device *pdev)
>>   	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
>>   		hpriv->flags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
>>
>> +	if (of_device_is_compatible(dev->of_node, "cavium,octeon-7130-ahci"))
>> +		ahci_octeon_config(pdev);
>> +
>
> If we really need this kind of thing, make a new struct and associate it
> with of_device_id::data in the table below. Then we make this path free
> from any device-specific code.
>

Good idea.

We will attempt to factor this into a separate driver module for the 
"cavium,octeon-7130-sata-uctl" block.  If that turns out to be too ugly, 
I would like to keep the code in this file, but with the change you suggest.

>>   	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info);
>>   	if (rc)
>>   		goto disable_resources;
>> @@ -67,6 +76,7 @@ static const struct of_device_id ahci_of_match[] = {
>>   	{ .compatible = "ibm,476gtr-ahci", },
>>   	{ .compatible = "snps,dwc-ahci", },
>>   	{ .compatible = "hisilicon,hisi-ahci", },
>> +	{ .compatible = "cavium,octeon-7130-ahci", },
>>   	{},
>
> I was under the impression that the strings other than "generic-ahci"
> were only for compatibility with existing DTBs. Why do we need to add
> new platform-specific strings here?

Because it is an "existing DTB", The device tree doesn't contain the 
compatible property of "generic-ahci", only "cavium,octeon-7130-ahci".

>
> [...]
>
>> +void ahci_octeon_config(struct platform_device *pdev)
>> +{
>> +	union cvmx_sata_uctl_shim_cfg shim_cfg;
>> +
>> +	/* set-up endian mode */
>> +	shim_cfg.u64 = cvmx_read_csr(CVMX_SATA_UCTL_SHIM_CFG);
>> +#ifdef __BIG_ENDIAN
>> +	shim_cfg.s.dma_endian_mode = 1;
>> +	shim_cfg.s.csr_endian_mode = 1;
>> +#else
>> +	shim_cfg.s.dma_endian_mode = 0;
>> +	shim_cfg.s.csr_endian_mode = 0;
>> +#endif
>> +	shim_cfg.s.dma_read_cmd = 1; /* No allocate L2C */
>> +	cvmx_write_csr(CVMX_SATA_UCTL_SHIM_CFG, shim_cfg.u64);
>> +
>> +	/* Set a good dma_mask */
>> +	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(64);
>> +	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
>
> I thought a dma-ranges property in the DT could be used to set up the
> DMA mask appropriately?

The DT contains no dma-ranges property, and we know a priori, that it 
should be 64-bits.

>
> Thanks,
> Mark.
>
>

