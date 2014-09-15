Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaIOOz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:55:29 -0400
Received: from mail-by2on0113.outbound.protection.outlook.com ([207.46.100.113]:1682
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752955AbaIOOz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:55:27 -0400
X-WSS-ID: 0NBY6S9-07-HQD-02
X-M-MSG: 
Message-ID: <5416FDDA.2070208@amd.com>
Date: Mon, 15 Sep 2014 09:55:22 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4] edac, amd64_edac: Modify usage of amd64_read_dct_pci_cfg()
References: <1410292346-3352-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140915120925.GD3340@nazgul.tnic>
In-Reply-To: <20140915120925.GD3340@nazgul.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(199003)(479174003)(24454002)(189002)(377454003)(51704005)(107046002)(87266999)(92566001)(83506001)(44976005)(19580395003)(50466002)(99396002)(50986999)(95666004)(65816999)(85306004)(97736003)(65806001)(23676002)(86362001)(74662001)(92726001)(102836001)(84676001)(31966008)(54356999)(76482001)(74502001)(76176999)(47776003)(79102001)(87936001)(36756003)(21056001)(19580405001)(64126003)(46102001)(65956001)(80022001)(77982001)(20776003)(90102001)(106466001)(110136001)(101416001)(4396001)(64706001)(81542001)(80316001)(85852003)(81342001)(83322001)(33656002)(105586002)(68736004)(83072002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB492;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03355EE97E
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/2014 7:09 AM, Borislav Petkov wrote:
> On Tue, Sep 09, 2014 at 02:52:26PM -0500, Aravind Gopalakrishnan wrote:
>> Rationale behind this change:
>>   - F2x1xx addresses were stopped from being mapped explicitly to DCT1
>>     from F15h (OR) onwards. They use _dct[0:1] mechanism to access the
>>     registers. So we should move away from using address ranges to select
>>     DCT for these families.
>>   - On newer processors, the address ranges used to indicate DCT1 (0x140,
>>     0x1a0) have different meanings than what is assumed currently.
>>
>> Changes introduced:
>>   - amd64_read_dct_pci_cfg() now takes in dct value and uses it for
>>     'selecting the dct'
>>   - Update usage of the function. Keep in mind that different families
>>     have specific handling requirements
>>   - Remove [k8|f10]_read_dct_pci_cfg() as they don't do much different
>>     from amd64_read_pci_cfg()
>>     - Move the k8 specific check to amd64_read_pci_cfg
>>   - Remove f15_read_dct_pci_cfg() and move logic to amd64_read_dct_pci_cfg()
>>   - Remove now needless .read_dct_pci_cfg
>>
>> Testing:
>>   - Tested on Fam 10h; Fam15h Models: 00h, 30h; Fam16h using 'EDAC_DEBUG'
>>     and mce_amd_inj
>>   - driver obtains info from F2x registers and caches it in pvt
>>     structures correctly
>>   - ECC decoding works fine
>>
>> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
>> ---
>> Change in V4:
>>   - move amd64_read_dct_pci_cfg() to amd64_edac.c and save exporting
>>     f15h_select_dct() in the process
>>
>> Changes in V3:
>>   - per Boris suggestion
>>     - move dct selection logic to amd64_read_dct_pci_cfg()
>>     - remove f15_read_dct_pci_cfg() and move logic to amd64_read_dct_pci_cfg()
>>   - misc
>>     - modify logic in amd64_read_dct_pci_cfg() to keep in mind the specific
>>       read handling requirements of different families. Previous version had
>>       failed to do that.
>>
>> Changes in V2: (per Boris suggestion)
>>   - Hide family checks in amd64_read_dct_pci_cfg()
>>   - Use pvt structure for family checks and not boot_cpu_data
>>
>>   drivers/edac/amd64_edac.c | 138 +++++++++++++++++++++++-----------------------
>>   drivers/edac/amd64_edac.h |   5 --
>>   2 files changed, 68 insertions(+), 75 deletions(-)
>>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index f8bf000..b39d1b0 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -87,35 +87,6 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
>>   }
>>   
>>   /*
>> - *
>> - * Depending on the family, F2 DCT reads need special handling:
>> - *
>> - * K8: has a single DCT only
>> - *
>> - * F10h: each DCT has its own set of regs
>> - *	DCT0 -> F2x040..
>> - *	DCT1 -> F2x140..
>> - *
>> - * F15h: we select which DCT we access using F1x10C[DctCfgSel]
>> - *
>> - * F16h: has only 1 DCT
>> - */
>> -static int k8_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>> -			       const char *func)
>> -{
>> -	if (addr >= 0x100)
>> -		return -EINVAL;
>> -
>> -	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
>> -}
>> -
>> -static int f10_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>> -				 const char *func)
>> -{
>> -	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
>> -}
>> -
>> -/*
>>    * Select DCT to which PCI cfg accesses are routed
>>    */
>>   static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
>> @@ -123,25 +94,51 @@ static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
>>   	u32 reg = 0;
>>   
>>   	amd64_read_pci_cfg(pvt->F1, DCT_CFG_SEL, &reg);
>> -	reg &= (pvt->model >= 0x30) ? ~3 : ~1;
>> +	reg &= (pvt->model == 0x30) ? ~3 : ~1;
>>   	reg |= dct;
>>   	amd64_write_pci_cfg(pvt->F1, DCT_CFG_SEL, reg);
>>   }
>>   
>> -static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>> -				 const char *func)
>> +/*
>> + *
>> + * Depending on the family, F2 DCT reads need special handling:
>> + *
>> + * K8: has a single DCT only and no address offsets >= 0x100
>> + *
>> + * F10h: each DCT has its own set of regs
>> + *	DCT0 -> F2x040..
>> + *	DCT1 -> F2x140..
>> + *
>> + * F16h: has only 1 DCT
>> + */
>> +static inline int amd64_read_dct_pci_cfg(struct amd64_pvt *pvt, u8 dct,
>> +					 int offset, u32 *val)
>>   {
>> -	u8 dct  = 0;
>> +	if (pvt->fam == 0xf) {
>> +		if (dct || offset >= 0x100)
>> +			return -EINVAL;
>> +	} else if (pvt->fam == 0x10 && dct) {
>> +		/*
>> +		 * Note: If ganging is enabled, barring the regs
>> +		 * F2x[1,0]98 and F2x[1,0]9C; reads reads to F2x1xx
> Why aren't we dealing with those registers here then?

According to BKDG, these registers are used to control DRAM electrical 
parameters..
Afaict, we have never had to use these regs here..

> Btw, let's do this function with a switch-case, for better
> readability:
>
> static inline int amd64_read_dct_pci_cfg(struct amd64_pvt *pvt, u8 dct,
>                                           int offset, u32 *val)
> {
>          switch (pvt->fam) {
>          case 0xf:
>                  if (dct || offset >= 0x100)
>                          return -EINVAL;
>                  break;
>
>          case 0x10:
>                  if (dct) {
>                          /*
>                           * Note: If ganging is enabled, barring the regs
>                           * F2x[1,0]98 and F2x[1,0]9C; reads reads to F2x1xx
>                           * return 0. (cf. Section 2.8.1 F10h BKDG)
>                           */
>                          if (dct_ganging_enabled(pvt))
>                                  return 0;
>
>                          offset += 0x100;
>                  }
>                  break;
>
>          case 0x15:
>                  /*
>                   * F15h: F2x1xx addresses do not map explicitly to DCT1.
>                   * We should select which DCT we access using F1x10C[DctCfgSel]
>                   */
>                  dct = (dct && pvt->model == 0x30) ? 3 : dct;
>                  f15h_select_dct(pvt, dct);
>                  break;
>
>          case 0x16:
>                  if (dct)
>                          return -EINVAL;
>                  break;
>
>          default:
>                  break;
>          }
>          return amd64_read_pci_cfg(pvt->F2, offset, val);
> }

