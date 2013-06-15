Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3FOSDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 14:03:06 -0400
Received: from mx2.parallels.com ([199.115.105.18]:51672 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab3FOSDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 14:03:04 -0400
From: Eugene Batalov <ebatalov@parallels.com>
To: <kvm@vger.kernel.org>
CC: Eugene Batalov <ebatalov@parallels.com>, <imammedo@redhat.com>,
        <mtosatti@redhat.com>, <linux-kernel@vger.kernel.org>,
        <eabatalov89@gmail.com>
Subject: [PATCHv1] kvm guest: fix uninitialized kvmclock read by KVM guest
Date: Sat, 15 Jun 2013 22:01:45 +0400
Message-ID: <1371319305-590-1-git-send-email-ebatalov@parallels.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20130610201933.GA31409@amt.cnet>
References: <20130610201933.GA31409@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to unintialized kvmclock read KVM guest is hanging on SMP boot stage.
If unintialized memory contains fatal garbage then hang reproduction is 100%.
Unintialized memory is allocated by memblock_alloc. So the garbage values
depend on many many things.

See the detailed description of the bug and possible ways to fix it
in the kernel bug tracker.
"Bug 59521 - KVM linux guest reads uninitialized pvclock values before
executing rdmsr MSR_KVM_WALL_CLOCK"

I decided to fix it simply returning 0ULL from kvm_clock_read when
kvm clocksource is not initialized yet.
The same as kernel bootstrap CPU doesn on boot stage when kernel
clocksources are not initialized yet.

Signed-off-by: Eugene Batalov <ebatalov@parallels.com>
---
I dont' use kernel percpu variables because for each SMP CPU
their contents are copied from the bootstrap CPU. And I don't
think that fixing the value for each SMP CPU is a good style.
If you know a better approach to store the is_pv_clock_ready flags
I am ready to use it.

The patch applies cleanly to
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

I've tested the changes with Ubuntu 13.04 "raring" userspace and
Ubuntu-3.8.0.19-30 kernel tag.

 arch/x86/kernel/kvmclock.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5bedbdd..a6e0af4 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -43,6 +43,9 @@ early_param("no-kvmclock", parse_no_kvmclock);
 static struct pvclock_vsyscall_time_info *hv_clock;
 static struct pvclock_wall_clock wall_clock;
 
+/* For each cpu store here a flag which tells whether pvclock is initialized */
+static int __cacheline_aligned_in_smp is_pv_clock_ready[NR_CPUS] = {};
+
 /*
  * The wallclock is the time of day when we booted. Since then, some time may
  * have elapsed since the hypervisor wrote the data. So we try to account for
@@ -84,8 +87,11 @@ static cycle_t kvm_clock_read(void)
 
 	preempt_disable_notrace();
 	cpu = smp_processor_id();
-	src = &hv_clock[cpu].pvti;
-	ret = pvclock_clocksource_read(src);
+	if (is_pv_clock_ready[cpu]) {
+		src = &hv_clock[cpu].pvti;
+		ret = pvclock_clocksource_read(src);
+	} else
+		ret = 0ULL;
 	preempt_enable_notrace();
 	return ret;
 }
@@ -168,6 +174,9 @@ int kvm_register_clock(char *txt)
 	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
 	       cpu, high, low, txt);
 
+	if (!ret)
+		is_pv_clock_ready[cpu] = 1;
+
 	return ret;
 }
 
-- 
1.7.9.5

