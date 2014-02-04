Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935903AbaBDXMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:12:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55973 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbaBDVAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:00:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Vinson Lee <vlee@twopensource.com>
Subject: [PATCH 3.4 32/37] KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
Date: Tue,  4 Feb 2014 13:01:08 -0800
Message-Id: <20140204210056.917787530@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210055.992134150@linuxfoundation.org>
References: <20140204210055.992134150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Vinson Lee <vlee@twopensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -538,7 +538,8 @@ static u32 apic_get_tmcct(struct kvm_lap
 	ASSERT(apic != NULL);
 
 	/* if initial count is 0, current count should also be 0 */
-	if (apic_get_reg(apic, APIC_TMICT) == 0)
+	if (apic_get_reg(apic, APIC_TMICT) == 0 ||
+		apic->lapic_timer.period == 0)
 		return 0;
 
 	remaining = hrtimer_get_remaining(&apic->lapic_timer.timer);


