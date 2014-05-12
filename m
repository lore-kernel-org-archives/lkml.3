Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaELBnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:45 -0400
Received: from 1wt.eu ([62.212.114.60]:34738 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbaELBnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:42 -0400
Message-Id: <20140512003206.309441586@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 135/143] KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit b963a22e6d1a266a67e9eecc88134713fd54775c upstream

Under guest controllable circumstances apic_get_tmcct will execute a
divide by zero and cause a crash.  If the guest cpuid support
tsc deadline timers and performs the following sequence of requests
the host will crash.
- Set the mode to periodic
- Set the TMICT to 0
- Set the mode bits to 11 (neither periodic, nor one shot, nor tsc deadline)
- Set the TMICT to non-zero.
Then the lapic_timer.period will be 0, but the TMICT will not be.  If the
guest then reads from the TMCCT then the host will perform a divide by 0.

This patch ensures that if the lapic_timer.period is 0, then the division
does not occur.

Reported-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8dfeaaa..b77857f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -519,7 +519,8 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 	ASSERT(apic != NULL);
 
 	/* if initial count is 0, current count should also be 0 */
-	if (apic_get_reg(apic, APIC_TMICT) == 0)
+	if (apic_get_reg(apic, APIC_TMICT) == 0 ||
+		apic->lapic_timer.period == 0)
 		return 0;
 
 	remaining = hrtimer_get_remaining(&apic->lapic_timer.timer);
-- 
1.7.12.2.21.g234cd45.dirty



