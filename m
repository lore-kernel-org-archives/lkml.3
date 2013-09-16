Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3IPOG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:06:27 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:33459 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3IPOGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:06:25 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, stable@vger.kernel.org,
        kvm@vger.kernel.org, gleb@redhat.com, jan.kiszka@siemens.com
Subject: [PATCH 1/3] KVM: cleanup (physical) CPU hotplug
Date: Mon, 16 Sep 2013 16:06:11 +0200
Message-Id: <1379340373-5135-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the useless argument, and do not do anything if there are no
VMs running at the time of the hotplug.

Cc: stable@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: gleb@redhat.com
Cc: jan.kiszka@siemens.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 979bff4..75522b3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2681,10 +2681,11 @@ static void hardware_enable_nolock(void *junk)
 	}
 }
 
-static void hardware_enable(void *junk)
+static void hardware_enable(void)
 {
 	raw_spin_lock(&kvm_lock);
-	hardware_enable_nolock(junk);
+	if (kvm_usage_count)
+		hardware_enable_nolock(NULL);
 	raw_spin_unlock(&kvm_lock);
 }
 
@@ -2698,10 +2699,11 @@ static void hardware_disable_nolock(void *junk)
 	kvm_arch_hardware_disable(NULL);
 }
 
-static void hardware_disable(void *junk)
+static void hardware_disable(void)
 {
 	raw_spin_lock(&kvm_lock);
-	hardware_disable_nolock(junk);
+	if (kvm_usage_count)
+		hardware_disable_nolock(NULL);
 	raw_spin_unlock(&kvm_lock);
 }
 
@@ -2756,12 +2758,12 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	case CPU_DYING:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
-		hardware_disable(NULL);
+		hardware_disable();
 		break;
 	case CPU_STARTING:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-		hardware_enable(NULL);
+		hardware_enable();
 		break;
 	}
 	return NOTIFY_OK;
-- 
1.8.3.1


