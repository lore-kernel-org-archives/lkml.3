Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaKLTlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:41:32 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:62695 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKLTlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:41:31 -0500
Date: Wed, 12 Nov 2014 20:41:44 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: marc.zyngier@arm.com, gleb@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virt: kvm: arm: vgic: Return failure code '-EBUSY' when
 mutex_trylock() fails
Message-ID: <20141112194144.GK19598@cbox>
References: <546376F7.90502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546376F7.90502@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:04:23PM +0800, Chen Gang wrote:
> When mutex_trylock() fails, kvm_vgic_create() will not create 'vgic', so
> it need return failure code '-EBUSY' instead of '0' to let outside know
> about it.

I already sent a patch for the -EBUSY:
https://lists.cs.columbia.edu/pipermail/kvmarm/2014-November/011936.html

> 
> Also simplify the code within kvm_vgic_create():
> 
>  - kvm_for_each_vcpu() scanning once is enough for current case.
> 
>  - Remove redundant variable 'vcpu_lock_idx'.

I don't like using the iterator variable for this kind of thing because
it can really break in languages where i is out-of-scope after the loop
and it is too easy to reuse the iterator variable in later versions of
the code.

That being said, the scanning once is slightly prettier I guess,
but I'd rather not introduce the churn unless others (Marc) think this
is a big win.

-Christoffer

> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  virt/kvm/arm/vgic.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 3aaca49..5846725 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1933,7 +1933,7 @@ out:
>  
>  int kvm_vgic_create(struct kvm *kvm)
>  {
> -	int i, vcpu_lock_idx = -1, ret = 0;
> +	int i, ret = 0;
>  	struct kvm_vcpu *vcpu;
>  
>  	mutex_lock(&kvm->lock);
> @@ -1949,13 +1949,12 @@ int kvm_vgic_create(struct kvm *kvm)
>  	 * that no other VCPUs are run while we create the vgic.
>  	 */
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (!mutex_trylock(&vcpu->mutex))
> +		if (!mutex_trylock(&vcpu->mutex)) {
> +			ret = -EBUSY;
>  			goto out_unlock;
> -		vcpu_lock_idx = i;
> -	}
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		}
>  		if (vcpu->arch.has_run_once) {
> +			mutex_unlock(&vcpu->mutex);
>  			ret = -EBUSY;
>  			goto out_unlock;
>  		}
> @@ -1968,8 +1967,8 @@ int kvm_vgic_create(struct kvm *kvm)
>  	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
>  
>  out_unlock:
> -	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> -		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> +	while (i-- > 0) {
> +		vcpu = kvm_get_vcpu(kvm, i);
>  		mutex_unlock(&vcpu->mutex);
>  	}
>  
> -- 
> 1.9.3
