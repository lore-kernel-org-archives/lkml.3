Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbaJ3NqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:46:21 -0400
Received: from mail-by2on0132.outbound.protection.outlook.com ([207.46.100.132]:53075
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759908AbaJ3NqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:46:19 -0400
X-WSS-ID: 0NE9FKY-08-TIU-02
X-M-MSG: 
Message-ID: <54524123.1020407@amd.com>
Date: Thu, 30 Oct 2014 08:46:11 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 4/4] edac, amd64_edac: Add F15h M60h support
References: <1414617483-4941-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141030124528.GB11178@pd.tnic>
In-Reply-To: <20141030124528.GB11178@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(24454002)(51704005)(479174003)(377454003)(95666004)(36756003)(20776003)(99136001)(87936001)(107046002)(76176999)(54356999)(120916001)(87266999)(106466001)(120886001)(65956001)(65806001)(105586002)(85852003)(85306004)(101416001)(59896002)(92726001)(92566001)(23676002)(117636001)(68736004)(110136001)(102836001)(76482002)(4396001)(50466002)(80022003)(31966008)(83506001)(46102003)(84676001)(64706001)(21056001)(65816999)(50986999)(86362001)(97736003)(47776003)(44976005)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 7:45 AM, Borislav Petkov wrote:
> On Wed, Oct 29, 2014 at 04:18:03PM -0500, Aravind Gopalakrishnan wrote:
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index bbd6514..1092ddd 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -692,9 +692,19 @@ static void debug_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
>>   {
>>   	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
>>   
>> -	edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
>> -		 (dclr & BIT(16)) ?  "un" : "",
> Why did we drop bit 16 about the unbuffered-ness of the DIMMs?

Because it gets printed anyway when we do
edac_dbg(1, "  DIMM type: %s\n", edac_mem_types[pvt->dram_type]);

>> @@ -813,25 +823,57 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>>   	}
>>   }
>>   
>> -static enum mem_type determine_memory_type(struct amd64_pvt *pvt, int cs)
>> +static void determine_memory_type(struct amd64_pvt *pvt)
>>   {
>> -	enum mem_type type;
>> -
>> -	/* F15h supports only DDR3 */
>> -	if (pvt->fam >= 0x15)
>> -		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
>> -	else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
>> -		if (pvt->dchr0 & DDR3_MODE)
>> -			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
>> -		else
>> -			type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
>> -	} else {
>> -		type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
>> +	switch (pvt->fam) {
>> +	case 0xf:
>> +		if (pvt->ext_model < K8_REV_F) {
>> +			pvt->dram_type = (pvt->dclr0 & BIT(18)) ?
>> +					 MEM_DDR : MEM_RDDR;
>> +			break;
>> +		}
>> +		/* ext_model >= k8_rev_f, fall down below */
>> +	case 0x10:
>> +		if (!(pvt->dchr0 & DDR3_MODE)) {
>> +			pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
>> +					 MEM_DDR2 : MEM_RDDR2;
>> +			break;
>> +		}
>> +		/* If f10h supports DDR3, it will be handled by cases below */
>> +	case 0x15:
>> +		/* F15h supports only DDR3 */
>> +		if (pvt->model == 0x60) {
>> +			/*
>> +			 * We use a Chip Select value of '0' to obtain dcsm.
>> +			 * Theoretically, it is possible to populate LRDIMMs
>> +			 * of different 'Rank' value on a DCT. But this is not
>> +			 * a common case. So, it's reasonable to assume all
>> +			 * DIMMs are going to be of same 'type' until proven
>> +			 * otherwise.
>> +			 */
>> +			u32 dram_ctrl;
>> +			u32 dcsm = pvt->csels[0].csmasks[0];
>> +
>> +			amd64_read_dct_pci_cfg(pvt, 0, DRAM_CONTROL,
>> +					       &dram_ctrl);
>> +			if (((dram_ctrl >> 8) & 0x7) == 0x2)
>> +				pvt->dram_type = MEM_DDR4;
>> +			else if (pvt->dclr0 & BIT(16))
>> +				pvt->dram_type = MEM_DDR3;
>> +			else if (dcsm & 0x3)
>> +				pvt->dram_type = MEM_LRDDR3;
>> +			else
>> +				pvt->dram_type = MEM_RDDR3;
>> +			break;
>> +		}
>> +		/* other f15h models fall down below */
>> +	case 0x16:
>> +		pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
>> +				 MEM_DDR3 : MEM_RDDR3;
>> +		break;
>> +	default:
>> +		pvt->dram_type = MEM_EMPTY;
>>   	}
> Ok, I went and did cleanup that version here by flipping the logic
> in the tests and thus saving an indentation level. Also, I've added
> explicit "return"s in the respective cases in order to follow through
> the code more easily. Here's how the whole function looks like now - I
> think it is a bit better readable this way. Full patch below:
>
> static void determine_memory_type(struct amd64_pvt *pvt)
> {
>          u32 dram_ctrl, dcsm;
>
>          switch (pvt->fam) {
>          case 0xf:
>                  if (pvt->ext_model >= K8_REV_F)
>                          goto ddr3;
>
>                  pvt->dram_type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
>                  return;
>
>          case 0x10:
>                  if (pvt->dchr0 & DDR3_MODE)
>                          goto ddr3;
>
>                  pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
>                  return;
>
>          case 0x15:
>                  if (pvt->model < 0x60)
>                          goto ddr3;
>
>                  /*
>                   * Model 0x60h needs special handling:
>                   *
>                   * We use a Chip Select value of '0' to obtain dcsm.
>                   * Theoretically, it is possible to populate LRDIMMs of different
>                   * 'Rank' value on a DCT. But this is not the common case. So,
>                   * it's reasonable to assume all DIMMs are going to be of same
>                   * 'type' until proven otherwise.
>                   */
>                  amd64_read_dct_pci_cfg(pvt, 0, DRAM_CONTROL, &dram_ctrl);
>                  dcsm = pvt->csels[0].csmasks[0];
>
>                  if (((dram_ctrl >> 8) & 0x7) == 0x2)
>                          pvt->dram_type = MEM_DDR4;
>                  else if (pvt->dclr0 & BIT(16))
>                          pvt->dram_type = MEM_DDR3;
>                  else if (dcsm & 0x3)
>                          pvt->dram_type = MEM_LRDDR3;
>                  else
>                          pvt->dram_type = MEM_RDDR3;
>
>                  return;
>
>          case 0x16:
>                  goto ddr3;
>
>          default:
>                  WARN(1, KERN_ERR "%s: Family??? 0x%x\n", __func__, pvt->fam);
>                  pvt->dram_type = MEM_EMPTY;
>          }
>          return;
>
> ddr3:
>          pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR3 : MEM_RDDR3;
> }

Ok, This does looks better, thanks :)


