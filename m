Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaG0KPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 06:15:52 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:20781
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751629AbaG0KPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 06:15:49 -0400
X-WSS-ID: 0N9D8I6-07-U9T-02
X-M-MSG: 
Message-ID: <53D4D13A.6000004@amd.com>
Date: Sun, 27 Jul 2014 13:15:22 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?windows-1252?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        =?windows-1252?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 21/25] amdkfd: Implement the create/destroy/update
 queue IOCTLs
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-22-git-send-email-oded.gabbay@amd.com>
 <20140720230916.GJ3068@gmail.com>
In-Reply-To: <20140720230916.GJ3068@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(51234002)(479174003)(189002)(199002)(51704005)(575784001)(86362001)(84676001)(105586002)(99396002)(65816999)(4396001)(87266999)(54356999)(101416001)(50986999)(76176999)(102836001)(64126003)(33656002)(80316001)(19580405001)(19580395003)(83322001)(44976005)(97736001)(110136001)(107046002)(106466001)(95666004)(83072002)(85852003)(85306003)(64706001)(47776003)(20776003)(50466002)(74662001)(74502001)(81342001)(23746002)(76482001)(92726001)(36756003)(81542001)(79102001)(92566001)(77982001)(87936001)(21056001)(68736004)(31966008)(46102001)(65956001)(80022001)(83506001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB038;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0285201563
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/14 02:09, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:29:28PM +0300, Oded Gabbay wrote:
>> From: Ben Goz <ben.goz@amd.com>
>>
>> Signed-off-by: Ben Goz <ben.goz@amd.com>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>   drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c | 133 +++++++++++++++++++++++++++-
>>   drivers/gpu/drm/radeon/amdkfd/kfd_priv.h    |   8 ++
>>   2 files changed, 138 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>> index d6580a6..a74693a 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>> @@ -119,17 +119,144 @@ static int kfd_open(struct inode *inode, struct file *filep)
>>
>>   static long kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *arg)
>>   {
>> -	return -ENODEV;
>> +	struct kfd_ioctl_create_queue_args args;
>> +	struct kfd_dev *dev;
>> +	int err = 0;
>> +	unsigned int queue_id;
>> +	struct kfd_process_device *pdd;
>> +	struct queue_properties q_properties;
>> +
>> +	memset(&q_properties, 0, sizeof(struct queue_properties));
>> +
>> +	if (copy_from_user(&args, arg, sizeof(args)))
>> +		return -EFAULT;
>> +
>> +	if (!access_ok(VERIFY_WRITE, args.read_pointer_address, sizeof(qptr_t))) {
>> +		pr_err("kfd: can't access read pointer");
>> +		return -EFAULT;
>> +	}
>> +
>> +	if (!access_ok(VERIFY_WRITE, args.write_pointer_address, sizeof(qptr_t))) {
>> +		pr_err("kfd: can't access write pointer");
>> +		return -EFAULT;
>> +	}
>> +
>> +	q_properties.is_interop = false;
>> +	q_properties.queue_percent = args.queue_percentage;
>> +	q_properties.priority = args.queue_priority;
>> +	q_properties.queue_address = args.ring_base_address;
>> +	q_properties.queue_size = args.ring_size;
>> +	q_properties.read_ptr = (qptr_t *) args.read_pointer_address;
>> +	q_properties.write_ptr = (qptr_t *) args.write_pointer_address;
>> +
>
> So there is still no sanity check on any of the argument especialy the queue_size.
> I might have missed it, if so i think it really should be here inside the ioctl
> function as is simpler to find.
>
Fixed in v3.
>> +
>> +	pr_debug("%s Arguments: Queue Percentage (%d, %d)\n"
>> +			"Queue Priority (%d, %d)\n"
>> +			"Queue Address (0x%llX, 0x%llX)\n"
>> +			"Queue Size (0x%llX, %u)\n"
>> +			"Queue r/w Pointers (0x%llX, 0x%llX)\n",
>> +			__func__,
>> +			q_properties.queue_percent, args.queue_percentage,
>> +			q_properties.priority, args.queue_priority,
>> +			q_properties.queue_address, args.ring_base_address,
>> +			q_properties.queue_size, args.ring_size,
>> +			(uint64_t) q_properties.read_ptr,
>> +			(uint64_t) q_properties.write_ptr);
>
> One pr_debug call perline.
>
Fixed in v3.
>> +
>> +	dev = kfd_device_by_id(args.gpu_id);
>> +	if (dev == NULL)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&p->mutex);
>> +
>> +	pdd = kfd_bind_process_to_device(dev, p);
>> +	if (IS_ERR(pdd) < 0) {
>> +		err = PTR_ERR(pdd);
>> +		goto err_bind_process;
>> +	}
>> +
>> +	pr_debug("kfd: creating queue for PASID %d on GPU 0x%x\n",
>> +			p->pasid,
>> +			dev->id);
>> +
>> +	err = pqm_create_queue(&p->pqm, dev, filep, &q_properties, 0, KFD_QUEUE_TYPE_COMPUTE, &queue_id);
>> +	if (err != 0)
>> +		goto err_create_queue;
>> +
>> +	args.queue_id = queue_id;
>> +	args.doorbell_address = (uint64_t)q_properties.doorbell_ptr;
>> +
>> +	if (copy_to_user(arg, &args, sizeof(args))) {
>> +		err = -EFAULT;
>> +		goto err_copy_args_out;
>> +	}
>> +
>> +	mutex_unlock(&p->mutex);
>> +
>> +	pr_debug("kfd: queue id %d was created successfully.\n"
>> +		 "     ring buffer address == 0x%016llX\n"
>> +		 "     read ptr address    == 0x%016llX\n"
>> +		 "     write ptr address   == 0x%016llX\n"
>> +		 "     doorbell address    == 0x%016llX\n",
>> +			args.queue_id,
>> +			args.ring_base_address,
>> +			args.read_pointer_address,
>> +			args.write_pointer_address,
>> +			args.doorbell_address);
>> +
>
> Ditto

