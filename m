Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaEHPVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:21:13 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:20049
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751501AbaEHPVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:21:11 -0400
X-WSS-ID: 0N59HB6-08-0BF-02
X-M-MSG: 
Message-ID: <536BA0E3.4050709@amd.com>
Date: Thu, 8 May 2014 10:21:07 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "Daniel J Blueman" <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH V3 1/3] x86/PCI: Fix PCI root numa_node info on AMD family15h
References: <1399489127-6961-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1399489127-6961-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20140508085905.GK32718@rric.localhost>
 <20140508090148.GL32718@rric.localhost> <536B973B.2000207@amd.com>
 <20140508151402.GN32718@rric.localhost>
In-Reply-To: <20140508151402.GN32718@rric.localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(479174003)(377454003)(189002)(199002)(51704005)(24454002)(79102001)(80022001)(65806001)(47776003)(20776003)(64706001)(65956001)(74662001)(74502001)(31966008)(83506001)(84676001)(36756003)(21056001)(33656001)(50466002)(81542001)(44976005)(68736004)(19580405001)(19580395003)(83322001)(76482001)(83072002)(64126003)(65816999)(85852003)(59896001)(77982001)(92726001)(23756003)(99396002)(46102001)(92566001)(86362001)(101416001)(54356999)(4396001)(76176999)(81342001)(50986999)(87266999)(77096999)(2009001)(97736001)(87936001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB115;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/2014 10:14 AM, Robert Richter wrote:
> On 08.05.14 09:39:55, Suravee Suthikulanit wrote:
>> On 5/8/2014 4:01 AM, Robert Richter wrote:
>>> On 08.05.14 10:59:05, Robert Richter wrote:
>>>> On 07.05.14 13:58:45, suravee.suthikulpanit@amd.com wrote:
>>>>> @@ -113,10 +122,17 @@ static int __init early_fill_mp_bus_info(void)
>>>>>   		info = alloc_pci_root_info(min_bus, max_bus, node, link);
>>>>>   	}
>>>>>
>>>>> +	/*
>>>>> +	 * The following code is only supported until Fam11h.
>>>>> +	 * Newer processors will depend on ACPI MCFG table instead.
>>>>> +	 */
>>>>> +	if (boot_cpu_data.x86 > 0x11)
>>>>> +		return 0;
>>>>> +
>>>>>   	/* get the default node and link for left over res */
>>>>
>>>> As this is the only substantial change of your patch, I would better
>>>> drop ther rest or at least split it in two patches. Should this change
>>>> also be for stable?
>>>
>>> Of course adding the hostbridge must be also part of the patch, didn't
>>> note this due to the other noise. See why the split would be good?
>>>
>>>>
>>>> -Robert
>>
>>
>> Robert,
>>
>> I have already added the hostbridge for family15h in this patch.
>>
>> +static struct amd_hostbridge hb_probes[] __initdata = {
>> +	{ 0, 0x18, 0x1100 }, /* K8 */
>> +	{ 0, 0x18, 0x1200 }, /* Family10h */
>> +	{ 0xff, 0, 0x1200 }, /* Family10h */
>> +	{ 0, 0x18, 0x1300 }, /* Family11h */
>> +	{ 0, 0x18, 0x1600 }, /* Family15h */ <--- HERE
>
> Yes, I noticed that, but later, thus my 2nd mail.
>
>>   };
>>
>> The rest of the changes are mostly comments, some minor renaming of
>> variables for clarity, and replace hardcode values with preprocessor macro.
>> If needed, I can split them.
>
> I just would drop it, you just need the fam15h device and the cpu mode
> check.
>
> -Robert
>
The reason I put it all these comments here is because it took us a 
while to discuss what to do with this file going forward. There were 
some confusions.  Therefore, I just want to document it here.

Also, the check for (boot_cpu_data.x86 > 0x11) was needed because it 
should not be done for family15h.

Suravee