Ok, Shall use the above snippet in V5.

>
> ...
>
>>   
>>   	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
>>   
>> -	amd64_read_dct_pci_cfg(pvt, DCLR0, &pvt->dclr0);
>> -	amd64_read_dct_pci_cfg(pvt, DCHR0, &pvt->dchr0);
>> -
>> -	if (!dct_ganging_enabled(pvt)) {
>> -		amd64_read_dct_pci_cfg(pvt, DCLR1, &pvt->dclr1);
>> -		amd64_read_dct_pci_cfg(pvt, DCHR1, &pvt->dchr1);
>> -	}
>> +	amd64_read_dct_pci_cfg(pvt, 0, DCLR0, &pvt->dclr0);
>> +	amd64_read_dct_pci_cfg(pvt, 0, DCHR0, &pvt->dchr0);
>>   
>>   	pvt->ecc_sym_sz = 4;
>>   
>>   	if (pvt->fam >= 0x10) {
>> +		amd64_read_dct_pci_cfg(pvt, 1, DCLR0, &pvt->dclr1);
>> +		amd64_read_dct_pci_cfg(pvt, 1, DCHR0, &pvt->dchr1);
> This doesn't look equivalent - above we're checking whether we're ganged
> now you're doing it for >= F10h. Why?
>
> Because only F10h supports ganging?

That's right.
If ganging is enabled (which is a condition we check for in 
amd64_read_dct_pci_cfg();
Then we return 0.

This doesn't affect behavior..
The pieces which look at dclr1 (for f10h are):
a. in dump_misc_regs() which already has this check:
/* Only if NOT ganged does dclr1 have valid info */
if (!dct_ganging_enabled(pvt))
  debug_dump_dramcfg_low(pvt, pvt->dclr1, 1);

b. to pass a 'dct_width' value from f10_dbam_to_chip_select();
Which is still '0' in this case.

Thanks,
-Aravind.

>> +
>>   		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
>> +		/* F16h has only DCT0, so no need to read dbam1 */
>>   		if (pvt->fam != 0x16)
>> -			/* F16h has only DCT0 */
>> -			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
>> +			amd64_read_dct_pci_cfg(pvt, 1, DBAM0, &pvt->dbam1);
>>   
>>   		/* F10h, revD and later can do x8 ECC too */
>>   		if ((pvt->fam > 0x10 || pvt->model > 7) && tmp & BIT(25))
>>

