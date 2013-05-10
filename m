Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3EJPEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:04:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab3EJPEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:04:00 -0400
Date: Fri, 10 May 2013 17:03:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
In-Reply-To: <20130510002930.GB2394@somewhere>
Message-ID: <alpine.LNX.2.00.1305101702250.23038@pobox.suse.cz>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130510002930.GB2394@somewhere>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, Frederic Weisbecker wrote:

> Like Borislav said, it's due to the scheduler IPI sent to an offline
> target. Here this is because we enqueue a timer and we must ensure the
> target handles this timer by rescheduling its tick if necessary.
> 
> But it's weird because the mce timer at this stage should only enqueue
> to the current CPU and the tick shouldn't be stopped. So there shouldn't
> be an IPI sent.
> 
> Could you please apply this patch and tell me what you can see in the
> logs?
> 
> Thanks.
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..19e841a 100644
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
> +					printk("%d %d\n", cpu, smp_processor_id());
> +					dump_stack();
> +					printed = 1;
> +				}
> +			}
>  			smp_send_reschedule(cpu);
> +		}
>  		return true;
>  	}

Absolutely, here it goes.

[ ... snip ... ]
 Enabling non-boot CPUs ...
 smpboot: Booting Node 0 Processor 1 APIC 0x1
 CPU1 microcode updated early to revision 0x60f, date = 2010-09-29
 Disabled fast string operations
 1 1
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.9.0-12317-gb2031d4 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
  ffff88007c28cca0 ffff880079851e08 ffffffff8154837e ffff880079851e28
  ffffffff81077514 ffff88007c28cca0 ffff88007c28cca0 ffff880079851e68
  ffffffff810529db 0000000179851e78 ffff88007c28cca0 0000000000000001
 Call Trace:
  [<ffffffff8154837e>] dump_stack+0x19/0x1b
  [<ffffffff81077514>] wake_up_nohz_cpu+0xd4/0xf0
  [<ffffffff810529db>] add_timer_on+0xdb/0x110
  [<ffffffff8101e4f4>] mce_start_timer+0x64/0x70
  [<ffffffff8101e552>] __mcheck_cpu_init_timer+0x52/0x60
  [<ffffffff8153e22e>] mcheck_cpu_init+0x6f/0x111
  [<ffffffff8153b94e>] identify_cpu+0x3cc/0x3f9
  [<ffffffff8153b98d>] identify_secondary_cpu+0x12/0x1d
  [<ffffffff8153fdd6>] smp_store_cpu_info+0x3a/0x3c
  [<ffffffff8153fec2>] smp_callin+0xea/0x1c1
  [<ffffffff8153ffbd>] start_secondary+0x24/0x97
 ------------[ cut here ]------------
 WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x59/0x60()
 Modules linked in: af_packet tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables rfcomm bnep btusb bluetooth cpufreq_conservative cpufreq_userspace cpufreq_powersave iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant acpi_cpufreq mperf kvm_intel kvm iwldvm mac80211 thinkpad_acpi snd_hda_intel sg microcode snd_hda_codec snd_seq iwlwifi snd_hwdep cfg80211 snd_seq_device pcspkr i2c_i801 snd_pcm lpc_ich mfd_core rfkill e1000e snd_timer snd_page_alloc ehci_pci ptp mei_me pps_core mei snd wmi soundcore tpm_tis battery tpm ac tpm_bios autofs4 uhci_hcd ehci_hcd i915 drm_kms_helper drm i2c_algo_bit usbcore button video usb_common edd fan processor ata_generic thermal thermal_sys
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.9.0-12317-gb2031d4 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
  000000000000007b ffff880079851da8 ffffffff8154837e ffff880079851de8
  ffffffff8104212b ffff88007c28cca0 0000000000000001 ffff88007c28cca0
  ffff880079878000 0000000100004525 0000000000000096 ffff880079851df8
 Call Trace:
  [<ffffffff8154837e>] dump_stack+0x19/0x1b
  [<ffffffff8104212b>] warn_slowpath_common+0x6b/0xa0
  [<ffffffff81042175>] warn_slowpath_null+0x15/0x20
  [<ffffffff81026b09>] native_smp_send_reschedule+0x59/0x60
  [<ffffffff81077486>] wake_up_nohz_cpu+0x46/0xf0
  [<ffffffff810529db>] add_timer_on+0xdb/0x110
  [<ffffffff8101e4f4>] mce_start_timer+0x64/0x70
  [<ffffffff8101e552>] __mcheck_cpu_init_timer+0x52/0x60
  [<ffffffff8153e22e>] mcheck_cpu_init+0x6f/0x111
  [<ffffffff8153b94e>] identify_cpu+0x3cc/0x3f9
  [<ffffffff8153b98d>] identify_secondary_cpu+0x12/0x1d
  [<ffffffff8153fdd6>] smp_store_cpu_info+0x3a/0x3c
  [<ffffffff8153fec2>] smp_callin+0xea/0x1c1
  [<ffffffff8153ffbd>] start_secondary+0x24/0x97
 ---[ end trace 954b959ede48c006 ]---
 microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60f
 CPU1 is up
 i915 0000:00:02.0: power state changed by ACPI to D0
[ ... snip ... ]

I.e. the "CPU1 is up" happens only after the microcode has been updated, 
but the attempt to send IPI to it indeed seems to happen earlier.

-- 
Jiri Kosina
SUSE Labs
