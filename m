Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3HRAuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 20:50:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47368 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab3HRAuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 20:50:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 3/4] hotplug, x86: Disable ARCH_CPU_PROBE_RELEASE on x86
Date: Sun, 18 Aug 2013 03:00:45 +0200
Message-ID: <2917026.KqRDPssAuo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376768819-28975-4-git-send-email-toshi.kani@hp.com>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com> <1376768819-28975-4-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 17, 2013 01:46:58 PM Toshi Kani wrote:
> Commit d7c53c9e enabled ARCH_CPU_PROBE_RELEASE on x86 in order to
> serialize CPU online/offline operations.  Although it is the config
> option to enable CPU hotplug test interfaces, probe & release, it is
> also the option to enable cpu_hotplug_driver_lock() as well.  Therefore,
> this option had to be enabled on x86 with dummy arch_cpu_probe() and
> arch_cpu_release().
> 
> Since then, lock_device_hotplug() was introduced to serialize CPU
> online/offline & hotplug operations.  Therefore, this config option
> is no longer required for the serialization.  This patch disables
> this config option on x86 and revert the changes made by commit
> d7c53c9e.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  arch/x86/Kconfig          |    4 ----
>  arch/x86/kernel/smpboot.c |   21 ---------------------
>  2 files changed, 25 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b32ebf9..c87e49a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -255,10 +255,6 @@ config ARCH_HWEIGHT_CFLAGS
>  	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
>  	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
>  
> -config ARCH_CPU_PROBE_RELEASE
> -	def_bool y
> -	depends on HOTPLUG_CPU
> -
>  config ARCH_SUPPORTS_UPROBES
>  	def_bool y
>  
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index aecc98a..5b24a9d 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -82,27 +82,6 @@
>  /* State of each CPU */
>  DEFINE_PER_CPU(int, cpu_state) = { 0 };
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> -/*
> - * We need this for trampoline_base protection from concurrent accesses when
> - * off- and onlining cores wildly.
> - */
> -static DEFINE_MUTEX(x86_cpu_hotplug_driver_mutex);
> -
> -void cpu_hotplug_driver_lock(void)
> -{
> -	mutex_lock(&x86_cpu_hotplug_driver_mutex);
> -}
> -
> -void cpu_hotplug_driver_unlock(void)
> -{
> -	mutex_unlock(&x86_cpu_hotplug_driver_mutex);
> -}
> -
> -ssize_t arch_cpu_probe(const char *buf, size_t count) { return -1; }
> -ssize_t arch_cpu_release(const char *buf, size_t count) { return -1; }
> -#endif
> -
>  /* Number of siblings per CPU package */
>  int smp_num_siblings = 1;
>  EXPORT_SYMBOL(smp_num_siblings);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
