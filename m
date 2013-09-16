Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3IPOGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:06:31 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42410 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3IPOG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:06:27 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, stable@vger.kernel.org,
        kvm@vger.kernel.org, gleb@redhat.com, jan.kiszka@siemens.com
Subject: [PATCH 2/3] KVM: protect kvm_usage_count with its own spinlock
Date: Mon, 16 Sep 2013 16:06:12 +0200
Message-Id: <1379340373-5135-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VM list need not be protected by a raw spinlock.  Separate the
two so that kvm_lock can be made non-raw.

Cc: stable@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: gleb@redhat.com
Cc: jan.kiszka@siemens.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virtual/kvm/locking.txt |  6 +++++-
 virt/kvm/kvm_main.c                   | 19 ++++++++++---------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/Documentation/virtual/kvm/locking.txt b/Documentation/virtual/kvm/locking.txt
index a9f366e..ba9e1c2 100644
--- a/Documentation/virtual/kvm/locking.txt
+++ b/Documentation/virtual/kvm/locking.txt
@@ -135,7 +135,11 @@ Name:		kvm_lock
 Type:		raw_spinlock
 Arch:		any
 Protects:	- vm_list
-		- hardware virtualization enable/disable
+
+Name:		kvm_count_lock
+Type:		raw_spinlock_t
+Arch:		any
+Protects:	- hardware virtualization enable/disable
 Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
 		migration.
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 75522b3..da13379 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -71,6 +71,7 @@ MODULE_LICENSE("GPL");
  */
 
 DEFINE_RAW_SPINLOCK(kvm_lock);
+static DEFINE_RAW_SPINLOCK(kvm_count_lock);
 LIST_HEAD(vm_list);
 
 static cpumask_var_t cpus_hardware_enabled;
@@ -2683,10 +2684,10 @@ static void hardware_enable_nolock(void *junk)
 
 static void hardware_enable(void)
 {
-	raw_spin_lock(&kvm_lock);
+	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
 		hardware_enable_nolock(NULL);
-	raw_spin_unlock(&kvm_lock);
+	raw_spin_unlock(&kvm_count_lock);
 }
 
 static void hardware_disable_nolock(void *junk)
@@ -2701,10 +2702,10 @@ static void hardware_disable_nolock(void *junk)
 
 static void hardware_disable(void)
 {
-	raw_spin_lock(&kvm_lock);
+	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
-	raw_spin_unlock(&kvm_lock);
+	raw_spin_unlock(&kvm_count_lock);
 }
 
 static void hardware_disable_all_nolock(void)
@@ -2718,16 +2719,16 @@ static void hardware_disable_all_nolock(void)
 
 static void hardware_disable_all(void)
 {
-	raw_spin_lock(&kvm_lock);
+	raw_spin_lock(&kvm_count_lock);
 	hardware_disable_all_nolock();
-	raw_spin_unlock(&kvm_lock);
+	raw_spin_unlock(&kvm_count_lock);
 }
 
 static int hardware_enable_all(void)
 {
 	int r = 0;
 
-	raw_spin_lock(&kvm_lock);
+	raw_spin_lock(&kvm_count_lock);
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
@@ -2740,7 +2741,7 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	raw_spin_unlock(&kvm_lock);
+	raw_spin_unlock(&kvm_count_lock);
 
 	return r;
 }
@@ -3133,7 +3134,7 @@ static int kvm_suspend(void)
 static void kvm_resume(void)
 {
 	if (kvm_usage_count) {
-		WARN_ON(raw_spin_is_locked(&kvm_lock));
+		WARN_ON(raw_spin_is_locked(&kvm_count_lock));
 		hardware_enable_nolock(NULL);
 	}
 }
-- 
1.8.3.1


