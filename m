Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935403AbaH0PW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:22:59 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51781 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935376AbaH0PWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:55 -0400
Message-ID: <53FDF7B6.507@linaro.org>
Date: Wed, 27 Aug 2014 17:22:30 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: eric.auger@st.com, christoffer.dall@linaro.org, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, joel.schopp@amd.com, kim.phillips@freescale.com,
        linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: Re: [RFC 8/9] KVM: KVM-VFIO: add kvm_vfio_arch_data and accessors
References: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>	 <1408973264-30384-9-git-send-email-eric.auger@linaro.org> <1409079750.2906.130.camel@ul30vt.home>
In-Reply-To: <1409079750.2906.130.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 09:02 PM, Alex Williamson wrote:
> On Mon, 2014-08-25 at 15:27 +0200, Eric Auger wrote:
>> add a pointer to architecture specific data in kvm_vfio struct
>> add accessors to keep kvm_vfio private
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  arch/arm/include/asm/kvm_host.h |  8 ++++++++
>>  virt/kvm/vfio.c                 | 21 +++++++++++++++++++++
>>  2 files changed, 29 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 62cbf5b..4f1edbf 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -177,6 +177,14 @@ void kvm_vfio_device_put_external_user(struct vfio_device *vdev);
>>  int kvm_vfio_external_get_type(struct vfio_device *vdev);
>>  struct device *kvm_vfio_external_get_base_device(struct vfio_device *vdev);
>>  
>> +struct kvm_vfio;
>> +struct kvm_vfio_arch_data;
>> +void kvm_vfio_device_set_arch_data(struct kvm_vfio *kv,
>> +				   struct kvm_vfio_arch_data *ptr);
>> +struct kvm_vfio_arch_data *kvm_vfio_device_get_arch_data(struct kvm_vfio *kv);
>> +void kvm_vfio_lock(struct kvm_vfio *kv);
>> +void kvm_vfio_unlock(struct kvm_vfio *kv);
>> +
>>  /* We do not have shadow page tables, hence the empty hooks */
>>  static inline int kvm_age_hva(struct kvm *kvm, unsigned long hva)
>>  {
>> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
>> index f1c4e35..177b71e 100644
>> --- a/virt/kvm/vfio.c
>> +++ b/virt/kvm/vfio.c
>> @@ -28,6 +28,7 @@ struct kvm_vfio {
>>  	struct list_head group_list;
>>  	struct mutex lock;
>>  	bool noncoherent;
>> +	struct kvm_vfio_arch_data *arch_data;
>>  };
>>  
>>  static struct vfio_group *kvm_vfio_group_get_external_user(struct file *filep)
>> @@ -338,6 +339,26 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
>>  	return 0;
>>  }
>>  
>> +void kvm_vfio_device_set_arch_data(struct kvm_vfio *kv,
>> +				   struct kvm_vfio_arch_data *ptr)
>> +{
>> +	kv->arch_data = ptr;
>> +}
>> +
>> +struct kvm_vfio_arch_data *kvm_vfio_device_get_arch_data(struct kvm_vfio *kv)
>> +{
> 
> My preference would be s/get_//
ok
> 
>> +	return kv->arch_data;
>> +}
>> +
>> +void kvm_vfio_lock(struct kvm_vfio *kv)
>> +{
>> +	mutex_lock(&kv->lock);
>> +}
>> +
>> +void kvm_vfio_unlock(struct kvm_vfio *kv)
>> +{
>> +	mutex_unlock(&kv->lock);
>> +}
> 
> Gosh, what could go wrong...
Hum sorry I did not understand what you meant here

Thanks

Eric
> 
>>  
>>  struct kvm_device_ops kvm_vfio_ops = {
>>  	.name = "kvm-vfio",
> 
> 
> 

