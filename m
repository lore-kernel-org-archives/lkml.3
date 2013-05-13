Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3EMO46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:56:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab3EMO45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:56:57 -0400
Date: Mon, 13 May 2013 16:56:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
In-Reply-To: <20130510213851.GC9358@somewhere>
Message-ID: <alpine.LNX.2.00.1305131655390.23038@pobox.suse.cz>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130510002930.GB2394@somewhere> <alpine.LNX.2.00.1305101702250.23038@pobox.suse.cz> <20130510152102.GD22942@pd.tnic> <20130510154349.GB9358@somewhere> <20130510162340.GE22942@pd.tnic>
 <20130510213851.GC9358@somewhere>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, Frederic Weisbecker wrote:

> The problem is that it doesn't catch issues with irqs that have been enabled
> before in start_secondary(), then re-disabled somewhow. Warning on offline CPU from the place 
> that disables the tick should catch the issue.
> 
> Jiri, could you test the following patch? I also added some code to dump
> the value of ts->tick_stopped, in case it's not well initialized or something.
> 
> Note this may give you spurious warning when you unplug a CPU or when you shutdown the
> system. But it's interesting if it dumps something in the boot.
> 
> Thanks!
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..9853125 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -616,8 +616,17 @@ static bool wake_up_full_nohz_cpu(int cpu)
>  {
>  	if (tick_nohz_full_cpu(cpu)) {
>  		if (cpu != smp_processor_id() ||
> -		    tick_nohz_tick_stopped())
> +		    tick_nohz_tick_stopped()) {
> +			if (!cpu_online(cpu)) {
> +				static int printed = 0;
> +				if (!printed) {
> +					printk("src: %d dst: %d stopped: %d\n", cpu, smp_processor_id(), tick_nohz_tick_stopped());
> +					dump_stack();
> +					printed = 1;
> +				}
> +			}
>  			smp_send_reschedule(cpu);
> +		}
>  		return true;
>  	}
>  
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index bc67d42..abfa8c3 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -650,6 +650,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
>  
>  			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
>  			ts->tick_stopped = 1;
> +			WARN_ON_ONCE(!cpu_online(cpu));
>  			trace_tick_stop(1, " ");
>  		}

Hi Frederic,

I am not getting anything on boot (and I have never seen any warning on 
boot), but suspend-resume cycle always triggers this.

With the patch above, I am getting:


