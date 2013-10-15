Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab3JOOhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:37:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab3JOOg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:36:58 -0400
Date: Tue, 15 Oct 2013 10:36:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dave.hansen@linux.intel.com, eranian@google.com, ak@linux.intel.com,
        jmario@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: x86, perf: throttling issues with long nmi latencies
Message-ID: <20131015143631.GZ227855@redhat.com>
References: <20131014203549.GY227855@redhat.com>
 <20131015101404.GD10651@twins.programming.kicks-ass.net>
 <20131015130226.GX26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015130226.GX26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 03:02:26PM +0200, Peter Zijlstra wrote:
> On Tue, Oct 15, 2013 at 12:14:04PM +0200, Peter Zijlstra wrote:
> >  arch/x86/kernel/cpu/perf_event_intel_ds.c | 43 ++++++++++++++++++++++---------
> >  1 file changed, 31 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > index 32e9ed81cd00..3978e72a1c9f 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > @@ -722,6 +722,8 @@ void intel_pmu_pebs_disable_all(void)
> >  		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
> >  }
> >  
> > +static DEFINE_PER_CPU(u8 [PAGE_SIZE], insn_page);
> > +
> >  static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
> >  {
> >  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> > @@ -729,6 +731,8 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
> >  	unsigned long old_to, to = cpuc->lbr_entries[0].to;
> >  	unsigned long ip = regs->ip;
> >  	int is_64bit = 0;
> > +	int size, bytes;
> > +	void *kaddr;
> >  
> >  	/*
> >  	 * We don't need to fixup if the PEBS assist is fault like
> > @@ -763,29 +767,44 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
> >  		return 1;
> >  	}
> >  
> > +refill:
> > +	if (kernel_ip(ip)) {
> > +		u8 *buf = &__get_cpu_var(insn_page[0]);
> > +		size = PAGE_SIZE - ((unsigned long)to & (PAGE_SIZE-1));
> > +		if (size < MAX_INSN_SIZE) {
> > +			/*
> > +			 * If we're going to have to touch two pages; just copy
> > +			 * as much as we can hold.
> > +			 */
> > +			size = PAGE_SIZE;
> 
> 
> Arguably we'd want that to be:
> 
> 			size = min(PAGE_SIZE, ip - to);
> 
> As there's no point in copying beyond the basic block.

Hey Peter,

I haven't looked to deep yet, but it has panic'd twice with


intel-brickland-03 login: [  385.203323] BUG: unable to handle kernel paging request at 00000000006e39f0
[  385.211128] IP: [<ffffffff812fc419>] insn_get_prefixes.part.2+0x29/0x270
[  385.218635] PGD 1850266067 PUD 1848f21067 PMD 18485aa067 PTE 84aabf025
[  385.225981] Oops: 0000 [#1] SMP
[  385.229609] Modules linked in: nfsv3 nfs_acl nfs lockd sunrpc fscache nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sg xfs libcrc32c iTCO_wdt iTCO_vendor_support ixgbe ptp pcspkr pps_core mtip32xx mdio lpc_ich i2c_i801 dca mfd_core wmi acpi_cpufreq mperf binfmt_misc sr_mod sd_mod cdrom crc_t10dif mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm ahci libahci libata megaraid_sas i2c_core dm_mirror dm_region_hash dm_log dm_mod
[  385.303771] CPU: 0 PID: 9545 Comm: xlinpack_xeon64 Not tainted 3.10.0c2c_mmap2+ #37
[  385.312327] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BIVTSDP1.86B.0038.R02.1307231126 07/23/2013
[  385.323892] task: ffff88203cd9e680 ti: ffff88204e4d8000 task.ti: ffff88204e4d8000
[  385.332253] RIP: 0010:[<ffffffff812fc419>]  [<ffffffff812fc419>] insn_get_prefixes.part.2+0x29/0x270
[  385.342473] RSP: 0000:ffff88085f806a18  EFLAGS: 00010083
[  385.348408] RAX: 0000000000000001 RBX: ffff88085f806b20 RCX: 0000000000000000
[  385.356379] RDX: 00000000006e39f0 RSI: 00000000006e39f0 RDI: ffff88085f806b20
[  385.364350] RBP: ffff88085f806a38 R08: 00000000006e39f0 R09: ffff88085f806b20
[  385.372324] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88085f80c9a0
[  385.380295] R13: ffff88085f806b20 R14: ffff88085f806c08 R15: 000000007fffffff
[  385.388268] FS:  0000000001679680(0063) GS:ffff88085f800000(0000) knlGS:0000000000000000
[  385.397307] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  385.403725] CR2: 00000000006e39f0 CR3: 0000001847c70000 CR4: 00000000001407f0
[  385.411697] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  385.419669] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  385.427640] Stack:
[  385.429885]  ffff88085f806b20 ffff88085f80c9a0 00000000006e39f0 ffff88085f806c08
[  385.438199]  ffff88085f806a58 ffffffff812fc7fd ffff88085f806b20 ffff88085f80c9a0
[  385.446513]  ffff88085f806a78 ffffffff812fc92d ffff88085f806b20 ffff88085f80c9a0
[  385.454830] Call Trace:
[  385.457561]  <NMI>
[  385.459710]  [<ffffffff812fc7fd>] insn_get_opcode+0x9d/0x160
[  385.466254]  [<ffffffff812fc92d>] insn_get_modrm.part.4+0x6d/0xf0
[  385.473065]  [<ffffffff812fca2e>] insn_get_sib+0x1e/0x80
[  385.478991]  [<ffffffff812fcb15>] insn_get_displacement+0x85/0x110
[  385.485898]  [<ffffffff812fccb5>] insn_get_immediate+0x115/0x3d0
[  385.492611]  [<ffffffff812fcfa5>] insn_get_length+0x35/0x40
[  385.498832]  [<ffffffff810254a2>] __intel_pmu_pebs_event+0x2e2/0x550
[  385.505937]  [<ffffffff810df24c>] ? __audit_syscall_exit+0x4c/0x2a0
[  385.512944]  [<ffffffff81018b65>] ? native_sched_clock+0x15/0x80
[  385.519655]  [<ffffffff81018bd9>] ? sched_clock+0x9/0x10
[  385.525591]  [<ffffffff8102585f>] intel_pmu_drain_pebs_nhm+0x14f/0x1c0
[  385.532888]  [<ffffffff81026fb2>] intel_pmu_handle_irq+0x372/0x490
[  385.539795]  [<ffffffff81018b65>] ? native_sched_clock+0x15/0x80
[  385.546507]  [<ffffffff81018bd9>] ? sched_clock+0x9/0x10
[  385.552446]  [<ffffffff810976f5>] ? sched_clock_cpu+0xb5/0x100
[  385.558968]  [<ffffffff8160437b>] perf_event_nmi_handler+0x2b/0x50
[  385.565876]  [<ffffffff81603b39>] nmi_handle.isra.0+0x59/0x90
[  385.572297]  [<ffffffff81603c40>] do_nmi+0xd0/0x310
[  385.577746]  [<ffffffff81603181>] end_repeat_nmi+0x1e/0x2e
[  385.583873]  <<EOE>>
[  385.586217] Code: 90 90 0f 1f 44 00 00 55 48 89 e5 41 56 41 55 49 89 fd 41 54 53 48 8b 57 58 48 8d 42 01 48 2b 47 50 48 83 f8 10 0f 8f 5b 01 00 00 <0f> b6 1a 45 31 e4 0f b6 fb e8 29 fe ff ff 83 e0 0f 31 f6 8d 50
[  385.608244] RIP  [<ffffffff812fc419>] insn_get_prefixes.part.2+0x29/0x270
[  385.615840]  RSP <ffff88085f806a18>
[  385.619736] CR2: 00000000006e39f0
[    0.000000] Initializing cgroup subsys cpuset

Quick thoughts?

Cheers,
Don
