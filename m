Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaIVObv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:31:51 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:58576 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaIVObu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:31:50 -0400
Message-ID: <542032D4.305@redhat.com>
Date: Mon, 22 Sep 2014 16:31:48 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        David Matlack <dmatlack@google.com>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
References: <1411167805-2458-1-git-send-email-dmatlack@google.com> <541FFEDE.9030800@redhat.com> <542027F6.4050205@de.ibm.com>
In-Reply-To: <542027F6.4050205@de.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2014 15:45, Christian Borntraeger ha scritto:
> We now have an extra condition check for every valid ioctl, to make an error case go faster.
> I know, the extra check is just a 1 or 2 cycles if branch prediction is right, but still.

I applied the patch because the delay could be substantial, depending on
what the other VCPU is doing.  Perhaps something like this would be
better?

(Untested, but Tested-by/Reviewed-bys are welcome).

Paolo

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 84e24b210273..ed31760d79fe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -117,12 +117,10 @@ bool kvm_is_mmio_pfn(pfn_t pfn)
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
  */
-int vcpu_load(struct kvm_vcpu *vcpu)
+static void __vcpu_load(struct kvm_vcpu *vcpu)
 {
 	int cpu;
 
-	if (mutex_lock_killable(&vcpu->mutex))
-		return -EINTR;
 	if (unlikely(vcpu->pid != current->pids[PIDTYPE_PID].pid)) {
 		/* The thread running this VCPU changed. */
 		struct pid *oldpid = vcpu->pid;
@@ -136,6 +134,14 @@ int vcpu_load(struct kvm_vcpu *vcpu)
 	preempt_notifier_register(&vcpu->preempt_notifier);
 	kvm_arch_vcpu_load(vcpu, cpu);
 	put_cpu();
+}
+
+int vcpu_load(struct kvm_vcpu *vcpu)
+{
+	if (mutex_lock_killable(&vcpu->mutex))
+		return -EINTR;
+
+	__vcpu_load(vcpu);
 	return 0;
 }
 
@@ -1989,9 +1995,6 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	if (vcpu->kvm->mm != current->mm)
 		return -EIO;
 
-	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
-		return -EINVAL;
-
 #if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS)
 	/*
 	 * Special cases: vcpu ioctls that are asynchronous to vcpu execution,
@@ -2001,8 +2004,21 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		return kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 #endif
 
+	if (!mutex_trylock(&vcpu->mutex))) {
+		/*
+		 * Before a potentially long sleep, check if we'd exit anyway.
+		 * The common case is for the mutex not to be contended, when
+		 * this does not add overhead.
+		 */
+		if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
+			return -EINVAL;
+
+		if (mutex_lock_killable(&vcpu->mutex))
+			return -EINTR;
+	}
+
 
-	r = vcpu_load(vcpu);
+	r = __vcpu_load(vcpu);
 	if (r)
 		return r;
 	switch (ioctl) {

