Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaGQL6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:58:13 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:34336
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932075AbaGQL6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:58:10 -0400
X-WSS-ID: 0N8UUKE-08-1IC-02
X-M-MSG: 
Message-ID: <53C7BA34.9000703@amd.com>
Date: Thu, 17 Jul 2014 14:57:40 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, Oded Gabbay <oded.gabbay@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 11/83] hsa/radeon: Add scheduler code
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	 <1405029027-6085-10-git-send-email-oded.gabbay@amd.com>
 <20140711182521.GL1870@gmail.com>
In-Reply-To: <20140711182521.GL1870@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(189002)(199002)(51704005)(479174003)(81542001)(92726001)(74502001)(95666004)(107046002)(106466001)(20776003)(47776003)(79102001)(59896001)(64706001)(77982001)(23756003)(81342001)(85306003)(21056001)(92566001)(65806001)(31966008)(74662001)(65956001)(80022001)(105586002)(85852003)(83506001)(50466002)(83072002)(68736004)(575784001)(86362001)(50986999)(87266999)(87936001)(54356999)(76176999)(44976005)(99396002)(83322001)(33656002)(65816999)(84676001)(19580405001)(19580395003)(97736001)(36756003)(64126003)(76482001)(101416001)(46102001)(4396001)(102836001)(579004);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/14 21:25, Jerome Glisse wrote:
> On Fri, Jul 11, 2014 at 12:50:11AM +0300, Oded Gabbay wrote:
>> This patch adds the code base of the scheduler, which handles queue
>> creation, deletion and scheduling on the CP of the GPU.
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>
> I would rather see all this squashed, this gave feeling that driver
> can access register which is latter remove. I know jungling with
> patch squashing can be daunting but really it makes reviewing hard
> here because i have to jump back and forth to see if thing i am looking
> at really matter in the final version.
>
> Cheers,
> Jérôme
Squashed and restructured in v2 of the patchset.
	Oded
