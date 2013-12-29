Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3L2Cgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:36:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55170 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247Ab3L2CKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:42 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andy Honig" <ahonig@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.246219733@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 143/185] KVM: x86: Fix potential divide by 0 in lapic
 (CVE-2013-6367)
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit b963a22e6d1a266a67e9eecc88134713fd54775c upstream.

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
Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.2: s/kvm_apic_get_reg/apic_get_reg/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -537,7 +537,8 @@ static u32 apic_get_tmcct(struct kvm_lap
 	ASSERT(apic != NULL);
 
 	/* if initial count is 0, current count should also be 0 */
-	if (apic_get_reg(apic, APIC_TMICT) == 0)
+	if (apic_get_reg(apic, APIC_TMICT) == 0 ||
+		apic->lapic_timer.period == 0)
 		return 0;
 
 	remaining = hrtimer_get_remaining(&apic->lapic_timer.timer);

