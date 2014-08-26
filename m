Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892AbaHZEGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:06:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:19892 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaHZEGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,401,1406617200"; 
   d="scan'208";a="593268111"
Date: Tue, 26 Aug 2014 12:07:49 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix xen guest panic due to lack of
 KVM_REQ_EVENT
Message-ID: <20140826040749.GA6746@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408953506-7289-1-git-send-email-wanpeng.li@linux.intel.com>
 <53FAFB53.7040806@redhat.com>
 <20140825090822.GA4955@kernel>
 <53FAFEE0.9000408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FAFEE0.9000408@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 11:16:16AM +0200, Paolo Bonzini wrote:
>Il 25/08/2014 11:08, Wanpeng Li ha scritto:
>> Hi Paolo,
>> On Mon, Aug 25, 2014 at 11:01:07AM +0200, Paolo Bonzini wrote:
>>> Il 25/08/2014 09:58, Wanpeng Li ha scritto:
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index c10408e..b7c0073 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -4928,6 +4928,8 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>>>>  		if (!mask)
>>>>  			kvm_make_request(KVM_REQ_EVENT, vcpu);
>>>>  	}
>>>> +	if (!(int_shadow || mask))
>>>> +		kvm_make_request(KVM_REQ_EVENT, vcpu);
>>>>  }
>>>>  
>>>>  static void inject_emulated_exception(struct kvm_vcpu *vcpu)
>>>
>>> No, this patch undoes the optimization in the buggy patch.
>>>
>>> A KVM_REQ_EVENT must be missing somewhere else.
>>>
>> 
>> Could you give some tips in order that I can figure it out?
>
>I have no idea right now (I was planning to debug it this week).
>
>(BTW, look at the original commit that introduced KVM_REQ_EVENT --
>https://git.kernel.org/cgit/virt/kvm/kvm.git/commit/?id=3842d135 -- and
>compare the patch and the commit message.  You can see that it was added
>to the emulator because it is a "place that can set EFLAGS" and this
>idea is preserved in the buggy patch).
>

>From xen codes which report panic:

check_timer 
	timer_irq_works

	local_save_flags(flags);  => pushf;pop
	local_irq_enable();       => sti 
	delay xxxx 
	local_irq_restore(flags); => pushfq;andq;orq;popfq 

Regards,
Wanpeng Li 

>The important thing is that (despite Xen being involved) this is not
>related to nested virtualization.  So I would first of all try to see if
>some module parameter makes it go away (apicv and unrestricted mode
>especially), then capture a trace of the panic.  At least this is how I
>was planning to start... :)
>
>Paolo
