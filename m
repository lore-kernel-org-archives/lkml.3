Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbaCTWCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:02:22 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:64108 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759424AbaCTWCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:02:20 -0400
Message-ID: <532B6543.7050707@redhat.com>
Date: Thu, 20 Mar 2014 23:01:39 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Alok Kataria <akataria@vmware.com>, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Scott J Norton <scott.norton@hp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Wright <chrisw@sous-sol.org>, Oleg Nesterov <oleg@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 06/11] pvqspinlock, x86: Allow unfair queue spinlock
 in a KVM guest
References: <1395260049-30839-1-git-send-email-Waiman.Long@hp.com> <1395260049-30839-7-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1395260049-30839-7-git-send-email-Waiman.Long@hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/03/2014 21:14, Waiman Long ha scritto:
> This patch adds a KVM init function to activate the unfair queue
> spinlock in a KVM guest when the PARAVIRT_UNFAIR_LOCKS kernel config
> option is selected.
>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  arch/x86/kernel/kvm.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 713f1b3..a489140 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -826,3 +826,20 @@ static __init int kvm_spinlock_init_jump(void)
>  early_initcall(kvm_spinlock_init_jump);
>
>  #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
> +
> +#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
> +/*
> + * Enable unfair lock if running in a real para-virtualized environment
> + */
> +static __init int kvm_unfair_locks_init_jump(void)
> +{
> +	if (!kvm_para_available())
> +		return 0;
> +
> +	static_key_slow_inc(&paravirt_unfairlocks_enabled);
> +	printk(KERN_INFO "KVM setup unfair spinlock\n");
> +
> +	return 0;
> +}
> +early_initcall(kvm_unfair_locks_init_jump);
> +#endif
>

No!  Please do what I asked you to do.  You are not handling Hyper-V or 
VMWare.  Just use X86_FEATURE_HYPERVISOR and it will cover all 
hypervisors that actually follow Intel's guidelines.

Paolo
