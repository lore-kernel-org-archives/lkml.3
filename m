Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaIKRb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:31:58 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55479 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaIKRb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:31:56 -0400
Message-ID: <5411DC70.5060104@linaro.org>
Date: Thu, 11 Sep 2014 19:31:28 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [RFC v2 2/9] KVM: ARM: VGIC: add forwarded irq rbtree lock
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org> <1409575968-5329-3-git-send-email-eric.auger@linaro.org> <20140911030953.GD2784@lvm>
In-Reply-To: <20140911030953.GD2784@lvm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 05:09 AM, Christoffer Dall wrote:
> On Mon, Sep 01, 2014 at 02:52:41PM +0200, Eric Auger wrote:
>> add a lock related to the rb tree manipulation. The rb tree can be
> 
> Ok, I can't hold myself back any longer. 


 Please begin sentences with a
> capital letter. You don't do this in French? :)
Hi Christoffer,


yep that's understood ;-) Definitively we do. Just that I am discovering
it is common too in commits and comments ;-)
> 
>> searched in one thread (irqfd handler for instance) and map/unmap
>> happen in another.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  include/kvm/arm_vgic.h |  1 +
>>  virt/kvm/arm/vgic.c    | 46 +++++++++++++++++++++++++++++++++++++---------
>>  2 files changed, 38 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>> index 743020f..3da244f 100644
>> --- a/include/kvm/arm_vgic.h
>> +++ b/include/kvm/arm_vgic.h
>> @@ -177,6 +177,7 @@ struct vgic_dist {
>>  	unsigned long		irq_pending_on_cpu;
>>  
>>  	struct rb_root		irq_phys_map;
>> +	spinlock_t			rb_tree_lock;
>>  #endif
>>  };
>>  
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 8ef495b..dbc2a5a 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -1630,9 +1630,15 @@ static struct rb_root *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
>>  
>>  int vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
>>  {
>> -	struct rb_root *root = vgic_get_irq_phys_map(vcpu, virt_irq);
>> -	struct rb_node **new = &root->rb_node, *parent = NULL;
>> +	struct rb_root *root;
>> +	struct rb_node **new, *parent = NULL;
>>  	struct irq_phys_map *new_map;
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +
>> +	spin_lock(&dist->rb_tree_lock);
>> +
>> +	root = vgic_get_irq_phys_map(vcpu, virt_irq);
>> +	new = &root->rb_node;
>>  
>>  	/* Boilerplate rb_tree code */
>>  	while (*new) {
>> @@ -1644,13 +1650,17 @@ int vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
>>  			new = &(*new)->rb_left;
>>  		else if (this->virt_irq > virt_irq)
>>  			new = &(*new)->rb_right;
>> -		else
>> +		else {
>> +			spin_unlock(&dist->rb_tree_lock);
>>  			return -EEXIST;
>> +		}
> 
> can you initialize a ret variable to -EEXIST in the beginning of this
> function, and add an out label above the unlock below, replace this
> multi-line statement with a goto out, and set ret = 0 after the while
> loop?
sure
> 
>>  	}
>>  
>>  	new_map = kzalloc(sizeof(*new_map), GFP_KERNEL);
>> -	if (!new_map)
>> +	if (!new_map) {
>> +		spin_unlock(&dist->rb_tree_lock);
>>  		return -ENOMEM;
> 
> then this becomes ret = -ENOMEM; goto out;
OK
> 
>> +	}
>>  
>>  	new_map->virt_irq = virt_irq;
>>  	new_map->phys_irq = phys_irq;
>> @@ -1658,6 +1668,8 @@ int vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
>>  	rb_link_node(&new_map->node, parent, new);
>>  	rb_insert_color(&new_map->node, root);
>>  
>> +	spin_unlock(&dist->rb_tree_lock);
>> +
> 
> aren't you allocating memory with GFP_KERNEL while holding a spinlock
> here?
oups. Thanks for noticing. I Will move the lock.
> 
>>  	return 0;
>>  }
>>  
>> @@ -1685,24 +1697,39 @@ static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
>>  
>>  int vgic_get_phys_irq(struct kvm_vcpu *vcpu, int virt_irq)
>>  {
>> -	struct irq_phys_map *map = vgic_irq_map_search(vcpu, virt_irq);
>> +	struct irq_phys_map *map;
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +	int ret;
>> +
>> +	spin_lock(&dist->rb_tree_lock);
>> +	map = vgic_irq_map_search(vcpu, virt_irq);
>>  
>>  	if (map)
>> -		return map->phys_irq;
>> +		ret = map->phys_irq;
>> +	else
>> +		ret =  -ENOENT;
> 
> initialize ret to -ENOENT and avoid the else statement.
ok
> 
>> +
>> +	spin_unlock(&dist->rb_tree_lock);
>> +	return ret;
>>  
>> -	return -ENOENT;
>>  }
>>  
>>  int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
>>  {
>> -	struct irq_phys_map *map = vgic_irq_map_search(vcpu, virt_irq);
>> +	struct irq_phys_map *map;
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> +
>> +	spin_lock(&dist->rb_tree_lock);
>> +
>> +	map = vgic_irq_map_search(vcpu, virt_irq);
>>  
>>  	if (map && map->phys_irq == phys_irq) {
>>  		rb_erase(&map->node, vgic_get_irq_phys_map(vcpu, virt_irq));
>>  		kfree(map);
>> +		spin_unlock(&dist->rb_tree_lock);
> 
> can kfree sleep?  I don't remember.  In any case, you can unlock before
> calling kfree.
no it can't but I will move anyway.
> 
>>  		return 0;
>>  	}
>> -
>> +	spin_unlock(&dist->rb_tree_lock);
>>  	return -ENOENT;
> 
> an out label and single unlock location would be preferred here as well
> I think.
ok

Thansk

Eric
> 
>>  }
>>  
>> @@ -1898,6 +1925,7 @@ int kvm_vgic_create(struct kvm *kvm)
>>  	}
>>  
>>  	spin_lock_init(&kvm->arch.vgic.lock);
>> +	spin_lock_init(&kvm->arch.vgic.rb_tree_lock);
>>  	kvm->arch.vgic.in_kernel = true;
>>  	kvm->arch.vgic.vctrl_base = vgic->vctrl_base;
>>  	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
>> -- 
>> 1.9.1
>>