[ ... snip ... ]
 PM: freeze of devices complete after 419.034 msecs
 PM: late freeze of devices complete after 0.589 msecs
 PM: noirq freeze of devices complete after 1.448 msecs
 Disabling non-boot CPUs ...
 ------------[ cut here ]------------
 WARNING: at kernel/time/tick-sched.c:653 tick_nohz_stop_sched_tick+0x38e/0x3a0()
 Modules linked in: af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables rfcomm bnep btusb bluetooth iTCO_wdt cpufreq_conservative cpufreq_userspace iTCO_vendor_support cpufreq_powersave acpi_cpufreq mperf kvm_intel kvm snd_hda_codec_conexant snd_hda_intel snd_hda_codec microcode snd_hwdep sg snd_pcm iwldvm thinkpad_acpi mac80211 snd_seq iwlwifi pcspkr i2c_i801 cfg80211 lpc_ich mfd_core snd_timer snd_seq_device rfkill e1000e snd ptp mei_me snd_page_alloc mei pps_core ehci_pci wmi tpm_tis soundcore ac battery tpm tpm_bios autofs4 uhci_hcd ehci_hcd usbcore usb_common i915 drm_kms_helper drm i2c_algo_bit video button edd fan processor ata_generic thermal thermal_sys
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.9.0-12317-g44bb655 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
  000000000000028d ffff880079851dc8 ffffffff815483ce ffff880079851e08
  ffffffff8104212b 000000000000d340 000000003fffffff 7fffffffffffffff
  ffff88007c28d640 00000000ffff1b2f 0000000f4b8c5f00 ffff880079851e18
 Call Trace:
  [<ffffffff815483ce>] dump_stack+0x19/0x1b
  [<ffffffff8104212b>] warn_slowpath_common+0x6b/0xa0
  [<ffffffff81042175>] warn_slowpath_null+0x15/0x20
  [<ffffffff8109f13e>] tick_nohz_stop_sched_tick+0x38e/0x3a0
  [<ffffffff8109f27b>] __tick_nohz_idle_enter+0x12b/0x170
  [<ffffffff8109f2ed>] tick_nohz_idle_enter+0x2d/0x60
  [<ffffffff810944c5>] cpu_idle_loop+0x35/0x230
  [<ffffffff810946de>] cpu_startup_entry+0x1e/0x20
  [<ffffffff81540072>] start_secondary+0x89/0x97
 ---[ end trace ecffd04d10ec9f65 ]---
 smpboot: CPU 1 is now offline
 PM: Creating hibernation image:
 PM: Need to copy 194352 pages
 PM: Normal pages needed: 194352 + 1024, available pages: 315053
 microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60f
 Enabling non-boot CPUs ...
 smpboot: Booting Node 0 Processor 1 APIC 0x1
 CPU1 microcode updated early to revision 0x60f, date = 2010-09-29
 Disabled fast string operations
 src: 1 dst: 1 stopped: 1
 CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.9.0-12317-g44bb655 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
  ffff88007c28cca0 ffff880079851e08 ffffffff815483ce ffff880079851e28
  ffffffff8107751c ffff88007c28cca0 ffff88007c28cca0 ffff880079851e68
  ffffffff810529db 0000000179851e78 ffff88007c28cca0 0000000000000001
 Call Trace:
  [<ffffffff815483ce>] dump_stack+0x19/0x1b
  [<ffffffff8107751c>] wake_up_nohz_cpu+0xdc/0xf0
  [<ffffffff810529db>] add_timer_on+0xdb/0x110
  [<ffffffff8101e4f4>] mce_start_timer+0x64/0x70
  [<ffffffff8101e552>] __mcheck_cpu_init_timer+0x52/0x60
  [<ffffffff8153e27e>] mcheck_cpu_init+0x6f/0x111
  [<ffffffff8153b99e>] identify_cpu+0x3cc/0x3f9
  [<ffffffff8153b9dd>] identify_secondary_cpu+0x12/0x1d
  [<ffffffff8153fe26>] smp_store_cpu_info+0x3a/0x3c
  [<ffffffff8153ff12>] smp_callin+0xea/0x1c1
  [<ffffffff8154000d>] start_secondary+0x24/0x97
 ------------[ cut here ]------------
 WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x59/0x60()
 Modules linked in: af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables rfcomm bnep btusb bluetooth iTCO_wdt cpufreq_conservative cpufreq_userspace iTCO_vendor_support cpufreq_powersave acpi_cpufreq mperf kvm_intel kvm snd_hda_codec_conexant snd_hda_intel snd_hda_codec microcode snd_hwdep sg snd_pcm iwldvm thinkpad_acpi mac80211 snd_seq iwlwifi pcspkr i2c_i801 cfg80211 lpc_ich mfd_core snd_timer snd_seq_device rfkill e1000e snd ptp mei_me snd_page_alloc mei pps_core ehci_pci wmi tpm_tis soundcore ac battery tpm tpm_bios autofs4 uhci_hcd ehci_hcd usbcore usb_common i915 drm_kms_helper drm i2c_algo_bit video button edd fan processor ata_generic thermal thermal_sys
 CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.9.0-12317-g44bb655 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
  000000000000007b ffff880079851da8 ffffffff815483ce ffff880079851de8
  ffffffff8104212b ffff88007c28cca0 0000000000000001 ffff88007c28cca0
  ffff880079878000 0000000100004043 0000000000000096 ffff880079851df8
 Call Trace:
  [<ffffffff815483ce>] dump_stack+0x19/0x1b
  [<ffffffff8104212b>] warn_slowpath_common+0x6b/0xa0
  [<ffffffff81042175>] warn_slowpath_null+0x15/0x20
  [<ffffffff81026b09>] native_smp_send_reschedule+0x59/0x60
  [<ffffffff81077486>] wake_up_nohz_cpu+0x46/0xf0
  [<ffffffff810529db>] add_timer_on+0xdb/0x110
  [<ffffffff8101e4f4>] mce_start_timer+0x64/0x70
  [<ffffffff8101e552>] __mcheck_cpu_init_timer+0x52/0x60
  [<ffffffff8153e27e>] mcheck_cpu_init+0x6f/0x111
  [<ffffffff8153b99e>] identify_cpu+0x3cc/0x3f9
  [<ffffffff8153b9dd>] identify_secondary_cpu+0x12/0x1d
  [<ffffffff8153fe26>] smp_store_cpu_info+0x3a/0x3c
  [<ffffffff8153ff12>] smp_callin+0xea/0x1c1
  [<ffffffff8154000d>] start_secondary+0x24/0x97
 ---[ end trace ecffd04d10ec9f66 ]---
 microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60f
 CPU1 is up
[ ... snip ... ]

-- 
Jiri Kosina
SUSE Labs
