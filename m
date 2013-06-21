Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030424Ab3FUJCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:02:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965400Ab3FUJCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:02:48 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        kvm@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        eabatalov89@gmail.com
Subject: [PATCH 1/2] x86: kvmclock: zero initialize pvclock shared memory area
Date: Fri, 21 Jun 2013 11:01:20 +0200
Message-Id: <1371805281-21305-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <bug-59521-28872@https.bugzilla.kernel.org/>
References: <bug-59521-28872@https.bugzilla.kernel.org/>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit:
  7069ed6 x86: kvmclock: allocate pvclock shared memory area

kernel might hung in pvclock_clocksource_read() due to
uninitialized memory might contain odd version value in
following cycle:

        do {
                version = __pvclock_read_cycles(src, &ret, &flags);
        } while ((src->version & 1) || version != src->version);

if secondary kvmclock is accessed before it's registered with kvm.

Additionally before regression was introduced users of pre-cpu
hv_clock were relying on variable being zero initialized, and
7069ed6 breaks this assumption for usage of:
  hv_clock.migrate_count
which could be populated with random garbage now.

Clearing garbage in pvclock shared memory area right after it's
allocated helps to avoid these issues.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/kvmclock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index d2c3812..3dd37eb 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -242,6 +242,7 @@ void __init kvmclock_init(void)
 	if (!mem)
 		return;
 	hv_clock = __va(mem);
+	memset(hv_clock, 0, size);
 
 	if (kvm_register_clock("boot clock")) {
 		hv_clock = NULL;
-- 
1.7.1

