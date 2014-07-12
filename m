Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaGLJAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 05:00:49 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:40624
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751912AbaGLJAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 05:00:46 -0400
X-WSS-ID: 0N8LD0K-08-B84-02
X-M-MSG: 
Message-ID: <53C0F921.2030909@amd.com>
Date: Sat, 12 Jul 2014 11:00:17 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: Jerome Glisse <j.glisse@gmail.com>, Oded Gabbay <oded.gabbay@gmail.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes
 in KV
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	<20140711160516.GC1870@gmail.com>	<53C00E6E.4040908@amd.com>
 <CADnq5_NkXJuaeMWv8HogykiH8ida17U90gO0Ec7DMRxMcLbrkA@mail.gmail.com>
In-Reply-To: <CADnq5_NkXJuaeMWv8HogykiH8ida17U90gO0Ec7DMRxMcLbrkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.37]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(377454003)(51704005)(199002)(189002)(33656002)(15975445006)(44976005)(59896001)(65956001)(99396002)(65816999)(110136001)(1411001)(54356999)(80022001)(77982001)(92726001)(83322001)(87936001)(50466002)(93886003)(107046002)(102836001)(92566001)(97736001)(23676002)(95666004)(80316001)(105586002)(81542001)(85852003)(19580405001)(74662001)(85306003)(68736004)(83072002)(85202003)(64706001)(46102001)(19580395003)(31966008)(106466001)(15202345003)(36756003)(20776003)(47776003)(85182001)(64126003)(76482001)(101416001)(50986999)(87266999)(575784001)(76176999)(79102001)(21056001)(86362001)(74502001)(81342001)(83506001)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB045;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0270ED2845
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.07.2014 18:22, schrieb Alex Deucher:
> On Fri, Jul 11, 2014 at 12:18 PM, Christian König
> <christian.koenig@amd.com> wrote:
>> Am 11.07.2014 18:05, schrieb Jerome Glisse:
>>
>>> On Fri, Jul 11, 2014 at 12:50:02AM +0300, Oded Gabbay wrote:
>>>> To support HSA on KV, we need to limit the number of vmids and pipes
>>>> that are available for radeon's use with KV.
>>>>
>>>> This patch reserves VMIDs 8-15 for KFD (so radeon can only use VMIDs
>>>> 0-7) and also makes radeon thinks that KV has only a single MEC with a
>>>> single
>>>> pipe in it
>>>>
>>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
>>
>> At least fro the VMIDs on demand allocation should be trivial to implement,
>> so I would rather prefer this instead of a fixed assignment.
> IIRC, the way the CP hw scheduler works you have to give it a range of
> vmids and it assigns them dynamically as queues are mapped so
> effectively they are potentially in use once the CP scheduler is set
> up.

That's not what I meant. Changing it completely on the fly is nice to 
have, but we should at least make it configurable as a module parameter.

And even if we hardcode it we should use a define for it somewhere 
instead of hardcoding 8 VMIDs on the KGD side and 8 VMIDs on KFD side 
without any relation to each other.

Christian.

