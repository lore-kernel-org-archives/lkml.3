Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaBDIJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:09:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaBDIJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:09:49 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH] PPC: KVM: fix VCPU run for HV KVM
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <52F09EC0.60201@ozlabs.ru>
Date: Tue, 4 Feb 2014 09:09:44 +0100
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        kvm-ppc <kvm-ppc@vger.kernel.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <D4E5BCE4-99BA-40B3-8726-71E71168FC54@suse.de>
References: <1389338467-26303-1-git-send-email-aik@ozlabs.ru> <AF6669B4-EF1A-44BD-9034-8824EFD94B5B@suse.de> <52F09EC0.60201@ozlabs.ru>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04.02.2014, at 09:03, Alexey Kardashevskiy <aik@ozlabs.ru> wrote:

> On 01/13/2014 02:44 AM, Alexander Graf wrote:
>> 
>> On 10.01.2014, at 08:21, Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
>> 
>>> When write to MMIO happens and there is an ioeventfd for that and
>>> is handled successfully, ioeventfd_write() returns 0 (success) and
>>> kvmppc_handle_store() returns EMULATE_DONE. Then kvmppc_emulate_mmio()
>>> converts EMULATE_DONE to RESUME_GUEST_NV and this broke from the loop.
>>> 
>>> This adds handling of RESUME_GUEST_NV in kvmppc_vcpu_run_hv().
>>> 
>>> Cc: Michael S. Tsirkin <mst@redhat.com>
>>> Suggested-by: Paul Mackerras <paulus@samba.org>
>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>> ---
>>> 
>>> This definitely needs a better commit message. Please, help.
>>> ps. it seems like ioeventfd never worked on ppc64. hm.
>>> 
>>> ---
>>> arch/powerpc/kvm/book3s_hv.c | 2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>>> index 072287f..24f363f 100644
>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>> @@ -1569,7 +1569,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_run *run, struct kvm_vcpu *vcpu)
>>> 				vcpu->arch.fault_dar, vcpu->arch.fault_dsisr);
>>> 			srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
>>> 		}
>>> -	} while (r == RESUME_GUEST);
>>> +	} while ((r == RESUME_GUEST_NV) || (r == RESUME_GUEST));
>> 
>> How about
>> 
>>  while(!(r & RESUME_FLAG_HOST));
> 
> 
> Rather "while(!(r & RESUME_FLAG_HOST) && (r > 0));" and still not obvious
> that this is really better.
> 
> Paul agrees with the original patch (and made a better commit message for
> our internal tree) but I just cannot make him reply in this thread, keep
> constantly asking him but to no avail :)
> 
> 
>> That should cover all RESUME_GUEST_XXX cases just fine. Apart from that
>> I agree that we should check for ! FLAG_HOST bit rather than the actual
>> RESUME_GUEST value in all case where we check for it (read: please
>> update all places).
> 
> There are 3 places remotely similar to this and none of them requires a fix
> like above.

Not today. Then someone goes in and realizes that CEDE advanced version 8 should clear r15 at which point you have to set RESUME_GUEST_NV and are in the same mess again. Let's just always treat RESUME_GUEST_NV and RESUME_GUEST as identical when checking for it.

If you like, add a small helper like

static inline bool is_resume_guest(int r) {
  return (r == RESUME_GUEST || r == RESUME_GUEST_NV);
}

in a header and use that one instead. That way we're guaranteed to be consistent.


Alex

