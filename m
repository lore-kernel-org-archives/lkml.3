Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbbAHAfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:35:30 -0500
Received: from mail-bn1bbn0108.outbound.protection.outlook.com ([157.56.111.108]:52704
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752396AbbAHAf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:35:26 -0500
X-WSS-ID: 0NHU0VM-08-4GS-02
X-M-MSG: 
Message-ID: <54ADCCF2.9060402@amd.com>
Date: Wed, 7 Jan 2015 18:18:58 -0600
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
 <54AC75A7.6050608@amd.com> <20150107170654.GG3984@pd.tnic>
In-Reply-To: <20150107170654.GG3984@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.180.168.240]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(164054003)(479174004)(24454002)(377454003)(51704005)(189002)(199003)(50466002)(84676001)(31966008)(83506001)(80316001)(23676002)(54356999)(87266999)(50986999)(76176999)(120886001)(65816999)(120916001)(21056001)(99396003)(4396001)(46102003)(47776003)(68736005)(77096005)(64706001)(2950100001)(77156002)(62966003)(20776003)(64126003)(93886004)(87936001)(575784001)(86362001)(59896002)(36756003)(92566001)(110136001)(33656002)(107046002)(105586002)(101416001)(97736003)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB201;
X-Forefront-PRVS: 0450A714CB
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2015 00:19:00.9465
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB201
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/2015 11:06 AM, Borislav Petkov wrote:
> On Tue, Jan 06, 2015 at 05:54:15PM -0600, Aravind Gopalakrishnan wrote:
>> But we still need to change the error injection interfaces in mce_amd_inj:
>> mce_amd_inj triggers a #MC on the cpu number that the user specifies on
>> debugfs.
>> For any error other than MC4 errors, this is fine.
>> But we should really be triggering #MC only on NBC for MC4 errors.
> Why?
>
> As you said yourself, the errors get reported on the NBC. Where they get
> *triggered* is a different story.

Apologies if I was not clear earlier. Let me try to address the issue again-
I shall be verbose for sake of clarity here..

The bank 4 MSRs are per-node and per-node MSR are shared between cores 
in a node.
So, technically, all cores of the same node have access to the MSR.
But, since D18F3x44[NBMstToMstCpuEn] is set, access is restricted to 
only the NBC.
And, BKDG states that-
reads of these MSRs from other cores return 0’s and writes are ignored.

Now, with mce_amd_inj interface as it is right now, we basically 
wrmsr_on_cpu()
to the MCx_[status|addr|misc] registers using the cpu value user 
specifies at /sys/kernel/debug/mce-inject/cpu.

For a bank4 error (assume a UC case here) to a non-NBC (say core 6 of 
first node in a multi-node platform),
mce_amd_inj will simply wrmsr_on_cpu(6,...).
Since writes are ignored, we basically don't populate any info on the 
MSRs and when you trigger_mce on cpu 6,
do_machine_check will try to read status MSR for cpu6 which causes RAZ 
and you basically would not see any output on dmesg.
(This is why I had originally thought we had dropped MCEs)

If the same error were to be introduced on a NBC (core 0 in the above 
example),
(i.e), user were to provide cpu number 0 on 
/sys/kernel/debug/mce-inject/cpu; then we would see output on dmesg.
This is because writes from cpu 0 to the MSR will go through.

This is the correction I have made in patch 3 where, for bank = 4, I 
find the NBC for the given cpu and write the MSRs using the nbc value.
(I still need to modify the patch to also trigger #MC on the NBC)

Also, just to clarify any terminology issues:
'reporting' of errors means: active notification of errors to software 
via machine check exceptions.
(as defined by BKDG in the section "Error Detection, Action, Logging, 
and Reporting".
It's section 2.13.1.3 on a F15h M0h-0fh BKDG rev 3.14 for me.
section number might vary for you depending on the document version you 
are referring to..)


> We do injection as it is described in "2.15.2 Error Injection and
> Simulation" in F15h BKDG, for example. Reporting of the thusly injected
> bank4 error goes to the NBC.
>
>

Just want to clarify some (potential) terminology issues here too:
"Error injection" is causing a DRAM error by writing to D18F3xB8 and 
D18F3xBC.
If a DRAM error were to be introduced by using above method, then HW 
should correctly 'report' the error to NBC.

"Error simulation" is basically what we are doing in mce_amd_inj.
But before we drive a #MC, we should honor the rules specified in the 
BKDG wrt writing of MSRs IMHO. (specifically for the bank=4 case)

Thanks,
-Aravind.