> Alex
>
>
>> Christian.
>>
>>
>>>> ---
>>>>    drivers/gpu/drm/radeon/cik.c | 48
>>>> ++++++++++++++++++++++----------------------
>>>>    1 file changed, 24 insertions(+), 24 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
>>>> index 4bfc2c0..e0c8052 100644
>>>> --- a/drivers/gpu/drm/radeon/cik.c
>>>> +++ b/drivers/gpu/drm/radeon/cik.c
>>>> @@ -4662,12 +4662,11 @@ static int cik_mec_init(struct radeon_device
>>>> *rdev)
>>>>          /*
>>>>           * KV:    2 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 64 Queues total
>>>>           * CI/KB: 1 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 32 Queues total
>>>> +        * Nonetheless, we assign only 1 pipe because all other pipes
>>>> will
>>>> +        * be handled by KFD
>>>>           */
>>>> -       if (rdev->family == CHIP_KAVERI)
>>>> -               rdev->mec.num_mec = 2;
>>>> -       else
>>>> -               rdev->mec.num_mec = 1;
>>>> -       rdev->mec.num_pipe = 4;
>>>> +       rdev->mec.num_mec = 1;
>>>> +       rdev->mec.num_pipe = 1;
>>>>          rdev->mec.num_queue = rdev->mec.num_mec * rdev->mec.num_pipe * 8;
>>>>          if (rdev->mec.hpd_eop_obj == NULL) {
>>>> @@ -4809,28 +4808,24 @@ static int cik_cp_compute_resume(struct
>>>> radeon_device *rdev)
>>>>          /* init the pipes */
>>>>          mutex_lock(&rdev->srbm_mutex);
>>>> -       for (i = 0; i < (rdev->mec.num_pipe * rdev->mec.num_mec); i++) {
>>>> -               int me = (i < 4) ? 1 : 2;
>>>> -               int pipe = (i < 4) ? i : (i - 4);
>>>>    -             eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr + (i *
>>>> MEC_HPD_SIZE * 2);
>>>> +       eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr;
>>>>    -             cik_srbm_select(rdev, me, pipe, 0, 0);
>>>> +       cik_srbm_select(rdev, 0, 0, 0, 0);
>>>>    -             /* write the EOP addr */
>>>> -               WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
>>>> -               WREG32(CP_HPD_EOP_BASE_ADDR_HI,
>>>> upper_32_bits(eop_gpu_addr) >> 8);
>>>> +       /* write the EOP addr */
>>>> +       WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
>>>> +       WREG32(CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(eop_gpu_addr) >>
>>>> 8);
>>>>    -             /* set the VMID assigned */
>>>> -               WREG32(CP_HPD_EOP_VMID, 0);
>>>> +       /* set the VMID assigned */
>>>> +       WREG32(CP_HPD_EOP_VMID, 0);
>>>> +
>>>> +       /* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
>>>> +       tmp = RREG32(CP_HPD_EOP_CONTROL);
>>>> +       tmp &= ~EOP_SIZE_MASK;
>>>> +       tmp |= order_base_2(MEC_HPD_SIZE / 8);
>>>> +       WREG32(CP_HPD_EOP_CONTROL, tmp);
>>>>    -             /* set the EOP size, register value is 2^(EOP_SIZE+1)
>>>> dwords */
>>>> -               tmp = RREG32(CP_HPD_EOP_CONTROL);
>>>> -               tmp &= ~EOP_SIZE_MASK;
>>>> -               tmp |= order_base_2(MEC_HPD_SIZE / 8);
>>>> -               WREG32(CP_HPD_EOP_CONTROL, tmp);
>>>> -       }
>>>> -       cik_srbm_select(rdev, 0, 0, 0, 0);
>>>>          mutex_unlock(&rdev->srbm_mutex);
>>>>          /* init the queues.  Just two for now. */
>>>> @@ -5876,8 +5871,13 @@ int cik_ib_parse(struct radeon_device *rdev,
>>>> struct radeon_ib *ib)
>>>>     */
>>>>    int cik_vm_init(struct radeon_device *rdev)
>>>>    {
>>>> -       /* number of VMs */
>>>> -       rdev->vm_manager.nvm = 16;
>>>> +       /*
>>>> +        * number of VMs
>>>> +        * VMID 0 is reserved for Graphics
>>>> +        * radeon compute will use VMIDs 1-7
>>>> +        * KFD will use VMIDs 8-15
>>>> +        */
>>>> +       rdev->vm_manager.nvm = 8;
>>>>          /* base offset of vram pages */
>>>>          if (rdev->flags & RADEON_IS_IGP) {
>>>>                  u64 tmp = RREG32(MC_VM_FB_OFFSET);
>>>> --
>>>> 1.9.1
>>>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel

