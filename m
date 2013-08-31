Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3HaANk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:13:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45968 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3HaANj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:13:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>, hpa@linux.intel.com
Cc: mingo@redhat.com, tglx@linutronix.de, gregkh@linuxfoundation.org,
        benh@kernel.crashing.org, linux-acpi@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        nfont@linux.vnet.ibm.com, fenghua.yu@intel.com, bp@suse.de,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH v2 1/4] hotplug, x86: Fix online state in cpu0 debug interface
Date: Sat, 31 Aug 2013 02:24:22 +0200
Message-ID: <2774711.qY7OXM5Wgn@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1377822129-4143-2-git-send-email-toshi.kani@hp.com>
References: <1377822129-4143-1-git-send-email-toshi.kani@hp.com> <1377822129-4143-2-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Any objections here?

On Thursday, August 29, 2013 06:22:06 PM Toshi Kani wrote:
> _debug_hotplug_cpu() is a debug interface that puts cpu0 offline during
> boot-up when CONFIG_DEBUG_HOTPLUG_CPU0 is set.  After cpu0 is put offline
> in this interface, however, /sys/devices/system/cpu/cpu0/online still
> shows 1 (online).
> 
> This patch fixes _debug_hotplug_cpu() to update dev->offline when CPU
> online/offline operation succeeded.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  arch/x86/kernel/topology.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
> index 6e60b5f..5823bbd 100644
> --- a/arch/x86/kernel/topology.c
> +++ b/arch/x86/kernel/topology.c
> @@ -72,16 +72,19 @@ int __ref _debug_hotplug_cpu(int cpu, int action)
>  		ret = cpu_down(cpu);
>  		if (!ret) {
>  			pr_info("CPU %u is now offline\n", cpu);
> +			dev->offline = true;
>  			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
>  		} else
>  			pr_debug("Can't offline CPU%d.\n", cpu);
>  		break;
>  	case 1:
>  		ret = cpu_up(cpu);
> -		if (!ret)
> +		if (!ret) {
> +			dev->offline = false;
>  			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> -		else
> +		} else {
>  			pr_debug("Can't online CPU%d.\n", cpu);
> +		}
>  		break;
>  	default:
>  		ret = -EINVAL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
