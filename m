Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbbATVu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:50:57 -0500
Received: from mail-bn1bon0117.outbound.protection.outlook.com ([157.56.111.117]:58592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751816AbbATVuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:50:55 -0500
X-WSS-ID: 0NIHWOO-07-C22-02
X-M-MSG: 
Message-ID: <54BECDB0.9060709@amd.com>
Date: Tue, 20 Jan 2015 15:50:40 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <riel@redhat.com>, <mgorman@suse.de>,
        <jolsa@kernel.org>, <pbonzini@redhat.com>, <jacob.w.shin@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, cpu, amd: Use 8-bit extractor for NodeId field
References: <1421691538-7152-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20150119182142.GF4486@pd.tnic>
In-Reply-To: <20150119182142.GF4486@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(199003)(24454002)(189002)(479174004)(377454003)(51704005)(19580395003)(87266999)(36756003)(50986999)(65816999)(120886001)(2950100001)(77156002)(68736005)(62966003)(80316001)(77096005)(46102003)(105586002)(65956001)(23676002)(65806001)(110136001)(106466001)(64706001)(54356999)(575784001)(50466002)(47776003)(19580405001)(76176999)(101416001)(59896002)(33656002)(92566002)(83506001)(86362001)(87936001)(64126003)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB194;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR02MB194;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB194;
X-Forefront-PRVS: 0462918D61
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB194;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2015 21:50:50.8563
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/2015 12:21 PM, Borislav Petkov wrote:
> On Mon, Jan 19, 2015 at 12:18:58PM -0600, Aravind Gopalakrishnan wrote:
>> The NodeId field in cpuid_ecx(0x8000001e) is a 8 bit field.
>> Although current extractor works fine, it will break if/when
>> the most significant 5 bits ever get used.
>>
>> So, lets honor the field as architected in the BKDG
>>
>> Reference: BKDG for AMD Fam15h Models 00h-0fh,
>> CPUID Fn8000_001E_ECX Node Identifiers
>>
>> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>> ---
>>   arch/x86/kernel/cpu/amd.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index a220239..9942b83 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -300,7 +300,7 @@ static void amd_get_topology(struct cpuinfo_x86 *c)
>>   
>>   		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
>>   		nodes = ((ecx >> 8) & 7) + 1;
>> -		node_id = ecx & 7;
>> +		node_id = ecx & 0xff;
> That's {00000b,D18F0x60[NodeId]} and NodeId is 3 bits for enumerating
> 8 nodes so checking the 3 bits is actually correct as it says that the
> other 5 are 0b.

Right. Just a concern that if the definition of those 5 bits changes 
then it would be a problem.

> Regardless, is this something hypothetical you've noticed from code
> inspection or are we really going to have more than 8 nodes? If the
> former, then patch is unnecessary churn.
>

Just something from code inspection. So not an immediate issue.

Thanks,
-Aravind.
