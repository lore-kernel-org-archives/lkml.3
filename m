Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939Ab3HSPU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:20:28 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53035 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3HSPU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:20:27 -0400
Message-ID: <521237A9.8010109@linux.vnet.ibm.com>
Date: Mon, 19 Aug 2013 10:20:09 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: mingo@redhat.com, hpa@linux.intel.com, tglx@linutronix.de,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org,
        fenghua.yu@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, isimatu.yasuaki@jp.fujitsu.com,
        srivatsa.bhat@linux.vnet.ibm.com, bp@suse.de,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 4/4] hotplug, powerpc, x86: Remove cpu_hotplug_driver_lock()
References: <1376768819-28975-1-git-send-email-toshi.kani@hp.com> <1376768819-28975-5-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1376768819-28975-5-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081915-5564-0000-0000-00000954F6FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 02:46 PM, Toshi Kani wrote:
> cpu_hotplug_driver_lock() serializes CPU online/offline operations
> when ARCH_CPU_PROBE_RELEASE is set.  This lock interface is no longer
> necessary with the following reason:
> 
>  - lock_device_hotplug() now protects CPU online/offline operations,
>    including the probe & release interfaces enabled by
>    ARCH_CPU_PROBE_RELEASE.  The use of cpu_hotplug_driver_lock() is
>    redundant.
>  - cpu_hotplug_driver_lock() is only valid when ARCH_CPU_PROBE_RELEASE
>    is defined, which is misleading and is only enabled on powerpc.
> 
> This patch removes the cpu_hotplug_driver_lock() interface.  As
> a result, ARCH_CPU_PROBE_RELEASE only enables / disables the cpu
> probe & release interface as intended.  There is no functional change
> in this patch.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Reviewed-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

