Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbaHUTRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:17:06 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49372 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaHUTRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:17:00 -0400
Message-ID: <53F645DF.4080101@linux.vnet.ibm.com>
Date: Fri, 22 Aug 2014 00:47:51 +0530
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
Subject: Re: [PATCH v3 6/7] KVM: VMX: runtime knobs for dynamic PLE window
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com> <1408637291-18533-7-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-7-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082119-0013-0000-0000-000000E884C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 09:38 PM, Radim Krčmář wrote:
> ple_window is updated on every vmentry, so there is no reason to have it
> read-only anymore.
> ple_window* weren't writable to prevent runtime overflow races;
> they are prevented by a seqlock.
>
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>   arch/x86/kvm/vmx.c | 46 +++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 37 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 273cbd5..1318232 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -132,24 +132,29 @@ module_param(nested, bool, S_IRUGO);
>   #define KVM_VMX_DEFAULT_PLE_WINDOW_MAX    \
>   		INT_MAX / KVM_VMX_DEFAULT_PLE_WINDOW_GROW
>
> +static struct kernel_param_ops param_ops_ple_int;
> +#define param_check_ple_int(name, p) __param_check(name, p, int)
> +
> +static DEFINE_SEQLOCK(ple_window_seqlock);
> +
>   static int ple_gap = KVM_VMX_DEFAULT_PLE_GAP;
>   module_param(ple_gap, int, S_IRUGO);
>
>   static int ple_window = KVM_VMX_DEFAULT_PLE_WINDOW;
> -module_param(ple_window, int, S_IRUGO);
> +module_param(ple_window, ple_int, S_IRUGO | S_IWUSR);
>
>   /* Default doubles per-vcpu window every exit. */
>   static int ple_window_grow = KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
> -module_param(ple_window_grow, int, S_IRUGO);
> +module_param(ple_window_grow, ple_int, S_IRUGO | S_IWUSR);
>
>   /* Default resets per-vcpu window every exit to ple_window. */
>   static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
> -module_param(ple_window_shrink, int, S_IRUGO);
> +module_param(ple_window_shrink, int, S_IRUGO | S_IWUSR);
>
>   /* Default is to compute the maximum so we can never overflow. */
>   static int ple_window_actual_max = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
>   static int ple_window_max        = KVM_VMX_DEFAULT_PLE_WINDOW_MAX;
> -module_param(ple_window_max, int, S_IRUGO);
> +module_param(ple_window_max, ple_int, S_IRUGO | S_IWUSR);
>
>

Positive thing about able to change default grow/shrink value is the
flexibility of tuning ple window to different workloads and different
number of cpus.

But is it that a value of shrink = 1 and grow > 1 is problematic ?
(running a undercommit workload and then overcommit workload)

