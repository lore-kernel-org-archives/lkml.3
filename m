Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3EQBEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 21:04:50 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61023 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3EQBEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 21:04:48 -0400
Date: Fri, 17 May 2013 03:04:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Gleb Natapov <gleb@redhat.com>, Scott Wood <scottwood@freescale.com>,
        linaro-kernel@lists.linaro.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: allow host header to be included even for
 !CONFIG_KVM
Message-ID: <20130517010442.GB12928@somewhere>
References: <20130321072955.GO3889@redhat.com>
 <87ppyshlq5.fsf@linaro.org>
 <1363891354.31522.17@snotra>
 <20130321191600.GG9382@redhat.com>
 <1363894393.31522.20@snotra>
 <20130321211736.GI9382@redhat.com>
 <CAFTL4hz2=VJBLG1w31JSPDtRdobcmL5oY6XkR46vi3zS904VGA@mail.gmail.com>
 <20130324140114.GV3889@redhat.com>
 <87txnz9o7n.fsf@linaro.org>
 <20130515225201.GA2341@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515225201.GA2341@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 12:52:03AM +0200, Frederic Weisbecker wrote:
> On Mon, Mar 25, 2013 at 02:14:20PM -0700, Kevin Hilman wrote:
> > Gleb Natapov <gleb@redhat.com> writes:
> > 
> > > On Sun, Mar 24, 2013 at 02:44:26PM +0100, Frederic Weisbecker wrote:
> > >> 2013/3/21 Gleb Natapov <gleb@redhat.com>:
> > >> > Isn't is simpler for kernel/context_tracking.c to define empty
> > >> > __guest_enter()/__guest_exit() if !CONFIG_KVM.
> > >> 
> > >> That doesn't look right. Off-cases are usually handled from the
> > >> headers, right? So that we avoid iffdeffery ugliness in core code.
> > > Lets put it in linux/context_tracking.h header then.
> > 
> > Here's a version to do that.
> > 
> > Kevin
> > 
> > From d9d909394479dd7ff90b7bddb95a564945406719 Mon Sep 17 00:00:00 2001
> > From: Kevin Hilman <khilman@linaro.org>
> > Date: Mon, 25 Mar 2013 14:12:41 -0700
> > Subject: [PATCH v2] ontext_tracking: fix !CONFIG_KVM compile: add stub guest
> >  enter/exit
> 
> Sorry for my very delayed response...
> 
> > 
> > When KVM is not enabled, or not available on a platform, the KVM
> > headers should not be included.  Instead, just define stub
> > __guest_[enter|exit] functions.
> 
> May be it would be cleaner to move guest_enter/exit definitions altogether
> in linux/context_tracking.h
> 
> After all that's where the implementation mostly belong to.
> 
> Let me see if I can get that in shape.

Does the following work for you?

---
commit b1633c075527653a99df6fd54d2611cf8c8047f5
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu May 16 01:21:38 2013 +0200

    kvm: Move guest entry/exit APIs to context_tracking
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 365f4a6..fc09d7b 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -3,6 +3,7 @@
 
 #include <linux/sched.h>
 #include <linux/percpu.h>
+#include <linux/vtime.h>
 #include <asm/ptrace.h>
 
 struct context_tracking {
@@ -19,6 +20,26 @@ struct context_tracking {
 	} state;
 };
 
+static inline void __guest_enter(void)
+{
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags |= PF_VCPU;
+}
+
+static inline void __guest_exit(void)
+{
+	/*
+	 * This is running in ioctl context so we can avoid
+	 * the call to vtime_account() with its unnecessary idle check.
+	 */
+	vtime_account_system(current);
+	current->flags &= ~PF_VCPU;
+}
+
 #ifdef CONFIG_CONTEXT_TRACKING
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
 
@@ -35,6 +56,9 @@ static inline bool context_tracking_active(void)
 extern void user_enter(void);
 extern void user_exit(void);
 
+extern void guest_enter(void);
+extern void guest_exit(void);
+
 static inline enum ctx_state exception_enter(void)
 {
 	enum ctx_state prev_ctx;
@@ -57,6 +81,17 @@ extern void context_tracking_task_switch(struct task_struct *prev,
 static inline bool context_tracking_in_user(void) { return false; }
 static inline void user_enter(void) { }
 static inline void user_exit(void) { }
+
+static inline void guest_enter(void)
+{
+	__guest_enter();
+}
+
+static inline void guest_exit(void)
+{
+	__guest_exit();
+}
+
 static inline enum ctx_state exception_enter(void) { return 0; }
 static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline void context_tracking_task_switch(struct task_struct *prev,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f0eea07..8db53cf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -23,6 +23,7 @@
 #include <linux/ratelimit.h>
 #include <linux/err.h>
 #include <linux/irqflags.h>
+#include <linux/context_tracking.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -760,42 +761,6 @@ static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
 }
 #endif
 
-static inline void __guest_enter(void)
-{
-	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
-	 */
-	vtime_account_system(current);
-	current->flags |= PF_VCPU;
-}
-
-static inline void __guest_exit(void)
-{
-	/*
-	 * This is running in ioctl context so we can avoid
-	 * the call to vtime_account() with its unnecessary idle check.
-	 */
-	vtime_account_system(current);
-	current->flags &= ~PF_VCPU;
-}
-
-#ifdef CONFIG_CONTEXT_TRACKING
-extern void guest_enter(void);
-extern void guest_exit(void);
-
-#else /* !CONFIG_CONTEXT_TRACKING */
-static inline void guest_enter(void)
-{
-	__guest_enter();
-}
-
-static inline void guest_exit(void)
-{
-	__guest_exit();
-}
-#endif /* !CONFIG_CONTEXT_TRACKING */
-
 static inline void kvm_guest_enter(void)
 {
 	unsigned long flags;
