Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585Ab3FSJNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:13:38 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39674 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934316Ab3FSJJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:09:44 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 3/7] KVM: MMU: document write_flooding_count
Date: Wed, 19 Jun 2013 17:09:21 +0800
Message-Id: <1371632965-20077-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061909-5816-0000-0000-00000884150F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document write_flooding_count to Documentation/virtual/kvm/mmu.txt

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/mmu.txt | 8 ++++++++
 arch/x86/include/asm/kvm_host.h   | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index ce6df51..5a6b2e2 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -214,6 +214,14 @@ Shadow pages contain the following information:
     It is only used on 32bit host which helps us to detect whether updating the
     64bit spte is complete so that we can avoid reading the truncated value out
     of mmu-lock.
+  write_flooding_count:
+    In order to sync the page table between guest and host, the page sometimes
+    needs to be write-protected (see "Synchronized and unsynchronized pages"
+    below), any write to the page can cause write emulation. If the emulation
+    on the page is too frequent we'd better unmap the page to avoid the
+    future emulation. write_flooding_count aims at this optimization which is
+    increased when the page needs to be write emulated and cleared when the
+    page is actually used.
 
 Reverse map
 ===========
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1dac2c1..5eb5382 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -234,6 +234,11 @@ struct kvm_mmu_page {
 	int clear_spte_count;
 #endif
 
+	/*
+	 * Increased when the page needs to be write emulated, cleared
+	 * when the page is actually used as page table to avoid frequent
+	 * emulation on the page.
+	 */
 	int write_flooding_count;
 };
 
-- 
1.8.1.4

