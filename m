Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab3EOS22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:28:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:44378 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980Ab3EOS20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:28:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,678,1363158000"; 
   d="scan'208";a="242050733"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86, microcode: Add local mutex to not hit a deadlock.
Thread-Topic: [PATCH] x86, microcode: Add local mutex to not hit a deadlock.
Thread-Index: AQHOTAb/iY09weC2rUipSYx45j/IQJkGmklA
Date: Wed, 15 May 2013 18:25:38 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220563322FE@ORSMSX106.amr.corp.intel.com>
References: <1368029583-23337-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1368029583-23337-1-git-send-email-konrad.wilk@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> 
> This can easily be triggered if a new CPU is added (via
> ACPI hotplug mechanism) and from user-space do:
> 
> echo 1 > /sys/devices/system/cpu/cpu3/online
> 
> (or wait for UDEV to do it) on a newly appeared CPU.
> 
> The deadlock is that the "store_online" in drivers/base/cpu.c
> takes the cpu_hotplug_driver_lock() lock, then calls "cpu_up".
> "cpu_up" eventually ends up calling "save_mc_for_early"
> which also takes the cpu_hotplug_driver_lock() lock.
> 
> And here is that kernel thinks of it:
> 
> smpboot: Stack at about ffff880075c39f44
> smpboot: CPU3: has booted.
> microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x25
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.9.0upstream-10129-g167af0e #1 Not tainted
> ---------------------------------------------
> sh/2487 is trying to acquire lock:
>  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>]
> cpu_hotplug_driver_lock+0x12/0x20
> 
> but task is already holding lock:
>  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>]
> cpu_hotplug_driver_lock+0x12/0x20
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(x86_cpu_hotplug_driver_mutex);
>   lock(x86_cpu_hotplug_driver_mutex);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 6 locks held by sh/2487:
>  #0:  (sb_writers#5){.+.+.+}, at: [<ffffffff811ca48d>]
> vfs_write+0x17d/0x190
>  #1:  (&buffer->mutex){+.+.+.}, at: [<ffffffff812464ef>]
> sysfs_write_file+0x3f/0x160
>  #2:  (s_active#20){.+.+.+}, at: [<ffffffff81246578>]
> sysfs_write_file+0xc8/0x160
>  #3:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>]
> cpu_hotplug_driver_lock+0x12/0x20
>  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810961c2>]
> cpu_maps_update_begin+0x12/0x20
>  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810962a7>]
> cpu_hotplug_begin+0x27/0x60
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> CC: stable@vger.kernel.org # for v3.9
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/kernel/microcode_intel_early.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_intel_early.c
> b/arch/x86/kernel/microcode_intel_early.c
> index d893e8e..2e9e128 100644
> --- a/arch/x86/kernel/microcode_intel_early.c
> +++ b/arch/x86/kernel/microcode_intel_early.c
> @@ -487,6 +487,7 @@ static inline void show_saved_mc(void)
>  #endif
> 
>  #if defined(CONFIG_MICROCODE_INTEL_EARLY) &&
> defined(CONFIG_HOTPLUG_CPU)
> +static DEFINE_MUTEX(x86_cpu_microcode_mutex);
>  /*
>   * Save this mc into mc_saved_data. So it will be loaded early when a
> CPU is
>   * hot added or resumes.
> @@ -507,7 +508,7 @@ int save_mc_for_early(u8 *mc)
>  	 * Hold hotplug lock so mc_saved_data is not accessed by a CPU in
>  	 * hotplug.
>  	 */

Could you please change the comment to use mutex instead? I think the mutex
is good way to handle race here.

> -	cpu_hotplug_driver_lock();
> +	mutex_lock(&x86_cpu_microcode_mutex);
> 
>  	mc_saved_count_init = mc_saved_data.mc_saved_count;
>  	mc_saved_count = mc_saved_data.mc_saved_count;
> @@ -544,7 +545,7 @@ int save_mc_for_early(u8 *mc)
>  	}
> 
>  out:
> -	cpu_hotplug_driver_unlock();
> +	mutex_unlock(&x86_cpu_microcode_mutex);
> 
>  	return ret;
>  }
> --
> 1.7.7.6

