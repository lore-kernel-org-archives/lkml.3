Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaKFQ5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:57:51 -0500
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:44592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752610AbaKFQ5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:57:47 -0500
X-WSS-ID: 0NEMN46-08-N5C-02
X-M-MSG: 
Message-ID: <545BA884.5040406@amd.com>
Date: Thu, 6 Nov 2014 10:57:40 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Jan Kiszka" <jan.kiszka@siemens.com>, Len Brown <len.brown@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf, amd, ibs: Update IBS MSRs and feature definitions
References: <1415291182-4324-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141106163430.GB4737@pd.tnic>
In-Reply-To: <20141106163430.GB4737@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(164054003)(377454003)(189002)(51704005)(479174003)(24454002)(65956001)(44976005)(47776003)(20776003)(64706001)(46102003)(36756003)(86362001)(87936001)(65816999)(65806001)(19580395003)(21056001)(76176999)(101416001)(54356999)(92726001)(50986999)(87266999)(31966008)(80316001)(84676001)(33656002)(92566001)(59896002)(83506001)(97736003)(68736004)(110136001)(4396001)(106466001)(23676002)(99396003)(64126003)(50466002)(77156002)(102836001)(62966003)(107046002)(95666004)(120916001)(105586002)(120886001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0387D64A71
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2014 10:34 AM, Borislav Petkov wrote:
> On Thu, Nov 06, 2014 at 10:26:22AM -0600, Aravind Gopalakrishnan wrote:
>> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
>> index e21331c..ba7b609 100644
>> --- a/arch/x86/include/uapi/asm/msr-index.h
>> +++ b/arch/x86/include/uapi/asm/msr-index.h
>> @@ -206,6 +206,8 @@
>>   #define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
>>   #define MSR_AMD64_IBSCTL		0xc001103a
>>   #define MSR_AMD64_IBSBRTARGET		0xc001103b
>> +#define MSR_AMD64_IBS_FETCH_EXTD_CTL	0xc001103c
>> +#define MSR_AMD64_IBSOPDATA4		0xc001103d
>>   #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
>>   
>>   /* Fam 16h MSRs */
>> diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
>> index cbb1be3e..a61f5c6 100644
>> --- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
>> +++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
>> @@ -565,6 +565,21 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
>>   				       perf_ibs->offset_max,
>>   				       offset + 1);
>>   	} while (offset < offset_max);
>> +	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
>> +		/*
>> +		 * Read IbsBrTarget and IbsOpData4 separately
>> +		 * depending on their availability.
>> +		 * Can't add to offset_max as they are staggered
>> +		 */
>> +		if (ibs_caps & IBS_CAPS_BRNTRGT) {
>> +			rdmsrl(MSR_AMD64_IBSBRTARGET, *buf++);
> Are those MSRs present on everything that supports IBS and if not, you
> probably should do rdmsr_safe() here instead and handle the error case.
> Or do something with f/m/s checking or so...

But Why?
IBS_CAPS_BRNTRGT and IBS_CAPS_OPDATA4 indicate support for the 
respective MSRs and
I am only loading the MSR contents upon checking for their availability. 
So it's not like an exception is
generated for a rdmsr command on an unimplemented/reserved MSR.

And the nice thing about the feature identifiers is that I don't have to 
do f/m/s checks right?
I mean, if some other future processor decides to implement it, then we 
don't have to revisit the code
to make a change to the f/m/s condition.
And if they don't want to use those MSRs then it's still OK as the 
feature bits are not going to be set..


Thanks,
-Aravind.

>> +			size++;
>> +		}
>> +		if (ibs_caps & IBS_CAPS_OPDATA4) {
>> +			rdmsrl(MSR_AMD64_IBSOPDATA4, *buf++);
>> +			size++;
>> +		}
>> +	}
>>   	ibs_data.size = sizeof(u64) * size;
>>   
>>   	regs = *iregs;
>> -- 
>> 1.9.1
>>

