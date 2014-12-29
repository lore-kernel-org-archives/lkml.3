Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaL2NGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 08:06:13 -0500
Received: from mail-bn1bon0114.outbound.protection.outlook.com ([157.56.111.114]:45367
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435AbaL2NGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 08:06:11 -0500
X-WSS-ID: 0NHCGZQ-07-6T2-02
X-M-MSG: 
Message-ID: <54A14DEB.4090503@amd.com>
Date: Mon, 29 Dec 2014 14:49:47 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        <dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>
CC: <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        LKP ML <lkp@01.org>, <ak@linux.intel.com>, <rusty@rustcorp.com.au>,
        <airlied@linux.ie>
Subject: Re: [PATCH v2] drm/radeon: Init amdkfd only if it was compiled
References: <1419843586-29864-1-git-send-email-oded.gabbay@amd.com>
 <54A14C0C.8090401@vodafone.de>
In-Reply-To: <54A14C0C.8090401@vodafone.de>
Content-Type: text/plain; charset="iso-8859-15"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(479174004)(24454002)(199003)(377454003)(51704005)(2950100001)(76176999)(62966003)(77096005)(105586002)(106466001)(23756003)(36756003)(86362001)(19580405001)(19580395003)(59896002)(50466002)(64126003)(107046002)(97736003)(54356999)(77156002)(68736005)(99396003)(33656002)(47776003)(20776003)(64706001)(21056001)(65956001)(101416001)(87266999)(84676001)(120916001)(4396001)(31966008)(65806001)(50986999)(92566001)(46102003)(87936001)(65816999)(83506001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB204;
X-Forefront-PRVS: 0440AC9990
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 12:50:16.2312
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/29/2014 02:41 PM, Christian König wrote:
> Am 29.12.2014 um 09:59 schrieb Oded Gabbay:
>> This patch changes the radeon_kfd_init(), which is used to initialize the
>> interface between radeon and amdkfd, so the interface will be initialized only
>> if amdkfd was build, either as module or inside the kernel image.
>>
>> In the modules case, the symbol_request() will be used (same as old code). In
>> the in-image compilation case, a direct call to kgd2kfd_init() will be done.
>> For other cases, radeon_kfd_init() will just return false.
>>
>> This patch is necessary because in case of the following specific
>> configuration: kernel 32-bit, no modules support, random kernel base and no
>> hibernation, the symbol_request() doesn't work as expected - it doesn't return
>> NULL if the symbol doesn't exists - which makes the kernel panic.
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>
> Using symbol_request() in general doesn't seem to be such a good idea, because
> it breaks symbol versioning and as far as I can see is only very rarely used in
> drivers (AFAIK only V4L drivers).
>
> But for the moment I don't have another idea either except for always loading
> the module which on most hardware is completely unnecessary. Maybe we should
> consider restructuring the module load dependencies in the next kernel release.
>
> For now the patch is Reviewed-by: Christian König <christian.koenig@amd.com>
>
Thanks Christian.
I agree that this is somewhat a mess, that was created unfortunately at the very 
beginning of kfd.

We will definitely fix this in 2015, as we also need to think how kfd will 
integrate with both radeon and amdgpu if they are present on the same system. 
The current method we use doesn't enable that situation.

Ideally, I would like to see total separation (between init of radeon and init 
of amdkfd) and use of exported symbols instead of symbol_request. Couple that 
with probe deferral and I think the end result will be much better than the 
current design.

	Oded

>> ---
>>   drivers/gpu/drm/radeon/radeon_kfd.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c
>> b/drivers/gpu/drm/radeon/radeon_kfd.c
>> index 242fd8b..d3e78b4 100644
>> --- a/drivers/gpu/drm/radeon/radeon_kfd.c
>> +++ b/drivers/gpu/drm/radeon/radeon_kfd.c
>> @@ -101,6 +101,7 @@ static const struct kgd2kfd_calls *kgd2kfd;
>>   bool radeon_kfd_init(void)
>>   {
>> +#if defined(CONFIG_HSA_AMD_MODULE)
>>       bool (*kgd2kfd_init_p)(unsigned, const struct kfd2kgd_calls*,
>>                   const struct kgd2kfd_calls**);
>> @@ -117,6 +118,17 @@ bool radeon_kfd_init(void)
>>       }
>>       return true;
>> +#elif defined(CONFIG_HSA_AMD)
>> +    if (!kgd2kfd_init(KFD_INTERFACE_VERSION, &kfd2kgd, &kgd2kfd)) {
>> +        kgd2kfd = NULL;
>> +
>> +        return false;
>> +    }
>> +
>> +    return true;
>> +#else
>> +    return false;
>> +#endif
>>   }
>>   void radeon_kfd_fini(void)
>
