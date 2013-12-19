Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3LSMAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:00:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45381 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3LSMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:00:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 195/208] KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
Date: Thu, 19 Dec 2013 11:54:53 +0000
Message-Id: <1387454106-19326-196-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index afc1124..adbcc08 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -855,7 +855,8 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 	ASSERT(apic != NULL);
 
 	/* if initial count is 0, current count should also be 0 */
-	if (kvm_apic_get_reg(apic, APIC_TMICT) == 0)
+	if (kvm_apic_get_reg(apic, APIC_TMICT) == 0 ||
+		apic->lapic_timer.period == 0)
 		return 0;
 
 	remaining = hrtimer_get_remaining(&apic->lapic_timer.timer);
-- 
1.8.3.2

