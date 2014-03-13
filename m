Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaCMO0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:26:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbaCMO0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:26:20 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, imammedo@redhat.com,
        bp@suse.de, paul.gortmaker@windriver.com, JBeulich@suse.com,
        prarit@redhat.com, drjones@redhat.com, toshi.kani@hp.com,
        x86@kernel.org, riel@redhat.com, gong.chen@linux.intel.com
Subject: [PATCH 2/3] x86: halt secondary CPU if master doesn't wait on it
Date: Thu, 13 Mar 2014 15:25:19 +0100
Message-Id: <1394720720-8484-3-git-send-email-imammedo@redhat.com>
In-Reply-To: <1394720720-8484-1-git-send-email-imammedo@redhat.com>
References: <1394720720-8484-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if during CPU hotplug master CPU had errors during
sending AP wake up IPIs, it fails hotplug operation.
But AP might start and spin on never set
cpu_callout_mask indefinitely, consuming power or
host VCPU resources needlessly.

On the other hand, master CPU marks AP with
BAD_APICID if hotplug attempt failed, so use this
fact to halt CPU to avoid needless spinning.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/cpu/common.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e048e87..9f07b8e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1242,8 +1242,11 @@ void cpu_init(void)
 	 * wait till the master CPU completes it's STARTUP sequence,
 	 * and decides to wait till this AP boots
 	 */
-	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
+	while (!cpumask_test_cpu(cpu, cpu_callout_mask)) {
 		cpu_relax();
+		if (per_cpu(x86_cpu_to_apicid, cpu) == BAD_APICID)
+			halt();
+	}
 
 	/*
 	 * Load microcode on this cpu if a valid microcode is available.
@@ -1345,8 +1348,11 @@ void cpu_init(void)
 	 * wait till the master CPU completes it's STARTUP sequence,
 	 * and decides to wait till this AP boots
 	 */
-	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
+	while (!cpumask_test_cpu(cpu, cpu_callout_mask)) {
 		cpu_relax();
+		if (per_cpu(x86_cpu_to_apicid, cpu) == BAD_APICID)
+			halt();
+	}
 
 
 	show_ucode_info_early();
-- 
1.7.1

