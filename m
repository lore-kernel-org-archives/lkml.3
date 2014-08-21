Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaHUTJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:09:15 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49511 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaHUTJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:09:13 -0400
Message-ID: <53F6440B.8010709@linux.vnet.ibm.com>
Date: Fri, 22 Aug 2014 00:40:03 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 4/7] KVM: VMX: dynamise PLE window
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com> <1408637291-18533-5-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-5-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082119-0005-0000-0000-0000009E0BCF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 09:38 PM, Radim Krčmář wrote:
> Window is increased on every PLE exit and decreased on every sched_in.
> The idea is that we don't want to PLE exit if there is no preemption
> going on.
> We do this with sched_in() because it does not hold rq lock.
>
> There are two new kernel parameters for changing the window:
>   ple_window_grow and ple_window_shrink
> ple_window_grow affects the window on PLE exit and ple_window_shrink
> does it on sched_in;  depending on their value, the window is modifier
> like this: (ple_window is kvm_intel's global)
>
>    ple_window_shrink/ |
>    ple_window_grow    | PLE exit           | sched_in
>    -------------------+--------------------+---------------------
>    < 1                |  = ple_window      |  = ple_window
>    < ple_window       | *= ple_window_grow | /= ple_window_shrink
>    otherwise          | += ple_window_grow | -= ple_window_shrink
>
> A third new parameter, ple_window_max, controls the maximal ple_window;
> it is internally rounded down to a closest multiple of ple_window_grow.
>
> VCPU's PLE window is never allowed below ple_window.
>
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>   arch/x86/kvm/vmx.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 85 insertions(+), 2 deletions(-)
>

Thanks for the nice patch.
default of grow = 2 and shrink = 0 is very good, which aids fast
clamping in overcommit and less ple_exits in undercommit.
with a small concern over modifier (shrinker) value in patch 6,

Reviewed-by: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>

> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 18e0e52..a2fa6ba 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -125,14 +125,32 @@ module_param(nested, bool, S_IRUGO);
>    * Time is measured based on a counter that runs at the same rate as the TSC,
>    * refer SDM volume 3b section 21.6.13 & 22.1.3.
>    */
> -#define KVM_VMX_DEFAULT_PLE_GAP    128
> -#define KVM_VMX_DEFAULT_PLE_WINDOW 4096
> +#define KVM_VMX_DEFAULT_PLE_GAP           128
> +#define KVM_VMX_DEFAULT_PLE_WINDOW        4096
> +#define KVM_VMX_DEFAULT_PLE_WINDOW_GROW   2
> +#define KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK 0
> +#define KVM_VMX_DEFAULT_PLE_WINDOW_MAX    \
> +		INT_MAX / KVM_VMX_DEFAULT_PLE_WINDOW_GROW
> +
>   static int ple_gap = KVM_VMX_DEFAULT_PLE_GAP;
>   module_param(ple_gap, int, S_IRUGO);
>
>   static int ple_window = KVM_VMX_DEFAULT_PLE_WINDOW;
>   module_param(ple_window, int, S_IRUGO);
>
> +/* Default doubles per-vcpu window every exit. */
> +static int ple_window_grow = KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
> +module_param(ple_window_grow, int, S_IRUGO);
> +
> +/* Default resets per-vcpu window every exit to ple_window. */
> +static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
> +module_param(ple_window_shrink, int, S_IRUGO);
> +
> +/* Default is to compute the maximum so we can never overflow. */
> +static int ple_window_actual_max = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
> +static int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
> +module_param(ple_window_max, int, S_IRUGO);

Some observations:

1. I think a large ple_window for e.g.,  16MB itself
would be very large value after which the ple_window change would not
have much effect.

So could KVM_VMX_DEFAULT_PLE_WINDOW_MAX be just
KVM_VMX_DEFAULT_PLE_WINDOW^2 or something ? or otherwise..

How about ..
define KVM_VMX_DEFAULT_PLE_WINDOW_MAX  = INT_MAX 
/KVM_VMX_DEFAULT_PLE_WINDOW.

(considering we don't allow default grow to be greater than default ple
window).

2. can we consider min_ple_window value of 2k. tracing showed that in
overcommit there were several occations of 4k <- 4k situations.

3. Do you think using ( << and >> ) instead of (*, /) saves some cycles
considering we could have potentially have grow,shrink numbers != power of 2

> +
>   extern const ulong vmx_return;
>
>   #define NR_AUTOLOAD_MSRS 8
> @@ -5679,12 +5697,73 @@ out:
>   	return ret;
>   }
>
> +static int __grow_ple_window(int val)
> +{
> +	if (ple_window_grow < 1)

why not ple_window_grow <= 1 ?


> +		return ple_window;
> +
> +	val = min(val, ple_window_actual_max);
> +
> +	if (ple_window_grow < ple_window)
> +		val *= ple_window_grow;
> +	else
> +		val += ple_window_grow;
> +
> +	return val;
> +}
> +
> +static int __shrink_ple_window(int val, int modifier, int minimum)
> +{
> +	if (modifier < 1)

why not modifier < 1. May be this would address a concern in patch 6.

> +		return ple_window;
> +
> +	if (modifier < ple_window)
> +		val /= modifier;
> +	else
> +		val -= modifier;
> +
> +	return max(val, minimum);
> +}
> +
> +static void grow_ple_window(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	vmx->ple_window = __grow_ple_window(vmx->ple_window);
> +}
> +
> +static void shrink_ple_window(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	vmx->ple_window = __shrink_ple_window(vmx->ple_window,
> +	                                      ple_window_shrink, ple_window);
> +}
> +
> +/*
> + * ple_window_actual_max is computed to be one grow_ple_window() below
> + * ple_window_max. (See __grow_ple_window for the reason.)
> + * This prevents overflows, because ple_window_max is int.
> + * ple_window_max effectively rounded down to a multiple of ple_window_grow in
> + * this process.
> + * ple_window_max is also prevented from setting vmx->ple_window < ple_window.
> + */
> +static void update_ple_window_actual_max(void)
> +{
> +	ple_window_actual_max =
> +			__shrink_ple_window(max(ple_window_max, ple_window),
> +			                    ple_window_grow, INT_MIN);
> +}
> +
>   /*
>    * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
>    * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
>    */
>   static int handle_pause(struct kvm_vcpu *vcpu)
>   {
> +	if (ple_gap)
> +		grow_ple_window(vcpu);
> +
>   	skip_emulated_instruction(vcpu);
>   	kvm_vcpu_on_spin(vcpu);
>
> @@ -8854,6 +8933,8 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
>
>   void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
>   {
> +	if (ple_gap)
> +		shrink_ple_window(vcpu);
>   }
>
>   static struct kvm_x86_ops vmx_x86_ops = {
> @@ -9077,6 +9158,8 @@ static int __init vmx_init(void)
>   	} else
>   		kvm_disable_tdp();
>
> +	update_ple_window_actual_max();
> +
>   	return 0;
>
>   out7:
>