>
>> ---
>>   drivers/gpu/hsa/radeon/Makefile               |   3 +-
>>   drivers/gpu/hsa/radeon/cik_regs.h             | 213 +++++++
>>   drivers/gpu/hsa/radeon/kfd_device.c           |   1 +
>>   drivers/gpu/hsa/radeon/kfd_registers.c        |  50 ++
>>   drivers/gpu/hsa/radeon/kfd_sched_cik_static.c | 800 ++++++++++++++++++++++++++
>>   drivers/gpu/hsa/radeon/kfd_vidmem.c           |  61 ++
>>   6 files changed, 1127 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/gpu/hsa/radeon/cik_regs.h
>>   create mode 100644 drivers/gpu/hsa/radeon/kfd_registers.c
>>   create mode 100644 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
>>   create mode 100644 drivers/gpu/hsa/radeon/kfd_vidmem.c
>>
>> diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
>> index 989518a..28da10c 100644
>> --- a/drivers/gpu/hsa/radeon/Makefile
>> +++ b/drivers/gpu/hsa/radeon/Makefile
>> @@ -4,6 +4,7 @@
>>
>>   radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
>>   		kfd_pasid.o kfd_topology.o kfd_process.o \
>> -		kfd_doorbell.o
>> +		kfd_doorbell.o kfd_sched_cik_static.o kfd_registers.o \
>> +		kfd_vidmem.o
>>
>>   obj-$(CONFIG_HSA_RADEON)	+= radeon_kfd.o
>> diff --git a/drivers/gpu/hsa/radeon/cik_regs.h b/drivers/gpu/hsa/radeon/cik_regs.h
>> new file mode 100644
>> index 0000000..d0cdc57
>> --- /dev/null
>> +++ b/drivers/gpu/hsa/radeon/cik_regs.h
>> @@ -0,0 +1,213 @@
>> +/*
>> + * Copyright 2014 Advanced Micro Devices, Inc.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> + * copy of this software and associated documentation files (the "Software"),
>> + * to deal in the Software without restriction, including without limitation
>> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
>> + * and/or sell copies of the Software, and to permit persons to whom the
>> + * Software is furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#ifndef CIK_REGS_H
>> +#define CIK_REGS_H
>> +
>> +#define BIF_DOORBELL_CNTL				0x530Cu
>> +
>> +#define	SRBM_GFX_CNTL					0xE44
>> +#define	PIPEID(x)					((x) << 0)
>> +#define	MEID(x)						((x) << 2)
>> +#define	VMID(x)						((x) << 4)
>> +#define	QUEUEID(x)					((x) << 8)
>> +
>> +#define	SQ_CONFIG					0x8C00
>> +
>> +#define	SH_MEM_BASES					0x8C28
>> +/* if PTR32, these are the bases for scratch and lds */
>> +#define	PRIVATE_BASE(x)					((x) << 0) /* scratch */
>> +#define	SHARED_BASE(x)					((x) << 16) /* LDS */
>> +#define	SH_MEM_APE1_BASE				0x8C2C
>> +/* if PTR32, this is the base location of GPUVM */
>> +#define	SH_MEM_APE1_LIMIT				0x8C30
>> +/* if PTR32, this is the upper limit of GPUVM */
>> +#define	SH_MEM_CONFIG					0x8C34
>> +#define	PTR32						(1 << 0)
>> +#define	ALIGNMENT_MODE(x)				((x) << 2)
>> +#define	SH_MEM_ALIGNMENT_MODE_DWORD			0
>> +#define	SH_MEM_ALIGNMENT_MODE_DWORD_STRICT		1
>> +#define	SH_MEM_ALIGNMENT_MODE_STRICT			2
>> +#define	SH_MEM_ALIGNMENT_MODE_UNALIGNED			3
>> +#define	DEFAULT_MTYPE(x)				((x) << 4)
>> +#define	APE1_MTYPE(x)					((x) << 7)
>> +
>> +/* valid for both DEFAULT_MTYPE and APE1_MTYPE */
>> +#define	MTYPE_NONCACHED					3
>> +
>> +
>> +#define SH_STATIC_MEM_CONFIG				0x9604u
>> +
>> +#define	TC_CFG_L1_LOAD_POLICY0				0xAC68
>> +#define	TC_CFG_L1_LOAD_POLICY1				0xAC6C
>> +#define	TC_CFG_L1_STORE_POLICY				0xAC70
>> +#define	TC_CFG_L2_LOAD_POLICY0				0xAC74
>> +#define	TC_CFG_L2_LOAD_POLICY1				0xAC78
>> +#define	TC_CFG_L2_STORE_POLICY0				0xAC7C
>> +#define	TC_CFG_L2_STORE_POLICY1				0xAC80
>> +#define	TC_CFG_L2_ATOMIC_POLICY				0xAC84
>> +#define	TC_CFG_L1_VOLATILE				0xAC88
>> +#define	TC_CFG_L2_VOLATILE				0xAC8C
>> +
>> +#define CP_PQ_WPTR_POLL_CNTL				0xC20C
>> +#define	WPTR_POLL_EN					(1 << 31)
>> +
>> +#define CP_ME1_PIPE0_INT_CNTL				0xC214
>> +#define CP_ME1_PIPE1_INT_CNTL				0xC218
>> +#define CP_ME1_PIPE2_INT_CNTL				0xC21C
>> +#define CP_ME1_PIPE3_INT_CNTL				0xC220
>> +#define CP_ME2_PIPE0_INT_CNTL				0xC224
>> +#define CP_ME2_PIPE1_INT_CNTL				0xC228
>> +#define CP_ME2_PIPE2_INT_CNTL				0xC22C
>> +#define CP_ME2_PIPE3_INT_CNTL				0xC230
>> +#define DEQUEUE_REQUEST_INT_ENABLE			(1 << 13)
>> +#define WRM_POLL_TIMEOUT_INT_ENABLE			(1 << 17)
>> +#define PRIV_REG_INT_ENABLE				(1 << 23)
>> +#define TIME_STAMP_INT_ENABLE				(1 << 26)
>> +#define GENERIC2_INT_ENABLE				(1 << 29)
>> +#define GENERIC1_INT_ENABLE				(1 << 30)
>> +#define GENERIC0_INT_ENABLE				(1 << 31)
>> +#define CP_ME1_PIPE0_INT_STATUS				0xC214
>> +#define CP_ME1_PIPE1_INT_STATUS				0xC218
>> +#define CP_ME1_PIPE2_INT_STATUS				0xC21C
>> +#define CP_ME1_PIPE3_INT_STATUS				0xC220
>> +#define CP_ME2_PIPE0_INT_STATUS				0xC224
>> +#define CP_ME2_PIPE1_INT_STATUS				0xC228
>> +#define CP_ME2_PIPE2_INT_STATUS				0xC22C
>> +#define CP_ME2_PIPE3_INT_STATUS				0xC230
>> +#define DEQUEUE_REQUEST_INT_STATUS			(1 << 13)
>> +#define WRM_POLL_TIMEOUT_INT_STATUS			(1 << 17)
>> +#define PRIV_REG_INT_STATUS				(1 << 23)
>> +#define TIME_STAMP_INT_STATUS				(1 << 26)
>> +#define GENERIC2_INT_STATUS				(1 << 29)
>> +#define GENERIC1_INT_STATUS				(1 << 30)
>> +#define GENERIC0_INT_STATUS				(1 << 31)
>> +
>> +#define CP_HPD_EOP_BASE_ADDR				0xC904
>> +#define CP_HPD_EOP_BASE_ADDR_HI				0xC908
>> +#define CP_HPD_EOP_VMID					0xC90C
>> +#define CP_HPD_EOP_CONTROL				0xC910
>> +#define	EOP_SIZE(x)					((x) << 0)
>> +#define	EOP_SIZE_MASK					(0x3f << 0)
>> +#define CP_MQD_BASE_ADDR				0xC914
>> +#define CP_MQD_BASE_ADDR_HI				0xC918
>> +#define CP_HQD_ACTIVE					0xC91C
>> +#define CP_HQD_VMID					0xC920
>> +
>> +#define CP_HQD_PERSISTENT_STATE				0xC924u
>> +#define	DEFAULT_CP_HQD_PERSISTENT_STATE			(0x33U << 8)
>> +
>> +#define CP_HQD_PIPE_PRIORITY				0xC928u
>> +#define CP_HQD_QUEUE_PRIORITY				0xC92Cu
>> +#define CP_HQD_QUANTUM					0xC930u
>> +#define	QUANTUM_EN					1U
>> +#define	QUANTUM_SCALE_1MS				(1U << 4)
>> +#define	QUANTUM_DURATION(x)				((x) << 8)
>> +
>> +#define CP_HQD_PQ_BASE					0xC934
>> +#define CP_HQD_PQ_BASE_HI				0xC938
>> +#define CP_HQD_PQ_RPTR					0xC93C
>> +#define CP_HQD_PQ_RPTR_REPORT_ADDR			0xC940
>> +#define CP_HQD_PQ_RPTR_REPORT_ADDR_HI			0xC944
>> +#define CP_HQD_PQ_WPTR_POLL_ADDR			0xC948
>> +#define CP_HQD_PQ_WPTR_POLL_ADDR_HI			0xC94C
>> +#define CP_HQD_PQ_DOORBELL_CONTROL			0xC950
>> +#define	DOORBELL_OFFSET(x)				((x) << 2)
>> +#define	DOORBELL_OFFSET_MASK				(0x1fffff << 2)
>> +#define	DOORBELL_SOURCE					(1 << 28)
>> +#define	DOORBELL_SCHD_HIT				(1 << 29)
>> +#define	DOORBELL_EN					(1 << 30)
>> +#define	DOORBELL_HIT					(1 << 31)
>> +#define CP_HQD_PQ_WPTR					0xC954
>> +#define CP_HQD_PQ_CONTROL				0xC958
>> +#define	QUEUE_SIZE(x)					((x) << 0)
>> +#define	QUEUE_SIZE_MASK					(0x3f << 0)
>> +#define	RPTR_BLOCK_SIZE(x)				((x) << 8)
>> +#define	RPTR_BLOCK_SIZE_MASK				(0x3f << 8)
>> +#define	MIN_AVAIL_SIZE(x)				((x) << 20)
>> +#define	PQ_ATC_EN					(1 << 23)
>> +#define	PQ_VOLATILE					(1 << 26)
>> +#define	NO_UPDATE_RPTR					(1 << 27)
>> +#define	UNORD_DISPATCH					(1 << 28)
>> +#define	ROQ_PQ_IB_FLIP					(1 << 29)
>> +#define	PRIV_STATE					(1 << 30)
>> +#define	KMD_QUEUE					(1 << 31)
>> +
>> +#define	DEFAULT_RPTR_BLOCK_SIZE				RPTR_BLOCK_SIZE(5)
>> +#define	DEFAULT_MIN_AVAIL_SIZE				MIN_AVAIL_SIZE(3)
>> +
>> +#define CP_HQD_IB_BASE_ADDR				0xC95Cu
>> +#define CP_HQD_IB_BASE_ADDR_HI				0xC960u
>> +#define CP_HQD_IB_RPTR					0xC964u
>> +#define CP_HQD_IB_CONTROL				0xC968u
>> +#define	IB_ATC_EN					(1U << 23)
>> +#define	DEFAULT_MIN_IB_AVAIL_SIZE			(3U << 20)
>> +
>> +#define CP_HQD_DEQUEUE_REQUEST				0xC974
>> +#define	DEQUEUE_REQUEST_DRAIN				1
>> +
>> +#define CP_HQD_SEMA_CMD					0xC97Cu
>> +#define CP_HQD_MSG_TYPE					0xC980u
>> +#define CP_HQD_ATOMIC0_PREOP_LO				0xC984u
>> +#define CP_HQD_ATOMIC0_PREOP_HI				0xC988u
>> +#define CP_HQD_ATOMIC1_PREOP_LO				0xC98Cu
>> +#define CP_HQD_ATOMIC1_PREOP_HI				0xC990u
>> +#define CP_HQD_HQ_SCHEDULER0				0xC994u
>> +#define CP_HQD_HQ_SCHEDULER1				0xC998u
>> +
>> +
>> +#define CP_MQD_CONTROL					0xC99C
>> +#define	MQD_VMID(x)					((x) << 0)
>> +#define	MQD_VMID_MASK					(0xf << 0)
>> +#define	MQD_CONTROL_PRIV_STATE_EN			(1U << 8)
>> +
>> +#define GRBM_GFX_INDEX					0x30800
>> +#define	INSTANCE_INDEX(x)				((x) << 0)
>> +#define	SH_INDEX(x)					((x) << 8)
>> +#define	SE_INDEX(x)					((x) << 16)
>> +#define	SH_BROADCAST_WRITES				(1 << 29)
>> +#define	INSTANCE_BROADCAST_WRITES			(1 << 30)
>> +#define	SE_BROADCAST_WRITES				(1 << 31)
>> +
>> +#define SQC_CACHES					0x30d20
>> +#define SQC_POLICY					0x8C38u
>> +#define SQC_VOLATILE					0x8C3Cu
>> +
>> +#define CP_PERFMON_CNTL					0x36020
>> +
>> +#define ATC_VMID0_PASID_MAPPING				0x339Cu
>> +#define	ATC_VMID_PASID_MAPPING_UPDATE_STATUS		0x3398u
>> +#define	ATC_VMID_PASID_MAPPING_VALID			(1U << 31)
>> +
>> +#define ATC_VM_APERTURE0_CNTL				0x3310u
>> +#define	ATS_ACCESS_MODE_NEVER				0
>> +#define	ATS_ACCESS_MODE_ALWAYS				1
>> +
>> +#define ATC_VM_APERTURE0_CNTL2				0x3318u
>> +#define ATC_VM_APERTURE0_HIGH_ADDR			0x3308u
>> +#define ATC_VM_APERTURE0_LOW_ADDR			0x3300u
>> +#define ATC_VM_APERTURE1_CNTL				0x3314u
>> +#define ATC_VM_APERTURE1_CNTL2				0x331Cu
>> +#define ATC_VM_APERTURE1_HIGH_ADDR			0x330Cu
>> +#define ATC_VM_APERTURE1_LOW_ADDR			0x3304u
>> +
>> +#endif
>> diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
>> index 4e9fe6c..465c822 100644
>> --- a/drivers/gpu/hsa/radeon/kfd_device.c
>> +++ b/drivers/gpu/hsa/radeon/kfd_device.c
>> @@ -28,6 +28,7 @@
>>   #include "kfd_scheduler.h"
>>
>>   static const struct kfd_device_info bonaire_device_info = {
>> +	.scheduler_class = &radeon_kfd_cik_static_scheduler_class,
>>   	.max_pasid_bits = 16,
>>   };
>>
>> diff --git a/drivers/gpu/hsa/radeon/kfd_registers.c b/drivers/gpu/hsa/radeon/kfd_registers.c
>> new file mode 100644
>> index 0000000..223debd
>> --- /dev/null
>> +++ b/drivers/gpu/hsa/radeon/kfd_registers.c
>> @@ -0,0 +1,50 @@
>> +/*
>> + * Copyright 2014 Advanced Micro Devices, Inc.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> + * copy of this software and associated documentation files (the "Software"),
>> + * to deal in the Software without restriction, including without limitation
>> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
>> + * and/or sell copies of the Software, and to permit persons to whom the
>> + * Software is furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#include <linux/io.h>
>> +#include "kfd_priv.h"
>> +
>> +/* In KFD, "reg" is the byte offset of the register. */
>> +static void __iomem *reg_address(struct kfd_dev *dev, uint32_t reg)
>> +{
>> +	return dev->regs + reg;
>> +}
>> +
>> +void radeon_kfd_write_reg(struct kfd_dev *dev, uint32_t reg, uint32_t value)
>> +{
>> +	writel(value, reg_address(dev, reg));
>> +}
>> +
>> +uint32_t radeon_kfd_read_reg(struct kfd_dev *dev, uint32_t reg)
>> +{
>> +	return readl(reg_address(dev, reg));
>> +}
>> +
>> +void radeon_kfd_lock_srbm_index(struct kfd_dev *dev)
>> +{
>> +	kfd2kgd->lock_srbm_gfx_cntl(dev->kgd);
>> +}
>> +
>> +void radeon_kfd_unlock_srbm_index(struct kfd_dev *dev)
>> +{
>> +	kfd2kgd->unlock_srbm_gfx_cntl(dev->kgd);
>> +}
>> diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
>> new file mode 100644
>> index 0000000..b986ff9
>> --- /dev/null
>> +++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
>> @@ -0,0 +1,800 @@
>> +/*
>> + * Copyright 2014 Advanced Micro Devices, Inc.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> + * copy of this software and associated documentation files (the "Software"),
>> + * to deal in the Software without restriction, including without limitation
>> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
>> + * and/or sell copies of the Software, and to permit persons to whom the
>> + * Software is furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#include <linux/log2.h>
>> +#include <linux/mutex.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/uaccess.h>
>> +#include "kfd_priv.h"
>> +#include "kfd_scheduler.h"
>> +#include "cik_regs.h"
>> +
>> +/* CIK CP hardware is arranged with 8 queues per pipe and 8 pipes per MEC (microengine for compute).
>> + * The first MEC is ME 1 with the GFX ME as ME 0.
>> + * We split the CP with the KGD, they take the first N pipes and we take the rest.
>> + */
>> +#define CIK_QUEUES_PER_PIPE 8
>> +#define CIK_PIPES_PER_MEC 4
>> +
>> +#define CIK_MAX_PIPES (2 * CIK_PIPES_PER_MEC)
>> +
>> +#define CIK_NUM_VMID 16
>> +
>> +#define CIK_HPD_SIZE_LOG2 11
>> +#define CIK_HPD_SIZE (1U << CIK_HPD_SIZE_LOG2)
>> +#define CIK_HPD_ALIGNMENT 256
>> +#define CIK_MQD_ALIGNMENT 4
>> +
>> +#pragma pack(push, 4)
>> +
>> +struct cik_hqd_registers {
>> +	u32 cp_mqd_base_addr;
>> +	u32 cp_mqd_base_addr_hi;
>> +	u32 cp_hqd_active;
>> +	u32 cp_hqd_vmid;
>> +	u32 cp_hqd_persistent_state;
>> +	u32 cp_hqd_pipe_priority;
>> +	u32 cp_hqd_queue_priority;
>> +	u32 cp_hqd_quantum;
>> +	u32 cp_hqd_pq_base;
>> +	u32 cp_hqd_pq_base_hi;
>> +	u32 cp_hqd_pq_rptr;
>> +	u32 cp_hqd_pq_rptr_report_addr;
>> +	u32 cp_hqd_pq_rptr_report_addr_hi;
>> +	u32 cp_hqd_pq_wptr_poll_addr;
>> +	u32 cp_hqd_pq_wptr_poll_addr_hi;
>> +	u32 cp_hqd_pq_doorbell_control;
>> +	u32 cp_hqd_pq_wptr;
>> +	u32 cp_hqd_pq_control;
>> +	u32 cp_hqd_ib_base_addr;
>> +	u32 cp_hqd_ib_base_addr_hi;
>> +	u32 cp_hqd_ib_rptr;
>> +	u32 cp_hqd_ib_control;
>> +	u32 cp_hqd_iq_timer;
>> +	u32 cp_hqd_iq_rptr;
>> +	u32 cp_hqd_dequeue_request;
>> +	u32 cp_hqd_dma_offload;
>> +	u32 cp_hqd_sema_cmd;
>> +	u32 cp_hqd_msg_type;
>> +	u32 cp_hqd_atomic0_preop_lo;
>> +	u32 cp_hqd_atomic0_preop_hi;
>> +	u32 cp_hqd_atomic1_preop_lo;
>> +	u32 cp_hqd_atomic1_preop_hi;
>> +	u32 cp_hqd_hq_scheduler0;
>> +	u32 cp_hqd_hq_scheduler1;
>> +	u32 cp_mqd_control;
>> +};
>> +
>> +struct cik_mqd {
>> +	u32 header;
>> +	u32 dispatch_initiator;
>> +	u32 dimensions[3];
>> +	u32 start_idx[3];
>> +	u32 num_threads[3];
>> +	u32 pipeline_stat_enable;
>> +	u32 perf_counter_enable;
>> +	u32 pgm[2];
>> +	u32 tba[2];
>> +	u32 tma[2];
>> +	u32 pgm_rsrc[2];
>> +	u32 vmid;
>> +	u32 resource_limits;
>> +	u32 static_thread_mgmt01[2];
>> +	u32 tmp_ring_size;
>> +	u32 static_thread_mgmt23[2];
>> +	u32 restart[3];
>> +	u32 thread_trace_enable;
>> +	u32 reserved1;
>> +	u32 user_data[16];
>> +	u32 vgtcs_invoke_count[2];
>> +	struct cik_hqd_registers queue_state;
>> +	u32 dequeue_cntr;
>> +	u32 interrupt_queue[64];
>> +};
>> +
>> +struct cik_mqd_padded {
>> +	struct cik_mqd mqd;
>> +	u8 padding[1024 - sizeof(struct cik_mqd)]; /* Pad MQD out to 1KB. (HW requires 4-byte alignment.) */
>> +};
>> +
>> +#pragma pack(pop)
>> +
>> +struct cik_static_private {
>> +	struct kfd_dev *dev;
>> +
>> +	struct mutex mutex;
>> +
>> +	unsigned int first_pipe;
>> +	unsigned int num_pipes;
>> +
>> +	unsigned long free_vmid_mask; /* unsigned long to make set/clear_bit happy */
>> +
>> +	/* Everything below here is offset by first_pipe. E.g. bit 0 in
>> +	 * free_queues is queue 0 in pipe first_pipe
>> +	 */
>> +
>> +	 /* Queue q on pipe p is at bit QUEUES_PER_PIPE * p + q. */
>> +	unsigned long free_queues[DIV_ROUND_UP(CIK_MAX_PIPES * CIK_QUEUES_PER_PIPE, BITS_PER_LONG)];
>> +
>> +	kfd_mem_obj hpd_mem;	/* Single allocation for HPDs for all KFD pipes. */
>> +	kfd_mem_obj mqd_mem;	/* Single allocation for all MQDs for all KFD
>> +				 * pipes. This is actually struct cik_mqd_padded. */
>> +	uint64_t hpd_addr;	/* GPU address for hpd_mem. */
>> +	uint64_t mqd_addr;	/* GPU address for mqd_mem. */
>> +	 /*
>> +	  * Pointer for mqd_mem.
>> +	  * We keep this mapped because multiple processes may need to access it
>> +	  * in parallel and this is simpler than controlling concurrent kmaps
>> +	  */
>> +	struct cik_mqd_padded *mqds;
>> +};
>> +
>> +struct cik_static_process {
>> +	unsigned int vmid;
>> +	pasid_t pasid;
>> +};
>> +
>> +struct cik_static_queue {
>> +	unsigned int queue; /* + first_pipe * QUEUES_PER_PIPE */
>> +
>> +	uint64_t mqd_addr;
>> +	struct cik_mqd *mqd;
>> +
>> +	void __user *pq_addr;
>> +	void __user *rptr_address;
>> +	doorbell_t __user *wptr_address;
>> +	uint32_t doorbell_index;
>> +
>> +	uint32_t queue_size_encoded; /* CP_HQD_PQ_CONTROL.QUEUE_SIZE takes the queue size as log2(size) - 3. */
>> +};
>> +
>> +static uint32_t lower_32(uint64_t x)
>> +{
>> +	return (uint32_t)x;
>> +}
>> +
>> +static uint32_t upper_32(uint64_t x)
>> +{
>> +	return (uint32_t)(x >> 32);
>> +}
>> +
>> +/* SRBM_GFX_CNTL provides the MEC/pipe/queue and vmid for many registers that are
>> + * In particular, CP_HQD_* and CP_MQD_* are instanced for each queue. CP_HPD_* are instanced for each pipe.
>> + * SH_MEM_* are instanced per-VMID.
>> + *
>> + * We provide queue_select, pipe_select and vmid_select helpers that should be used before accessing
>> + * registers from those groups. Note that these overwrite each other, e.g. after vmid_select the current
>> + * selected MEC/pipe/queue is undefined.
>> + *
>> + * SRBM_GFX_CNTL and the registers it indexes are shared with KGD. You must be holding the srbm_gfx_cntl
>> + * lock via lock_srbm_index before setting SRBM_GFX_CNTL or accessing any of the instanced registers.
>> + */
>> +static uint32_t make_srbm_gfx_cntl_mpqv(unsigned int me, unsigned int pipe, unsigned int queue, unsigned int vmid)
>> +{
>> +	return QUEUEID(queue) | VMID(vmid) | MEID(me) | PIPEID(pipe);
>> +}
>> +
>> +static void pipe_select(struct cik_static_private *priv, unsigned int pipe)
>> +{
>> +	unsigned int pipe_in_mec = (pipe + priv->first_pipe) % CIK_PIPES_PER_MEC;
>> +	unsigned int mec = (pipe + priv->first_pipe) / CIK_PIPES_PER_MEC;
>> +
>> +	WRITE_REG(priv->dev, SRBM_GFX_CNTL, make_srbm_gfx_cntl_mpqv(mec+1, pipe_in_mec, 0, 0));
>> +}
>> +
>> +static void queue_select(struct cik_static_private *priv, unsigned int queue)
>> +{
>> +	unsigned int queue_in_pipe = queue % CIK_QUEUES_PER_PIPE;
>> +	unsigned int pipe = queue / CIK_QUEUES_PER_PIPE + priv->first_pipe;
>> +	unsigned int pipe_in_mec = pipe % CIK_PIPES_PER_MEC;
>> +	unsigned int mec = pipe / CIK_PIPES_PER_MEC;
>> +
>> +#if 0
>> +	dev_err(radeon_kfd_chardev(), "queue select %d = %u/%u/%u = 0x%08x\n", queue, mec+1, pipe_in_mec, queue_in_pipe,
>> +		make_srbm_gfx_cntl_mpqv(mec+1, pipe_in_mec, queue_in_pipe, 0));
>> +#endif
>> +
>> +	WRITE_REG(priv->dev, SRBM_GFX_CNTL, make_srbm_gfx_cntl_mpqv(mec+1, pipe_in_mec, queue_in_pipe, 0));
>> +}
>> +
>> +static void vmid_select(struct cik_static_private *priv, unsigned int vmid)
>> +{
>> +	WRITE_REG(priv->dev, SRBM_GFX_CNTL, make_srbm_gfx_cntl_mpqv(0, 0, 0, vmid));
>> +}
>> +
>> +static void lock_srbm_index(struct cik_static_private *priv)
>> +{
>> +	radeon_kfd_lock_srbm_index(priv->dev);
>> +}
>> +
>> +static void unlock_srbm_index(struct cik_static_private *priv)
>> +{
>> +	WRITE_REG(priv->dev, SRBM_GFX_CNTL, 0);	/* Be nice to KGD, reset indexed CP registers to the GFX pipe. */
>> +	radeon_kfd_unlock_srbm_index(priv->dev);
>> +}
>> +
>> +/* One-time setup for all compute pipes. They need to be programmed with the address & size of the HPD EOP buffer. */
>> +static void init_pipes(struct cik_static_private *priv)
>> +{
>> +	unsigned int i;
>> +
>> +	lock_srbm_index(priv);
>> +
>> +	for (i = 0; i < priv->num_pipes; i++) {
>> +		uint64_t pipe_hpd_addr = priv->hpd_addr + i * CIK_HPD_SIZE;
>> +
>> +		pipe_select(priv, i);
>> +
>> +		WRITE_REG(priv->dev, CP_HPD_EOP_BASE_ADDR, lower_32(pipe_hpd_addr >> 8));
>> +		WRITE_REG(priv->dev, CP_HPD_EOP_BASE_ADDR_HI, upper_32(pipe_hpd_addr >> 8));
>> +		WRITE_REG(priv->dev, CP_HPD_EOP_VMID, 0);
>> +		WRITE_REG(priv->dev, CP_HPD_EOP_CONTROL, CIK_HPD_SIZE_LOG2 - 1);
>> +	}
>> +
>> +	unlock_srbm_index(priv);
>> +}
>> +
>> +/* Program the VMID -> PASID mapping for one VMID.
>> + * PASID 0 is special: it means to associate no PASID with that VMID.
>> + * This function waits for the VMID/PASID mapping to complete.
>> + */
>> +static void set_vmid_pasid_mapping(struct cik_static_private *priv, unsigned int vmid, pasid_t pasid)
>> +{
>> +	/* We have to assume that there is no outstanding mapping.
>> +	 * The ATC_VMID_PASID_MAPPING_UPDATE_STATUS bit could be 0 because a mapping
>> +	 * is in progress or because a mapping finished and the SW cleared it.
>> +	 * So the protocol is to always wait & clear.
>> +	 */
>> +
>> +	uint32_t pasid_mapping = (pasid == 0) ? 0 : (uint32_t)pasid | ATC_VMID_PASID_MAPPING_VALID;
>> +
>> +	WRITE_REG(priv->dev, ATC_VMID0_PASID_MAPPING + vmid*sizeof(uint32_t), pasid_mapping);
>> +
>> +	while (!(READ_REG(priv->dev, ATC_VMID_PASID_MAPPING_UPDATE_STATUS) & (1U << vmid)))
>> +		cpu_relax();
>> +	WRITE_REG(priv->dev, ATC_VMID_PASID_MAPPING_UPDATE_STATUS, 1U << vmid);
>> +}
>> +
>> +static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble)
>> +{
>> +	/* In 64-bit mode, we can only control the top 3 bits of the LDS, scratch and GPUVM apertures.
>> +	 * The hardware fills in the remaining 59 bits according to the following pattern:
>> +	 * LDS:		X0000000'00000000 - X0000001'00000000 (4GB)
>> +	 * Scratch:	X0000001'00000000 - X0000002'00000000 (4GB)
>> +	 * GPUVM:	Y0010000'00000000 - Y0020000'00000000 (1TB)
>> +	 *
>> +	 * (where X/Y is the configurable nybble with the low-bit 0)
>> +	 *
>> +	 * LDS and scratch will have the same top nybble programmed in the top 3 bits of SH_MEM_BASES.PRIVATE_BASE.
>> +	 * GPUVM can have a different top nybble programmed in the top 3 bits of SH_MEM_BASES.SHARED_BASE.
>> +	 * We don't bother to support different top nybbles for LDS/Scratch and GPUVM.
>> +	 */
>> +
>> +	BUG_ON((top_address_nybble & 1) || top_address_nybble > 0xE);
>> +
>> +	return PRIVATE_BASE(top_address_nybble << 12) | SHARED_BASE(top_address_nybble << 12);
>> +}
>> +
>> +/* Initial programming for all ATS registers.
>> + * - enable ATS for all compute VMIDs
>> + * - clear the VMID/PASID mapping for all compute VMIDS
>> + * - program the shader core flat address settings:
>> + * -- 64-bit mode
>> + * -- unaligned access allowed
>> + * -- noncached (this is the only CPU-coherent mode in CIK)
>> + * -- APE 1 disabled
>> + */
>> +static void init_ats(struct cik_static_private *priv)
>> +{
>> +	unsigned int i;
>> +
>> +	/* Enable self-ringing doorbell recognition and direct the BIF to send
>> +	 * untranslated writes to the IOMMU before comparing to the aperture.*/
>> +	WRITE_REG(priv->dev, BIF_DOORBELL_CNTL, 0);
>> +
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE0_CNTL, ATS_ACCESS_MODE_ALWAYS);
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE0_CNTL2, priv->free_vmid_mask);
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE0_LOW_ADDR, 0);
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE0_HIGH_ADDR, 0);
>> +
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE1_CNTL, 0);
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE1_CNTL2, 0);
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE1_LOW_ADDR, 0);
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE1_HIGH_ADDR, 0);
>> +
>> +	lock_srbm_index(priv);
>> +
>> +	for (i = 0; i < CIK_NUM_VMID; i++) {
>> +		if (priv->free_vmid_mask & (1U << i)) {
>> +			uint32_t sh_mem_config;
>> +
>> +			set_vmid_pasid_mapping(priv, i, 0);
>> +
>> +			vmid_select(priv, i);
>> +
>> +			sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED);
>> +			sh_mem_config |= DEFAULT_MTYPE(MTYPE_NONCACHED);
>> +
>> +			WRITE_REG(priv->dev, SH_MEM_CONFIG, sh_mem_config);
>> +
>> +			/* Configure apertures:
>> +			 * LDS:		0x60000000'00000000 - 0x60000001'00000000 (4GB)
>> +			 * Scratch:	0x60000001'00000000 - 0x60000002'00000000 (4GB)
>> +			 * GPUVM:	0x60010000'00000000 - 0x60020000'00000000 (1TB)
>> +			 */
>> +			WRITE_REG(priv->dev, SH_MEM_BASES, compute_sh_mem_bases_64bit(6));
>> +
>> +			/* Scratch aperture is not supported for now. */
>> +			WRITE_REG(priv->dev, SH_STATIC_MEM_CONFIG, 0);
>> +
>> +			/* APE1 disabled for now. */
>> +			WRITE_REG(priv->dev, SH_MEM_APE1_BASE, 1);
>> +			WRITE_REG(priv->dev, SH_MEM_APE1_LIMIT, 0);
>> +		}
>> +	}
>> +
>> +	unlock_srbm_index(priv);
>> +}
>> +
>> +static void exit_ats(struct cik_static_private *priv)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < CIK_NUM_VMID; i++)
>> +		if (priv->free_vmid_mask & (1U << i))
>> +			set_vmid_pasid_mapping(priv, i, 0);
>> +
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE0_CNTL, ATS_ACCESS_MODE_NEVER);
>> +	WRITE_REG(priv->dev, ATC_VM_APERTURE0_CNTL2, 0);
>> +}
>> +
>> +static struct cik_static_private *kfd_scheduler_to_private(struct kfd_scheduler *scheduler)
>> +{
>> +	return (struct cik_static_private *)scheduler;
>> +}
>> +
>> +static struct cik_static_process *kfd_process_to_private(struct kfd_scheduler_process *process)
>> +{
>> +	return (struct cik_static_process *)process;
>> +}
>> +
>> +static struct cik_static_queue *kfd_queue_to_private(struct kfd_scheduler_queue *queue)
>> +{
>> +	return (struct cik_static_queue *)queue;
>> +}
>> +
>> +static int cik_static_create(struct kfd_dev *dev, struct kfd_scheduler **scheduler)
>> +{
>> +	struct cik_static_private *priv;
>> +	unsigned int i;
>> +	int err;
>> +	void *hpdptr;
>> +
>> +	priv = kmalloc(sizeof(*priv), GFP_KERNEL);
>> +	if (priv == NULL)
>> +		return -ENOMEM;
>> +
>> +	mutex_init(&priv->mutex);
>> +
>> +	priv->dev = dev;
>> +
>> +	priv->first_pipe = dev->shared_resources.first_compute_pipe;
>> +	priv->num_pipes = dev->shared_resources.compute_pipe_count;
>> +
>> +	for (i = 0; i < priv->num_pipes * CIK_QUEUES_PER_PIPE; i++)
>> +		__set_bit(i, priv->free_queues);
>> +
>> +	priv->free_vmid_mask = dev->shared_resources.compute_vmid_bitmap;
>> +
>> +	/*
>> +	 * Allocate memory for the HPDs. This is hardware-owned per-pipe data.
>> +	 * The driver never accesses this memory after zeroing it. It doesn't even have
>> +	 * to be saved/restored on suspend/resume because it contains no data when there
>> +	 * are no active queues.
>> +	 */
>> +	err = radeon_kfd_vidmem_alloc(dev,
>> +				      CIK_HPD_SIZE * priv->num_pipes * 2,
>> +				      PAGE_SIZE,
>> +				      KFD_MEMPOOL_SYSTEM_WRITECOMBINE,
>> +				      &priv->hpd_mem);
>> +	if (err)
>> +		goto err_hpd_alloc;
>> +
>> +	err = radeon_kfd_vidmem_kmap(dev, priv->hpd_mem, &hpdptr);
>> +	if (err)
>> +		goto err_hpd_kmap;
>> +	memset(hpdptr, 0, CIK_HPD_SIZE * priv->num_pipes);
>> +	radeon_kfd_vidmem_unkmap(dev, priv->hpd_mem);
>> +
>> +	/*
>> +	 * Allocate memory for all the MQDs.
>> +	 * These are per-queue data that is hardware owned but with driver init.
>> +	 * The driver has to copy this data into HQD registers when a
>> +	 * pipe is (re)activated.
>> +	 */
>> +	err = radeon_kfd_vidmem_alloc(dev,
>> +				      sizeof(struct cik_mqd_padded) * priv->num_pipes * CIK_QUEUES_PER_PIPE,
>> +				      PAGE_SIZE,
>> +				      KFD_MEMPOOL_SYSTEM_CACHEABLE,
>> +				      &priv->mqd_mem);
>> +	if (err)
>> +		goto err_mqd_alloc;
>> +	radeon_kfd_vidmem_kmap(dev, priv->mqd_mem, (void **)&priv->mqds);
>> +	if (err)
>> +		goto err_mqd_kmap;
>> +
>> +	*scheduler = (struct kfd_scheduler *)priv;
>> +
>> +	return 0;
>> +
>> +err_mqd_kmap:
>> +	radeon_kfd_vidmem_free(dev, priv->mqd_mem);
>> +err_mqd_alloc:
>> +err_hpd_kmap:
>> +	radeon_kfd_vidmem_free(dev, priv->hpd_mem);
>> +err_hpd_alloc:
>> +	mutex_destroy(&priv->mutex);
>> +	kfree(priv);
>> +	return err;
>> +}
>> +
>> +static void cik_static_destroy(struct kfd_scheduler *scheduler)
>> +{
>> +	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
>> +
>> +	radeon_kfd_vidmem_unkmap(priv->dev, priv->mqd_mem);
>> +	radeon_kfd_vidmem_free(priv->dev, priv->mqd_mem);
>> +	radeon_kfd_vidmem_free(priv->dev, priv->hpd_mem);
>> +
>> +	mutex_destroy(&priv->mutex);
>> +
>> +	kfree(priv);
>> +}
>> +
>> +static void cik_static_start(struct kfd_scheduler *scheduler)
>> +{
>> +	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
>> +
>> +	radeon_kfd_vidmem_gpumap(priv->dev, priv->hpd_mem, &priv->hpd_addr);
>> +	radeon_kfd_vidmem_gpumap(priv->dev, priv->mqd_mem, &priv->mqd_addr);
>> +
>> +	init_pipes(priv);
>> +	init_ats(priv);
>> +}
>> +
>> +static void cik_static_stop(struct kfd_scheduler *scheduler)
>> +{
>> +	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
>> +
>> +	exit_ats(priv);
>> +
>> +	radeon_kfd_vidmem_ungpumap(priv->dev, priv->hpd_mem);
>> +	radeon_kfd_vidmem_ungpumap(priv->dev, priv->mqd_mem);
>> +}
>> +
>> +static bool allocate_vmid(struct cik_static_private *priv, unsigned int *vmid)
>> +{
>> +	bool ok = false;
>> +
>> +	mutex_lock(&priv->mutex);
>> +
>> +	if (priv->free_vmid_mask != 0) {
>> +		unsigned int v = __ffs64(priv->free_vmid_mask);
>> +
>> +		clear_bit(v, &priv->free_vmid_mask);
>> +		*vmid = v;
>> +
>> +		ok = true;
>> +	}
>> +
>> +	mutex_unlock(&priv->mutex);
>> +
>> +	return ok;
>> +}
>> +
>> +static void release_vmid(struct cik_static_private *priv, unsigned int vmid)
>> +{
>> +	/* It's okay to race against allocate_vmid because this only adds bits to free_vmid_mask.
>> +	 * And set_bit/clear_bit are atomic wrt each other. */
>> +	set_bit(vmid, &priv->free_vmid_mask);
>> +}
>> +
>> +static void setup_vmid_for_process(struct cik_static_private *priv, struct cik_static_process *p)
>> +{
>> +	set_vmid_pasid_mapping(priv, p->vmid, p->pasid);
>> +
>> +	/*
>> +	 * SH_MEM_CONFIG and others need to be programmed differently
>> +	 * for 32/64-bit processes. And maybe other reasons.
>> +	 */
>> +}
>> +
>> +static int
>> +cik_static_register_process(struct kfd_scheduler *scheduler, struct kfd_process *process,
>> +			    struct kfd_scheduler_process **scheduler_process)
>> +{
>> +	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
>> +
>> +	struct cik_static_process *hwp;
>> +
>> +	hwp = kmalloc(sizeof(*hwp), GFP_KERNEL);
>> +	if (hwp == NULL)
>> +		return -ENOMEM;
>> +
>> +	if (!allocate_vmid(priv, &hwp->vmid)) {
>> +		kfree(hwp);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	hwp->pasid = process->pasid;
>> +
>> +	setup_vmid_for_process(priv, hwp);
>> +
>> +	*scheduler_process = (struct kfd_scheduler_process *)hwp;
>> +
>> +	return 0;
>> +}
>> +
>> +static void cik_static_deregister_process(struct kfd_scheduler *scheduler,
>> +				struct kfd_scheduler_process *scheduler_process)
>> +{
>> +	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
>> +	struct cik_static_process *pp = kfd_process_to_private(scheduler_process);
>> +
>> +	release_vmid(priv, pp->vmid);
>> +	kfree(pp);
>> +}
>> +
>> +static bool allocate_hqd(struct cik_static_private *priv, unsigned int *queue)
>> +{
>> +	bool ok = false;
>> +	unsigned int q;
>> +
>> +	mutex_lock(&priv->mutex);
>> +
>> +	q = find_first_bit(priv->free_queues, priv->num_pipes * CIK_QUEUES_PER_PIPE);
>> +
>> +	if (q != priv->num_pipes * CIK_QUEUES_PER_PIPE) {
>> +		clear_bit(q, priv->free_queues);
>> +		*queue = q;
>> +
>> +		ok = true;
>> +	}
>> +
>> +	mutex_unlock(&priv->mutex);
>> +
>> +	return ok;
>> +}
>> +
>> +static void release_hqd(struct cik_static_private *priv, unsigned int queue)
>> +{
>> +	/* It's okay to race against allocate_hqd because this only adds bits to free_queues.
>> +	 * And set_bit/clear_bit are atomic wrt each other. */
>> +	set_bit(queue, priv->free_queues);
>> +}
>> +
>> +static void init_mqd(const struct cik_static_queue *queue, const struct cik_static_process *process)
>> +{
>> +	struct cik_mqd *mqd = queue->mqd;
>> +
>> +	memset(mqd, 0, sizeof(*mqd));
>> +
>> +	mqd->header = 0xC0310800;
>> +	mqd->pipeline_stat_enable = 1;
>> +	mqd->static_thread_mgmt01[0] = 0xffffffff;
>> +	mqd->static_thread_mgmt01[1] = 0xffffffff;
>> +	mqd->static_thread_mgmt23[0] = 0xffffffff;
>> +	mqd->static_thread_mgmt23[1] = 0xffffffff;
>> +
>> +	mqd->queue_state.cp_mqd_base_addr = lower_32(queue->mqd_addr);
>> +	mqd->queue_state.cp_mqd_base_addr_hi = upper_32(queue->mqd_addr);
>> +	mqd->queue_state.cp_mqd_control = MQD_CONTROL_PRIV_STATE_EN;
>> +
>> +	mqd->queue_state.cp_hqd_pq_base = lower_32((uintptr_t)queue->pq_addr >> 8);
>> +	mqd->queue_state.cp_hqd_pq_base_hi = upper_32((uintptr_t)queue->pq_addr >> 8);
>> +	mqd->queue_state.cp_hqd_pq_control = QUEUE_SIZE(queue->queue_size_encoded) | DEFAULT_RPTR_BLOCK_SIZE
>> +					    | DEFAULT_MIN_AVAIL_SIZE | PQ_ATC_EN;
>> +	mqd->queue_state.cp_hqd_pq_rptr_report_addr = lower_32((uintptr_t)queue->rptr_address);
>> +	mqd->queue_state.cp_hqd_pq_rptr_report_addr_hi = upper_32((uintptr_t)queue->rptr_address);
>> +	mqd->queue_state.cp_hqd_pq_doorbell_control = DOORBELL_OFFSET(queue->doorbell_index) | DOORBELL_EN;
>> +	mqd->queue_state.cp_hqd_vmid = process->vmid;
>> +	mqd->queue_state.cp_hqd_active = 1;
>> +
>> +	mqd->queue_state.cp_hqd_persistent_state = DEFAULT_CP_HQD_PERSISTENT_STATE;
>> +
>> +	/* The values for these 3 are from WinKFD. */
>> +	mqd->queue_state.cp_hqd_quantum = QUANTUM_EN | QUANTUM_SCALE_1MS | QUANTUM_DURATION(10);
>> +	mqd->queue_state.cp_hqd_pipe_priority = 1;
>> +	mqd->queue_state.cp_hqd_queue_priority = 15;
>> +
>> +	mqd->queue_state.cp_hqd_ib_control = IB_ATC_EN | DEFAULT_MIN_IB_AVAIL_SIZE;
>> +}
>> +
>> +/* Write the HQD registers and activate the queue.
>> + * Requires that SRBM_GFX_CNTL has already been programmed for the queue.
>> + */
>> +static void load_hqd(struct cik_static_private *priv, struct cik_static_queue *queue)
>> +{
>> +	struct kfd_dev *dev = priv->dev;
>> +	const struct cik_hqd_registers *qs = &queue->mqd->queue_state;
>> +
>> +	WRITE_REG(dev, CP_MQD_BASE_ADDR, qs->cp_mqd_base_addr);
>> +	WRITE_REG(dev, CP_MQD_BASE_ADDR_HI, qs->cp_mqd_base_addr_hi);
>> +	WRITE_REG(dev, CP_MQD_CONTROL, qs->cp_mqd_control);
>> +
>> +	WRITE_REG(dev, CP_HQD_PQ_BASE, qs->cp_hqd_pq_base);
>> +	WRITE_REG(dev, CP_HQD_PQ_BASE_HI, qs->cp_hqd_pq_base_hi);
>> +	WRITE_REG(dev, CP_HQD_PQ_CONTROL, qs->cp_hqd_pq_control);
>> +	/* DOORBELL_CONTROL before WPTR because WPTR writes are dropped if DOORBELL_HIT is set. */
>> +	WRITE_REG(dev, CP_HQD_PQ_DOORBELL_CONTROL, qs->cp_hqd_pq_doorbell_control);
>> +	WRITE_REG(dev, CP_HQD_PQ_WPTR, qs->cp_hqd_pq_wptr);
>> +	WRITE_REG(dev, CP_HQD_PQ_RPTR, qs->cp_hqd_pq_rptr);
>> +	WRITE_REG(dev, CP_HQD_PQ_RPTR_REPORT_ADDR, qs->cp_hqd_pq_rptr_report_addr);
>> +	WRITE_REG(dev, CP_HQD_PQ_RPTR_REPORT_ADDR_HI, qs->cp_hqd_pq_rptr_report_addr_hi);
>> +
>> +	WRITE_REG(dev, CP_HQD_VMID, qs->cp_hqd_vmid);
>> +	WRITE_REG(dev, CP_HQD_PERSISTENT_STATE, qs->cp_hqd_persistent_state);
>> +	WRITE_REG(dev, CP_HQD_QUANTUM, qs->cp_hqd_quantum);
>> +	WRITE_REG(dev, CP_HQD_PIPE_PRIORITY, qs->cp_hqd_pipe_priority);
>> +	WRITE_REG(dev, CP_HQD_QUEUE_PRIORITY, qs->cp_hqd_queue_priority);
>> +
>> +	WRITE_REG(dev, CP_HQD_IB_CONTROL, qs->cp_hqd_ib_control);
>> +	WRITE_REG(dev, CP_HQD_IB_BASE_ADDR, qs->cp_hqd_ib_base_addr);
>> +	WRITE_REG(dev, CP_HQD_IB_BASE_ADDR_HI, qs->cp_hqd_ib_base_addr_hi);
>> +	WRITE_REG(dev, CP_HQD_IB_RPTR, qs->cp_hqd_ib_rptr);
>> +	WRITE_REG(dev, CP_HQD_SEMA_CMD, qs->cp_hqd_sema_cmd);
>> +	WRITE_REG(dev, CP_HQD_MSG_TYPE, qs->cp_hqd_msg_type);
>> +	WRITE_REG(dev, CP_HQD_ATOMIC0_PREOP_LO, qs->cp_hqd_atomic0_preop_lo);
>> +	WRITE_REG(dev, CP_HQD_ATOMIC0_PREOP_HI, qs->cp_hqd_atomic0_preop_hi);
>> +	WRITE_REG(dev, CP_HQD_ATOMIC1_PREOP_LO, qs->cp_hqd_atomic1_preop_lo);
>> +	WRITE_REG(dev, CP_HQD_ATOMIC1_PREOP_HI, qs->cp_hqd_atomic1_preop_hi);
>> +	WRITE_REG(dev, CP_HQD_HQ_SCHEDULER0, qs->cp_hqd_hq_scheduler0);
>> +	WRITE_REG(dev, CP_HQD_HQ_SCHEDULER1, qs->cp_hqd_hq_scheduler1);
>> +
>> +	WRITE_REG(dev, CP_HQD_ACTIVE, 1);
>> +}
>> +
>> +static void activate_queue(struct cik_static_private *priv, struct cik_static_queue *queue)
>> +{
>> +	bool wptr_shadow_valid;
>> +	doorbell_t wptr_shadow;
>> +
>> +	/* Avoid sleeping while holding the SRBM lock. */
>> +	wptr_shadow_valid = !get_user(wptr_shadow, queue->wptr_address);
>> +
>> +	lock_srbm_index(priv);
>> +	queue_select(priv, queue->queue);
>> +
>> +	load_hqd(priv, queue);
>> +
>> +	/* Doorbell and wptr are special because there is a race when reactivating a queue.
>> +	 * Since doorbell writes to deactivated queues are ignored by hardware, the application
>> +	 * shadows the doorbell into memory at queue->wptr_address.
>> +	 *
>> +	 * We want the queue to automatically resume processing as if it were always active,
>> +	 * so we want to copy from queue->wptr_address into the wptr/doorbell.
>> +	 *
>> +	 * The race is that the app could write a new wptr into the doorbell before we
>> +	 * write the shadowed wptr, resulting in an old wptr written later.
>> +	 *
>> +	 * The hardware solves this ignoring CP_HQD_WPTR writes after a doorbell write.
>> +	 * So the KFD can activate the doorbell then write the shadow wptr to CP_HQD_WPTR
>> +	 * knowing it will be ignored if the user has written a more-recent doorbell.
>> +	 */
>> +	if (wptr_shadow_valid)
>> +		WRITE_REG(priv->dev, CP_HQD_PQ_WPTR, wptr_shadow);
>> +
>> +	unlock_srbm_index(priv);
>> +}
>> +
>> +static void drain_hqd(struct cik_static_private *priv)
>> +{
>> +	WRITE_REG(priv->dev, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_DRAIN);
>> +}
>> +
>> +static void wait_hqd_inactive(struct cik_static_private *priv)
>> +{
>> +	while (READ_REG(priv->dev, CP_HQD_ACTIVE) != 0)
>> +		cpu_relax();
>> +}
>> +
>> +static void deactivate_queue(struct cik_static_private *priv, struct cik_static_queue *queue)
>> +{
>> +	lock_srbm_index(priv);
>> +	queue_select(priv, queue->queue);
>> +
>> +	drain_hqd(priv);
>> +	wait_hqd_inactive(priv);
>> +
>> +	unlock_srbm_index(priv);
>> +}
>> +
>> +#define BIT_MASK_64(high, low) (((1ULL << (high)) - 1) & ~((1ULL << (low)) - 1))
>> +#define RING_ADDRESS_BAD_BIT_MASK (~BIT_MASK_64(48, 8))
>> +#define RWPTR_ADDRESS_BAD_BIT_MASK (~BIT_MASK_64(48, 2))
>> +
>> +#define MAX_QUEUE_SIZE (1ULL << 32)
>> +#define MIN_QUEUE_SIZE (1ULL << 10)
>> +
>> +static int
>> +cik_static_create_queue(struct kfd_scheduler *scheduler,
>> +			struct kfd_scheduler_process *process,
>> +			struct kfd_scheduler_queue *queue,
>> +			void __user *ring_address,
>> +			uint64_t ring_size,
>> +			void __user *rptr_address,
>> +			void __user *wptr_address,
>> +			unsigned int doorbell)
>> +{
>> +	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
>> +	struct cik_static_process *hwp = kfd_process_to_private(process);
>> +	struct cik_static_queue *hwq = kfd_queue_to_private(queue);
>> +
>> +	if ((uint64_t)ring_address & RING_ADDRESS_BAD_BIT_MASK
>> +	    || (uint64_t)rptr_address & RWPTR_ADDRESS_BAD_BIT_MASK
>> +	    || (uint64_t)wptr_address & RWPTR_ADDRESS_BAD_BIT_MASK)
>> +		return -EINVAL;
>> +
>> +	if (ring_size > MAX_QUEUE_SIZE || ring_size < MIN_QUEUE_SIZE || !is_power_of_2(ring_size))
>> +		return -EINVAL;
>> +
>> +	if (!allocate_hqd(priv, &hwq->queue))
>> +		return -ENOMEM;
>> +
>> +	hwq->mqd_addr = priv->mqd_addr + sizeof(struct cik_mqd_padded) * hwq->queue;
>> +	hwq->mqd = &priv->mqds[hwq->queue].mqd;
>> +	hwq->pq_addr = ring_address;
>> +	hwq->rptr_address = rptr_address;
>> +	hwq->wptr_address = wptr_address;
>> +	hwq->doorbell_index = doorbell;
>> +	hwq->queue_size_encoded = ilog2(ring_size) - 3;
>> +
>> +	init_mqd(hwq, hwp);
>> +	activate_queue(priv, hwq);
>> +
>> +	return 0;
>> +}
>> +
>> +static void
>> +cik_static_destroy_queue(struct kfd_scheduler *scheduler, struct kfd_scheduler_queue *queue)
>> +{
>> +	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
>> +	struct cik_static_queue *hwq = kfd_queue_to_private(queue);
>> +
>> +	deactivate_queue(priv, hwq);
>> +
>> +	release_hqd(priv, hwq->queue);
>> +}
>> +
>> +const struct kfd_scheduler_class radeon_kfd_cik_static_scheduler_class = {
>> +	.name = "CIK static scheduler",
>> +	.create = cik_static_create,
>> +	.destroy = cik_static_destroy,
>> +	.start = cik_static_start,
>> +	.stop = cik_static_stop,
>> +	.register_process = cik_static_register_process,
>> +	.deregister_process = cik_static_deregister_process,
>> +	.queue_size = sizeof(struct cik_static_queue),
>> +	.create_queue = cik_static_create_queue,
>> +	.destroy_queue = cik_static_destroy_queue,
>> +};
>> diff --git a/drivers/gpu/hsa/radeon/kfd_vidmem.c b/drivers/gpu/hsa/radeon/kfd_vidmem.c
>> new file mode 100644
>> index 0000000..c8d3770
>> --- /dev/null
>> +++ b/drivers/gpu/hsa/radeon/kfd_vidmem.c
>> @@ -0,0 +1,61 @@
>> +/*
>> + * Copyright 2014 Advanced Micro Devices, Inc.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> + * copy of this software and associated documentation files (the "Software"),
>> + * to deal in the Software without restriction, including without limitation
>> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
>> + * and/or sell copies of the Software, and to permit persons to whom the
>> + * Software is furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#include "kfd_priv.h"
>> +
>> +int radeon_kfd_vidmem_alloc(struct kfd_dev *kfd, size_t size, size_t alignment,
>> +				enum kfd_mempool pool, kfd_mem_obj *mem_obj)
>> +{
>> +	return kfd2kgd->allocate_mem(kfd->kgd,
>> +					size,
>> +					alignment,
>> +					(enum kgd_memory_pool)pool,
>> +					(struct kgd_mem **)mem_obj);
>> +}
>> +
>> +void radeon_kfd_vidmem_free(struct kfd_dev *kfd, kfd_mem_obj mem_obj)
>> +{
>> +	kfd2kgd->free_mem(kfd->kgd, (struct kgd_mem *)mem_obj);
>> +}
>> +
>> +int radeon_kfd_vidmem_gpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj,
>> +				uint64_t *vmid0_address)
>> +{
>> +	return kfd2kgd->gpumap_mem(kfd->kgd,
>> +					(struct kgd_mem *)mem_obj,
>> +					vmid0_address);
>> +}
>> +
>> +void radeon_kfd_vidmem_ungpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj)
>> +{
>> +	kfd2kgd->ungpumap_mem(kfd->kgd, (struct kgd_mem *)mem_obj);
>> +}
>> +
>> +int radeon_kfd_vidmem_kmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj, void **ptr)
>> +{
>> +	return kfd2kgd->kmap_mem(kfd->kgd, (struct kgd_mem *)mem_obj, ptr);
>> +}
>> +
>> +void radeon_kfd_vidmem_unkmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj)
>> +{
>> +	kfd2kgd->unkmap_mem(kfd->kgd, (struct kgd_mem *)mem_obj);
>> +}
>> --
>> 1.9.1
>>

