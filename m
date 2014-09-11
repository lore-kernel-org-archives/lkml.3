Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaIKK0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:26:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:5768 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754105AbaIKKZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:25:58 -0400
X-IronPort-AV: E=Sophos;i="5.04,504,1406563200"; 
   d="scan'208";a="35809540"
Message-ID: <541178E1.3080503@cn.fujitsu.com>
Date: Thu, 11 Sep 2014 18:26:41 +0800
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, <gleb@kernel.org>,
        <mtosatti@redhat.com>, <nadav.amit@gmail.com>, <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v5 3/7] kvm: Make init_rmode_identity_map() return 0 on
 success.
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com> <1410413886-32213-4-git-send-email-tangchen@cn.fujitsu.com> <541168AB.9070101@redhat.com>
In-Reply-To: <541168AB.9070101@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/11/2014 05:17 PM, Paolo Bonzini wrote:
> ......
> @@ -7645,7 +7642,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>   			kvm->arch.ept_identity_map_addr =
>   				VMX_EPT_IDENTITY_PAGETABLE_ADDR;
>   		err = -ENOMEM;
> -		if (!init_rmode_identity_map(kvm))
> +		if (init_rmode_identity_map(kvm))
> Please add "< 0" here.  I would also consider setting err to the return
> value of init_rmode_identity_map, and initializing it to -ENOMEM only
> after the "if".
>
I'd like to move err = -ENOMEM to the following place:

vmx_create_vcpu()
{
     ......
     err = kvm_vcpu_init(&vmx->vcpu, kvm, id);
     if (err)
         goto free_vcpu;

     err = -ENOMEM;              ---------------------- move it here

     vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
     ....
     vmx->loaded_vmcs->vmcs = alloc_vmcs();
     ....
}

So that it can be used to handle the next two memory allocation error.

Thanks.
