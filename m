Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaKKFp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:45:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaKKFn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:43:59 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V3 3/8] xen: Delay m2p_override initialization
Date: Tue, 11 Nov 2014 06:43:41 +0100
Message-Id: <1415684626-18590-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415684626-18590-1-git-send-email-jgross@suse.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m2p overrides are used to be able to find the local pfn for a
foreign mfn mapped into the domain. They are used by driver backends
having to access frontend data.

As this functionality isn't used in early boot it makes no sense to
initialize the m2p override functions very early. It can be done
later without doing any harm, removing the need for allocating memory
via extend_brk().

While at it make some m2p override functions static as they are only
used internally.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/p2m.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index f67f8cf..97252e3 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -426,8 +426,6 @@ void __init xen_build_dynamic_phys_to_machine(void)
 		}
 		p2m_top[topidx][mididx] = &mfn_list[pfn];
 	}
-
-	m2p_override_init();
 }
 #ifdef CONFIG_X86_64
 unsigned long __init xen_revector_p2m_tree(void)
@@ -498,13 +496,15 @@ unsigned long __init xen_revector_p2m_tree(void)
 		}
 		/* This should be the leafs allocated for identity from _brk. */
 	}
-	return (unsigned long)mfn_list;
 
+	m2p_override_init();
+	return (unsigned long)mfn_list;
 }
 #else
 unsigned long __init xen_revector_p2m_tree(void)
 {
 	use_brk = 0;
+	m2p_override_init();
 	return 0;
 }
 #endif
@@ -794,15 +794,16 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 #define M2P_OVERRIDE_HASH_SHIFT	10
 #define M2P_OVERRIDE_HASH	(1 << M2P_OVERRIDE_HASH_SHIFT)
 
-static RESERVE_BRK_ARRAY(struct list_head, m2p_overrides, M2P_OVERRIDE_HASH);
+static struct list_head *m2p_overrides;
 static DEFINE_SPINLOCK(m2p_override_lock);
 
 static void __init m2p_override_init(void)
 {
 	unsigned i;
 
-	m2p_overrides = extend_brk(sizeof(*m2p_overrides) * M2P_OVERRIDE_HASH,
-				   sizeof(unsigned long));
+	m2p_overrides = alloc_bootmem_align(
+				sizeof(*m2p_overrides) * M2P_OVERRIDE_HASH,
+				sizeof(unsigned long));
 
 	for (i = 0; i < M2P_OVERRIDE_HASH; i++)
 		INIT_LIST_HEAD(&m2p_overrides[i]);
@@ -930,21 +931,25 @@ EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
 static struct page *m2p_find_override(unsigned long mfn)
 {
 	unsigned long flags;
-	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
+	struct list_head *bucket;
 	struct page *p, *ret;
 
 	ret = NULL;
 
-	spin_lock_irqsave(&m2p_override_lock, flags);
+	if (m2p_overrides) {
+		bucket = &m2p_overrides[mfn_hash(mfn)];
 
-	list_for_each_entry(p, bucket, lru) {
-		if (page_private(p) == mfn) {
-			ret = p;
-			break;
+		spin_lock_irqsave(&m2p_override_lock, flags);
+
+		list_for_each_entry(p, bucket, lru) {
+			if (page_private(p) == mfn) {
+				ret = p;
+				break;
+			}
 		}
-	}
 
-	spin_unlock_irqrestore(&m2p_override_lock, flags);
+		spin_unlock_irqrestore(&m2p_override_lock, flags);
+	}
 
 	return ret;
 }
-- 
2.1.2

