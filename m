Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaIBPdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:33:25 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:6043
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753703AbaIBPdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:33:22 -0400
X-WSS-ID: 0NBA5VE-08-MEF-02
X-M-MSG: 
Message-ID: <5405E33B.9000905@amd.com>
Date: Tue, 2 Sep 2014 10:33:15 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] edac, amd64_edac: Modify usage of amd64_read_dct_pci_cfg()
References: <1409075049-3579-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140902070840.GE32105@nazgul.tnic>
In-Reply-To: <20140902070840.GE32105@nazgul.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(199003)(164054003)(479174003)(189002)(24454002)(377454003)(21056001)(105586002)(79102001)(47776003)(102836001)(81542001)(92566001)(107046002)(19580395003)(99396002)(80022001)(50986999)(81342001)(76176999)(87266999)(64706001)(76482001)(90102001)(65816999)(65956001)(77982001)(97736001)(19580405001)(54356999)(92726001)(95666004)(33656002)(50466002)(575784001)(86362001)(110136001)(83322001)(44976005)(46102001)(4396001)(68736004)(87936001)(84676001)(31966008)(36756003)(59896002)(74502001)(85306004)(106466001)(23676002)(85852003)(74662001)(80316001)(83506001)(101416001)(20776003)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB048;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0322B4EDE1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/2014 2:08 AM, Borislav Petkov wrote:
> On Tue, Aug 26, 2014 at 12:44:09PM -0500, Aravind Gopalakrishnan wrote:
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
>>   - Update usage of the function
>>   - Remove [k8|f10]_read_dct_pci_cfg() as they don't do much different
>>     from amd64_read_pci_cfg().
>>     - Move the k8 specific check to amd64_read_pci_cfg
>>   - Remove now needless .read_dct_pci_cfg
>>
>> Testing:
>>   - Tested on Fam 10h; Fam15h Models: 00h, 30h; Fam16h using 'EDAC_DEBUG'
>>     and mce_amd_inj
>>   - driver obtains info from F2x registers and caches it in pvt
>>     structures correctly
>>   - ECC decoding wotks fine
>>
>> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
>> ---
>> Changes in V2: (per Boris suggestion)
>>   - Hide family checks in amd64_read_dct_pci_cfg()
>>   - Use pvt structure for family checks and not boot_cpu_data
>>
>>   drivers/edac/amd64_edac.c | 134 ++++++++++++++++++++++------------------------
>>   drivers/edac/amd64_edac.h |  23 ++++++--
>>   2 files changed, 83 insertions(+), 74 deletions(-)
>>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index f8bf000..ba0b78e 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -60,6 +60,20 @@ static const struct scrubrate {
>>   	{ 0x00, 0UL},        /* scrubbing off */
>>   };
>>   
>>
>>   
>> @@ -767,17 +747,21 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>>   		int reg1   = DCSB1 + (cs * 4);
>>   		u32 *base0 = &pvt->csels[0].csbases[cs];
>>   		u32 *base1 = &pvt->csels[1].csbases[cs];
>> +		u8 dct = 0;
>>   
>> -		if (!amd64_read_dct_pci_cfg(pvt, reg0, base0))
>> +		if (!amd64_read_dct_pci_cfg(pvt, dct, reg0, base0))
>>   			edac_dbg(0, "  DCSB0[%d]=0x%08x reg: F2x%x\n",
>>   				 cs, *base0, reg0);
>>   
>> -		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
>> +		if (pvt->fam == 0xf)
>>   			continue;
>>   
>> -		if (!amd64_read_dct_pci_cfg(pvt, reg1, base1))
>> +		dct = ((pvt->fam == 0x15)
>> +			&& (pvt->model == 0x30)) ? 3 : 1;
> That selection can go into amd64_read_dct_pci_cfg() too, right?

I still need to pass '0' or '1' for the dct value. But sure, shall move 
the check to amd64_read_dct_pci_cfg()

>>   
>> -	if (!dct_ganging_enabled(pvt)) {
>> -		amd64_read_dct_pci_cfg(pvt, DCLR1, &pvt->dclr1);
>> -		amd64_read_dct_pci_cfg(pvt, DCHR1, &pvt->dchr1);
>> -	}
>> +	dct = ((pvt->fam == 0x15)
>> +		&& (pvt->model == 0x30)) ? 3 : 1;
>> +	amd64_read_dct_pci_cfg(pvt, dct, DCLR0, &pvt->dclr1);
>> +	amd64_read_dct_pci_cfg(pvt, dct, DCHR0, &pvt->dchr1);
>>   
>>   	pvt->ecc_sym_sz = 4;
>>   
>>   	if (pvt->fam >= 0x10) {
>>   		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
>> -		if (pvt->fam != 0x16)
>> -			/* F16h has only DCT0 */
>> -			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
>> +		if (pvt->fam == 0x10)
>> +			amd64_read_pci_cfg(pvt->F2, DBAM1, &pvt->dbam1);
>> +		/* F16h has only DCT0, so no need to read dbam1 */
>> +		else if (pvt->fam == 0x15) {
> This logic can be moved into amd64_read_dct_pci_cfg() too?

Fam10h needs some careful handling since I see that in some places I do 
amd64_read_dct_pci_cfg()
dct_ganging need to be disabled and in some places need not be. (This is 
why I had the condition above)
I think I can work around this..
Let me give it a shot and send you a V3.

> I think you can get rid of the f15_read_dct_pci_cfg() completely and
> move the logic into amd64_read_dct_pci_cfg()
>

Ok.

Thanks,
-Aravind.
