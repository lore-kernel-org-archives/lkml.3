Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbbAFXyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:54:24 -0500
Received: from mail-bn1on0119.outbound.protection.outlook.com ([157.56.110.119]:31232
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751573AbbAFXyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:54:22 -0500
X-WSS-ID: 0NHS52C-08-27V-02
X-M-MSG: 
Message-ID: <54AC75A7.6050608@amd.com>
Date: Tue, 6 Jan 2015 17:54:15 -0600
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
 <20141222231929.GC1942@pd.tnic> <5499C57B.5030900@amd.com>
In-Reply-To: <5499C57B.5030900@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(51704005)(377454003)(164054003)(43544003)(24454002)(479174004)(189002)(59896002)(68736005)(23676002)(36756003)(77096005)(84676001)(93886004)(92566001)(83506001)(77156002)(62966003)(4396001)(64126003)(50466002)(65806001)(80316001)(31966008)(21056001)(2950100001)(20776003)(46102003)(47776003)(64706001)(87936001)(97736003)(33656002)(107046002)(87266999)(54356999)(76176999)(120886001)(120916001)(65816999)(50986999)(99396003)(106466001)(86362001)(110136001)(101416001)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB196;
X-Forefront-PRVS: 0448A97BF2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 23:54:18.2196
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 1:41 PM, Aravind Gopalakrishnan wrote:
> On 12/22/2014 5:19 PM, Borislav Petkov wrote:
>> On Mon, Dec 22, 2014 at 02:56:47PM -0600, Aravind Gopalakrishnan wrote:
>>> On 12/22/2014 2:15 PM, Borislav Petkov wrote:
>>>> On Mon, Dec 22, 2014 at 02:10:09PM -0600, Aravind Gopalakrishnan 
>>>> wrote:
>>>>> When a MCE happens that is to be logged onto bank 4 of AMD multi-node
>>>>> processors, they are reported only to corresponding node base core of
>>>>> the cpu on which the error occurred.
>>>>>
>>>>> Refer D18F3x44[NbMcaToMstCpuEn] on BKDGs of Fam10h and later for
>>>> Let me try to understand this correctly:
>>>>
>>>> Does that mean that we could fix this by simply doing:
>>>>
>>>> D18F3x44[NbMcaToMstCpuEn]=0b
>>>>
>>>> on each NB?
>>>>
>>> Not quite..
>>> When this field is 0, BKDG says the error may be reported to the 
>>> core that
>>> originated the request *if applicable and known*
>>> Looking at the error signatures table for MC4 (Part 2),
>>> we can see only some errors have 'ErrCoreId' column as valid
>>>
>>> Besides, if IO originated the request, then it is reported only to NBC.
>>>
>>> So, to take care of all these cases, I am just following one 
>>> approach here:
>>> and that is to look at NBC MSRs for any bank 4 errors.
>>> (It seems to be what the BKDG recommends anyway as BIOS by default 
>>> should
>>> set D18F3x44[NbMcaToMstCpuEn])
>> Then in that case you have to check the case where
>> D18F3x44[NbMcaToMstCpuEn] is 0 for whatever reason (some BIOS forgot to
>> set it or whatever) and to set it again.
>

Hi Boris,
It seems my earlier understanding of hardware behavior was not 
completely right.
Here are some clarifications I have received after some internal discussion-
When D18F3x44[NBMstToMstCpuEn] is set, the interrupt is also routed to 
the NBC.

This was not immediately clear to me from the description for the field 
in the BKDG.
The BKDG states that errors are reported to the NBC and also that 
status, addr, ctl
MSRs for MC4 are only accessible from the NBC.
I took this to understand that the error info is written to the NBC MSRs 
while
the #MC could be generated from the non-NBC.

Now, given that setting NBMstToMstCpuEn ensures #MC is generated only on 
NBC for MC4 errors,
we don't have a problem to solve in the #MC handler code.
So, we can discard patch2 of the series,

But we still need to change the error injection interfaces in mce_amd_inj:
mce_amd_inj triggers a #MC on the cpu number that the user specifies on 
debugfs.
For any error other than MC4 errors, this is fine.
But we should really be triggering #MC only on NBC for MC4 errors.
and also make sure we use NBC to write to the status/addr MSRs as only 
NBC has access to
these MSRs.

And for this, we will still need some the changes introduced in patch 1 
and patch 3 entirely.

And since calculating a corresponding NBC for a given core will be 
needed only in mce_amd_inj,
I can move those calculations to mce_amd_inj.
(Or if you prefer it be in a common location then I can leave it as it 
as too)


>>
>> Also, the math in amd_get_nbc_for_node() is too fragile and will break
>> the moment some BIOS renumbers cores to accomodate some other OS.
>>
>

Could you please clarify this?

For cores_per_node I am using c->x86_max_cores which is a value obtained 
from cpuid_ecx(0x80000008);
and NodesPerProcessor is obtained from cpuid_ecx(0x8000001e); (or 
MSR_FAM10H_NODE_ID)

These values should still be consistent for other OS too right?

Also, these are the values that we have currently in amd_get_topology(). 
I simply refactored the code..

Thanks,
-Aravind.


