Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3FZGyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:54:50 -0400
Received: from mail1.windriver.com ([147.11.146.13]:64204 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3FZGyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:54:47 -0400
Message-ID: <51CA903A.4070809@windriver.com>
Date: Wed, 26 Jun 2013 14:54:50 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bharat Bhushan <r65777@freescale.com>
CC: <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <mikey@neuling.org>, Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: Re: [PATCH 4/6 v5] KVM: PPC: exit to user space on "ehpriv" instruction
References: <1372225346-5029-1-git-send-email-Bharat.Bhushan@freescale.com> <1372225346-5029-5-git-send-email-Bharat.Bhushan@freescale.com>
In-Reply-To: <1372225346-5029-5-git-send-email-Bharat.Bhushan@freescale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.212]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 01:42 PM, Bharat Bhushan wrote:
> "ehpriv" instruction is used for setting software breakpoints
> by user space. This patch adds support to exit to user space
> with "run->debug" have relevant information.
>
> As this is the first point we are using run->debug, also defined
> the run->debug structure.
>
> Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> ---
>   arch/powerpc/include/asm/disassemble.h |    4 ++++
>   arch/powerpc/include/uapi/asm/kvm.h    |   21 +++++++++++++++++----
>   arch/powerpc/kvm/e500_emulate.c        |   27 +++++++++++++++++++++++++++
>   3 files changed, 48 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/disassemble.h b/arch/powerpc/include/asm/disassemble.h
> index 9b198d1..856f8de 100644
> --- a/arch/powerpc/include/asm/disassemble.h
> +++ b/arch/powerpc/include/asm/disassemble.h
> @@ -77,4 +77,8 @@ static inline unsigned int get_d(u32 inst)
>   	return inst & 0xffff;
>   }
>
> +static inline unsigned int get_oc(u32 inst)
> +{
> +	return (inst >> 11) & 0x7fff;
> +}
>   #endif /* __ASM_PPC_DISASSEMBLE_H__ */
> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
> index 0fb1a6e..ded0607 100644
> --- a/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> @@ -269,7 +269,24 @@ struct kvm_fpu {
>   	__u64 fpr[32];
>   };
>
> +/*
> + * Defines for h/w breakpoint, watchpoint (read, write or both) and
> + * software breakpoint.
> + * These are used as "type" in KVM_SET_GUEST_DEBUG ioctl and "status"
> + * for KVM_DEBUG_EXIT.
> + */
> +#define KVMPPC_DEBUG_NONE		0x0
> +#define KVMPPC_DEBUG_BREAKPOINT		(1UL << 1)
> +#define KVMPPC_DEBUG_WATCH_WRITE	(1UL << 2)
> +#define KVMPPC_DEBUG_WATCH_READ		(1UL << 3)
>   struct kvm_debug_exit_arch {
> +	__u64 address;
> +	/*
> +	 * exiting to userspace because of h/w breakpoint, watchpoint
> +	 * (read, write or both) and software breakpoint.
> +	 */
> +	__u32 status;
> +	__u32 reserved;
>   };
>
>   /* for KVM_SET_GUEST_DEBUG */
> @@ -281,10 +298,6 @@ struct kvm_guest_debug_arch {
>   		 * Type denotes h/w breakpoint, read watchpoint, write
>   		 * watchpoint or watchpoint (both read and write).
>   		 */
> -#define KVMPPC_DEBUG_NONE		0x0
> -#define KVMPPC_DEBUG_BREAKPOINT		(1UL << 1)
> -#define KVMPPC_DEBUG_WATCH_WRITE	(1UL << 2)
> -#define KVMPPC_DEBUG_WATCH_READ		(1UL << 3)
>   		__u32 type;
>   		__u32 reserved;
>   	} bp[16];
> diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
> index b10a012..dab9d07 100644
> --- a/arch/powerpc/kvm/e500_emulate.c
> +++ b/arch/powerpc/kvm/e500_emulate.c
> @@ -26,6 +26,8 @@
>   #define XOP_TLBRE   946
>   #define XOP_TLBWE   978
>   #define XOP_TLBILX  18
> +#define XOP_EHPRIV  270
> +#define EHPRIV_OC_DEBUG 0

As I think the case, "OC = 0", is a bit specific since IIRC, if the OC
operand is omitted, its equal 0 by default. So I think we should start this OC 
value from 1 or other magic number.

And if possible, we'd better add some comments to describe this to make the OC 
definition readable.

Tiejun

>
>   #ifdef CONFIG_KVM_E500MC
>   static int dbell2prio(ulong param)
> @@ -82,6 +84,26 @@ static int kvmppc_e500_emul_msgsnd(struct kvm_vcpu *vcpu, int rb)
>   }
>   #endif
>
> +static int kvmppc_e500_emul_ehpriv(struct kvm_run *run, struct kvm_vcpu *vcpu,
> +				   unsigned int inst, int *advance)
> +{
> +	int emulated = EMULATE_DONE;
> +
> +	switch (get_oc(inst)) {
> +	case EHPRIV_OC_DEBUG:
> +		run->exit_reason = KVM_EXIT_DEBUG;
> +		run->debug.arch.address = vcpu->arch.pc;
> +		run->debug.arch.status = 0;
> +		kvmppc_account_exit(vcpu, DEBUG_EXITS);
> +		emulated = EMULATE_EXIT_USER;
> +		*advance = 0;
> +		break;
> +	default:
> +		emulated = EMULATE_FAIL;
> +	}
> +	return emulated;
> +}
> +
>   int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
>                              unsigned int inst, int *advance)
>   {
> @@ -130,6 +152,11 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
>   			emulated = kvmppc_e500_emul_tlbivax(vcpu, ea);
>   			break;
>
> +		case XOP_EHPRIV:
> +			emulated = kvmppc_e500_emul_ehpriv(run, vcpu, inst,
> +							   advance);
> +			break;
> +
>   		default:
>   			emulated = EMULATE_FAIL;
>   		}
>