Fixed in v3.
>
>> +	return 0;
>> +
>> +err_copy_args_out:
>> +	pqm_destroy_queue(&p->pqm, queue_id);
>> +err_create_queue:
>> +err_bind_process:
>> +	mutex_unlock(&p->mutex);
>> +	return err;
>>   }
>>
>>   static int kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p, void __user *arg)
>>   {
>> -	return -ENODEV;
>> +	int retval;
>> +	struct kfd_ioctl_destroy_queue_args args;
>> +
>> +	if (copy_from_user(&args, arg, sizeof(args)))
>> +		return -EFAULT;
>> +
>> +	pr_debug("kfd: destroying queue id %d for PASID %d\n",
>> +				args.queue_id,
>> +				p->pasid);
>> +
>> +	mutex_lock(&p->mutex);
>> +
>> +	retval = pqm_destroy_queue(&p->pqm, args.queue_id);
>> +
>> +	mutex_unlock(&p->mutex);
>> +	return retval;
>>   }
>>
>>   static int kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p, void __user *arg)
>>   {
>> -	return -ENODEV;
>> +	int retval;
>> +	struct kfd_ioctl_update_queue_args args;
>> +	struct queue_properties properties;
>> +
>> +	if (copy_from_user(&args, arg, sizeof(args)))
>> +		return -EFAULT;
>> +
>> +	properties.queue_address = args.ring_base_address;
>> +	properties.queue_size = args.ring_size;
>> +	properties.queue_percent = args.queue_percentage;
>> +	properties.priority = args.queue_priority;
>> +
>
> Would need sanity check on argument.

fixed in v3.
	Oded
>
>> +	pr_debug("kfd: updating queue id %d for PASID %d\n", args.queue_id, p->pasid);
>> +
>> +	mutex_lock(&p->mutex);
>> +
>> +	retval = pqm_update_queue(&p->pqm, args.queue_id, &properties);
>> +
>> +	mutex_unlock(&p->mutex);
>> +
>> +	return retval;
>>   }
>>
>>   static long kfd_ioctl_set_memory_policy(struct file *filep, struct kfd_process *p, void __user *arg)
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> index 8a1de68..7ea0e81 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> @@ -418,7 +418,15 @@ struct process_queue_node {
>>
>>   int pqm_init(struct process_queue_manager *pqm, struct kfd_process *p);
>>   void pqm_uninit(struct process_queue_manager *pqm);
>> +int pqm_create_queue(struct process_queue_manager *pqm,
>> +			    struct kfd_dev *dev,
>> +			    struct file *f,
>> +			    struct queue_properties *properties,
>> +			    unsigned int flags,
>> +			    enum kfd_queue_type type,
>> +			    unsigned int *qid);
>>   int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid);
>> +int pqm_update_queue(struct process_queue_manager *pqm, unsigned int qid, struct queue_properties *p);
>>
>>   /* Packet Manager */
>>
>> --
>> 1.9.1
>>

