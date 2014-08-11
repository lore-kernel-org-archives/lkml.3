Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaHKOuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:50:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbaHKOuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:50:11 -0400
From: Don Zickus <dzickus@redhat.com>
To: akpm@linux-foundation.org
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, mingo@redhat.com,
        LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 5/5] kvm: ensure hard lockup detection is disabled by default
Date: Mon, 11 Aug 2014 10:49:27 -0400
Message-Id: <1407768567-171794-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
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
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/kvm.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 3dd8e2c..95c3cb1 100644
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
1.7.1

