Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaA3Iue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 03:50:34 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:48349 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaA3Iub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 03:50:31 -0500
Date: Thu, 30 Jan 2014 09:50:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: x86: disabled interrupts on shutdown causing tlb flush WARNs
Message-ID: <20140130085027.GA2024@gmail.com>
References: <20140129185453.GA25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129185453.GA25953@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> Hi Ingo,
> 
> A while ago patch 55c844a4dd16a4d1fdc0cf2a283ec631a02ec448 was committed
> to deal with WARN_ONs during shutdown in native_smp_send_reschedule() (in
> arch/x86/kernel/smp.c).
> 
> The solution at the time was to disable local interrupts to block the
> timer interrupt from calling the reschedule function during
> shutdown/reboot.
> 
> Lately, we have a customer who says that patch is causing a new WARN_ON in
> kernel/smp.c::smp_call_function_many() because irqs are disabled.
> 
> It seems to be related to iounmap calling flush_tlb_kernel_range.
> 
> stack is:
> 
> [ 3255.956295] WARNING: at kernel/smp.c:387 smp_call_function_many+0xaf/0x2c0()
> [ 3255.956295] Modules linked in: nf_conntrack_netbios_ns
> nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6table_security
> ip6table_raw ip6t_REJECT iptable_nat nf_nat_ipv4 iptable_mangle
> iptable_security iptable_raw ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4
> xt_conntrack ebtable_filter ebtables ip6table_filter sg iptable_filter
> ip_tables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 nf_nat
> nf_conntrack ip6_tables coretemp kvm_intel kvm crc32_pclmul crc32c_intel
> ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper
> cryptd microcode pcspkr be2net iTCO_wdt iTCO_vendor_support ixgbe ses ptp
> enclosure pps_core hpilo hpwdt mdio lpc_ich mfd_core ioatdma shpchp dca
> vfat fat acpi_cpufreq mperf dm_service_time sd_mod lpfc mgag200
> syscopyarea qla2xxx crc_t10dif sysfillrect sysimgblt i2c_algo_bit
> drm_kms_helper scsi_transport_fc ttm scsi_tgt drm i2c_core dm_multipath
> dm_mirror dm_region_hash dm_log dm_mod
> [ 3255.956295] CPU: 0 PID: 19237 Comm: reboot Not tainted 3.10.0-33.el7.x86_64 #1
> [ 3255.956295]  0000000000000009 ffff901f4e42bb50 ffffffff815fdacb ffff901f4e42bb88
> [ 3255.956295]  ffffffff81058c61 0000000000000000 ffffffff81a08c20 0000000000000000
> [ 3255.956295]  0000000000000000 ffffffff81a08c20 ffff901f4e42bb98 ffffffff81058d3a
> [ 3255.956295] Call Trace:
> [ 3255.956295]  [<ffffffff815fdacb>] dump_stack+0x19/0x1b
> [ 3255.956295]  [<ffffffff81058c61>] warn_slowpath_common+0x61/0x80
> [ 3255.956295]  [<ffffffff81058d3a>] warn_slowpath_null+0x1a/0x20
> [ 3255.956295]  [<ffffffff810b843f>] smp_call_function_many+0xaf/0x2c0
> [ 3255.956295]  [<ffffffff811647ee>] ? __insert_vmap_area+0x8e/0xc0
> [ 3255.956295]  [<ffffffff8104c2a0>] ? flush_tlb_func+0xb0/0xb0
> [ 3255.956295]  [<ffffffff8104c2a0>] ? flush_tlb_func+0xb0/0xb0
> [ 3255.956295]  [<ffffffff810b86ad>] on_each_cpu+0x2d/0x60
> [ 3255.956295]  [<ffffffff8104c73a>] flush_tlb_kernel_range+0x4a/0x70
> [ 3255.956295]  [<ffffffff8116524c>] __purge_vmap_area_lazy+0x16c/0x1d0
> [ 3255.956295]  [<ffffffff8116549e>] free_vmap_area_noflush+0x5e/0x60
> [ 3255.956295]  [<ffffffff81166d5e>] remove_vm_area+0x5e/0x70
> [ 3255.956295]  [<ffffffff810478c7>] iounmap+0x67/0xa0
> [ 3255.956295]  [<ffffffff8134e3d6>] acpi_os_write_memory+0x89/0x9d
> [ 3255.956295]  [<ffffffff81368887>] acpi_hw_write+0x3d/0x4e
> [ 3255.956295]  [<ffffffff813691c6>] acpi_reset+0x4f/0x51
> [ 3255.956295]  [<ffffffff8134ed40>] acpi_reboot+0xb0/0xb8
> [ 3255.956295]  [<ffffffff81035cc6>] native_machine_emergency_restart+0x186/0x240
> [ 3255.956295]  [<ffffffff810383a2>] ? disconnect_bsp_APIC+0x82/0xc0
> [ 3255.956295]  [<ffffffff810357c7>] native_machine_restart+0x37/0x40
> [ 3255.956295]  [<ffffffff81035a3f>] machine_restart+0xf/0x20
> [ 3255.956295]  [<ffffffff81071375>] kernel_restart+0x45/0x60
> [ 3255.956295]  [<ffffffff810715b9>] SYSC_reboot+0x229/0x260
> [ 3255.956295]  [<ffffffff8119a3a6>] ? do_readv_writev+0x176/0x240
> [ 3255.956295]  [<ffffffff8119af93>] ? __fput+0x183/0x270
> [ 3255.956295]  [<ffffffff8119b1ae>] ? ____fput+0xe/0x10
> [ 3255.956295]  [<ffffffff8107161e>] SyS_reboot+0xe/0x10
> [ 3255.956295]  [<ffffffff8160cf99>] system_call_fastpath+0x16/0x1b

I think a low level reboot method like acpi_reboot() calling 
on_each_cpu() is unrobust, and it is the source of the problem.

Thanks,

	Ingo
