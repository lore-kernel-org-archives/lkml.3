Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab3J2RRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:17:22 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61965 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394Ab3J2RRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:17:00 -0400
Message-ID: <526FED86.9060806@redhat.com>
Date: Tue, 29 Oct 2013 18:16:54 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/10/2013 16:13, Tim Gardner ha scritto:
> The x86 specific kvm init creates a new conflicting
> debugfs directory which causes modprobe issues
> with kvm_intel and kvm_amd. For example,
> 
> sudo modprobe kvm_amd
> modprobe: ERROR: could not insert 'kvm_amd': Bad address
> 
> The simplest fix is to just rename the directory. The following
> KVM config options are set:
> 
> CONFIG_KVM_GUEST=y
> CONFIG_KVM_DEBUG_FS=y
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> CONFIG_HAVE_KVM_IRQ_ROUTING=y
> CONFIG_HAVE_KVM_EVENTFD=y
> CONFIG_KVM_APIC_ARCHITECTURE=y
> CONFIG_KVM_MMIO=y
> CONFIG_KVM_ASYNC_PF=y
> CONFIG_HAVE_KVM_MSI=y
> CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> CONFIG_KVM=m
> CONFIG_KVM_INTEL=m
> CONFIG_KVM_AMD=m
> # CONFIG_KVM_MMU_AUDIT is not set
> CONFIG_KVM_DEVICE_ASSIGNMENT=y
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
> 
> There is likely a more elegant and complicated way to solve this
> problem, but a simple rename for a debug feature seems best,
> especially for an -rc7.

I agree, but I'd prefer "kvm-pv" to distinguish x86-specific KVM
features on the host (the debugfs directory that Linus was complaining
about) from KVM features that require guest cooperation (this case).

I'll send a pull request tomorrow.

Paolo

>  arch/x86/kernel/kvm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a0e2a8a..d17895a 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -609,7 +609,7 @@ static struct dentry *d_kvm_debug;
>  
>  struct dentry *kvm_init_debugfs(void)
>  {
> -	d_kvm_debug = debugfs_create_dir("kvm", NULL);
> +	d_kvm_debug = debugfs_create_dir("kvm-x86", NULL);
>  	if (!d_kvm_debug)
>  		printk(KERN_WARNING "Could not create 'kvm' debugfs directory\n");
>  
> 

