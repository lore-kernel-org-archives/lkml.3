Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451Ab3EFXpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:45:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053Ab3EFW6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:58:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 11/46] xen/time: Fix kasprintf splat when allocating timer%d IRQ line.
Date: Mon,  6 May 2013 15:58:17 -0700
Message-Id: <20130506225821.866881777@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 7918c92ae9638eb8a6ec18e2b4a0de84557cccc8 upstream.

When we online the CPU, we get this splat:

smpboot: Booting Node 0 Processor 1 APIC 0x2
installing Xen timer for CPU 1
BUG: sleeping function called from invalid context at /home/konrad/ssd/konrad/linux/mm/slab.c:3179
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/1
Pid: 0, comm: swapper/1 Not tainted 3.9.0-rc6upstream-00001-g3884fad #1
Call Trace:
 [<ffffffff810c1fea>] __might_sleep+0xda/0x100
 [<ffffffff81194617>] __kmalloc_track_caller+0x1e7/0x2c0
 [<ffffffff81303758>] ? kasprintf+0x38/0x40
 [<ffffffff813036eb>] kvasprintf+0x5b/0x90
 [<ffffffff81303758>] kasprintf+0x38/0x40
 [<ffffffff81044510>] xen_setup_timer+0x30/0xb0
 [<ffffffff810445af>] xen_hvm_setup_cpu_clockevents+0x1f/0x30
 [<ffffffff81666d0a>] start_secondary+0x19c/0x1a8

The solution to that is use kasprintf in the CPU hotplug path
that 'online's the CPU. That is, do it in in xen_hvm_cpu_notify,
and remove the call to in xen_hvm_setup_cpu_clockevents.

Unfortunatly the later is not a good idea as the bootup path
does not use xen_hvm_cpu_notify so we would end up never allocating
timer%d interrupt lines when booting. As such add the check for
atomic() to continue.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/enlighten.c |    5 ++++-
 arch/x86/xen/time.c      |    6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1365,8 +1365,11 @@ static int __cpuinit xen_hvm_cpu_notify(
 	switch (action) {
 	case CPU_UP_PREPARE:
 		xen_vcpu_setup(cpu);
-		if (xen_have_vector_callback)
+		if (xen_have_vector_callback) {
 			xen_init_lock_cpu(cpu);
+			if (xen_feature(XENFEAT_hvm_safe_pvclock))
+				xen_setup_timer(cpu);
+		}
 		break;
 	default:
 		break;
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -482,7 +482,11 @@ static void xen_hvm_setup_cpu_clockevent
 {
 	int cpu = smp_processor_id();
 	xen_setup_runstate_info(cpu);
-	xen_setup_timer(cpu);
+	/*
+	 * xen_setup_timer(cpu) - snprintf is bad in atomic context. Hence
+	 * doing it xen_hvm_cpu_notify (which gets called by smp_init during
+	 * early bootup and also during CPU hotplug events).
+	 */
 	xen_setup_cpu_clockevents();
 }
 


