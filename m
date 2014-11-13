Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaKMC2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:28:06 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65216 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaKMC2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:28:04 -0500
Message-ID: <546418A6.3000904@gmail.com>
Date: Thu, 13 Nov 2014 10:34:14 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: marc.zyngier@arm.com, gleb@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virt: kvm: arm: vgic: Return failure code '-EBUSY' when
 mutex_trylock() fails
References: <546376F7.90502@gmail.com> <20141112194144.GK19598@cbox>
In-Reply-To: <20141112194144.GK19598@cbox>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/14 3:41, Christoffer Dall wrote:
> On Wed, Nov 12, 2014 at 11:04:23PM +0800, Chen Gang wrote:
>> When mutex_trylock() fails, kvm_vgic_create() will not create 'vgic', so
>> it need return failure code '-EBUSY' instead of '0' to let outside know
>> about it.
> 
> I already sent a patch for the -EBUSY:
> https://lists.cs.columbia.edu/pipermail/kvmarm/2014-November/011936.html
> 

Yeah, really it is.

>>
>> Also simplify the code within kvm_vgic_create():
>>
>>  - kvm_for_each_vcpu() scanning once is enough for current case.
>>
>>  - Remove redundant variable 'vcpu_lock_idx'.
> 
> I don't like using the iterator variable for this kind of thing because
> it can really break in languages where i is out-of-scope after the loop
> and it is too easy to reuse the iterator variable in later versions of
> the code.
> 

For me, what you said is OK, we can still keep it no touch.

> That being said, the scanning once is slightly prettier I guess,
> but I'd rather not introduce the churn unless others (Marc) think this
> is a big win.
> 

If only merge the 2 scanning loops, it will not change much. And also
can let code simpler and clearer for readers (both are for processing
and checking '-EBUSY').

If possible, after your patch merges into linux next tree, I will send
the related improving patch for it.

Thanks.

> -Christoffer
> 
>>
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  virt/kvm/arm/vgic.c | 15 +++++++--------
>>  1 file changed, 7 insertions(+), 8 deletions(-)
>>
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 3aaca49..5846725 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -1933,7 +1933,7 @@ out:
>>  
>>  int kvm_vgic_create(struct kvm *kvm)
>>  {
>> -	int i, vcpu_lock_idx = -1, ret = 0;
>> +	int i, ret = 0;
>>  	struct kvm_vcpu *vcpu;
>>  
>>  	mutex_lock(&kvm->lock);
>> @@ -1949,13 +1949,12 @@ int kvm_vgic_create(struct kvm *kvm)
>>  	 * that no other VCPUs are run while we create the vgic.
>>  	 */
>>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>> -		if (!mutex_trylock(&vcpu->mutex))
>> +		if (!mutex_trylock(&vcpu->mutex)) {
>> +			ret = -EBUSY;
>>  			goto out_unlock;
>> -		vcpu_lock_idx = i;
>> -	}
>> -
>> -	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		}
>>  		if (vcpu->arch.has_run_once) {
>> +			mutex_unlock(&vcpu->mutex);
>>  			ret = -EBUSY;
>>  			goto out_unlock;
>>  		}
>> @@ -1968,8 +1967,8 @@ int kvm_vgic_create(struct kvm *kvm)
>>  	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
>>  
>>  out_unlock:
>> -	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
>> -		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
>> +	while (i-- > 0) {
>> +		vcpu = kvm_get_vcpu(kvm, i);
>>  		mutex_unlock(&vcpu->mutex);
>>  	}
>>  
>> -- 
>> 1.9.3

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
