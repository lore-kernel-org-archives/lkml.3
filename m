Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934592Ab3DOMyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:54:18 -0400
Received: from goliath.siemens.de ([192.35.17.28]:25067 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3DOMyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:54:17 -0400
Message-ID: <516BF874.7020608@siemens.com>
Date: Mon, 15 Apr 2013 14:54:12 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnatapov@redhat.com" <gnatapov@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] kvm: nVMX: check vmcs12 for valid activity state
References: <1366029996-3284-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1366029996-3284-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-04-15 14:46, Paolo Bonzini wrote:
> KVM does not use the activity state VMCS field, and does not support
> it in nested VMX either (the corresponding bits in the misc VMX feature
> MSR are zero).  Fail entry if the activity state is set to anything but
> "active".

Ah, that indeed simplifies the issue.

> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index c75c25d..589e79a 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -7223,6 +7223,11 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  		return 1;
>  	}
>  
> +	if (vmcs12->guest_activity_state != 0) {

GUEST_ACTIVITY_ACTIVE, please.

> +		nested_vmx_failValid(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
> +		return 1;
> +	}
> +
>  	if ((vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_MSR_BITMAPS) &&
>  			!IS_ALIGNED(vmcs12->msr_bitmap, PAGE_SIZE)) {
>  		/*TODO: Also verify bits beyond physical address width are 0*/
> 

That means we also do not need to read and write the corresponding VMCS
field on L1/L2 transitions - avoids any risk of setting it to an
unsupported value. So I would fold it into this change.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
