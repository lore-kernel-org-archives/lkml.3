Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933630AbaJ2PaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:30:22 -0400
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:9184
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933331AbaJ2PaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:30:20 -0400
X-WSS-ID: 0NE7PQE-08-OMN-02
X-M-MSG: 
Message-ID: <54510806.9080102@amd.com>
Date: Wed, 29 Oct 2014 10:30:14 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/4] edac, amd64_edac: Add F15h M60h support
References: <1412640280-11452-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141010174954.GA13017@pd.tnic>
In-Reply-To: <20141010174954.GA13017@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174003)(51704005)(377454003)(24454002)(164054003)(52314003)(199003)(189002)(110136001)(102836001)(117636001)(64126003)(68736004)(4396001)(50466002)(76482002)(92726001)(59896002)(101416001)(19580405001)(19580395003)(23676002)(92566001)(47776003)(97736003)(44976005)(83506001)(84676001)(21056001)(80022003)(31966008)(46102003)(64706001)(86362001)(65816999)(50986999)(54356999)(76176999)(99136001)(107046002)(87936001)(65956001)(106466001)(99396003)(87266999)(120886001)(120916001)(95666004)(20776003)(36756003)(105586002)(85852003)(85306004)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 03793408BA
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 12:49 PM, Borislav Petkov wrote:
> On Mon, Oct 06, 2014 at 07:04:40PM -0500, Aravind Gopalakrishnan wrote:
>> This patch adds support for ECC error decoding for F15h M60h processor.
>> Aside from the usual changes, the patch adds support for some new features
>> in the processor:
>>   - DDR4(unbuffered, registered); LRDIMM DDR3 support
>>     - relevant debug messages have been modified/added to report these
>>       memory types
>>   - new dbam_to_cs mappers
>>     - if (F15h M60h && LRDIMM); we need a 'multiplier' value to find
>>       cs_size. This multiplier value is obtained from the per-dimm
>>       DCSM register. So, change the interface to accept a 'cs_mask_nr'
>>       value to facilitate this calculation
>>   - new determine_memory_type low_ops
>>     - introduced to remove too many if-else conditions in
>>       determine_memory_type().
>>     - This is now called early in read_mc_regs() to cache dram_type
>>
>> Misc cleanup:
>>   - amd64_pci_table[] is condensed by using PCI_VDEVICE macro.
>>
>> Testing details:
>> Tested the patch by injecting 'ECC' type errors using mce_amd_inj
>> and error decoding works fine.
>>
>> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>> ---
>> Changes in V2
>>   - Cache dram_type in amd64_pvt structure (per Boris suggestion)
>>   - Introduce per-family low_ops for determine_memory_type() to reduce
>>     number of if-else statements
>>     - Call this early in read_mc_regs() to cache dram_type
>>     - The debug messages are moved around a bit as a result to print
>>       dram_type immediately
>>
>>   drivers/edac/amd64_edac.c | 253 ++++++++++++++++++++++++++++++++--------------
>>   drivers/edac/amd64_edac.h |  16 ++-
>>   2 files changed, 188 insertions(+), 81 deletions(-)
>>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index bbd6514..6cc3243 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -692,9 +692,18 @@ static void debug_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
>>   {
>>   	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
>>   
>> -	edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
>> -		 (dclr & BIT(16)) ?  "un" : "",
>> -		 (dclr & BIT(19)) ? "yes" : "no");
>> +	if (pvt->dram_type == MEM_LRDDR3) {
>> +		u32 dcsm = pvt->csels[chan].csmasks[0];
>> +		/*
>> +		 * It's assumed all LRDIMMs in a DCT are going to be of
>> +		 * same 'type' until proven otherwise. So, use a cs
>> +		 * value of '0' here to get dcsm value.
>> +		 */
>> +		edac_dbg(1, " LRDIMM %dx rank multiply\n", (dcsm & 0x3));
>> +	}
>> +
>> +	edac_dbg(1, "All DIMMs support ECC:%s\n",
>> +		    (dclr & BIT(19)) ? "yes" : "no");
>>   
>>   	edac_dbg(1, "  PAR/ERR parity: %s\n",
>>   		 (dclr & BIT(8)) ?  "enabled" : "disabled");
>> @@ -756,7 +765,7 @@ static void prep_chip_selects(struct amd64_pvt *pvt)
>>   	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_F) {
>>   		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
>>   		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
>> -	} else if (pvt->fam == 0x15 && pvt->model >= 0x30) {
>> +	} else if (pvt->fam == 0x15 && pvt->model == 0x30) {
>>   		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
>>   		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
>>   	} else {
>> @@ -813,25 +822,57 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>>   	}
>>   }
>>   
>> -static enum mem_type determine_memory_type(struct amd64_pvt *pvt, int cs)
>> +void determine_memory_type_k8(struct amd64_pvt *pvt)
>>   {
>> -	enum mem_type type;
>> -
>> -	/* F15h supports only DDR3 */
>> -	if (pvt->fam >= 0x15)
>> -		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
>> -	else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
>> +	if (pvt->ext_model >= K8_REV_F) {
>>   		if (pvt->dchr0 & DDR3_MODE)
>> -			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
>> +			pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
>> +					 MEM_DDR3 : MEM_RDDR3;
>>   		else
>> -			type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
>> +			pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
>> +					 MEM_DDR2 : MEM_RDDR2;
> If you want to do separate ->determine_memory_type() per family, you can
> at least avoid code duplication here above ^^^ by doing
>
> 	return determine_memory_type_f10(pvt);
>
> for the K8-revF and later at least.
>
> Or, you can do a nice clean switch/case and keep the logic for the
> memory type in one function. See which one looks cleaner but from where
> I'm standing, the per-family pointers are a bit too much for this case,
> IMHO.
>
> Oh, btw, they all should be static declarations, of course.
>
>>   	} else {
>> -		type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
>> +		pvt->dram_type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
>>   	}
>> +}
>>   
>> -	amd64_info("CS%d: %s\n", cs, edac_mem_types[type]);
>> +void determine_memory_type_f10(struct amd64_pvt *pvt)
>> +{
>> +	if (pvt->dchr0 & DDR3_MODE)
>> +		pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
>> +				 MEM_DDR3 : MEM_RDDR3;
>> +	else
>> +		pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
>> +				 MEM_DDR2 : MEM_RDDR2;
>> +}
>>   
>> -	return type;
>> +void determine_memory_type_f15(struct amd64_pvt *pvt)
>> +{
>> +	if (pvt->model == 0x60) {
>> +		/*
>> +		 * We use a Chip Select value of '0' to obtain dcsm.
>> +		 * Theoretically, it is possible to populate LRDIMMs
>> +		 * of different 'Rank' value on a DCT. But this is
>> +		 * not a common case. So, it's reasonable to assume
>> +		 * all DIMMs are going to be of same 'type' until
>> +		 * proven otherwise.
>> +		 */
>> +		u32 dram_ctrl;
>> +		u32 dcsm = pvt->csels[0].csmasks[0];
>> +
>> +		amd64_read_dct_pci_cfg(pvt, 0, DRAM_CONTROL,
>> +				       &dram_ctrl);
>> +		pvt->dram_type = (((dram_ctrl >> 8) & 0x7) == 0x2) ? MEM_DDR4 :
>> +				 (pvt->dclr0 & BIT(16)) ? MEM_DDR3 :
>> +				 (dcsm & 0x3) ? MEM_LRDDR3 : MEM_RDDR3;
> This is pretty unreadable, please do a simpler if-else instead.

Ok, will do.

>> +	} else {
>> +		pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR3 : MEM_RDDR3;
>> +	}
>> +}
>> +
>> +void determine_memory_type_f16(struct amd64_pvt *pvt)
>> +{
>> +	pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR3 : MEM_RDDR3;
> This line tends to repeat a lot - the switch/case version starts to
> sound much better all of a sudden... :-)
>
>

switch-case is fine too (although it'll probably be one big function..).
I thought per-family pointers might be more manageable; anyway, I'll 
re-implement this as a switch-case and send as V3.

Thanks,
-Aravind
