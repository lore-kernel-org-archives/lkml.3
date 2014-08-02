Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaHBUIB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 16:08:01 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:36530
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754744AbaHBUIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 16:08:00 -0400
X-WSS-ID: 0N9P3WR-08-LQF-02
X-M-MSG: 
Message-ID: <53DD4504.3030505@amd.com>
Date: Sat, 2 Aug 2014 23:07:32 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>
Subject: Re: [PATCH v2 06/25] drm/radeon: Add radeon <--> amdkfd interface
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-7-git-send-email-oded.gabbay@amd.com>
 <20140720173529.GD3068@gmail.com>
In-Reply-To: <20140720173529.GD3068@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.144]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(51704005)(189002)(24454002)(479174003)(74502001)(84676001)(54356999)(31966008)(74662001)(105586002)(79102001)(50986999)(20776003)(47776003)(65816999)(76176999)(87266999)(99396002)(81542001)(65956001)(36756003)(92726001)(2201001)(92566001)(46102001)(81342001)(85852003)(83072002)(65806001)(64706001)(80022001)(4396001)(87936001)(21056001)(95666004)(33656002)(102836001)(101416001)(76482001)(83506001)(77982001)(106466001)(83322001)(23676002)(97736001)(107046002)(575784001)(19580395003)(86362001)(68736004)(85306004)(50466002)(80316001)(19580405001)(44976005);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB044;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029174C036
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20/07/14 20:35, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:29:13PM +0300, Oded Gabbay wrote:
>> This patch adds the interface between the radeon driver and the amdkfd driver.
>> The interface implementation is contained in radeon_kfd.c and radeon_kfd.h.
>>
>> The interface itself is represented by a pointer to struct
>> kfd_dev. The pointer is located inside radeon_device structure.
>>
>> All the register accesses that amdkfd need are done using this interface. This
>> allows us to avoid direct register accesses in amdkfd proper,  while also
>> avoiding locking between amdkfd and radeon.
>>
>> The single exception is the doorbells that are used in both of the drivers.
>> However, because they are located in separate pci bar pages, the danger of
>> sharing registers between the drivers is minimal.
>>
>> Having said that, we are planning to move the doorbells as well to radeon.
>>
>> The loading of the amdkfd module is done via symbol lookup. According to the code review discussions, this may change in v3 of the patch set.
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>  drivers/gpu/drm/radeon/Makefile     |   1 +
>>  drivers/gpu/drm/radeon/cik.c        |   9 +
>>  drivers/gpu/drm/radeon/cik_reg.h    |  65 +++++
>>  drivers/gpu/drm/radeon/cikd.h       |  51 +++-
>>  drivers/gpu/drm/radeon/radeon.h     |   3 +
>>  drivers/gpu/drm/radeon/radeon_drv.c |   5 +
>>  drivers/gpu/drm/radeon/radeon_kfd.c | 566 ++++++++++++++++++++++++++++++++++++
>>  drivers/gpu/drm/radeon/radeon_kfd.h | 119 ++++++++
>>  drivers/gpu/drm/radeon/radeon_kms.c |   7 +
>>  9 files changed, 825 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.c
>>  create mode 100644 drivers/gpu/drm/radeon/radeon_kfd.h
>>
>> diff --git a/drivers/gpu/drm/radeon/Makefile b/drivers/gpu/drm/radeon/Makefile
>> index 1b04002..a1c913d 100644
>> --- a/drivers/gpu/drm/radeon/Makefile
>> +++ b/drivers/gpu/drm/radeon/Makefile
>> @@ -104,6 +104,7 @@ radeon-y += \
>>  	radeon_vce.o \
>>  	vce_v1_0.o \
>>  	vce_v2_0.o \
>> +	radeon_kfd.o
>>  
>>  radeon-$(CONFIG_COMPAT) += radeon_ioc32.o
>>  radeon-$(CONFIG_VGA_SWITCHEROO) += radeon_atpx_handler.o
>> diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
>> index b4bbc22..6f71095 100644
>> --- a/drivers/gpu/drm/radeon/cik.c
>> +++ b/drivers/gpu/drm/radeon/cik.c
>> @@ -32,6 +32,7 @@
>>  #include "cik_blit_shaders.h"
>>  #include "radeon_ucode.h"
>>  #include "clearstate_ci.h"
>> +#include "radeon_kfd.h"
>>  
>>  MODULE_FIRMWARE("radeon/BONAIRE_pfp.bin");
>>  MODULE_FIRMWARE("radeon/BONAIRE_me.bin");
>> @@ -7727,6 +7728,9 @@ restart_ih:
>>  	while (rptr != wptr) {
>>  		/* wptr/rptr are in bytes! */
>>  		ring_index = rptr / 4;
>> +
>> +		radeon_kfd_interrupt(rdev, (const void *) &rdev->ih.ring[ring_index]);
>> +
>>  		src_id =  le32_to_cpu(rdev->ih.ring[ring_index]) & 0xff;
>>  		src_data = le32_to_cpu(rdev->ih.ring[ring_index + 1]) & 0xfffffff;
>>  		ring_id = le32_to_cpu(rdev->ih.ring[ring_index + 2]) & 0xff;
>> @@ -8386,6 +8390,10 @@ static int cik_startup(struct radeon_device *rdev)
>>  	if (r)
>>  		return r;
>>  
>> +	r = radeon_kfd_resume(rdev);
>> +	if (r)
>> +		return r;
>> +
>>  	return 0;
>>  }
>>  
>> @@ -8434,6 +8442,7 @@ int cik_resume(struct radeon_device *rdev)
>>   */
>>  int cik_suspend(struct radeon_device *rdev)
>>  {
>> +	radeon_kfd_suspend(rdev);
>>  	radeon_pm_suspend(rdev);
>>  	dce6_audio_fini(rdev);
>>  	radeon_vm_manager_fini(rdev);
>> diff --git a/drivers/gpu/drm/radeon/cik_reg.h b/drivers/gpu/drm/radeon/cik_reg.h
>> index ca1bb61..1ab3dbc 100644
>> --- a/drivers/gpu/drm/radeon/cik_reg.h
>> +++ b/drivers/gpu/drm/radeon/cik_reg.h
>> @@ -147,4 +147,69 @@
>>  
>>  #define CIK_LB_DESKTOP_HEIGHT                     0x6b0c
>>  
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
>>  #endif
>> diff --git a/drivers/gpu/drm/radeon/cikd.h b/drivers/gpu/drm/radeon/cikd.h
>> index 0c6e1b5..0a2a403 100644
>> --- a/drivers/gpu/drm/radeon/cikd.h
>> +++ b/drivers/gpu/drm/radeon/cikd.h
>> @@ -1137,6 +1137,9 @@
>>  #define			SH_MEM_ALIGNMENT_MODE_UNALIGNED			3
>>  #define		DEFAULT_MTYPE(x)				((x) << 4)
>>  #define		APE1_MTYPE(x)					((x) << 7)
>> +/* valid for both DEFAULT_MTYPE and APE1_MTYPE */
>> +#define	MTYPE_CACHED					0
>> +#define	MTYPE_NONCACHED					3
>>  
>>  #define	SX_DEBUG_1					0x9060
>>  
>> @@ -1447,6 +1450,16 @@
>>  #define CP_HQD_ACTIVE                                     0xC91C
>>  #define CP_HQD_VMID                                       0xC920
>>  
>> +#define CP_HQD_PERSISTENT_STATE							0xC924u
>> +#define	DEFAULT_CP_HQD_PERSISTENT_STATE						(0x33U << 8)
>> +
>> +#define CP_HQD_PIPE_PRIORITY							0xC928u
>> +#define CP_HQD_QUEUE_PRIORITY							0xC92Cu
>> +#define CP_HQD_QUANTUM									0xC930u
>> +#define	QUANTUM_EN											1U
>> +#define	QUANTUM_SCALE_1MS									(1U << 4)
>> +#define	QUANTUM_DURATION(x)									((x) << 8)
>> +
> 
> We need documentation for this queue/pipe priority to know their
> granularity and how they are use exactly.
> 
Done in v3
>>  #define CP_HQD_PQ_BASE                                    0xC934
>>  #define CP_HQD_PQ_BASE_HI                                 0xC938
>>  #define CP_HQD_PQ_RPTR                                    0xC93C
>> @@ -1474,12 +1487,32 @@
>>  #define		PRIV_STATE      			(1 << 30)
>>  #define		KMD_QUEUE      				(1 << 31)
>>  
>> -#define CP_HQD_DEQUEUE_REQUEST                          0xC974
>> +#define CP_HQD_IB_BASE_ADDR				0xC95Cu
>> +#define CP_HQD_IB_BASE_ADDR_HI			0xC960u
>> +#define CP_HQD_IB_RPTR					0xC964u
>> +#define CP_HQD_IB_CONTROL				0xC968u
>> +#define	IB_ATC_EN							(1U << 23)
>> +#define	DEFAULT_MIN_IB_AVAIL_SIZE			(3U << 20)
>> +
>> +#define CP_HQD_DEQUEUE_REQUEST			0xC974
>> +#define	DEQUEUE_REQUEST_DRAIN				1
>> +#define DEQUEUE_REQUEST_RESET				2
>>  
>>  #define CP_MQD_CONTROL                                  0xC99C
>>  #define		MQD_VMID(x)				((x) << 0)
>>  #define		MQD_VMID_MASK      			(0xf << 0)
>>  
>> +#define CP_HQD_SEMA_CMD					0xC97Cu
>> +#define CP_HQD_MSG_TYPE					0xC980u
>> +#define CP_HQD_ATOMIC0_PREOP_LO			0xC984u
>> +#define CP_HQD_ATOMIC0_PREOP_HI			0xC988u
>> +#define CP_HQD_ATOMIC1_PREOP_LO			0xC98Cu
>> +#define CP_HQD_ATOMIC1_PREOP_HI			0xC990u
>> +#define CP_HQD_HQ_SCHEDULER0			0xC994u
>> +#define CP_HQD_HQ_SCHEDULER1			0xC998u
>> +
>> +#define SH_STATIC_MEM_CONFIG			0x9604u
> 
> Same here documentation is needed on all those register.
> 
This is a bit more problematic. I need to find out what I can reveal. I
prefer to add this later (v4 or a single patch)
>> +
>>  #define DB_RENDER_CONTROL                               0x28000
>>  
>>  #define PA_SC_RASTER_CONFIG                             0x28350
>> @@ -2069,4 +2102,20 @@
>>  #define VCE_CMD_IB_AUTO		0x00000005
>>  #define VCE_CMD_SEMAPHORE	0x00000006
>>  
>> +#define ATC_VMID0_PASID_MAPPING					0x339Cu
>> +#define	ATC_VMID_PASID_MAPPING_UPDATE_STATUS	0x3398u
>> +#define	ATC_VMID_PASID_MAPPING_VALID				(1U << 31)
>> +
>> +#define ATC_VM_APERTURE0_CNTL					0x3310u
>> +#define	ATS_ACCESS_MODE_NEVER						0
>> +#define	ATS_ACCESS_MODE_ALWAYS						1
>> +
>> +#define ATC_VM_APERTURE0_CNTL2					0x3318u
>> +#define ATC_VM_APERTURE0_HIGH_ADDR				0x3308u
>> +#define ATC_VM_APERTURE0_LOW_ADDR				0x3300u
>> +#define ATC_VM_APERTURE1_CNTL					0x3314u
>> +#define ATC_VM_APERTURE1_CNTL2					0x331Cu
>> +#define ATC_VM_APERTURE1_HIGH_ADDR				0x330Cu
>> +#define ATC_VM_APERTURE1_LOW_ADDR				0x3304u
>> +
>>  #endif
>> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
>> index 5136855..94b38a7 100644
>> --- a/drivers/gpu/drm/radeon/radeon.h
>> +++ b/drivers/gpu/drm/radeon/radeon.h
>> @@ -2342,6 +2342,9 @@ struct radeon_device {
>>  
>>  	struct dev_pm_domain vga_pm_domain;
>>  	bool have_disp_power_ref;
>> +
>> +	/* HSA KFD interface */
>> +	struct kfd_dev		*kfd;
>>  };
>>  
>>  bool radeon_is_px(struct drm_device *dev);
>> diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
>> index cb14213..efaa086 100644
>> --- a/drivers/gpu/drm/radeon/radeon_drv.c
>> +++ b/drivers/gpu/drm/radeon/radeon_drv.c
>> @@ -39,6 +39,8 @@
>>  #include <linux/pm_runtime.h>
>>  #include <linux/vga_switcheroo.h>
>>  #include "drm_crtc_helper.h"
>> +#include "radeon_kfd.h"
>> +
>>  /*
>>   * KMS wrapper.
>>   * - 2.0.0 - initial interface
>> @@ -630,12 +632,15 @@ static int __init radeon_init(void)
>>  #endif
>>  	}
>>  
>> +	radeon_kfd_init();
>> +
>>  	/* let modprobe override vga console setting */
>>  	return drm_pci_init(driver, pdriver);
>>  }
>>  
>>  static void __exit radeon_exit(void)
>>  {
>> +	radeon_kfd_fini();
>>  	drm_pci_exit(driver, pdriver);
>>  	radeon_unregister_atpx_handler();
>>  }
>> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
>> new file mode 100644
>> index 0000000..0385239
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/radeon_kfd.c
>> @@ -0,0 +1,566 @@
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
>> +#include <linux/module.h>
>> +#include <linux/fdtable.h>
>> +#include <linux/uaccess.h>
>> +#include <drm/drmP.h>
>> +#include "radeon.h"
>> +#include "cikd.h"
>> +#include "cik_reg.h"
>> +#include "radeon_kfd.h"
>> +
>> +#define CIK_PIPE_PER_MEC	(4)
>> +
>> +struct kgd_mem {
>> +	struct radeon_bo *bo;
>> +	u32 domain;
>> +	struct radeon_bo_va *bo_va;
>> +};
>> +
>> +static int allocate_mem(struct kgd_dev *kgd, size_t size, size_t alignment,
>> +		enum kgd_memory_pool pool, struct kgd_mem **memory_handle);
>> +
>> +static void free_mem(struct kgd_dev *kgd, struct kgd_mem *memory_handle);
>> +
>> +static int gpumap_mem(struct kgd_dev *kgd, struct kgd_mem *mem, uint64_t *vmid0_address);
>> +static void ungpumap_mem(struct kgd_dev *kgd, struct kgd_mem *mem);
>> +
>> +static int kmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem, void **ptr);
>> +static void unkmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem);
>> +
>> +static uint64_t get_vmem_size(struct kgd_dev *kgd);
>> +static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd);
>> +
>> +static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd);
>> +
>> +/*
>> + * Register access functions
>> + */
>> +
>> +static void kgd_program_sh_mem_settings(struct kgd_dev *kgd, uint32_t vmid, uint32_t sh_mem_config,
>> +		uint32_t sh_mem_ape1_base, uint32_t sh_mem_ape1_limit, uint32_t sh_mem_bases);
>> +static int kgd_set_pasid_vmid_mapping(struct kgd_dev *kgd, unsigned int pasid, unsigned int vmid);
>> +static int kgd_init_memory(struct kgd_dev *kgd);
>> +static int kgd_init_pipeline(struct kgd_dev *kgd, uint32_t pipe_id, uint32_t hpd_size, uint64_t hpd_gpu_addr);
>> +static int kgd_hqd_load(struct kgd_dev *kgd, void *mqd, uint32_t pipe_id, uint32_t queue_id, uint32_t __user *wptr);
>> +static bool kgd_hqd_is_occupies(struct kgd_dev *kgd, uint64_t queue_address, uint32_t pipe_id, uint32_t queue_id);
>> +static int kgd_hqd_destroy(struct kgd_dev *kgd, bool is_reset, unsigned int timeout,
>> +				uint32_t pipe_id, uint32_t queue_id);
>> +
>> +static const struct kfd2kgd_calls kfd2kgd = {
>> +	.allocate_mem = allocate_mem,
>> +	.free_mem = free_mem,
>> +	.gpumap_mem = gpumap_mem,
>> +	.ungpumap_mem = ungpumap_mem,
>> +	.kmap_mem = kmap_mem,
>> +	.unkmap_mem = unkmap_mem,
>> +	.get_vmem_size = get_vmem_size,
>> +	.get_gpu_clock_counter = get_gpu_clock_counter,
>> +	.get_max_engine_clock_in_mhz = get_max_engine_clock_in_mhz,
>> +	.program_sh_mem_settings = kgd_program_sh_mem_settings,
>> +	.set_pasid_vmid_mapping = kgd_set_pasid_vmid_mapping,
>> +	.init_memory = kgd_init_memory,
>> +	.init_pipeline = kgd_init_pipeline,
>> +	.hqd_load = kgd_hqd_load,
>> +	.hqd_is_occupies = kgd_hqd_is_occupies,
>> +	.hqd_destroy = kgd_hqd_destroy,
>> +};
>> +
>> +static const struct kgd2kfd_calls *kgd2kfd;
>> +
>> +bool radeon_kfd_init(void)
>> +{
>> +	bool (*kgd2kfd_init_p)(unsigned, const struct kfd2kgd_calls*,
>> +				const struct kgd2kfd_calls**);
>> +
>> +	kgd2kfd_init_p = symbol_request(kgd2kfd_init);
>> +
>> +	if (kgd2kfd_init_p == NULL)
>> +		return false;
>> +
>> +	if (!kgd2kfd_init_p(KFD_INTERFACE_VERSION, &kfd2kgd, &kgd2kfd)) {
>> +		symbol_put(kgd2kfd_init);
>> +		kgd2kfd = NULL;
>> +
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +void radeon_kfd_fini(void)
>> +{
>> +	if (kgd2kfd) {
>> +		kgd2kfd->exit();
>> +		symbol_put(kgd2kfd_init);
>> +	}
>> +}
>> +
>> +void radeon_kfd_device_probe(struct radeon_device *rdev)
>> +{
>> +	if (kgd2kfd)
>> +		rdev->kfd = kgd2kfd->probe((struct kgd_dev *)rdev, rdev->pdev);
>> +}
>> +
>> +void radeon_kfd_device_init(struct radeon_device *rdev)
>> +{
>> +	if (rdev->kfd) {
>> +		struct kgd2kfd_shared_resources gpu_resources = {
>> +			.compute_vmid_bitmap = 0xFF00,
>> +
>> +			.first_compute_pipe = 1,
>> +			.compute_pipe_count = 8 - 1,
>> +		};
>> +
>> +		radeon_doorbell_get_kfd_info(rdev,
>> +				&gpu_resources.doorbell_physical_address,
>> +				&gpu_resources.doorbell_aperture_size,
>> +				&gpu_resources.doorbell_start_offset);
>> +
>> +		kgd2kfd->device_init(rdev->kfd, &gpu_resources);
>> +	}
>> +}
>> +
>> +void radeon_kfd_device_fini(struct radeon_device *rdev)
>> +{
>> +	if (rdev->kfd) {
>> +		kgd2kfd->device_exit(rdev->kfd);
>> +		rdev->kfd = NULL;
>> +	}
>> +}
>> +
>> +void radeon_kfd_interrupt(struct radeon_device *rdev, const void *ih_ring_entry)
>> +{
>> +	if (rdev->kfd)
>> +		kgd2kfd->interrupt(rdev->kfd, ih_ring_entry);
>> +}
>> +
>> +void radeon_kfd_suspend(struct radeon_device *rdev)
>> +{
>> +	if (rdev->kfd)
>> +		kgd2kfd->suspend(rdev->kfd);
>> +}
>> +
>> +int radeon_kfd_resume(struct radeon_device *rdev)
>> +{
>> +	int r = 0;
>> +
>> +	if (rdev->kfd)
>> +		r = kgd2kfd->resume(rdev->kfd);
>> +
>> +	return r;
>> +}
> 
> All of the above wrapper function should be move to header file and mark
> as inline this would allow for compiler optimization. I still would like
> to see the possibility to build radeon without hsa.
> 
That is problematic as they don't compile in the header file. Anyway,
these functions are rarely called so a compiler optimization is quite
useless here.
Radeon can definitely build without amdkfd. This file will always be
built as it will be part of radeon.
>> +
>> +static u32 pool_to_domain(enum kgd_memory_pool p)
>> +{
>> +	switch (p) {
>> +	case KGD_POOL_FRAMEBUFFER: return RADEON_GEM_DOMAIN_VRAM;
>> +	default: return RADEON_GEM_DOMAIN_GTT;
>> +	}
>> +}
>> +
>> +static int allocate_mem(struct kgd_dev *kgd, size_t size, size_t alignment,
>> +		enum kgd_memory_pool pool, struct kgd_mem **memory_handle)
>> +{
>> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
>> +	struct kgd_mem *mem;
>> +	int r;
>> +
>> +	mem = kzalloc(sizeof(struct kgd_mem), GFP_KERNEL);
>> +	if (!mem)
>> +		return -ENOMEM;
>> +
>> +	mem->domain = pool_to_domain(pool);
>> +
>> +	r = radeon_bo_create(rdev, size, alignment, true, mem->domain, NULL, &mem->bo);
>> +	if (r) {
>> +		kfree(mem);
>> +		return r;
>> +	}
>> +
>> +	*memory_handle = mem;
>> +	return 0;
>> +}
>> +
>> +static void free_mem(struct kgd_dev *kgd, struct kgd_mem *mem)
>> +{
>> +	/* Assume that KFD will never free gpumapped or kmapped memory. This is not quite settled. */
>> +	radeon_bo_unref(&mem->bo);
>> +	kfree(mem);
>> +}
>> +
>> +static int gpumap_mem(struct kgd_dev *kgd, struct kgd_mem *mem, uint64_t *vmid0_address)
>> +{
>> +	int r;
>> +
>> +	r = radeon_bo_reserve(mem->bo, true);
>> +
>> +	/*
>> +	 * ttm_bo_reserve can only fail if the buffer reservation lock
>> +	 * is held in circumstances that would deadlock
>> +	 */
>> +	BUG_ON(r != 0);
>> +	r = radeon_bo_pin(mem->bo, mem->domain, vmid0_address);
>> +	radeon_bo_unreserve(mem->bo);
>> +
>> +	return r;
>> +}
> 
> NACK NACK NACK, no radeon_bo_pin this is not acceptable. Buffer pining should be done
> very seldomly and i would say only radeon module can do it and only for buffer object
> under its control. We certainly can not accept to do that for buffer object that are
> under userspace management.
> 
Changed to new method in v3, as discussed in main thread.
> 
>> +
>> +static void ungpumap_mem(struct kgd_dev *kgd, struct kgd_mem *mem)
>> +{
>> +	int r;
>> +
>> +	r = radeon_bo_reserve(mem->bo, true);
>> +
>> +	/*
>> +	 * ttm_bo_reserve can only fail if the buffer reservation lock
>> +	 * is held in circumstances that would deadlock
>> +	 */
>> +	BUG_ON(r != 0);
>> +	r = radeon_bo_unpin(mem->bo);
>> +
>> +	/*
>> +	 * This unpin only removed NO_EVICT placement flags
>> +	 * and should never fail
>> +	 */
>> +	BUG_ON(r != 0);
>> +	radeon_bo_unreserve(mem->bo);
>> +}
>> +
>> +static int kmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem, void **ptr)
>> +{
>> +	int r;
>> +
>> +	r = radeon_bo_reserve(mem->bo, true);
>> +
>> +	/*
>> +	 * ttm_bo_reserve can only fail if the buffer reservation lock
>> +	 * is held in circumstances that would deadlock
>> +	 */
>> +	BUG_ON(r != 0);
>> +	r = radeon_bo_kmap(mem->bo, ptr);
>> +	radeon_bo_unreserve(mem->bo);
>> +
>> +	return r;
>> +}
>> +
>> +static void unkmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem)
>> +{
>> +	int r;
>> +
>> +	r = radeon_bo_reserve(mem->bo, true);
>> +	/*
>> +	 * ttm_bo_reserve can only fail if the buffer reservation lock
>> +	 * is held in circumstances that would deadlock
>> +	 */
>> +	BUG_ON(r != 0);
>> +	radeon_bo_kunmap(mem->bo);
>> +	radeon_bo_unreserve(mem->bo);
>> +}
>> +
>> +static uint64_t get_vmem_size(struct kgd_dev *kgd)
>> +{
>> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
>> +
>> +	BUG_ON(kgd == NULL);
>> +
>> +	return rdev->mc.real_vram_size;
>> +}
>> +
>> +static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd)
>> +{
>> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
>> +
>> +	return rdev->asic->get_gpu_clock_counter(rdev);
>> +}
>> +
>> +static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd)
>> +{
>> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
>> +
>> +	/* The sclk is in quantas of 10kHz */
>> +	return rdev->pm.dpm.dyn_state.max_clock_voltage_on_ac.sclk / 100;
>> +}
>> +
>> +/*
>> + * kfd/radeon registers access interface
>> + */
>> +
>> +inline uint32_t lower_32(uint64_t x)
>> +{
>> +	return (uint32_t)x;
>> +}
>> +
>> +inline uint32_t upper_32(uint64_t x)
>> +{
>> +	return (uint32_t)(x >> 32);
>> +}
> 
> Use appropriate macro (upper_32_bits, lower_32_bits) instead of those
> inline function.
> 
Done in v3.
>> +
>> +static inline struct radeon_device *get_radeon_device(struct kgd_dev *kgd)
>> +{
>> +	return (struct radeon_device *)kgd;
>> +}
>> +
>> +static void write_register(struct kgd_dev *kgd, uint32_t offset, uint32_t value)
>> +{
>> +	struct radeon_device *rdev = get_radeon_device(kgd);
>> +
>> +	writel(value, (void __iomem *)(rdev->rmmio + offset));
>> +}
>> +
>> +static uint32_t read_register(struct kgd_dev *kgd, uint32_t offset)
>> +{
>> +	struct radeon_device *rdev = get_radeon_device(kgd);
>> +
>> +	return readl((void __iomem *)(rdev->rmmio + offset));
>> +}
>> +
>> +static void lock_srbm(struct kgd_dev *kgd, uint32_t mec, uint32_t pipe, uint32_t queue, uint32_t vmid)
>> +{
>> +	struct radeon_device *rdev = get_radeon_device(kgd);
>> +	uint32_t value = PIPEID(pipe) | MEID(mec) | VMID(vmid) | QUEUEID(queue);
>> +
>> +	mutex_lock(&rdev->srbm_mutex);
>> +	write_register(kgd, SRBM_GFX_CNTL, value);
>> +}
>> +
>> +static void unlock_srbm(struct kgd_dev *kgd)
>> +{
>> +	struct radeon_device *rdev = get_radeon_device(kgd);
>> +
>> +	write_register(kgd, SRBM_GFX_CNTL, 0);
>> +	mutex_unlock(&rdev->srbm_mutex);
>> +}
>> +
>> +static void acquire_queue(struct kgd_dev *kgd, uint32_t pipe_id, uint32_t queue_id)
>> +{
>> +	uint32_t mec = (++pipe_id / CIK_PIPE_PER_MEC) + 1;
>> +	uint32_t pipe = (pipe_id % CIK_PIPE_PER_MEC);
>> +
>> +	lock_srbm(kgd, mec, pipe, queue_id, 0);
>> +}
>> +
>> +static void release_queue(struct kgd_dev *kgd)
>> +{
>> +	unlock_srbm(kgd);
>> +}
>> +
>> +static void kgd_program_sh_mem_settings(struct kgd_dev *kgd, uint32_t vmid, uint32_t sh_mem_config,
>> +		uint32_t sh_mem_ape1_base, uint32_t sh_mem_ape1_limit, uint32_t sh_mem_bases)
>> +{
>> +	lock_srbm(kgd, 0, 0, 0, vmid);
>> +
>> +	write_register(kgd, SH_MEM_CONFIG, sh_mem_config);
>> +	write_register(kgd, SH_MEM_APE1_BASE, sh_mem_ape1_base);
>> +	write_register(kgd, SH_MEM_APE1_LIMIT, sh_mem_ape1_limit);
>> +	write_register(kgd, SH_MEM_BASES, sh_mem_bases);
>> +
>> +	unlock_srbm(kgd);
>> +}
>> +
>> +static int kgd_set_pasid_vmid_mapping(struct kgd_dev *kgd, unsigned int pasid, unsigned int vmid)
>> +{
>> +	/* We have to assume that there is no outstanding mapping.
>> +	 * The ATC_VMID_PASID_MAPPING_UPDATE_STATUS bit could be 0 because a mapping
>> +	 * is in progress or because a mapping finished and the SW cleared it.
>> +	 * So the protocol is to always wait & clear.
>> +	 */
>> +	uint32_t pasid_mapping = (pasid == 0) ? 0 : (uint32_t)pasid | ATC_VMID_PASID_MAPPING_VALID;
>> +
>> +	write_register(kgd, ATC_VMID0_PASID_MAPPING + vmid*sizeof(uint32_t), pasid_mapping);
>> +
>> +	while (!(read_register(kgd, ATC_VMID_PASID_MAPPING_UPDATE_STATUS) & (1U << vmid)))
>> +		cpu_relax();
>> +	write_register(kgd, ATC_VMID_PASID_MAPPING_UPDATE_STATUS, 1U << vmid);
>> +
>> +	return 0;
>> +}
>> +
>> +static int kgd_init_memory(struct kgd_dev *kgd)
>> +{
>> +	/* Configure apertures:
>> +	 * LDS:         0x60000000'00000000 - 0x60000001'00000000 (4GB)
>> +	 * Scratch:     0x60000001'00000000 - 0x60000002'00000000 (4GB)
>> +	 * GPUVM:       0x60010000'00000000 - 0x60020000'00000000 (1TB)
>> +	 */
> 
> Again this whole aperture business need some explanation somewhere.
> 
Added explanation in v3.
>> +	int i;
>> +	uint32_t sh_mem_bases = PRIVATE_BASE(0x6000) | SHARED_BASE(0x6000);
>> +
>> +	for (i = 8; i < 16; i++) {
>> +		uint32_t sh_mem_config;
>> +
>> +		lock_srbm(kgd, 0, 0, 0, i);
>> +
>> +		sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED);
>> +		sh_mem_config |= DEFAULT_MTYPE(MTYPE_NONCACHED);
>> +
>> +		write_register(kgd, SH_MEM_CONFIG, sh_mem_config);
>> +
>> +		write_register(kgd, SH_MEM_BASES, sh_mem_bases);
>> +
>> +		/* Scratch aperture is not supported for now. */
>> +		write_register(kgd, SH_STATIC_MEM_CONFIG, 0);
>> +
>> +		/* APE1 disabled for now. */
>> +		write_register(kgd, SH_MEM_APE1_BASE, 1);
>> +		write_register(kgd, SH_MEM_APE1_LIMIT, 0);
>> +
>> +		unlock_srbm(kgd);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int kgd_init_pipeline(struct kgd_dev *kgd, uint32_t pipe_id, uint32_t hpd_size, uint64_t hpd_gpu_addr)
>> +{
>> +	uint32_t mec = (++pipe_id / CIK_PIPE_PER_MEC) + 1;
>> +	uint32_t pipe = (pipe_id % CIK_PIPE_PER_MEC);
>> +
>> +	lock_srbm(kgd, mec, pipe, 0, 0);
>> +	write_register(kgd, CP_HPD_EOP_BASE_ADDR, lower_32(hpd_gpu_addr >> 8));
>> +	write_register(kgd, CP_HPD_EOP_BASE_ADDR_HI, upper_32(hpd_gpu_addr >> 8));
>> +	write_register(kgd, CP_HPD_EOP_VMID, 0);
>> +	write_register(kgd, CP_HPD_EOP_CONTROL, hpd_size);
>> +	unlock_srbm(kgd);
>> +
>> +	return 0;
>> +}
>> +
>> +static inline struct cik_mqd *get_mqd(void *mqd)
>> +{
>> +	return (struct cik_mqd *)mqd;
>> +}
>> +
>> +static int kgd_hqd_load(struct kgd_dev *kgd, void *mqd, uint32_t pipe_id, uint32_t queue_id, uint32_t __user *wptr)
>> +{
>> +	uint32_t wptr_shadow, is_wptr_shadow_valid;
>> +	struct cik_mqd *m;
>> +
>> +	m = get_mqd(mqd);
>> +
>> +	is_wptr_shadow_valid = !get_user(wptr_shadow, wptr);
>> +
>> +	acquire_queue(kgd, pipe_id, queue_id);
>> +	write_register(kgd, CP_MQD_BASE_ADDR, m->queue_state.cp_mqd_base_addr);
>> +	write_register(kgd, CP_MQD_BASE_ADDR_HI, m->queue_state.cp_mqd_base_addr_hi);
>> +	write_register(kgd, CP_MQD_CONTROL, m->queue_state.cp_mqd_control);
>> +
>> +	write_register(kgd, CP_HQD_PQ_BASE, m->queue_state.cp_hqd_pq_base);
>> +	write_register(kgd, CP_HQD_PQ_BASE_HI, m->queue_state.cp_hqd_pq_base_hi);
>> +	write_register(kgd, CP_HQD_PQ_CONTROL, m->queue_state.cp_hqd_pq_control);
>> +
>> +	write_register(kgd, CP_HQD_IB_CONTROL, m->queue_state.cp_hqd_ib_control);
>> +	write_register(kgd, CP_HQD_IB_BASE_ADDR, m->queue_state.cp_hqd_ib_base_addr);
>> +	write_register(kgd, CP_HQD_IB_BASE_ADDR_HI, m->queue_state.cp_hqd_ib_base_addr_hi);
>> +
>> +	write_register(kgd, CP_HQD_IB_RPTR, m->queue_state.cp_hqd_ib_rptr);
>> +
>> +	write_register(kgd, CP_HQD_PERSISTENT_STATE, m->queue_state.cp_hqd_persistent_state);
>> +	write_register(kgd, CP_HQD_SEMA_CMD, m->queue_state.cp_hqd_sema_cmd);
>> +	write_register(kgd, CP_HQD_MSG_TYPE, m->queue_state.cp_hqd_msg_type);
>> +
>> +	write_register(kgd, CP_HQD_ATOMIC0_PREOP_LO, m->queue_state.cp_hqd_atomic0_preop_lo);
>> +	write_register(kgd, CP_HQD_ATOMIC0_PREOP_HI, m->queue_state.cp_hqd_atomic0_preop_hi);
>> +	write_register(kgd, CP_HQD_ATOMIC1_PREOP_LO, m->queue_state.cp_hqd_atomic1_preop_lo);
>> +	write_register(kgd, CP_HQD_ATOMIC1_PREOP_HI, m->queue_state.cp_hqd_atomic1_preop_hi);
>> +
>> +	write_register(kgd, CP_HQD_PQ_RPTR_REPORT_ADDR, m->queue_state.cp_hqd_pq_rptr_report_addr);
>> +	write_register(kgd, CP_HQD_PQ_RPTR_REPORT_ADDR_HI, m->queue_state.cp_hqd_pq_rptr_report_addr_hi);
>> +	write_register(kgd, CP_HQD_PQ_RPTR, m->queue_state.cp_hqd_pq_rptr);
>> +
>> +	write_register(kgd, CP_HQD_PQ_WPTR_POLL_ADDR, m->queue_state.cp_hqd_pq_wptr_poll_addr);
>> +	write_register(kgd, CP_HQD_PQ_WPTR_POLL_ADDR_HI, m->queue_state.cp_hqd_pq_wptr_poll_addr_hi);
>> +
>> +	write_register(kgd, CP_HQD_PQ_DOORBELL_CONTROL, m->queue_state.cp_hqd_pq_doorbell_control);
>> +
>> +	write_register(kgd, CP_HQD_VMID, m->queue_state.cp_hqd_vmid);
>> +
>> +	write_register(kgd, CP_HQD_QUANTUM, m->queue_state.cp_hqd_quantum);
>> +
>> +	write_register(kgd, CP_HQD_PIPE_PRIORITY, m->queue_state.cp_hqd_pipe_priority);
>> +	write_register(kgd, CP_HQD_QUEUE_PRIORITY, m->queue_state.cp_hqd_queue_priority);
>> +
>> +	write_register(kgd, CP_HQD_HQ_SCHEDULER0, m->queue_state.cp_hqd_hq_scheduler0);
>> +	write_register(kgd, CP_HQD_HQ_SCHEDULER1, m->queue_state.cp_hqd_hq_scheduler1);
>> +
>> +	if (is_wptr_shadow_valid)
>> +		write_register(kgd, CP_HQD_PQ_WPTR, wptr_shadow);
>> +
>> +	write_register(kgd, CP_HQD_ACTIVE, m->queue_state.cp_hqd_active);
>> +	release_queue(kgd);
>> +
>> +	return 0;
>> +}
>> +
>> +static bool kgd_hqd_is_occupies(struct kgd_dev *kgd, uint64_t queue_address, uint32_t pipe_id, uint32_t queue_id)
>> +{
>> +	uint32_t act;
>> +	bool retval = false;
>> +	uint32_t low, high;
>> +
>> +	acquire_queue(kgd, pipe_id, queue_id);
>> +	act = read_register(kgd, CP_HQD_ACTIVE);
>> +	if (act) {
>> +		low = lower_32(queue_address >> 8);
>> +		high = upper_32(queue_address >> 8);
>> +
>> +		if (low == read_register(kgd, CP_HQD_PQ_BASE) &&
>> +				high == read_register(kgd, CP_HQD_PQ_BASE_HI))
>> +			retval = true;
>> +	}
>> +	release_queue(kgd);
>> +	return retval;
>> +}
>> +
>> +static int kgd_hqd_destroy(struct kgd_dev *kgd, bool is_reset,
>> +				unsigned int timeout, uint32_t pipe_id,
>> +				uint32_t queue_id)
>> +{
>> +	int status = 0;
>> +	bool sync = (timeout > 0) ? true : false;
>> +
>> +	acquire_queue(kgd, pipe_id, queue_id);
>> +	write_register(kgd, CP_HQD_PQ_DOORBELL_CONTROL, 0);
>> +
>> +	if (is_reset)
>> +		write_register(kgd, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_RESET);
>> +	else
>> +		write_register(kgd, CP_HQD_DEQUEUE_REQUEST, DEQUEUE_REQUEST_DRAIN);
>> +
>> +
>> +	while (read_register(kgd, CP_HQD_ACTIVE) != 0) {
>> +		if (sync && timeout <= 0) {
>> +			status = -EBUSY;
>> +			break;
>> +		}
>> +		msleep(20);
>> +		if (sync) {
>> +			if (timeout >= 20)
>> +				timeout -= 20;
>> +			else
>> +				timeout = 0;
>> +		}
>> +	}
>> +	release_queue(kgd);
>> +	return status;
>> +}
>> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.h b/drivers/gpu/drm/radeon/radeon_kfd.h
>> new file mode 100644
>> index 0000000..5171726
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/radeon_kfd.h
>> @@ -0,0 +1,119 @@
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
>> +/*
>> + * radeon_kfd.h defines the private interface between the
>> + * AMD kernel graphics drivers and the AMD KFD.
>> + */
>> +
>> +#ifndef RADEON_KFD_H_INCLUDED
>> +#define RADEON_KFD_H_INCLUDED
>> +
>> +#include <linux/types.h>
>> +
>> +struct pci_dev;
>> +
>> +#define KFD_INTERFACE_VERSION 1
>> +
>> +struct kfd_dev;
>> +struct kgd_dev;
>> +
>> +struct kgd_mem;
>> +
>> +struct radeon_device;
>> +
>> +enum kgd_memory_pool {
>> +	KGD_POOL_SYSTEM_CACHEABLE = 1,
>> +	KGD_POOL_SYSTEM_WRITECOMBINE = 2,
>> +	KGD_POOL_FRAMEBUFFER = 3,
>> +};
>> +
>> +struct kgd2kfd_shared_resources {
>> +	unsigned int compute_vmid_bitmap; /* Bit n == 1 means VMID n is available for KFD. */
>> +
>> +	unsigned int first_compute_pipe; /* Compute pipes are counted starting from MEC0/pipe0 as 0. */
>> +	unsigned int compute_pipe_count; /* Number of MEC pipes available for KFD. */
>> +
>> +	phys_addr_t doorbell_physical_address; /* Base address of doorbell aperture. */
>> +	size_t doorbell_aperture_size; /* Size in bytes of doorbell aperture. */
>> +	size_t doorbell_start_offset; /* Number of bytes at start of aperture reserved for KGD. */
>> +};
>> +
>> +struct kgd2kfd_calls {
>> +	void (*exit)(void);
>> +	struct kfd_dev* (*probe)(struct kgd_dev *kgd, struct pci_dev *pdev);
>> +	bool (*device_init)(struct kfd_dev *kfd, const struct kgd2kfd_shared_resources *gpu_resources);
>> +	void (*device_exit)(struct kfd_dev *kfd);
>> +	void (*interrupt)(struct kfd_dev *kfd, const void *ih_ring_entry);
>> +	void (*suspend)(struct kfd_dev *kfd);
>> +	int (*resume)(struct kfd_dev *kfd);
>> +};
>> +
>> +struct kfd2kgd_calls {
>> +	/* Memory management. */
>> +	int (*allocate_mem)(struct kgd_dev *kgd,
>> +				size_t size,
>> +				size_t alignment,
>> +				enum kgd_memory_pool pool,
>> +				struct kgd_mem **memory_handle);
>> +
>> +	void (*free_mem)(struct kgd_dev *kgd, struct kgd_mem *memory_handle);
>> +
>> +	int (*gpumap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem, uint64_t *vmid0_address);
>> +	void (*ungpumap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
>> +
>> +	int (*kmap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem, void **ptr);
>> +	void (*unkmap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
>> +
>> +	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
>> +	uint64_t (*get_gpu_clock_counter)(struct kgd_dev *kgd);
>> +
>> +	uint32_t (*get_max_engine_clock_in_mhz)(struct kgd_dev *kgd);
>> +
>> +	/* Register access functions */
>> +	void (*program_sh_mem_settings)(struct kgd_dev *kgd, uint32_t vmid, uint32_t sh_mem_config,
>> +			uint32_t sh_mem_ape1_base, uint32_t sh_mem_ape1_limit, uint32_t sh_mem_bases);
>> +	int (*set_pasid_vmid_mapping)(struct kgd_dev *kgd, unsigned int pasid, unsigned int vmid);
>> +	int (*init_memory)(struct kgd_dev *kgd);
>> +	int (*init_pipeline)(struct kgd_dev *kgd, uint32_t pipe_id, uint32_t hpd_size, uint64_t hpd_gpu_addr);
>> +	int (*hqd_load)(struct kgd_dev *kgd, void *mqd, uint32_t pipe_id, uint32_t queue_id, uint32_t __user *wptr);
>> +	bool (*hqd_is_occupies)(struct kgd_dev *kgd, uint64_t queue_address, uint32_t pipe_id, uint32_t queue_id);
>> +	int (*hqd_destroy)(struct kgd_dev *kgd, bool is_reset, unsigned int timeout,
>> +				uint32_t pipe_id, uint32_t queue_id);
>> +};
> 
> Such interface should be documented looks at ttm or any other function structure
> inside the kernel for example on how to document those.
> 
Done in v3.

	Oded
>> +
>> +bool radeon_kfd_init(void);
>> +void radeon_kfd_fini(void);
>> +bool kgd2kfd_init(unsigned interface_version,
>> +		  const struct kfd2kgd_calls *f2g,
>> +		  const struct kgd2kfd_calls **g2f);
>> +
>> +void radeon_kfd_suspend(struct radeon_device *rdev);
>> +int radeon_kfd_resume(struct radeon_device *rdev);
>> +void radeon_kfd_interrupt(struct radeon_device *rdev,
>> +			const void *ih_ring_entry);
>> +void radeon_kfd_device_probe(struct radeon_device *rdev);
>> +void radeon_kfd_device_init(struct radeon_device *rdev);
>> +void radeon_kfd_device_fini(struct radeon_device *rdev);
>> +
>> +#endif
>> +
>> diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
>> index 35d9318..929beda 100644
>> --- a/drivers/gpu/drm/radeon/radeon_kms.c
>> +++ b/drivers/gpu/drm/radeon/radeon_kms.c
>> @@ -34,6 +34,8 @@
>>  #include <linux/slab.h>
>>  #include <linux/pm_runtime.h>
>>  
>> +#include "radeon_kfd.h"
>> +
>>  #if defined(CONFIG_VGA_SWITCHEROO)
>>  bool radeon_has_atpx(void);
>>  #else
>> @@ -63,6 +65,8 @@ int radeon_driver_unload_kms(struct drm_device *dev)
>>  
>>  	pm_runtime_get_sync(dev->dev);
>>  
>> +	radeon_kfd_device_fini(rdev);
>> +
>>  	radeon_acpi_fini(rdev);
>>  	
>>  	radeon_modeset_fini(rdev);
>> @@ -142,6 +146,9 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
>>  				"Error during ACPI methods call\n");
>>  	}
>>  
>> +	radeon_kfd_device_probe(rdev);
>> +	radeon_kfd_device_init(rdev);
>> +
>>  	if (radeon_is_px(dev)) {
>>  		pm_runtime_use_autosuspend(dev->dev);
>>  		pm_runtime_set_autosuspend_delay(dev->dev, 5000);
>> -- 
>> 1.9.1
>>
