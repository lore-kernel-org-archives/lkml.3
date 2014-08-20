Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaHTHQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:16:23 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52513 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaHTHQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:16:21 -0400
Message-ID: <53F44B40.6060806@redhat.com>
Date: Wed, 20 Aug 2014 09:16:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 9/9] KVM: VMX: automatic PLE window maximum
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com> <1408480536-8240-10-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-10-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2014 22:35, Radim Krčmář ha scritto:
> Every increase of ple_window_grow creates potential overflows.
> They are not serious, because we clamp ple_window and userspace is
> expected to fix ple_window_max within a second.
> ---
>  arch/x86/kvm/vmx.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index d7f58e8..6873a0b 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -138,7 +138,9 @@ module_param(ple_window, int, S_IRUGO | S_IWUSR);
>  
>  /* Default doubles per-vcpu window every exit. */
>  static int ple_window_grow = KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
> -module_param(ple_window_grow, int, S_IRUGO | S_IWUSR);
> +static struct kernel_param_ops ple_window_grow_ops;
> +module_param_cb(ple_window_grow, &ple_window_grow_ops,
> +                &ple_window_grow, S_IRUGO | S_IWUSR);
>  
>  /* Default resets per-vcpu window every exit to ple_window. */
>  static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
> @@ -5717,6 +5719,36 @@ static void type##_ple_window(struct kvm_vcpu *vcpu) \
>  make_ple_window_modifier(grow,   *, +) /* grow_ple_window */
>  make_ple_window_modifier(shrink, /, -) /* shrink_ple_window */
>  
> +static void clamp_ple_window_max(void)
> +{
> +	int maximum;
> +
> +	if (ple_window_grow < 1)
> +		return;
> +
> +	if (ple_window_grow < ple_window)
> +		maximum = INT_MAX / ple_window_grow;
> +	else
> +		maximum = INT_MAX - ple_window_grow;
> +
> +	ple_window_max = clamp(ple_window_max, ple_window, maximum);
> +}

I think avoiding overflows is better.  In fact, I think you should call
this function for ple_window_max too.

You could keep the ple_window_max variable to the user-set value.
Whenever ple_window_grow or ple_window_max are changed, you can set an
internal variable (let's call it ple_window_actual_max, but I'm not wed
to this name) to the computed value, and then do:

	if (ple_window_grow < 1 || ple_window_actual_max < ple_window)
		new = ple_window;
	else if (ple_window_grow < ple_window)
		new = max(ple_window_actual_max, old) * ple_window_grow;
	else
		new = max(ple_window_actual_max, old) + ple_window_grow;

(I think the || in the first "if" can be eliminated with some creativity
in clamp_ple_window_max).

Paolo

> +static int set_ple_window_grow(const char *arg, const struct kernel_param *kp)
> +{
> +	int ret;
> +
> +	clamp_ple_window_max();
> +	ret = param_set_int(arg, kp);
> +
> +	return ret;
> +}
> +
> +static struct kernel_param_ops ple_window_grow_ops = {
> +	.set = set_ple_window_grow,
> +	.get = param_get_int,
> +};
> +
>  /*
>   * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
>   * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
> 

