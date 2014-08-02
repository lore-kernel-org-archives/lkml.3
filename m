Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaHBNLO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 09:11:14 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:54225
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755139AbaHBNLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 09:11:12 -0400
X-WSS-ID: 0N9OKMI-08-CWG-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
CC: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, <John.Bridgman@amd.com>,
        Joerg Roedel <joro@8bytes.org>, <hpa@zytor.com>, <mgorman@suse.de>,
        <aarcange@redhat.com>, <airlied@gmail.com>,
        <Alexander.Deucher@amd.com>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH] mmu_notifier: add call_srcu and sync function for listener to delay call and sync
Date: Sat, 2 Aug 2014 16:10:51 +0300
Message-ID: <1406985051-19620-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(74502001)(31966008)(74662001)(84676001)(79102001)(87286001)(105586002)(50986999)(20776003)(47776003)(36756003)(99396002)(81542001)(2201001)(77156001)(81342001)(92566001)(92726001)(46102001)(85852003)(83072002)(50226001)(80022001)(87936001)(62966002)(64706001)(4396001)(89996001)(77096002)(88136002)(33646002)(21056001)(95666004)(102836001)(101416001)(76482001)(229853001)(77982001)(83322001)(23676002)(97736001)(107046002)(106466001)(19580405001)(93916002)(19580395003)(86362001)(104166001)(68736004)(85306004)(50466002)(44976005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB044;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029174C036
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

When kernel device drivers or subsystems want to bind their lifespan to the
lifespan of the mm_struct, they usually use one of the following methods:

1. Manually calling a function in the interested kernel module. The function
call needs to be placed in mmput. This method was rejected by several kernel
maintainers.

2. Registering to the mmu notifier release mechanism.

The problem with the latter approach is that the mmu_notifier_release callback
is called from__mmu_notifier_release (called from exit_mmap). That function
iterates over the list of mmu notifiers and don't expect the release callback
function to remove itself from the list. Therefore, the callback function in
the kernel module can't release the mmu_notifier_object, which is actually the
kernel module's object itself. As a result, the destruction of the kernel
module's object must to be done in a delayed fashion.

This patch adds support for this delayed callback, by adding a new
mmu_notifier_call_srcu function that receives a function ptr and calls that
function with call_srcu. In that function, the kernel module releases its
object. To use mmu_notifier_call_srcu, the calling module needs to call before
that a new function called mmu_notifier_unregister_no_release that as its name
implies, unregisters a notifier without calling its notifier release callback.

This patch also adds a function that will call barrier_srcu so those kernel
modules can sync with mmu_notifier.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 include/linux/mmu_notifier.h |  6 ++++++
 mm/mmu_notifier.c            | 40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index deca874..2728869 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -170,6 +170,8 @@ extern int __mmu_notifier_register(struct mmu_notifier *mn,
 				   struct mm_struct *mm);
 extern void mmu_notifier_unregister(struct mmu_notifier *mn,
 				    struct mm_struct *mm);
+extern void mmu_notifier_unregister_no_release(struct mmu_notifier *mn,
+					       struct mm_struct *mm);
 extern void __mmu_notifier_mm_destroy(struct mm_struct *mm);
 extern void __mmu_notifier_release(struct mm_struct *mm);
 extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
@@ -288,6 +290,10 @@ static inline void mmu_notifier_mm_destroy(struct mm_struct *mm)
 	set_pte_at(___mm, ___address, __ptep, ___pte);			\
 })
 
+extern void mmu_notifier_call_srcu(struct rcu_head *rcu,
+				   void (*func)(struct rcu_head *rcu));
+extern void mmu_notifier_synchronize(void);
+
 #else /* CONFIG_MMU_NOTIFIER */
 
 static inline void mmu_notifier_release(struct mm_struct *mm)
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 41cefdf..950813b 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -23,6 +23,25 @@
 static struct srcu_struct srcu;
 
 /*
+ * This function allows mmu_notifier::release callback to delay a call to
+ * a function that will free appropriate resources. The function must be
+ * quick and must not block.
+ */
+void mmu_notifier_call_srcu(struct rcu_head *rcu,
+			    void (*func)(struct rcu_head *rcu))
+{
+	call_srcu(&srcu, rcu, func);
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_call_srcu);
+
+void mmu_notifier_synchronize(void)
+{
+	/* Wait for any running method to finish. */
+	srcu_barrier(&srcu);
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_synchronize);
+
+/*
  * This function can't run concurrently against mmu_notifier_register
  * because mm->mm_users > 0 during mmu_notifier_register and exit_mmap
  * runs with mm_users == 0. Other tasks may still invoke mmu notifiers
@@ -53,7 +72,6 @@ void __mmu_notifier_release(struct mm_struct *mm)
 		 */
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
-	srcu_read_unlock(&srcu, id);
 
 	spin_lock(&mm->mmu_notifier_mm->lock);
 	while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
@@ -69,6 +87,7 @@ void __mmu_notifier_release(struct mm_struct *mm)
 		hlist_del_init_rcu(&mn->hlist);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
+	srcu_read_unlock(&srcu, id);
 
 	/*
 	 * synchronize_srcu here prevents mmu_notifier_release from returning to
@@ -325,6 +344,25 @@ void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_unregister);
 
+/*
+ * Same as mmu_notifier_unregister but no callback and no srcu synchronization.
+ */
+void mmu_notifier_unregister_no_release(struct mmu_notifier *mn,
+					struct mm_struct *mm)
+{
+	spin_lock(&mm->mmu_notifier_mm->lock);
+	/*
+	 * Can not use list_del_rcu() since __mmu_notifier_release
+	 * can delete it before we hold the lock.
+	 */
+	hlist_del_init_rcu(&mn->hlist);
+	spin_unlock(&mm->mmu_notifier_mm->lock);
+
+	BUG_ON(atomic_read(&mm->mm_count) <= 0);
+	mmdrop(mm);
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_unregister_no_release);
+
 static int __init mmu_notifier_init(void)
 {
 	return init_srcu_struct(&srcu);
-- 
1.9.1

