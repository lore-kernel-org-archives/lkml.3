Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaLULfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:35:04 -0500
Received: from mail-bn1on0148.outbound.protection.outlook.com ([157.56.110.148]:62656
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751298AbaLULfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:35:00 -0500
X-WSS-ID: 0NGXK65-07-939-02
X-M-MSG: 
Message-ID: <5496B04C.50502@amd.com>
Date: Sun, 21 Dec 2014 13:34:36 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <Alexander.Deucher@amd.com>
Subject: Re: [PATCH 1/3] amdkfd: Don't clear *kfd2kgd on kfd_module_init
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
 <1419108374-7020-2-git-send-email-oded.gabbay@amd.com>
 <5496AEAD.3090003@vodafone.de>
In-Reply-To: <5496AEAD.3090003@vodafone.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174004)(24454002)(199003)(377454003)(189002)(51704005)(106466001)(2950100001)(54356999)(68736005)(65956001)(107046002)(65816999)(21056001)(50466002)(77096005)(50986999)(76176999)(33656002)(87936001)(105586002)(120916001)(19580395003)(101416001)(64126003)(84676001)(47776003)(20776003)(64706001)(46102003)(31966008)(4396001)(65806001)(19580405001)(99396003)(23676002)(77156002)(36756003)(92566001)(83506001)(62966003)(97736003)(86362001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0201MB0997;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0201MB0997;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0201MB0997;
X-Forefront-PRVS: 0432A04947
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0201MB0997;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2014 11:34:54.9731
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0201MB0997
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0201MB0949;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/21/2014 01:27 PM, Christian König wrote:
> Am 20.12.2014 um 21:46 schrieb Oded Gabbay:
>> When amdkfd and radeon are compiled inside the kernel image (not as modules),
>> radeon will load before amdkfd and will set *kfd2kgd to its interface
>> structure. Therefore, we must not set *kfd2kgd to NULL when amdkfd is loaded
>> because it will override radeon's initialization and cause kernel BUG.
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>
> You should probably rather fix the dependency between the two modules to get an
> determined load order instead of doing such nasty workarounds.
>
> Christian.

The problem is that when modules are compiled inside the kernel, there is NO 
determined load order and there is no mechanism to enforce that. If there is/was 
such a mechanism, I would of course prefer to use it.

Actually, I don't understand why the kernel doesn't enforce the order according 
to the use of exported symbols, like it does with modules.

There will always be dependencies between kgd (radeon) and amdkfd and between 
amdkfd and amd_iommu_v2. I don't think I can eliminate those dependencies, not 
without a very complex solution. And the fact that this complex solution occurs 
only in a very specific use case (all modules compiled in), makes me less 
inclined to do that.

So I don't see it as a "nasty workaround". I would call it just a "workaround" 
for a specific use case, which should be solved by a generic solution to the 
kernel enforcing load orders.

	Oded
>
>> ---
>>   drivers/gpu/drm/amd/amdkfd/kfd_module.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>> b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>> index 95d5af1..236562f 100644
>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>> @@ -34,7 +34,7 @@
>>   #define KFD_DRIVER_MINOR    7
>>   #define KFD_DRIVER_PATCHLEVEL    0
>> -const struct kfd2kgd_calls *kfd2kgd;
>> +const struct kfd2kgd_calls *kfd2kgd = NULL;
>>   static const struct kgd2kfd_calls kgd2kfd = {
>>       .exit        = kgd2kfd_exit,
>>       .probe        = kgd2kfd_probe,
>> @@ -84,14 +84,13 @@ EXPORT_SYMBOL(kgd2kfd_init);
>>   void kgd2kfd_exit(void)
>>   {
>> +    kfd2kgd = NULL;
>>   }
>>   static int __init kfd_module_init(void)
>>   {
>>       int err;
>> -    kfd2kgd = NULL;
>> -
>>       /* Verify module parameters */
>>       if ((sched_policy < KFD_SCHED_POLICY_HWS) ||
>>           (sched_policy > KFD_SCHED_POLICY_NO_HWS)) {
>
