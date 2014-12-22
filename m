Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaLVU45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:56:57 -0500
Received: from mail-by2on0115.outbound.protection.outlook.com ([207.46.100.115]:58259
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754781AbaLVU4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:56:53 -0500
X-Greylist: delayed 4439 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 15:56:53 EST
X-WSS-ID: 0NH04UJ-08-2Y9-02
X-M-MSG: 
Message-ID: <5498858F.1030209@amd.com>
Date: Mon, 22 Dec 2014 14:56:47 -0600
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
 <20141222201542.GB1942@pd.tnic>
In-Reply-To: <20141222201542.GB1942@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(43544003)(164054003)(479174004)(377454003)(189002)(51704005)(199003)(46102003)(68736005)(92566001)(33656002)(83506001)(59896002)(80316001)(97736003)(106466001)(105586002)(36756003)(99396003)(77156002)(87266999)(110136001)(120916001)(2950100001)(76176999)(77096005)(64126003)(62966003)(87936001)(120886001)(84676001)(50986999)(99136001)(65816999)(31966008)(64706001)(107046002)(54356999)(4396001)(101416001)(47776003)(20776003)(86362001)(23676002)(65806001)(21056001)(65956001)(50466002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB199;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 20:56:49.3703
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB199
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 2:15 PM, Borislav Petkov wrote:
> On Mon, Dec 22, 2014 at 02:10:09PM -0600, Aravind Gopalakrishnan wrote:
>> When a MCE happens that is to be logged onto bank 4 of AMD multi-node
>> processors, they are reported only to corresponding node base core of
>> the cpu on which the error occurred.
>>
>> Refer D18F3x44[NbMcaToMstCpuEn] on BKDGs of Fam10h and later for
> Let me try to understand this correctly:
>
> Does that mean that we could fix this by simply doing:
>
> D18F3x44[NbMcaToMstCpuEn]=0b
>
> on each NB?
>

Not quite..
When this field is 0, BKDG says the error may be reported to the core 
that originated the request *if applicable and known*
Looking at the error signatures table for MC4 (Part 2),
we can see only some errors have 'ErrCoreId' column as valid

Besides, if IO originated the request, then it is reported only to NBC.

So, to take care of all these cases, I am just following one approach 
here: and that is to look at NBC MSRs for any bank 4 errors.
(It seems to be what the BKDG recommends anyway as BIOS by default 
should set D18F3x44[NbMcaToMstCpuEn])

Thanks,
-Aravind.
