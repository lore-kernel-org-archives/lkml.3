Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3ENNik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:38:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48188 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab3ENNii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:38:38 -0400
Date: Tue, 14 May 2013 15:38:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, tboot-devel@lists.sourceforge.net,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH] x86: add a new SMP bring up way for tboot case
Message-ID: <20130514133834.GA28834@pd.tnic>
References: <1368566485-14785-1-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1368566485-14785-1-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 05:21:25AM +0800, Qiaowei Ren wrote:
> tboot provides a better AP wakeup mechanism based on cpu MWAIT
> feature for OS/VMM. With this mechanism, system will boot faster
> and will NOT require VT to be enabled. But it requires that
> OS/VMM must have support it, otherwise system can never boot up.
> 
> Once this mechanism is enabled, tboot will put APs waiting in
> MWAIT loops before launching kernel. kernel can check the new
> flag field in v6 tboot shared page for the hint. If the bit
> TB_FLAG_AP_WAKE_SUPPORT in flag field is set, kernel BSP has
> to write the monitored memory (tboot->ap_wake_trigger) to bring

Now this is a cool way to wake up an AP. It can't get any simpler. :-)

> APs out of MWAIT loops. The sipi vector should be written in
> tboot->ap_wake_addr before waking up APs.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
> Signed-off-by: Gang Wei <gang.wei@intel.com>
> ---
>  arch/x86/kernel/smpboot.c |   21 ++++++++++-----------
>  arch/x86/kernel/tboot.c   |   36 ++++++++++++++++++++++++++++++++++++
>  include/linux/tboot.h     |   17 +++++++++++++++++
>  3 files changed, 63 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 9f190a2..07f979e 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -787,17 +787,16 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
>  		}
>  	}
>  
> -	/*
> -	 * Wake up a CPU in difference cases:
> -	 * - Use the method in the APIC driver if it's defined
> -	 * Otherwise,
> -	 * - Use an INIT boot APIC message for APs or NMI for BSP.
> -	 */
> -	if (apic->wakeup_secondary_cpu)
> -		boot_error = apic->wakeup_secondary_cpu(apicid, start_ip);
> -	else
> -		boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
> -						     &cpu0_nmi_registered);
> +	if (!tboot_wake_up(apicid, start_ip)) {
> +		/*
> +		 * Kick the secondary CPU. Use the method in the APIC driver
> +		 * if it's defined - or use an INIT boot APIC message otherwise:
> +		 */
> +		if (apic->wakeup_secondary_cpu)
> +			boot_error = apic->wakeup_secondary_cpu(apicid, start_ip);
> +		else
> +			boot_error = wakeup_secondary_cpu_via_init(apicid, start_ip);
> +	}
>  
>  	if (!boot_error) {
>  		/*
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> index f84fe00..0ec1947 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -101,6 +101,8 @@ void __init tboot_probe(void)
>  	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
>  	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
>  	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
> +	if (tboot->version >= 6)
> +		pr_info("flags: 0x%08x\n", tboot->flags);

This should be pr_debug like the rest, no?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
