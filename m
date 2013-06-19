Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620Ab3FSJOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:14:31 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:51990 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934311Ab3FSJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:09:43 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 2/7] KVM: MMU: document clear_spte_count
Date: Wed, 19 Jun 2013 17:09:20 +0800
Message-Id: <1371632965-20077-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061909-1618-0000-0000-0000041C936B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document it to Documentation/virtual/kvm/mmu.txt

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/mmu.txt | 4 ++++
 arch/x86/include/asm/kvm_host.h   | 5 +++++
 arch/x86/kvm/mmu.c                | 7 ++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index 869abcc..ce6df51 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -210,6 +210,10 @@ Shadow pages contain the following information:
     A bitmap indicating which sptes in spt point (directly or indirectly) at
     pages that may be unsynchronized.  Used to quickly locate all unsychronized
     pages reachable from a given page.
+  clear_spte_count:
+    It is only used on 32bit host which helps us to detect whether updating the
+    64bit spte is complete so that we can avoid reading the truncated value out
+    of mmu-lock.
 
 Reverse map
 ===========
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 966f265..1dac2c1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -226,6 +226,11 @@ struct kvm_mmu_page {
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 #ifdef CONFIG_X86_32
+	/*
+	 * Count after the page's spte has been cleared to avoid
+	 * the truncated value is read out of mmu-lock.
+	 * please see the comments in __get_spte_lockless().
+	 */
 	int clear_spte_count;
 #endif
 
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c87b19d..77d516c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -464,9 +464,10 @@ static u64 __update_clear_spte_slow(u64 *sptep, u64 spte)
 /*
  * The idea using the light way get the spte on x86_32 guest is from
  * gup_get_pte(arch/x86/mm/gup.c).
- * The difference is we can not catch the spte tlb flush if we leave
- * guest mode, so we emulate it by increase clear_spte_count when spte
- * is cleared.
+ * The difference is we can not immediately catch the spte tlb since
+ * kvm may collapse tlb flush some times. Please see kvm_set_pte_rmapp.
+ *
+ * We emulate it by increase clear_spte_count when spte is cleared.
  */
 static u64 __get_spte_lockless(u64 *sptep)
 {
-- 
1.8.1.4

