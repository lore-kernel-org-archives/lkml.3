Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaGWQYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:24:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55537 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201AbaGWQYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:24:01 -0400
Date: Wed, 23 Jul 2014 18:23:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 10/70] x86, kvm: _FROZEN Cleanup
Message-ID: <20140723162357.GF21707@pd.tnic>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-11-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406080786-3938-11-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:58:46PM -0400, Chen, Gong wrote:
> Remove XXX_FROZEN state from kvm.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  arch/x86/kernel/kvm.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 3dd8e2c..22d472b 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -442,19 +442,20 @@ static int kvm_cpu_notify(struct notifier_block *self, unsigned long action,
>  			  void *hcpu)
>  {
>  	int cpu = (unsigned long)hcpu;
> -	switch (action) {
> +	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_ONLINE:
> -	case CPU_DOWN_FAILED:

This looks strange. Why even touch CPU_DOWN_FAILED ...

> -	case CPU_ONLINE_FROZEN:
>  		smp_call_function_single(cpu, kvm_guest_cpu_online, NULL, 0);
>  		break;
>  	case CPU_DOWN_PREPARE:
> -	case CPU_DOWN_PREPARE_FROZEN:
>  		smp_call_function_single(cpu, kvm_guest_cpu_offline, NULL, 1);
>  		break;
>  	default:
>  		break;
>  	}
> +
> +	if (action == CPU_DOWN_FAILED)
> +		smp_call_function_single(cpu, kvm_guest_cpu_online, NULL, 0);

to move it here?

Just remove the _FROZEN stuff and don't touch anything else.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
