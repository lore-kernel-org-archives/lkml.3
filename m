Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbaLBRzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:55:21 -0500
Received: from mail-bn1on0094.outbound.protection.outlook.com ([157.56.110.94]:55900
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932569AbaLBRzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:55:19 -0500
Message-ID: <547DFCC1.3060805@opensource.altera.com>
Date: Tue, 2 Dec 2014 11:54:09 -0600
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "bp@alien8.de" <bp@alien8.de>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tthayer.linux@gmail.com" <tthayer.linux@gmail.com>
Subject: Re: [PATCHv5 2/5] arm: socfpga: Enable OCRAM ECC on startup.
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com> <1415751263-1830-3-git-send-email-tthayer@opensource.altera.com> <20141202151145.GN23671@leverpostej>
In-Reply-To: <20141202151145.GN23671@leverpostej>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0035.namprd08.prod.outlook.com (10.141.200.15) To
 BN1PR03MB121.namprd03.prod.outlook.com (10.255.201.16)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB121;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB121;
X-Forefront-PRVS: 0413C9F1ED
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(189002)(479174003)(377454003)(24454002)(51704005)(164054003)(199003)(64706001)(110136001)(83506001)(54356999)(87266999)(19580395003)(40100003)(50986999)(65816999)(76176999)(47776003)(20776003)(122386002)(65956001)(66066001)(77156002)(62966003)(42186005)(68736005)(50466002)(102836001)(99396003)(31966008)(92726001)(106356001)(105586002)(92566001)(46102003)(95666004)(64126003)(107046002)(80316001)(21056001)(87976001)(59896002)(86362001)(33656002)(4396001)(23746002)(97736003)(120916001)(19580405001)(101416001)(77096005)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB121;H:[137.57.160.203];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB121;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/02/2014 09:11 AM, Mark Rutland wrote:
> On Wed, Nov 12, 2014 at 12:14:20AM +0000, tthayer@opensource.altera.com wrote:
>> From: Thor Thayer <tthayer@opensource.altera.com>
>>
>> This patch enables the ECC for On-Chip RAM on machine
>> startup.  The ECC has to be enabled before data is
>> is stored in memory otherwise the ECC will fail on
>> reads.
>>
>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
>> ---
>> v2: Split OCRAM ECC portion separately. Addition of iounmap()
>> and reorganization of gen_pool_free. Remove defconfig from patch.
>>
>> v3/4: No change
>>
>> v5: Remove ocram.h, use io.h instead of clk-provider.h
>>      Check prop in correct place. Add ECC EN defines.
>> ---
<snip>

>> +
>> +void socfpga_init_ocram_ecc(void)
>> +{
>> +	struct device_node *np;
>> +	const __be32 *prop;
>
> Please don't use accessors which return raw __be32s in drivers,
> typically it's the wrong thing to do and leaves horrible bugs and/or
> quirks that are painful to fix up.

OK. Thanks.

>> +	u32 ocr_edac_addr, iram_addr, len;
>> +	void __iomem  *mapped_ocr_edac_addr;
>> +	size_t size;
>> +	struct gen_pool *gp;
>> +
>> +	np = of_find_compatible_node(NULL, NULL, "altr,ocram-edac");
>> +	if (!np) {
>> +		pr_err("SOCFPGA: Unable to find altr,ocram-edac in dtb\n");
>> +		return;
>> +	}
>> +
>> +	prop = of_get_property(np, "reg", &size);
>> +	if (!prop || size < sizeof(*prop)) {
>> +		pr_err("SOCFPGA: Unable to find OCRAM ECC mapping in dtb\n");
>> +		return;
>> +	}
>> +	ocr_edac_addr = be32_to_cpup(prop++);
>> +	len = be32_to_cpup(prop);
>
> Use of_iomap(np, 0). You don't seem to pass the address around, so that
> should be sufficient.
>
>> +
>> +	gp = of_get_named_gen_pool(np, "iram", 0);
>> +	if (!gp) {
>> +		pr_err("SOCFPGA: OCRAM cannot find gen pool\n");
>> +		return;
>> +	}
>> +
>> +	np = of_find_compatible_node(NULL, NULL, "mmio-sram");
>> +	if (!np) {
>> +		pr_err("SOCFPGA: Unable to find mmio-sram in dtb\n");
>> +		return;
>> +	}
>> +
>> +	/* Determine the OCRAM address and size */
>> +	prop = of_get_property(np, "reg", &size);
>> +	if (!prop || size < sizeof(*prop)) {
>> +		pr_err("SOCFPGA: Unable to find OCRAM mapping in dtb\n");
>> +		return;
>> +	}
>> +	iram_addr = be32_to_cpup(prop++);
>> +	len = be32_to_cpup(prop);
>
> This address is overwritten below. What's going on?
>

Thanks, leftovers from debugging. I will look for a different way of 
getting the information without the be32 stuff.

>> +
>> +	iram_addr = gen_pool_alloc(gp, len);
>> +	if (iram_addr == 0) {
>> +		pr_err("SOCFPGA: cannot alloc from gen pool\n");
>> +		return;
>> +	}
>> +
>> +	memset((void *)iram_addr, 0, len);
>
> How is the iram mapped? Is memset to it safe (e.g. it unaligned accesses
> are made)?
>

I will need to look at this further - good points. The entire iram 
should be used as a pool so I didn't expect anything unusual even though 
I just realized allocations are not contiguous.

>> +
>> +	gen_pool_free(gp, iram_addr, len);
>> +
>> +	mapped_ocr_edac_addr = ioremap(ocr_edac_addr, 4);
>> +	if (!mapped_ocr_edac_addr) {
>> +		pr_err("SOCFPGA: Unable to map OCRAM ecc regs.\n");
>> +		return;
>> +	}
>> +
>> +	/* Clear any pending OCRAM ECC interrupts, then enable ECC */
>> +	writel(ALTR_OCRAM_CLEAR_ECC, mapped_ocr_edac_addr);
>> +	writel(ALTR_OCRAM_ECC_EN, mapped_ocr_edac_addr);
>> +
>> +	iounmap(mapped_ocr_edac_addr);
>> +
>> +	pr_debug("SOCFPGA: Success Initializing OCRAM\n");
>> +}
>> diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
>> index 0954011..065d80d 100644
>> --- a/arch/arm/mach-socfpga/socfpga.c
>> +++ b/arch/arm/mach-socfpga/socfpga.c
>> @@ -100,6 +100,14 @@ static void socfpga_cyclone5_restart(enum reboot_mode mode, const char *cmd)
>>   	writel(temp, rst_manager_base_addr + SOCFPGA_RSTMGR_CTRL);
>>   }
>>
>> +static void __init socfpga_cyclone5_init(void)
>> +{
>> +	of_platform_populate(NULL, of_default_bus_match_table,
>> +			     NULL, NULL);
>> +	if (IS_ENABLED(CONFIG_EDAC_ALTERA_OCRAM))
>> +		socfpga_init_ocram_ecc();
>
> If it's safe to do this after probing everything else, why can't this be
> a normal device probe?
>
> Thanks,
> Mark.

Good point. Thank you.
