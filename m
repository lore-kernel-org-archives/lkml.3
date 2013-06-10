Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3FJQbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:31:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab3FJQbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:31:43 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mtosatti@redhat.com, eabatalov89@gmail.com
Subject: [PATCH] x86: kvmclock: zero initialize pvclock shared memory area
Date: Mon, 10 Jun 2013 18:31:11 +0200
Message-Id: <1370881871-13130-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <bug-59521-28872@https.bugzilla.kernel.org/>
References: <bug-59521-28872@https.bugzilla.kernel.org/>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

===
Could be the following an acceptable fix?
===

kernel might hung in pvclock_clocksource_read() due to
uninitialized memory might contain odd version value in
following cycle:

        do {
                version = __pvclock_read_cycles(src, &ret, &flags);
        } while ((src->version & 1) || version != src->version);

if secondary kvmclock is accessed before it's registered with kvm.

Clear garbage in pvclock shared memory area right after it's
allocated to avoid this issue.

Ref: https://bugzilla.kernel.org/show_bug.cgi?id=59521
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

