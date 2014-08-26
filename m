Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaHZRg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:36:27 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:26899
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752713AbaHZRgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:36:24 -0400
X-WSS-ID: 0NAXCVV-08-NWM-02
X-M-MSG: 
Message-ID: <53FCC57D.2030601@amd.com>
Date: Tue, 26 Aug 2014 12:35:57 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac, amd64_edac: Modify usage of amd64_read_dct_pci_cfg()
References: <1408659586-4736-1-git-send-email-aravind.gopalakrishnan@amd.com>
 <20140825054339.GA13911@nazgul.tnic>
In-Reply-To: <20140825054339.GA13911@nazgul.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(24454002)(199003)(377454003)(189002)(479174003)(107046002)(106466001)(77982001)(85852003)(97736001)(47776003)(95666004)(79102001)(85306004)(65816999)(76176999)(65956001)(21056001)(20776003)(4396001)(54356999)(83072002)(64706001)(87266999)(84676001)(105586002)(110136001)(87936001)(76482001)(99396002)(83322001)(92726001)(31966008)(68736004)(74502001)(86362001)(50466002)(92566001)(81342001)(101416001)(74662001)(59896002)(81542001)(33656002)(90102001)(50986999)(83506001)(80022001)(36756003)(23676002)(46102001)(102836001)(44976005);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB033;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/25/2014 12:43 AM, Borislav Petkov wrote:
> On Thu, Aug 21, 2014 at 05:19:46PM -0500, Aravind Gopalakrishnan wrote:
>> @@ -767,17 +750,25 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
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
>> +		if (pvt->fam == 0xf) {
>>   			continue;
>> -
>> -		if (!amd64_read_dct_pci_cfg(pvt, reg1, base1))
>> -			edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
>> -				 cs, *base1, reg1);
>> +		} else if (pvt->fam == 0x10 && !dct_ganging_enabled(pvt)) {
>> +			if (!amd64_read_pci_cfg(pvt->F2, reg1, base1))
>> +				edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
>> +					 cs, *base1, reg1);
>> +		} else {
>> +			dct = ((pvt->fam == 0x15)
>> +				&& (pvt->model == 0x30)) ? 3 : 1;
>> +			if (!amd64_read_dct_pci_cfg(pvt, dct, reg0, base1))
>> +				edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
>> +					 cs, *base1, reg0);
>> +		}
>>   	}
>>   
>>   	for_each_chip_select_mask(cs, 0, pvt) {
>> @@ -785,17 +776,25 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>>   		int reg1   = DCSM1 + (cs * 4);
>>   		u32 *mask0 = &pvt->csels[0].csmasks[cs];
>>   		u32 *mask1 = &pvt->csels[1].csmasks[cs];
>> +		u8 dct = 0;
>>   
>> -		if (!amd64_read_dct_pci_cfg(pvt, reg0, mask0))
>> +		if (!amd64_read_dct_pci_cfg(pvt, dct, reg0, mask0))
>>   			edac_dbg(0, "    DCSM0[%d]=0x%08x reg: F2x%x\n",
>>   				 cs, *mask0, reg0);
>>   
>> -		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
>> +		if (pvt->fam == 0xf) {
>>   			continue;
>> -
>> -		if (!amd64_read_dct_pci_cfg(pvt, reg1, mask1))
>> -			edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
>> -				 cs, *mask1, reg1);
>> +		} else if (pvt->fam == 0x10 && !dct_ganging_enabled(pvt)) {
>> +			if (!amd64_read_pci_cfg(pvt->F2, reg1, mask1))
>> +				edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
>> +					 cs, *mask1, reg1);
>> +		} else {
>> +			dct = ((pvt->fam == 0x15)
>> +				&& (pvt->model == 0x30)) ? 3 : 1;
>> +			if (!amd64_read_dct_pci_cfg(pvt, dct, reg0, mask1))
>> +				edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
>> +					 cs, *mask1, reg0);
>> +		}
> This is almost unreadable now with all the family checks everywhere.
> You need to hide all that per-family logic into the function and have a
> single
>
> amd_read_pci_cfg_dct(pvt, dct, ...)
>
> which contains all that logic. Calling code doesn't need to care about
> details like on which family it is running, etc, etc.
>

Ok, I have addressed this issue and the use of 'boot_cpu_data' that you 
mentioned on separate reply.
Sending it out as V2.

Thanks,
-Aravind.
