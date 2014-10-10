Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaJJRPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:15:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbaJJRPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:15:47 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH v2 1/2] KVM: x86: add apic_timer_expired()
Date: Fri, 10 Oct 2014 19:15:08 +0200
Message-Id: <1412961309-16485-2-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1412961309-16485-1-git-send-email-rkrcmar@redhat.com>
References: <1412961309-16485-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code reusable.

If the timer was already pending, we shouldn't be waiting in a queue,
so wake_up can be skipped, simplifying the path.

There is no 'reinject' case => the comment is removed.
Current race behaves correctly.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 Not sure about the FIXME, and it might motivate someone to redo the
 implicit checking as well :)

 arch/x86/kvm/lapic.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b8345dd..a3cf68b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1034,6 +1034,26 @@ static void update_divide_count(struct kvm_lapic *apic)
 				   apic->divide_count);
 }
 
+static void apic_timer_expired(struct kvm_lapic *apic)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+	wait_queue_head_t *q = &vcpu->wq;
+
+	/*
+	 * Note: KVM_REQ_PENDING_TIMER is implicitly checked in
+	 * vcpu_enter_guest.
+	 */
+	if (atomic_read(&apic->lapic_timer.pending))
+		return;
+
+	atomic_inc(&apic->lapic_timer.pending);
+	/* FIXME: this code should not know anything about vcpus */
+	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
+
+	if (waitqueue_active(q))
+		wake_up_interruptible(q);
+}
+
 static void start_apic_timer(struct kvm_lapic *apic)
 {
 	ktime_t now;
@@ -1538,23 +1558,8 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 {
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
-	struct kvm_vcpu *vcpu = apic->vcpu;
-	wait_queue_head_t *q = &vcpu->wq;
 
-	/*
-	 * There is a race window between reading and incrementing, but we do
-	 * not care about potentially losing timer events in the !reinject
-	 * case anyway. Note: KVM_REQ_PENDING_TIMER is implicitly checked
-	 * in vcpu_enter_guest.
-	 */
-	if (!atomic_read(&ktimer->pending)) {
-		atomic_inc(&ktimer->pending);
-		/* FIXME: this code should not know anything about vcpus */
-		kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
-	}
-
-	if (waitqueue_active(q))
-		wake_up_interruptible(q);
+	apic_timer_expired(apic);
 
 	if (lapic_is_periodic(apic)) {
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
-- 
2.1.0

