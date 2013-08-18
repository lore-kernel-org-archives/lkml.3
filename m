Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3HRAtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 20:49:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47355 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab3HRAtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 20:49:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, bp@suse.de, srivatsa.bhat@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 2/4] hotplug, x86: Add hotplug lock to missing places
Date: Sun, 18 Aug 2013 02:59:51 +0200
Message-ID: <2079659.IbpQLfJuuh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376768819-28975-3-git-send-email-toshi.kani@hp.com>
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com> <1376768819-28975-3-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 17, 2013 01:46:57 PM Toshi Kani wrote:
> lock_device_hotplug() serializes CPU & Memory online/offline and hotplug
> operations.  However, this lock is not held in the debug interfaces below
> that initiate CPU online/offline operations.
> 
>  - _debug_hotplug_cpu(), cpu0 hotplug test interface enabled by
>    CONFIG_DEBUG_HOTPLUG_CPU0.
>  - cpu_probe_store() and cpu_release_store(), cpu hotplug test interface
>    enabled by CONFIG_ARCH_CPU_PROBE_RELEASE.
> 
> This patch changes the above interfaces to hold lock_device_hotplug().
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  arch/x86/kernel/topology.c |    2 ++
>  drivers/base/cpu.c         |   16 ++++++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
> index 5823bbd..a3f35eb 100644
> --- a/arch/x86/kernel/topology.c
> +++ b/arch/x86/kernel/topology.c
> @@ -65,6 +65,7 @@ int __ref _debug_hotplug_cpu(int cpu, int action)
>  	if (!cpu_is_hotpluggable(cpu))
>  		return -EINVAL;
>  
> +	lock_device_hotplug();
>  	cpu_hotplug_driver_lock();
>  
>  	switch (action) {
> @@ -91,6 +92,7 @@ int __ref _debug_hotplug_cpu(int cpu, int action)
>  	}
>  
>  	cpu_hotplug_driver_unlock();
> +	unlock_device_hotplug();
>  
>  	return ret;
>  }
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 4c358bc..4cc6928 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -88,7 +88,13 @@ static ssize_t cpu_probe_store(struct device *dev,
>  			       const char *buf,
>  			       size_t count)
>  {
> -	return arch_cpu_probe(buf, count);
> +	ssize_t ret;
> +
> +	lock_device_hotplug();
> +	ret = arch_cpu_probe(buf, count);
> +	unlock_device_hotplug();
> +
> +	return ret;
>  }
>  
>  static ssize_t cpu_release_store(struct device *dev,
> @@ -96,7 +102,13 @@ static ssize_t cpu_release_store(struct device *dev,
>  				 const char *buf,
>  				 size_t count)
>  {
> -	return arch_cpu_release(buf, count);
> +	ssize_t ret;
> +
> +	lock_device_hotplug();
> +	ret = arch_cpu_release(buf, count);
> +	unlock_device_hotplug();
> +
> +	return ret;
>  }
>  
>  static DEVICE_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
