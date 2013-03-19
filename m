Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3CSMLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:11:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab3CSMLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:11:15 -0400
Message-ID: <514855D7.2080108@redhat.com>
Date: Tue, 19 Mar 2013 08:11:03 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: clockevents: WARNING when settimeofday() is called
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note: I can also reproduce this on latest top-of-tree but I didn't keep my
debug output :(.  I'll checkout a new tree and do the same debug if necessary.]

settimeofday causes a backtrace WARNING in clockevents code on large CPU count
systems .  Debugging points to lapic timer (which is used as a broadcast timer)
being problematic after settimeofday() is called.

Tried to debug this using printk's thinking that it was a problem in
settimeofday() where we release irqs and then adjust the hrtimers.   It turns
out that this is likely the case.  The comments with '<<<' are added after
the output to give an idea of what I added during debug.

[  131.044947] do_settimeofday: 1 irqs off cpu 11 with timespec sec = 100 nsec =
100000 <<< debug line after irqs off in do_settimeofday()
[  131.052177] do_settimeofday: 2 current time sec = 1363692316 nsec = 199596399
[  131.059282] do_settimeofday: irqs on cpu 11 << end of settimeofday() before
call to clock_was_set();
[  131.063134] clock_was_set: called
[  131.066751] ------------[ cut here ]------------ <<< beginning of stack trace
... this is where the WARNING actually occurs.
[  131.066751] clock_was_set: on_each_cpu() <<< IPI from for_each_cpu()
[  131.066753] clock_was_set: finished
[  131.096448] WARNING: at kernel/time/clockevents.c:209
clockevents_program_event+0x135/0x140()
[  131.104935] Hardware name: Dinar
[  131.108150] Modules linked in: sg nfsv3 nfs_acl nfsv4 auth_rpcgss nfs
dns_resolver fscache lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast
ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter ip_tables kvm_amd kvm sp5100_tco bnx2 i2c_piix4
crc32c_intel k10temp fam15h_power ghash_clmulni_intel amd64_edac_mod pcspkr
serio_raw edac_mce_amd edac_core microcode xfs libcrc32c sr_mod sd_mod cdrom
ata_generic crc_t10dif pata_acpi radeon i2c_algo_bit drm_kms_helper ttm drm ahci
pata_atiixp libahci libata usb_storage i2c_core dm_mirror dm_region_hash dm_log
dm_mod
[  131.176784] Pid: 0, comm: swapper/28 Not tainted 3.8.0+ #6
[  131.182248] Call Trace:
[  131.184684]  <IRQ>  [<ffffffff810612af>] warn_slowpath_common+0x7f/0xc0
[  131.191312]  [<ffffffff8106130a>] warn_slowpath_null+0x1a/0x20
[  131.197131]  [<ffffffff810b9fd5>] clockevents_program_event+0x135/0x140
[  131.203721]  [<ffffffff810bb584>] tick_program_event+0x24/0x30
[  131.209534]  [<ffffffff81089ab1>] hrtimer_interrupt+0x131/0x230
[  131.215437]  [<ffffffff814b9600>] ? cpufreq_p4_target+0x130/0x130
[  131.221509]  [<ffffffff81619119>] smp_apic_timer_interrupt+0x69/0x99
[  131.227839]  [<ffffffff8161805d>] apic_timer_interrupt+0x6d/0x80
[  131.233816]  <EOI>  [<ffffffff81099745>] ? sched_clock_cpu+0xc5/0x120
[  131.240267]  [<ffffffff814b9ff0>] ? cpuidle_wrap_enter+0x50/0xa0
[  131.246252]  [<ffffffff814b9fe9>] ? cpuidle_wrap_enter+0x49/0xa0
[  131.252238]  [<ffffffff814ba050>] cpuidle_enter_tk+0x10/0x20
[  131.257877]  [<ffffffff814b9c89>] cpuidle_idle_call+0xa9/0x260
[  131.263692]  [<ffffffff8101c42f>] cpu_idle+0xaf/0x120
[  131.268727]  [<ffffffff815f8971>] start_secondary+0x255/0x257
[  131.274449] ---[ end trace 1151a50552231615 ]---
[  131.279047] clockevents_program_event: cpu = 28 name = lapic expires.tv64 =
-11431039 <<< data from 'broken' clockevent.  Note, I have not seen any other
clockevent than the lapic.

ie) in the code,

int do_settimeofday(const struct timespec *tv)
{
        struct timekeeper *tk = &timekeeper;
        struct timespec ts_delta, xt;
        unsigned long flags;

        if (!timespec_valid_strict(tv))
                return -EINVAL;

        write_seqlock_irqsave(&tk->lock, flags);

	... update time code ...

        write_sequnlock_irqrestore(&tk->lock, flags);

        /* signal hrtimers about time change */

        clock_was_set(); <<< this is called without irq protection.  If an
hrtimer fires in the window that it takes to do the IPI in for_each_cpu() in
clock_was_set() then we get a WARNING.

        return 0;
}


Is there something peculiar about the lapic timer that would cause this to
happen and not to other hrtimers?  ie) is there some subtlety of the lapic timer
that I'm missing?  If not then here are some possible fixes:

- I could lock the hrtimer_bases by acquiring all the base locks which
would prevent the hrtimer_interrupts from executing.  This would require some
reworking of the code (obviously) in both the hrtimer core code and the
places where we call time_was_set() throughout the kernel... but that seems
awfully messy and there has to be a better way :/.

- It might be possible to do something with stop_machine() which
would guarantee cpu rendezvous in a state where no locks can be held and
then update the system time.  In theory the places where clock_was_set() needs
to be called are rare slow paths so it shouldn't be a problem to use the heavy
handed stop_machine().

Obviously, I'm looking for any suggestions on a solution.  I think I'm
familiar enough with the code to take a suggestion and code it.

P.
