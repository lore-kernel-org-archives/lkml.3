Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbaLWT6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 14:58:00 -0500
Received: from mail-by2on0148.outbound.protection.outlook.com ([207.46.100.148]:50375
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754239AbaLWT56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 14:57:58 -0500
X-WSS-ID: 0NH1W1O-07-L5W-02
X-M-MSG: 
Message-ID: <5499C57B.5030900@amd.com>
Date: Tue, 23 Dec 2014 13:41:47 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <tony.luck@intel.com>, <dougthompson@xmission.com>,
        <mchehab@osg.samsung.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <dave.hansen@linux.intel.com>, <mgorman@suse.de>, <bp@suse.de>,
        <riel@redhat.com>, <jacob.w.shin@gmail.com>
Subject: Re: [PATCH 0/3] Fix MCE handling for AMD multi-node processors
References: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141222201542.GB1942@pd.tnic> <5498858F.1030209@amd.com>
 <20141222231929.GC1942@pd.tnic>
In-Reply-To: <20141222231929.GC1942@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(24454002)(164054003)(52314003)(377454003)(43544003)(189002)(479174004)(199003)(31966008)(76176999)(50986999)(87936001)(65956001)(99396003)(65806001)(64706001)(64126003)(50466002)(80316001)(84676001)(23676002)(83506001)(87266999)(20776003)(120886001)(65816999)(54356999)(77156002)(105586002)(47776003)(120916001)(36756003)(21056001)(110136001)(4396001)(97736003)(93886004)(59896002)(107046002)(106466001)(46102003)(2950100001)(33656002)(86362001)(62966003)(68736005)(77096005)(101416001)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB206;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 19:41:50.8450
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB206
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 5:19 PM, Borislav Petkov wrote:
> On Mon, Dec 22, 2014 at 02:56:47PM -0600, Aravind Gopalakrishnan wrote:
>> On 12/22/2014 2:15 PM, Borislav Petkov wrote:
>>> On Mon, Dec 22, 2014 at 02:10:09PM -0600, Aravind Gopalakrishnan wrote:
>>>> When a MCE happens that is to be logged onto bank 4 of AMD multi-node
>>>> processors, they are reported only to corresponding node base core of
>>>> the cpu on which the error occurred.
>>>>
>>>> Refer D18F3x44[NbMcaToMstCpuEn] on BKDGs of Fam10h and later for
>>> Let me try to understand this correctly:
>>>
>>> Does that mean that we could fix this by simply doing:
>>>
>>> D18F3x44[NbMcaToMstCpuEn]=0b
>>>
>>> on each NB?
>>>
>> Not quite..
>> When this field is 0, BKDG says the error may be reported to the core that
>> originated the request *if applicable and known*
>> Looking at the error signatures table for MC4 (Part 2),
>> we can see only some errors have 'ErrCoreId' column as valid
>>
>> Besides, if IO originated the request, then it is reported only to NBC.
>>
>> So, to take care of all these cases, I am just following one approach here:
>> and that is to look at NBC MSRs for any bank 4 errors.
>> (It seems to be what the BKDG recommends anyway as BIOS by default should
>> set D18F3x44[NbMcaToMstCpuEn])
> Then in that case you have to check the case where
> D18F3x44[NbMcaToMstCpuEn] is 0 for whatever reason (some BIOS forgot to
> set it or whatever) and to set it again.
Okay.

> Then, upon a quick scan, your patches are adding a lot of vendor-specific
> stuff which doesn't belong in the #MC handler, should probably be
> wrapped or so, no good idea right now.
>
> Then, you're using rd/wrmsr_on_cpu which does smp_call_function_single()
> which can deadlock in atomic context and #MC is one.
>
> Also, the math in amd_get_nbc_for_node() is too fragile and will break
> the moment some BIOS renumbers cores to accomodate some other OS.
>
> In any case, I won't be able to take a detailed look soon with the
> holidays coming up.
>
> Also, I'm wondering if this can't be solved much more elegantly
> by detecting that condition (bank == 4) in the #MC handler and
> issuing an IPI before exiting it using irq_work which will schedule
> do_machine_check on the NBC. And that should be even easier to do since
> we're moving the #MC handler out of the IST and to the normal kernel
> stack for 3.20, which would make this endeavor pretty cheap.

Ok. I'll look into this approach too over the holidays and we can 
restart the discussion
at a more convenient time.

> Anyway, just a couple of thoughts...
>

Thanks,
-Aravind.
