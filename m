Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3HRAtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 20:49:11 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47335 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3HRAtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 20:49:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 1/4] hotplug, x86: Fix online state in cpu0 debug interface
Date: Sun, 18 Aug 2013 02:59:35 +0200
Message-ID: <2432072.Zy8S4hcMML@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376768819-28975-2-git-send-email-toshi.kani@hp.com>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com> <1376768819-28975-2-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 17, 2013 01:46:56 PM Toshi Kani wrote:
> _debug_hotplug_cpu() is a debug interface that puts cpu0 offline during
> boot-up when CONFIG_DEBUG_HOTPLUG_CPU0 is set.  After cpu0 is put offline
> in this interface, however, /sys/devices/system/cpu/cpu0/online still
> shows 1 (online).
> 
> This patch fixes _debug_hotplug_cpu() to update dev->offline when CPU
> online/offline operation succeeded.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
