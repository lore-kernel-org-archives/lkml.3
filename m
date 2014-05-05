Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbaEEO0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:26:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932720AbaEEO0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:26:35 -0400
Message-ID: <53679F96.3020300@redhat.com>
Date: Mon, 05 May 2014 16:26:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4] kvm/irqchip: Speed up KVM_SET_GSI_ROUTING
References: <1398703176-17812-1-git-send-email-pbonzini@redhat.com> <53679E6A.3060807@de.ibm.com>
In-Reply-To: <53679E6A.3060807@de.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/05/2014 16:21, Christian Borntraeger ha scritto:
> On 28/04/14 18:39, Paolo Bonzini wrote:
>> From: Christian Borntraeger <borntraeger@de.ibm.com>
>
> Given all your work, What about From: Paolo Bonzini <pbonzini@redhat.com>
> plus "Based on an inital patch from Christian Borntraeger"

No big deal, I don't care about authorship that much.

>> @@ -221,17 +225,18 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>>  	unsigned long flags = (unsigned long)key;
>>  	struct kvm_kernel_irq_routing_entry *irq;
>>  	struct kvm *kvm = irqfd->kvm;
>> +	int idx;
>>
>>  	if (flags & POLLIN) {
>> -		rcu_read_lock();
>> -		irq = rcu_dereference(irqfd->irq_entry);
>> +		idx = srcu_read_lock(&kvm->irq_srcu);
>> +		irq = srcu_dereference(irqfd->irq_entry, &kvm->irq_srcu);
>>  		/* An event has been signaled, inject an interrupt */
>>  		if (irq)
>>  			kvm_set_msi(irq, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1,
>>  					false);
>>  		else
>>  			schedule_work(&irqfd->inject);
>> -		rcu_read_unlock();
>> +		srcu_read_unlock(&kvm->irq_srcu, idx);
>>  	}
>>
>>  	if (flags & POLLHUP) {
>> @@ -363,7 +368,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>>  		}
>>
>>  		list_add_rcu(&irqfd->resampler_link, &irqfd->resampler->list);
>> -		synchronize_rcu();
>> +		synchronize_srcu(&kvm->irq_srcu);
>
> No idea what resampler is, can this become time critical as well - iow do we need expedited here?

It's for level-triggered interrupts.  I decided that if synchronize_rcu 
was good enough before, synchronize_srcu will do after the patch.

>> @@ -85,7 +86,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>>  	mutex_lock(&kvm->irq_lock);
>>  	hlist_del_init_rcu(&kian->link);
>>  	mutex_unlock(&kvm->irq_lock);
>> -	synchronize_rcu();
>> +	synchronize_srcu_expedited(&kvm->irq_srcu);
>
> Hmm, looks like all callers are slow path (shutdown, deregister assigned dev). Couldnt
> we use the non expedited variant?

... but I have screwed up this one.  Thanks, I'll change it.

>>  	r = kvm_arch_init_vm(kvm, type);
>>  	if (r)
>> -		goto out_err_nodisable;
>> +		goto out_err_no_disable;
>>
>>  	r = hardware_enable_all();
>>  	if (r)
>> -		goto out_err_nodisable;
>> +		goto out_err_no_disable;
>>
>>  #ifdef CONFIG_HAVE_KVM_IRQCHIP
>>  	INIT_HLIST_HEAD(&kvm->mask_notifier_list);
>> @@ -473,10 +473,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
>>  	r = -ENOMEM;
>>  	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
>>  	if (!kvm->memslots)
>> -		goto out_err_nosrcu;
>> +		goto out_err_no_srcu;
>>  	kvm_init_memslots_id(kvm);
>>  	if (init_srcu_struct(&kvm->srcu))
>> -		goto out_err_nosrcu;
>> +		goto out_err_no_srcu;
>> +	if (init_srcu_struct(&kvm->irq_srcu))
>> +		goto out_err_no_irq_srcu;
>>  	for (i = 0; i < KVM_NR_BUSES; i++) {
>>  		kvm->buses[i] = kzalloc(sizeof(struct kvm_io_bus),
>>  					GFP_KERNEL);
>> @@ -505,10 +507,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
>>  	return kvm;
>>
>>  out_err:
>> +	cleanup_srcu_struct(&kvm->irq_srcu);
>> +out_err_no_irq_srcu:
>>  	cleanup_srcu_struct(&kvm->srcu);
>> -out_err_nosrcu:
>> +out_err_no_srcu:
>>  	hardware_disable_all();
>> -out_err_nodisable:
>> +out_err_no_disable:
>
>
> the patch would be smaller without this change, but it makes the naming more consistent, so ok.

Yeah, out_err_noirq_srcu or out_err_noirqsrcu are both very ugly.

Thanks for the review, I'm making the small change to remove expedited 
and applying to kvm/queue.

Paolo

>
>>  	for (i = 0; i < KVM_NR_BUSES; i++)
>>  		kfree(kvm->buses[i]);
>>  	kfree(kvm->memslots);
>>
>

