Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676AbbA1VeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:34:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761553AbbA1UoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:44:04 -0500
Date: Wed, 28 Jan 2015 10:46:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: lizf@kernel.org
cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: Re: [PATCH 3.4 07/91] ACPI / cpuidle: fix deadlock between cpuidle_lock
 and cpu_hotplug.lock
In-Reply-To: <1422418236-12852-13-git-send-email-lizf@kernel.org>
Message-ID: <alpine.LNX.2.00.1501281045540.6510@pobox.suse.cz>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org> <1422418236-12852-13-git-send-email-lizf@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015, lizf@kernel.org wrote:

> From: Jiri Kosina <jkosina@suse.cz>
> 
> 3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

Please don't forget to include followup deadlock fix as well:

	https://lkml.org/lkml/2015/1/20/983

> 
> ------------------
> 
> 
> commit 6726655dfdd2dc60c035c690d9f10cb69d7ea075 upstream.
> 
> There is a following AB-BA dependency between cpu_hotplug.lock and
> cpuidle_lock:
> 
> 1) cpu_hotplug.lock -> cpuidle_lock
> enable_nonboot_cpus()
>  _cpu_up()
>   cpu_hotplug_begin()
>    LOCK(cpu_hotplug.lock)
>  cpu_notify()
>   ...
>   acpi_processor_hotplug()
>    cpuidle_pause_and_lock()
>     LOCK(cpuidle_lock)
> 
> 2) cpuidle_lock -> cpu_hotplug.lock
> acpi_os_execute_deferred() workqueue
>  ...
>  acpi_processor_cst_has_changed()
>   cpuidle_pause_and_lock()
>    LOCK(cpuidle_lock)
>   get_online_cpus()
>    LOCK(cpu_hotplug.lock)
> 
> Fix this by reversing the order acpi_processor_cst_has_changed() does
> thigs -- let it first execute the protection against CPU hotplug by
> calling get_online_cpus() and obtain the cpuidle lock only after that (and
> perform the symmentric change when allowing CPUs hotplug again and
> dropping cpuidle lock).
> 
> Spotted by lockdep.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Zefan Li <lizefan@huawei.com>
> ---
>  drivers/acpi/processor_idle.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 6cba428..e1180ce 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -1195,9 +1195,9 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
>  
>  	if (pr->id == 0 && cpuidle_get_driver() == &acpi_idle_driver) {
>  
> -		cpuidle_pause_and_lock();
>  		/* Protect against cpu-hotplug */
>  		get_online_cpus();
> +		cpuidle_pause_and_lock();
>  
>  		/* Disable all cpuidle devices */
>  		for_each_online_cpu(cpu) {
> @@ -1222,8 +1222,8 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
>  				cpuidle_enable_device(&_pr->power.dev);
>  			}
>  		}
> -		put_online_cpus();
>  		cpuidle_resume_and_unlock();
> +		put_online_cpus();
>  	}
>  
>  	return 0;
> -- 
> 1.9.1
> 

-- 
Jiri Kosina
SUSE Labs
