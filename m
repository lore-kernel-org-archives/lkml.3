Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab3ERCSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:18:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3ERCQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:59 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=c8QXKa4_xSoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fR2S3pHwVBQA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=GwTQQQbaBWdsK5bCS4QA:9 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=WwgC8nHKvroA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021650.295325909@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [ 053/136 ] hrtimer: Add expiry time overflow check in hrtimer_interrupt
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0053-hrtimer-Add-expiry-time-overflow-check-in-hrtimer_in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

[ Upstream commit 8f294b5a139ee4b75e890ad5b443c93d1e558a8b ]

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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[jstultz: Tweaked commit subject]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/hrtimer.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 532294f..e3999c2 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1312,6 +1312,8 @@ retry:
 
 				expires = ktime_sub(hrtimer_get_expires(timer),
 						    base->offset);
+				if (expires.tv64 < 0)
+					expires.tv64 = KTIME_MAX;
 				if (expires.tv64 < expires_next.tv64)
 					expires_next = expires;
 				break;
-- 
1.7.10.4


