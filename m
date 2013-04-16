Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3DPGdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:33:11 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57400 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3DPGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:33:08 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 01/15] KVM: x86: clean up and optimize for kvm_arch_free_memslot
Date: Tue, 16 Apr 2013 14:32:39 +0800
Message-Id: <1366093973-2617-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041606-5564-0000-0000-00000784CF83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memslot rmap and lpage-info are never partly reused and nothing need
be freed when new memslot is created

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4be4733..b0be7ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6856,19 +6856,22 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
 {
 	int i;
 
+	if (dont && dont->arch.rmap[0] == free->arch.rmap[0])
+		return;
+
+	/* It is a empty memslot. */
+	if (!free->arch.rmap[0])
+		return;
+
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		if (!dont || free->arch.rmap[i] != dont->arch.rmap[i]) {
-			kvm_kvfree(free->arch.rmap[i]);
-			free->arch.rmap[i] = NULL;
-		}
+		kvm_kvfree(free->arch.rmap[i]);
+		free->arch.rmap[i] = NULL;
+
 		if (i == 0)
 			continue;
 
-		if (!dont || free->arch.lpage_info[i - 1] !=
-			     dont->arch.lpage_info[i - 1]) {
-			kvm_kvfree(free->arch.lpage_info[i - 1]);
-			free->arch.lpage_info[i - 1] = NULL;
-		}
+		kvm_kvfree(free->arch.lpage_info[i - 1]);
+		free->arch.lpage_info[i - 1] = NULL;
 	}
 }
 
-- 
1.7.7.6

