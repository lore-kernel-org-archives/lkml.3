Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaIVSfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:35:48 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37765 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbaIVSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:35:45 -0400
Date: Mon, 22 Sep 2014 11:35:42 -0700
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
Message-ID: <20140922183542.GA1018@google.com>
References: <1411167805-2458-1-git-send-email-dmatlack@google.com>
 <541FFEDE.9030800@redhat.com>
 <542027F6.4050205@de.ibm.com>
 <542032D4.305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542032D4.305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22, Paolo Bonzini wrote:
> Il 22/09/2014 15:45, Christian Borntraeger ha scritto:
> > We now have an extra condition check for every valid ioctl, to make an error case go faster.
> > I know, the extra check is just a 1 or 2 cycles if branch prediction is right, but still.
> 
> I applied the patch because the delay could be substantial, depending on
> what the other VCPU is doing.  Perhaps something like this would be
> better?

I'm happy with either approach.

> 
> (Untested, but Tested-by/Reviewed-bys are welcome).

There were a few build bugs in your diff. Here's a working version that
I tested. Feel free to add my Tested-by and Reviewed-by if you go with
this.


diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c71931f..fbdcdc2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -133,12 +133,10 @@ bool kvm_is_mmio_pfn(pfn_t pfn)
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
@@ -151,6 +149,14 @@ int vcpu_load(struct kvm_vcpu *vcpu)
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
 
@@ -2197,10 +2203,21 @@ static long kvm_vcpu_ioctl(struct file *filp,
 		return kvm_arch_vcpu_ioctl(filp, ioctl, arg);
 #endif
 
+	if (!mutex_trylock(&vcpu->mutex)) {
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
+	__vcpu_load(vcpu);
 
-	r = vcpu_load(vcpu);
-	if (r)
-		return r;
 	switch (ioctl) {
 	case KVM_RUN:
 		r = -EINVAL;
