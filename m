Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaGKQTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:19:12 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:21990
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754479AbaGKQTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:19:11 -0400
X-WSS-ID: 0N8K2NJ-07-5IF-02
X-M-MSG: 
Message-ID: <53C00E6E.4040908@amd.com>
Date: Fri, 11 Jul 2014 18:18:54 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, Oded Gabbay <oded.gabbay@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: Re: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes
 in KV
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <20140711160516.GC1870@gmail.com>
In-Reply-To: <20140711160516.GC1870@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.224.155.21]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(51704005)(24454002)(101416001)(50986999)(21056001)(85852003)(74502001)(99396002)(92726001)(65806001)(19580395003)(74662001)(54356999)(87936001)(97736001)(85306003)(76176999)(83322001)(23756003)(83506001)(20776003)(79102001)(81542001)(44976005)(68736004)(19580405001)(92566001)(81342001)(80316001)(47776003)(105586002)(65816999)(80022001)(87266999)(107046002)(95666004)(33656002)(106466001)(46102001)(102836001)(77982001)(65956001)(4396001)(36756003)(86362001)(31966008)(64706001)(83072002)(64126003)(84676001)(575784001)(76482001)(50466002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB044;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02698DF457
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.07.2014 18:05, schrieb Jerome Glisse:
> On Fri, Jul 11, 2014 at 12:50:02AM +0300, Oded Gabbay wrote:
>> To support HSA on KV, we need to limit the number of vmids and pipes
>> that are available for radeon's use with KV.
>>
>> This patch reserves VMIDs 8-15 for KFD (so radeon can only use VMIDs
>> 0-7) and also makes radeon thinks that KV has only a single MEC with a single
>> pipe in it
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>

At least fro the VMIDs on demand allocation should be trivial to 
implement, so I would rather prefer this instead of a fixed assignment.

Christian.

>
>> ---
>>   drivers/gpu/drm/radeon/cik.c | 48 ++++++++++++++++++++++----------------------
>>   1 file changed, 24 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
>> index 4bfc2c0..e0c8052 100644
>> --- a/drivers/gpu/drm/radeon/cik.c
>> +++ b/drivers/gpu/drm/radeon/cik.c
>> @@ -4662,12 +4662,11 @@ static int cik_mec_init(struct radeon_device *rdev)
>>   	/*
>>   	 * KV:    2 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 64 Queues total
>>   	 * CI/KB: 1 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 32 Queues total
>> +	 * Nonetheless, we assign only 1 pipe because all other pipes will
>> +	 * be handled by KFD
>>   	 */
>> -	if (rdev->family == CHIP_KAVERI)
>> -		rdev->mec.num_mec = 2;
>> -	else
>> -		rdev->mec.num_mec = 1;
>> -	rdev->mec.num_pipe = 4;
>> +	rdev->mec.num_mec = 1;
>> +	rdev->mec.num_pipe = 1;
>>   	rdev->mec.num_queue = rdev->mec.num_mec * rdev->mec.num_pipe * 8;
>>   
>>   	if (rdev->mec.hpd_eop_obj == NULL) {
>> @@ -4809,28 +4808,24 @@ static int cik_cp_compute_resume(struct radeon_device *rdev)
>>   
>>   	/* init the pipes */
>>   	mutex_lock(&rdev->srbm_mutex);
>> -	for (i = 0; i < (rdev->mec.num_pipe * rdev->mec.num_mec); i++) {
>> -		int me = (i < 4) ? 1 : 2;
>> -		int pipe = (i < 4) ? i : (i - 4);
>>   
>> -		eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr + (i * MEC_HPD_SIZE * 2);
>> +	eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr;
>>   
>> -		cik_srbm_select(rdev, me, pipe, 0, 0);
>> +	cik_srbm_select(rdev, 0, 0, 0, 0);
>>   
>> -		/* write the EOP addr */
>> -		WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
>> -		WREG32(CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(eop_gpu_addr) >> 8);
>> +	/* write the EOP addr */
>> +	WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
>> +	WREG32(CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(eop_gpu_addr) >> 8);
>>   
>> -		/* set the VMID assigned */
>> -		WREG32(CP_HPD_EOP_VMID, 0);
>> +	/* set the VMID assigned */
>> +	WREG32(CP_HPD_EOP_VMID, 0);
>> +
>> +	/* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
>> +	tmp = RREG32(CP_HPD_EOP_CONTROL);
>> +	tmp &= ~EOP_SIZE_MASK;
>> +	tmp |= order_base_2(MEC_HPD_SIZE / 8);
>> +	WREG32(CP_HPD_EOP_CONTROL, tmp);
>>   
>> -		/* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
>> -		tmp = RREG32(CP_HPD_EOP_CONTROL);
>> -		tmp &= ~EOP_SIZE_MASK;
>> -		tmp |= order_base_2(MEC_HPD_SIZE / 8);
>> -		WREG32(CP_HPD_EOP_CONTROL, tmp);
>> -	}
>> -	cik_srbm_select(rdev, 0, 0, 0, 0);
>>   	mutex_unlock(&rdev->srbm_mutex);
>>   
>>   	/* init the queues.  Just two for now. */
>> @@ -5876,8 +5871,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib)
>>    */
>>   int cik_vm_init(struct radeon_device *rdev)
>>   {
>> -	/* number of VMs */
>> -	rdev->vm_manager.nvm = 16;
>> +	/*
>> +	 * number of VMs
>> +	 * VMID 0 is reserved for Graphics
>> +	 * radeon compute will use VMIDs 1-7
>> +	 * KFD will use VMIDs 8-15
>> +	 */
>> +	rdev->vm_manager.nvm = 8;
>>   	/* base offset of vram pages */
>>   	if (rdev->flags & RADEON_IS_IGP) {
>>   		u64 tmp = RREG32(MC_VM_FB_OFFSET);
>> -- 
>> 1.9.1
>>

