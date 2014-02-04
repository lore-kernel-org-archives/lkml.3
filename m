Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaBDIDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:03:31 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59877 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaBDIDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:03:21 -0500
Message-ID: <52F09EC0.60201@ozlabs.ru>
Date: Tue, 04 Feb 2014 19:03:12 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        kvm-ppc@vger.kernel.org,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PPC: KVM: fix VCPU run for HV KVM
References: <1389338467-26303-1-git-send-email-aik@ozlabs.ru> <AF6669B4-EF1A-44BD-9034-8824EFD94B5B@suse.de>
In-Reply-To: <AF6669B4-EF1A-44BD-9034-8824EFD94B5B@suse.de>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 02:44 AM, Alexander Graf wrote:
> 
> On 10.01.2014, at 08:21, Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
> 
>> When write to MMIO happens and there is an ioeventfd for that and
>> is handled successfully, ioeventfd_write() returns 0 (success) and
>> kvmppc_handle_store() returns EMULATE_DONE. Then kvmppc_emulate_mmio()
>> converts EMULATE_DONE to RESUME_GUEST_NV and this broke from the loop.
>>
>> This adds handling of RESUME_GUEST_NV in kvmppc_vcpu_run_hv().
>>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Suggested-by: Paul Mackerras <paulus@samba.org>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>
>> This definitely needs a better commit message. Please, help.
>> ps. it seems like ioeventfd never worked on ppc64. hm.
>>
>> ---
>> arch/powerpc/kvm/book3s_hv.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 072287f..24f363f 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -1569,7 +1569,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_run *run, struct kvm_vcpu *vcpu)
>> 				vcpu->arch.fault_dar, vcpu->arch.fault_dsisr);
>> 			srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
>> 		}
>> -	} while (r == RESUME_GUEST);
>> +	} while ((r == RESUME_GUEST_NV) || (r == RESUME_GUEST));
> 
> How about
> 
>   while(!(r & RESUME_FLAG_HOST));


Rather "while(!(r & RESUME_FLAG_HOST) && (r > 0));" and still not obvious
that this is really better.

Paul agrees with the original patch (and made a better commit message for
our internal tree) but I just cannot make him reply in this thread, keep
constantly asking him but to no avail :)


> That should cover all RESUME_GUEST_XXX cases just fine. Apart from that
> I agree that we should check for ! FLAG_HOST bit rather than the actual
> RESUME_GUEST value in all case where we check for it (read: please
> update all places).

There are 3 places remotely similar to this and none of them requires a fix
like above.



-- 
Alexey
