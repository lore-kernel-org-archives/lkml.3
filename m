Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaG0KWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 06:22:14 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:25543
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751629AbaG0KWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 06:22:12 -0400
X-WSS-ID: 0N9D8SR-08-TUA-02
X-M-MSG: 
Message-ID: <53D4D2BC.30004@amd.com>
Date: Sun, 27 Jul 2014 13:21:48 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: David Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?windows-1252?Q?Michel_D=E4n?= =?windows-1252?Q?zer?= 
	<michel.daenzer@amd.com>,
        <linux-kernel@vger.kernel.org>, Ben Goz <Ben.Goz@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>
Subject: Re: [PATCH v2 16/25] amdkfd: Add module parameter of scheduling policy
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-17-git-send-email-oded.gabbay@amd.com>
 <20140721024534.GM3068@gmail.com>
In-Reply-To: <20140721024534.GM3068@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(479174003)(24454002)(97736001)(20776003)(47776003)(106466001)(80022001)(65806001)(107046002)(21056001)(50986999)(81342001)(92726001)(92566001)(77982001)(84676001)(105586002)(110136001)(65956001)(4396001)(87936001)(99396002)(64706001)(101416001)(76176999)(76482001)(19580405001)(95666004)(15975445006)(68736004)(83322001)(79102001)(19580395003)(102836001)(33656002)(44976005)(23746002)(46102001)(74502001)(31966008)(74662001)(54356999)(83506001)(50466002)(36756003)(65816999)(85306003)(64126003)(81542001)(85852003)(86362001)(83072002)(15202345003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB033;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0285201563
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/14 05:45, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:29:23PM +0300, Oded Gabbay wrote:
>> From: Ben Goz <ben.goz@amd.com>
>>
>> This patch adds a new parameter to the amdkfd driver. This parameter enables the user to select the scheduling policy of the CP. The choices are:
>>
>> * CP Scheduling with support for over-subscription
>> * CP Scheduling without support for over-subscription
>> * Without CP Scheduling
>
> Is this property per process ?
No, this is the general scheduling mode for all of amdkfd.
The runlist that we feed to the GPU contains queues from all HSA processes. 
Furthermore, the number of hardware queues is a total number of the GPU. 
Therefore, there is no option to operate in different modes (and I see no point 
in that).

Also, I see I forgot to write in the commit msg that the third option (without 
CP Scheduling) is only for debug purposes and bringup of new H/W. As such, it is 
_not_ guaranteed to work at all times on all H/W versions.
Added this is v3.

> And again 80 chars line please.
Fixed in v3.
	Oded

>
>>
>> Signed-off-by: Ben Goz <ben.goz@amd.com>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>   drivers/gpu/drm/radeon/amdkfd/kfd_module.c | 4 ++++
>>   drivers/gpu/drm/radeon/amdkfd/kfd_priv.h   | 9 +++++++++
>>   2 files changed, 13 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>> index dc08f51..fe5e39d 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>> @@ -46,6 +46,10 @@ static const struct kgd2kfd_calls kgd2kfd = {
>>   	.resume		= kgd2kfd_resume,
>>   };
>>
>> +int sched_policy = KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION;
>> +module_param(sched_policy, int, S_IRUSR | S_IWUSR);
>> +MODULE_PARM_DESC(sched_policy, "Kernel cmdline parameter define the kfd scheduling policy");
>> +
>>   bool kgd2kfd_init(unsigned interface_version,
>>   		  const struct kfd2kgd_calls *f2g,
>>   		  const struct kgd2kfd_calls **g2f)
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> index 25f23c5..8be07a1 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> @@ -64,6 +64,15 @@
>>   /* Macro for allocating structures */
>>   #define kfd_alloc_struct(ptr_to_struct)	((typeof(ptr_to_struct)) kzalloc(sizeof(*ptr_to_struct), GFP_KERNEL))
>>
>> +/* Kernel module parameter to specify the scheduling policy */
>> +extern int sched_policy;
>> +
>> +enum kfd_sched_policy {
>> +	KFD_SCHED_POLICY_HWS = 0,
>> +	KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION,
>> +	KFD_SCHED_POLICY_NO_HWS
>> +};
>> +
>>   /*
>>    * Large enough to hold the maximum usable pasid + 1.
>>    * It must also be able to store the number of doorbells
>> --
>> 1.9.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel

