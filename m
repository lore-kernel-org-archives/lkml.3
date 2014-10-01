Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaJAPdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:33:12 -0400
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:1056
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751365AbaJAPdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:33:10 -0400
X-WSS-ID: 0NCRV71-08-889-02
X-M-MSG: 
Message-ID: <542C1EAA.4050408@amd.com>
Date: Wed, 1 Oct 2014 10:32:58 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] edac, amd64_edac: Add F15h M60h support
References: <1411070230-10298-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141001113235.GC18271@pd.tnic>
In-Reply-To: <20141001113235.GC18271@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(57704003)(51704005)(479174003)(189002)(377454003)(24454002)(199003)(164054003)(92566001)(36756003)(76482002)(80022003)(92726001)(50986999)(4396001)(65806001)(54356999)(65956001)(65816999)(33656002)(59896002)(46102003)(50466002)(76176999)(102836001)(87266999)(68736004)(85306004)(105586002)(95666004)(87936001)(85852003)(106466001)(97736003)(101416001)(83506001)(21056001)(84676001)(31966008)(99396003)(86362001)(20776003)(19580395003)(44976005)(120916001)(10300001)(64126003)(64706001)(107046002)(19580405001)(120886001)(23676002)(47776003)(110136001)(80316001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Forefront-PRVS: 0351D213B3
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/2014 6:32 AM, Borislav Petkov wrote:
> On Thu, Sep 18, 2014 at 02:57:10PM -0500, Aravind Gopalakrishnan wrote:
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
>> Misc cleanup:
>>   - amd64_pci_table[] is condensed by using PCI_VDEVICE macro.
>>
>> Testing details:
>> Tested the patch by injecting 'ECC' type errors using mce_amd_inj
>> and error decoding works fine.
>>
>> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>> ---
>>   drivers/edac/amd64_edac.c | 226 ++++++++++++++++++++++++++++++++--------------
>>   drivers/edac/amd64_edac.h |  12 ++-
>>   2 files changed, 169 insertions(+), 69 deletions(-)
>>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index bbd6514..3e265e0 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -690,11 +690,32 @@ static void debug_display_dimm_sizes(struct amd64_pvt *, u8);
>>   
>>   static void debug_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
>>   {
>> +	int cs;
>> +
>>   	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
>>   
>> -	edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
>> -		 (dclr & BIT(16)) ?  "un" : "",
>> -		 (dclr & BIT(19)) ? "yes" : "no");
>> +	if (pvt->fam == 0x15 && pvt->model == 0x60) {
>> +		for_each_chip_select_mask(cs, chan, pvt) {
>> +			u32 dcsm = pvt->csels[chan].csmasks[cs];
>> +
>> +			if (dcsm & 0x3) {
>> +				/* LRDIMMs */
>> +				edac_dbg(1, "  DIMM type: LRDIMM %dx rank multiply;"
>> +					 "CS = %d; all DIMMs support ECC: %s\n",
>> +					 (dcsm & 0x3), cs,
>> +					 (dclr & BIT(19)) ? "yes" : "no");
> Why do we need to iterate over the DRAM CS sets? Just for the rank
> multiplier, apparently. We dump those normally in read_dct_base_mask(),
> though.

It's not just for rank multiplier.. we find that it's LRDIMM only by 
examining dcsm. Hence the iteration here..

Not sure if we should move it to read_dct_base_mask() as traditionally 
we report the DIMM type
in this function.

>> +			} else {
>> +				edac_dbg(1, "  DIMM type: %sbuffered; CS = %d;"
>> +					 "all DIMMs support ECC: %s\n",
>> +					 (dclr & BIT(16)) ?  "un" : "", cs,
>> +					 (dclr & BIT(19)) ? "yes" : "no");
>> +			}
>> +		}
>> +	} else {
>> +		edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC:"
>> +			    "%s\n", (dclr & BIT(16)) ?  "un" : "",
>> +				    (dclr & BIT(19)) ? "yes" : "no");
>> +	}
> Single if-else statements don't need {} braces.

Ok, will fix this.

