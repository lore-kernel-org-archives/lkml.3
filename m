Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3C1SYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3C1SYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:24:37 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [RFE PATCH] hrtimer, add expiry time overflow check in hrtimer_interrupt
Date: Thu, 28 Mar 2013 14:24:22 -0400
Message-Id: <1364495062-26997-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The settimeofday01 test in the LTP testsuite effectively does

        gettimeofday(current time);
        settimeofday(Jan 1, 1970 + 100 seconds);
        settimeofday(current time);

This test causes a stack trace to be displayed on the console during the
setting of timeofday to Jan 1, 1970 + 100 seconds:

[  131.066751] ------------[ cut here ]------------
[  131.096448] WARNING: at kernel/time/clockevents.c:209 clockevents_program_event+0x135/0x140()
[  131.104935] Hardware name: Dinar
[  131.108150] Modules linked in: sg nfsv3 nfs_acl nfsv4 auth_rpcgss nfs dns_resolver fscache lockd sunrpc nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables kvm_amd kvm sp5100_tco bnx2 i2c_piix4 crc32c_intel k10temp fam15h_power ghash_clmulni_intel amd64_edac_mod pcspkr serio_raw edac_mce_amd edac_core microcode xfs libcrc32c sr_mod sd_mod cdrom ata_generic crc_t10dif pata_acpi radeon i2c_algo_bit drm_kms_helper ttm drm ahci pata_atiixp libahci libata usb_storage i2c_core dm_mirror dm_region_hash dm_log dm_mod
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

When we change the system time to a low value like this, the value of
timekeeper->offs_real will be a negative value.

It seems that the WARN occurs because an hrtimer has been started in the time
between the releasing of the timekeeper lock and the IPI call (via a call to
on_each_cpu) in clock_was_set() in the do_settimeofday() code.  The end result
is that a REALTIME_CLOCK timer has been added with softexpires = expires =
KTIME_MAX.  The hrtimer_interrupt() fires/is called and the loop at
kernel/hrtimer.c:1289 is executed.  In this loop the code subtracts the
clock base's offset (which was set to timekeeper->offs_real in
do_settimeofday()) from the current hrtimer_cpu_base->expiry value (which
was KTIME_MAX):

	KTIME_MAX - (a negative value) = overflow

A simple check for an overflow can resolve this problem.  Using KTIME_MAX
instead of the overflow value will result in the hrtimer function being run,
and the reprogramming of the timer after that.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
---
 kernel/hrtimer.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cc47812..17eafd7 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1309,6 +1309,8 @@ retry:
 
 				expires = ktime_sub(hrtimer_get_expires(timer),
 						    base->offset);
+				if (expires.tv64 < 0)
+					expires.tv64 = KTIME_MAX;
 				if (expires.tv64 < expires_next.tv64)
 					expires_next = expires;
 				break;
-- 
1.7.9.3

