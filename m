Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab3CLXCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:02:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933673Ab3CLWdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [ 074/100] x86: pvclock kvm: align allocation size to page size
Date: Tue, 12 Mar 2013 15:31:59 -0700
Message-Id: <20130312223130.903868541@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit ed55705dd5008b408c48a8459b8b34b01f3de985 upstream.

To match whats mapped via vsyscalls to userspace.

Reported-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/kvmclock.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -218,6 +218,9 @@ static void kvm_shutdown(void)
 void __init kvmclock_init(void)
 {
 	unsigned long mem;
+	int size;
+
+	size = PAGE_ALIGN(sizeof(struct pvclock_vsyscall_time_info)*NR_CPUS);
 
 	if (!kvm_para_available())
 		return;
@@ -231,16 +234,14 @@ void __init kvmclock_init(void)
 	printk(KERN_INFO "kvm-clock: Using msrs %x and %x",
 		msr_kvm_system_time, msr_kvm_wall_clock);
 
-	mem = memblock_alloc(sizeof(struct pvclock_vsyscall_time_info)*NR_CPUS,
-			     PAGE_SIZE);
+	mem = memblock_alloc(size, PAGE_SIZE);
 	if (!mem)
 		return;
 	hv_clock = __va(mem);
 
 	if (kvm_register_clock("boot clock")) {
 		hv_clock = NULL;
-		memblock_free(mem,
-			sizeof(struct pvclock_vsyscall_time_info)*NR_CPUS);
+		memblock_free(mem, size);
 		return;
 	}
 	pv_time_ops.sched_clock = kvm_clock_read;
@@ -275,7 +276,7 @@ int __init kvm_setup_vsyscall_timeinfo(v
 	struct pvclock_vcpu_time_info *vcpu_time;
 	unsigned int size;
 
-	size = sizeof(struct pvclock_vsyscall_time_info)*NR_CPUS;
+	size = PAGE_ALIGN(sizeof(struct pvclock_vsyscall_time_info)*NR_CPUS);
 
 	preempt_disable();
 	cpu = smp_processor_id();