>>   
>>   	edac_dbg(1, "  PAR/ERR parity: %s\n",
>>   		 (dclr & BIT(8)) ?  "enabled" : "disabled");
>> @@ -756,7 +777,7 @@ static void prep_chip_selects(struct amd64_pvt *pvt)
>>   	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_F) {
>>   		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
>>   		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
>> -	} else if (pvt->fam == 0x15 && pvt->model >= 0x30) {
>> +	} else if (pvt->fam == 0x15 && pvt->model == 0x30) {
>>   		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
>>   		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
>>   	} else {
>> @@ -817,10 +838,26 @@ static enum mem_type determine_memory_type(struct amd64_pvt *pvt, int cs)
>>   {
>>   	enum mem_type type;
>>   
>> -	/* F15h supports only DDR3 */
>> -	if (pvt->fam >= 0x15)
>> -		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
>> -	else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
>> +	/* F15h, M60h supports DDR4 too*/
>> +	if (pvt->fam >= 0x15) {
>> +		if (pvt->model == 0x60) {
>> +			/*
>> +			 * Since in init_csrow we iterate over just DCT0
>> +			 * use '0' for dct values here when necessary.
>> +			 */
>> +			u32 dram_ctrl;
>> +			u32 dcsm = pvt->csels[0].csmasks[cs];
>> +
>> +			amd64_read_dct_pci_cfg(pvt, 0, DRAM_CONTROL,
>> +					       &dram_ctrl);
> We're reading DRAM_CONTROL at two locations, maybe we should cache it in
> pvt->dram_ctl ?

Makes sense. Will do this.

>> +			type = (((dram_ctrl >> 8) & 0x7) == 0x2) ? MEM_DDR4 :
>> +				(pvt->dclr0 & BIT(16)) ? MEM_DDR3 :
>> +				(dcsm & 0x3) ? MEM_LRDDR3 : MEM_RDDR3;
> Doesn't D18F2x78_dct[3:0][DramType] define all possible types or do you
> have to fallback to DCLR for DDR3 types?

No, we need to fall back to DCLR to realize if it's Unbuffered DIMM or not.

>> +		} else {
>> +			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
>> +		}
> Single if-else statements don't need {} braces. Please read
> Documentation/CodingStyle.

Yeah. Sorry about that. Will fix.

>> +
>> +	} else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
>>   		if (pvt->dchr0 & DDR3_MODE)
>>   			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
>>   		else
>> @@ -958,8 +995,12 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
>>   	if (WARN_ON(!nb))
>>   		return;
>>   
>> -	pci_func = (pvt->model == 0x30) ? PCI_DEVICE_ID_AMD_15H_M30H_NB_F1
>> -					: PCI_DEVICE_ID_AMD_15H_NB_F1;
>> +	if (pvt->model == 0x60)
>> +		pci_func = PCI_DEVICE_ID_AMD_15H_M60H_NB_F1;
>> +	else if (pvt->model == 0x30)
>> +		pci_func = PCI_DEVICE_ID_AMD_15H_M30H_NB_F1;
>> +	else
>> +		pci_func = PCI_DEVICE_ID_AMD_15H_NB_F1;
>>   
>>   	f1 = pci_get_related_function(nb->misc->vendor, pci_func, nb->misc);
>>   	if (WARN_ON(!f1))
>> @@ -1049,7 +1090,7 @@ static int ddr2_cs_size(unsigned i, bool dct_width)
>>   }
>>   
>>   static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>> -				  unsigned cs_mode)
>> +				  unsigned cs_mode, int cs_mask_nr)
>>   {
>>   	u32 dclr = dct ? pvt->dclr1 : pvt->dclr0;
>>   
>> @@ -1167,8 +1208,43 @@ static int ddr3_cs_size(unsigned i, bool dct_width)
>>   	return cs_size;
>>   }
>>   
>> +static int ddr3_lrdimm_cs_size(unsigned i, unsigned rank_multiply)
>> +{
>> +	unsigned shift = 0;
>> +	int cs_size = 0;
>> +
>> +	if (i < 4 || i == 6)
>> +		cs_size = -1;
>> +	else if (i == 12)
>> +		shift = 7;
>> +	else if (!(i & 0x1))
>> +		shift = i >> 1;
>> +	else
>> +		shift = (i + 1) >> 1;
>> +
>> +	if (cs_size != -1)
>> +		cs_size = rank_multiply * (128 << shift);
>> +
>> +	return cs_size;
>> +}
>> +
>> +static int ddr4_cs_size(unsigned i)
>> +{
>> +	int cs_size = 0;
>> +
>> +	if (i == 0)
>> +		cs_size = -1;
>> +	else if (i == 1)
>> +		cs_size = 1024;
>> +	else
>> +		/* Min cs_size = 1G */
>> +		cs_size = 1024 * (1 << (i >> 1));
>> +
>> +	return cs_size;
>> +}
>> +
>>   static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>> -				   unsigned cs_mode)
>> +				   unsigned cs_mode, int cs_mask_nr)
>>   {
>>   	u32 dclr = dct ? pvt->dclr1 : pvt->dclr0;
>>   
>> @@ -1184,18 +1260,56 @@ static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>>    * F15h supports only 64bit DCT interfaces
>>    */
>>   static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>> -				   unsigned cs_mode)
>> +				   unsigned cs_mode, int cs_mask_nr)
>>   {
>>   	WARN_ON(cs_mode > 12);
>>   
>>   	return ddr3_cs_size(cs_mode, false);
>>   }
>>   
>> +/* F15h M60h supports DDR4 mapping as well.. */
>> +static int f15_m60h_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>> +					unsigned cs_mode, int cs_mask_nr)
>> +{
>> +	int cs_size;
>> +	enum mem_type type;
>> +	u32 dram_ctrl;
>> +	u32 dcsm = pvt->csels[dct].csmasks[cs_mask_nr];
>> +
>> +	WARN_ON(cs_mode > 12);
>> +
>> +	amd64_read_dct_pci_cfg(pvt, dct, DRAM_CONTROL, &dram_ctrl);
>> +	type = (((dram_ctrl >> 8) & 0x7) == 0x2) ? MEM_DDR4 :
>> +		(pvt->dclr0 & BIT(16)) ? MEM_DDR3 :
>> +		(dcsm & 0x3) ? MEM_LRDDR3 : MEM_RDDR3;
> This is the second time we're determining memory type, maybe we should
> cache that too into pvt->dram_type...?

Yes, Will do.

>> +
>> +	if (type == MEM_DDR4) {
>> +		if (cs_mode > 9)
>> +			return -1;
>> +
>> +		cs_size = ddr4_cs_size(cs_mode);
>> +	} else if (type == MEM_LRDDR3) {
>> +		unsigned rank_multiply = dcsm & 0xf;
>> +
>> +		if (rank_multiply == 3)
>> +			rank_multiply = 4;
>> +		cs_size = ddr3_lrdimm_cs_size(cs_mode, rank_multiply);
>> +	} else {
>> +		/* Minimum cs size is 512mb for F15hM60h*/
>> +		if (cs_mode == 0x1)
>> +			return -1;
>> +
>> +		cs_size = ddr3_cs_size(cs_mode, false);
>> +	}
>> +
>> +	return cs_size;
>> +}

Shall resend as V2.

Thanks,
-Aravind.
