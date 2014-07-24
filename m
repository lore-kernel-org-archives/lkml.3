Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935035AbaGXKOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:14:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934964AbaGXKNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:13:50 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: uobergfe@redhat.com, dzickus@redhat.com, pbonzini@redhat.com,
        akpm@linux-foundation.org, mingo@redhat.com
Subject: [PATCH 3/3] kvm: ensure hard lockup detection is disabled by default
Date: Thu, 24 Jul 2014 12:13:31 +0200
Message-Id: <1406196811-5384-4-git-send-email-drjones@redhat.com>
In-Reply-To: <1406196811-5384-1-git-send-email-drjones@redhat.com>
References: <1406196811-5384-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

Use watchdog_enable_hardlockup_detector() to set hard lockup detection's
default value to false. It's risky to run this detection in a guest, as
false positives are easy to trigger, especially if the host is
overcommitted.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/x86/kernel/kvm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 3dd8e2c4d74a9..95c3cb16af3e5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/kprobes.h>
 #include <linux/debugfs.h>
+#include <linux/nmi.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -499,6 +500,13 @@ void __init kvm_guest_init(void)
 #else
 	kvm_guest_cpu_init();
 #endif
+
+	/*
+	 * Hard lockup detection is enabled by default. Disable it, as guests
+	 * can get false positives too easily, for example if the host is
+	 * overcommitted.
+	 */
+	watchdog_enable_hardlockup_detector(false);
 }
 
 static noinline uint32_t __kvm_cpuid_base(void)
-- 
1.9.3