> ---
> Performed build test only on powerpc.
> ---
>  arch/powerpc/kernel/smp.c              |   12 ----------
>  arch/powerpc/platforms/pseries/dlpar.c |   40 ++++++++++++--------------------
>  arch/x86/kernel/topology.c             |    2 --
>  drivers/base/cpu.c                     |   10 +-------
>  include/linux/cpu.h                    |   13 ----------
>  5 files changed, 16 insertions(+), 61 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 38b0ba6..1667269 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -763,18 +763,6 @@ void __cpu_die(unsigned int cpu)
>  		smp_ops->cpu_die(cpu);
>  }
>  
> -static DEFINE_MUTEX(powerpc_cpu_hotplug_driver_mutex);
> -
> -void cpu_hotplug_driver_lock()
> -{
> -	mutex_lock(&powerpc_cpu_hotplug_driver_mutex);
> -}
> -
> -void cpu_hotplug_driver_unlock()
> -{
> -	mutex_unlock(&powerpc_cpu_hotplug_driver_mutex);
> -}
> -
>  void cpu_die(void)
>  {
>  	if (ppc_md.cpu_die)
> diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
> index a1a7b9a..e39325d 100644
> --- a/arch/powerpc/platforms/pseries/dlpar.c
> +++ b/arch/powerpc/platforms/pseries/dlpar.c
> @@ -387,18 +387,13 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
>  	char *cpu_name;
>  	int rc;
>  
> -	cpu_hotplug_driver_lock();
>  	rc = strict_strtoul(buf, 0, &drc_index);
> -	if (rc) {
> -		rc = -EINVAL;
> -		goto out;
> -	}
> +	if (rc)
> +		return -EINVAL;
>  
>  	dn = dlpar_configure_connector(drc_index);
> -	if (!dn) {
> -		rc = -EINVAL;
> -		goto out;
> -	}
> +	if (!dn)
> +		return -EINVAL;
>  
>  	/* configure-connector reports cpus as living in the base
>  	 * directory of the device tree.  CPUs actually live in the
> @@ -407,8 +402,7 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
>  	cpu_name = kasprintf(GFP_KERNEL, "/cpus%s", dn->full_name);
>  	if (!cpu_name) {
>  		dlpar_free_cc_nodes(dn);
> -		rc = -ENOMEM;
> -		goto out;
> +		return -ENOMEM;
>  	}
>  
>  	kfree(dn->full_name);
> @@ -417,22 +411,21 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
>  	rc = dlpar_acquire_drc(drc_index);
>  	if (rc) {
>  		dlpar_free_cc_nodes(dn);
> -		rc = -EINVAL;
> -		goto out;
> +		return -EINVAL;
>  	}
>  
>  	rc = dlpar_attach_node(dn);
>  	if (rc) {
>  		dlpar_release_drc(drc_index);
>  		dlpar_free_cc_nodes(dn);
> -		goto out;
> +		return rc;
>  	}
>  
>  	rc = dlpar_online_cpu(dn);
> -out:
> -	cpu_hotplug_driver_unlock();
> +	if (rc)
> +		return rc;
>  
> -	return rc ? rc : count;
> +	return count;
>  }
>  
>  static int dlpar_offline_cpu(struct device_node *dn)
> @@ -505,30 +498,27 @@ static ssize_t dlpar_cpu_release(const char *buf, size_t count)
>  		return -EINVAL;
>  	}
>  
> -	cpu_hotplug_driver_lock();
>  	rc = dlpar_offline_cpu(dn);
>  	if (rc) {
>  		of_node_put(dn);
> -		rc = -EINVAL;
> -		goto out;
> +		return -EINVAL;
>  	}
>  
>  	rc = dlpar_release_drc(*drc_index);
>  	if (rc) {
>  		of_node_put(dn);
> -		goto out;
> +		return rc;
>  	}
>  
>  	rc = dlpar_detach_node(dn);
>  	if (rc) {
>  		dlpar_acquire_drc(*drc_index);
> -		goto out;
> +		return rc;
>  	}
>  
>  	of_node_put(dn);
> -out:
> -	cpu_hotplug_driver_unlock();
> -	return rc ? rc : count;
> +
> +	return count;
>  }
>  
>  static int __init pseries_dlpar_init(void)
> diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
> index a3f35eb..649b010 100644
> --- a/arch/x86/kernel/topology.c
> +++ b/arch/x86/kernel/topology.c
> @@ -66,7 +66,6 @@ int __ref _debug_hotplug_cpu(int cpu, int action)
>  		return -EINVAL;
>  
>  	lock_device_hotplug();
> -	cpu_hotplug_driver_lock();
>  
>  	switch (action) {
>  	case 0:
> @@ -91,7 +90,6 @@ int __ref _debug_hotplug_cpu(int cpu, int action)
>  		ret = -EINVAL;
>  	}
>  
> -	cpu_hotplug_driver_unlock();
>  	unlock_device_hotplug();
>  
>  	return ret;
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 4cc6928..b4ebd7b 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -45,8 +45,6 @@ static int __ref cpu_subsys_online(struct device *dev)
>  	int from_nid, to_nid;
>  	int ret;
>  
> -	cpu_hotplug_driver_lock();
> -
>  	from_nid = cpu_to_node(cpuid);
>  	ret = cpu_up(cpuid);
>  	/*
> @@ -57,18 +55,12 @@ static int __ref cpu_subsys_online(struct device *dev)
>  	if (from_nid != to_nid)
>  		change_cpu_under_node(cpu, from_nid, to_nid);
>  
> -	cpu_hotplug_driver_unlock();
>  	return ret;
>  }
>  
>  static int cpu_subsys_offline(struct device *dev)
>  {
> -	int ret;
> -
> -	cpu_hotplug_driver_lock();
> -	ret = cpu_down(dev->id);
> -	cpu_hotplug_driver_unlock();
> -	return ret;
> +	return cpu_down(dev->id);
>  }
>  
>  void unregister_cpu(struct cpu *cpu)
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index ab0eade..e847ef8 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -182,19 +182,6 @@ extern void cpu_hotplug_enable(void);
>  void clear_tasks_mm_cpumask(int cpu);
>  int cpu_down(unsigned int cpu);
>  
> -#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
> -extern void cpu_hotplug_driver_lock(void);
> -extern void cpu_hotplug_driver_unlock(void);
> -#else
> -static inline void cpu_hotplug_driver_lock(void)
> -{
> -}
> -
> -static inline void cpu_hotplug_driver_unlock(void)
> -{
> -}
> -#endif
> -
>  #else		/* CONFIG_HOTPLUG_CPU */
>  
>  #define get_online_cpus()	do { } while (0)
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

