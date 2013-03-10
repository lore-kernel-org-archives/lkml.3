Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab3CJOyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 10:54:00 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:37565 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3CJOx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 10:53:58 -0400
Message-ID: <513C9E82.1020304@redhat.com>
Date: Sun, 10 Mar 2013 15:53:54 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets
 an INIT
References: <1362811713-25830-1-git-send-email-pbonzini@redhat.com> <20130310114646.GM11223@redhat.com>
In-Reply-To: <20130310114646.GM11223@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/03/2013 12:46, Gleb Natapov ha scritto:
> On Sat, Mar 09, 2013 at 07:48:33AM +0100, Paolo Bonzini wrote:
>> After receiving an INIT signal (either via the local APIC, or through
>> KVM_SET_MP_STATE), the bootstrap processor should reset immediately
>> and start execution at 0xfffffff0.  Also, SIPIs have no effect on the
>> bootstrap processor.  However, KVM currently does not differentiate
>> between the BSP and APs.
>>
> Userspace is capable of resetting vcpu by itself, so adding code to
> handle KVM_SET_MP_STATE(INIT) looks unnecessary to me. I think the
> simple patch below (not tested) should handle INIT for in-kernel irq chip
> and userspace does not need special handling for cpu reset. It already
> knows how to reset cpu on system_reset, so reseting only cpus should not
> be different.

At least you'll need the last two hunks, moving the check for
KVM_MP_STATE_SIPI_RECEIVED before kvm_vcpu_block, but yes---something
like this could work.

However, it would effectively redefine the meaning of
KVM_MP_STATE_INIT_RECEIVED and KVM_MP_STATE_SIPI_RECEIVED, respectively
to KVM_MP_STATE_WAIT_FOR_SIPI and KVM_MP_STATE_RESETTING.  I wasn't sure
if this is considered an API change (personally, I would treat it as one).

Paolo

> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 02b51dd..6cb3c21 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -731,7 +731,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>  	case APIC_DM_INIT:
>  		if (!trig_mode || level) {
>  			result = 1;
> -			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> +			vcpu->arch.mp_state = kvm_vcpu_is_bsp(vcpu) ?
> +				KVM_MP_STATE_SIPI_RECEIVED :
> +				KVM_MP_STATE_INIT_RECEIVED;
>  			kvm_make_request(KVM_REQ_EVENT, vcpu);
>  			kvm_vcpu_kick(vcpu);
>  		} else {
> --
> 			Gleb.
> 

