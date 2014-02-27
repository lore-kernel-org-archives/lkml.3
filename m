Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaB0LZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:25:25 -0500
Received: from goliath.siemens.de ([192.35.17.28]:41304 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaB0LZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:25:20 -0500
Message-ID: <530F2098.1040100@siemens.com>
Date: Thu, 27 Feb 2014 12:25:12 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, alex.williamson@redhat.com, mtosatti@redhat.com,
        gleb@kernel.org
Subject: Re: [PATCH 4/4] KVM: vmx: Allow the guest to run with dirty debug
 registers
References: <1393429753-20857-1-git-send-email-pbonzini@redhat.com> <1393429753-20857-5-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1393429753-20857-5-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-26 16:49, Paolo Bonzini wrote:
> When not running in guest-debug mode (i.e. the guest controls the debug
> registers, having to take an exit for each DR access is a waste of time.
> If the guest gets into a state where each context switch causes DR to be
> saved and restored, this can take away as much as 40% of the execution
> time from the guest.
> 
> If the guest is running with vcpu->arch.db == vcpu->arch.eff_db, we
> can let it write freely to the debug registers and reload them on the
> next exit.  We still need to exit on the first access, so that the
> KVM_DEBUGREG_WONT_EXIT flag is set in switch_db_regs; after that, further
> accesses to the debug registers will not cause a vmexit.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 6e57e1434cf3..71c57ec48d8f 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -2851,7 +2851,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
>  		      vmx_capability.ept, vmx_capability.vpid);
>  	}
>  
> -	min = 0;
> +	min = VM_EXIT_SAVE_DEBUG_CONTROLS;
>  #ifdef CONFIG_X86_64
>  	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
>  #endif
> @@ -5121,6 +5121,22 @@ static int handle_dr(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> +	if (vcpu->guest_debug == 0) {
> +		u32 cpu_based_vm_exec_control;
> +
> +		cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
> +		cpu_based_vm_exec_control &= ~CPU_BASED_MOV_DR_EXITING;
> +		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
> +
> +		/*
> +		 * No more DR vmexits; force a reload of the debug registers
> +		 * and reenter on this instruction.  The next vmexit will
> +		 * retrieve the full state of the debug registers.
> +		 */
> +		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
> +		return 1;
> +	}
> +
>  	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
>  	dr = exit_qualification & DEBUG_REG_ACCESS_NUM;
>  	reg = DEBUG_REG_ACCESS_REG(exit_qualification);
> @@ -5147,6 +5163,18 @@ static void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
>  {
>  }
>  
> +static u64 vmx_get_dr7(struct kvm_vcpu *vcpu)
> +{
> +	/* DRs are being synced back to vcpu->arch, exit on DR access.  */
> +	u32 cpu_based_vm_exec_control;
> +
> +	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
> +	cpu_based_vm_exec_control |= CPU_BASED_MOV_DR_EXITING;
> +	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
> +
> +	return vmcs_readl(GUEST_DR7);
> +}

The general idea looks ok (It passes x86/debug.flat unit test, right?).
But this side effect of get_dr7 seems a bit ugly to me. Also the
imbalanced updates of arch.switch_db_regs: KVM_DEBUGREG_WONT_EXIT is set
by the vendor code but cleared in a common x86 path. Can't you make this
more regular and explicit?

Jan

> +
>  static void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
>  {
>  	vmcs_writel(GUEST_DR7, val);
> @@ -8606,6 +8634,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
>  	.set_gdt = vmx_set_gdt,
>  	.get_dr6 = vmx_get_dr6,
>  	.set_dr6 = vmx_set_dr6,
> +	.get_dr7 = vmx_get_dr7,
>  	.set_dr7 = vmx_set_dr7,
>  	.cache_reg = vmx_cache_reg,
>  	.get_rflags = vmx_get_rflags,
> 

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
