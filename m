Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3EJRBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:01:50 -0400
Received: from smtp.riverbed.com ([208.70.196.45]:25005 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3EJRBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:01:48 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2013 13:01:48 EDT
From: Ming Lei <Ming.Lei@riverbed.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "tony.luck@intel.com" <tony.luck@intel.com>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: x86_mce: mce_start uses number of phsical cores instead of logical
 cores
Thread-Topic: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Index: Ac5NnrX+OJKCA1vXQtyGCRlOybefOw==
Date: Fri, 10 May 2013 16:52:09 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.254]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I found this bug in my edac testing on intel 56xx motherboard. I did mce-inject test on AMD 64 CPU also. Thanks


Subject: [PATCH] mce_start times out waiting for the logical cores which have never received the mce broadcast. It can potentially turn non fatal mce exception into kernel panic complaining "Some CPUs didn't answer in synchronization". Here is the example of console log before and after the fix.

mce: [Hardware Error]: CPU 16: Machine Check Exception: 4 Bank 8: be0000000001009f
mce: [Hardware Error]: TSC 2d7ff062dc4 ADDR 622eac800 MISC 1004000006040
mce: [Hardware Error]: PROCESSOR 0:206c2 TIME 1368135921 SOCKET 0 APIC 13 microcode 15
mce: [Hardware Error]: Some CPUs didn't answer in synchronization
mce: [Hardware Error]: Machine check: Processor context corrupt
Kernel panic - not syncing: Fatal machine check on current CPU

[admin@amnesiac ~]# cd /sys/devices/system/edac/mc/mc0
[admin@amnesiac mc0]# echo 2 >inject_type
[admin@amnesiac mc0]# echo 3 >inject_section
[admin@amnesiac mc0]# echo 65600 >inject_eccmask
[admin@amnesiac mc0]# echo 1 >inject_enable
[admin@amnesiac mc0]# mce: [Hardware Error]: CPU 0: Machine Check Exception: 4 Bank 8: be0000000001009f
mce: [Hardware Error]: TSC 12541d6511e ADDR 625f2d380 MISC 1004000001181
mce: [Hardware Error]: PROCESSOR 0:206c2 TIME 1368141409 SOCKET 0 APIC 0 microcode 15
mce: [Hardware Error]: Machine check: Processor context corrupt
Kernel panic - not syncing: Fatal Machine check

I saw duplicate mce entries being logged when mce exception is fatal so solution is only allow the Monarch doing mce_log.
---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9239504..7a40ae5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -796,6 +796,10 @@ static int mce_start(int *no_way_out)
 	if (!timeout)
 		return -1;
 
+#if NR_CPUS > 1
+	cpus /= cpumask_weight(cpu_core_mask(0)) / cpu_data(0).booted_cores;
+#endif
+
 	atomic_add(*no_way_out, &global_nwo);
 	/*
 	 * global_nwo should be updated before mce_callin
@@ -871,6 +875,10 @@ static int mce_end(int order)
 		/* CHECKME: Can this race with a parallel hotplug? */
 		int cpus = num_online_cpus();
 
+#if NR_CPUS > 1
+		cpus /= cpumask_weight(cpu_core_mask(0)) /
+			cpu_data(0).booted_cores;
+#endif
+
 		/*
 		 * Monarch: Wait for everyone to go through their scanning
 		 * loops.
@@ -1113,7 +1121,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
 			mce_ring_add(m.addr >> PAGE_SHIFT);
 
-		mce_log(&m);
+		if (atomic_read(&mce_executing) <= 1)
+			mce_log(&m);
 
 		if (severity > worst) {
 			*final = m;
--

