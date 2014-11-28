Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaK1Kzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:55:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbaK1KyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:08 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 05/10] xen: Delay m2p_override initialization
Date: Fri, 28 Nov 2014 11:53:54 +0100
Message-Id: <1417172039-8627-6-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
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
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 24cd9d1..8676f35 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -428,8 +428,6 @@ void __init xen_build_dynamic_phys_to_machine(void)
 		}
 		p2m_top[topidx][mididx] = &mfn_list[pfn];
 	}
-
-	m2p_override_init();
 }
 #ifdef CONFIG_X86_64
 unsigned long __init xen_revector_p2m_tree(void)
@@ -500,13 +498,15 @@ unsigned long __init xen_revector_p2m_tree(void)
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
@@ -796,15 +796,16 @@ bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
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
@@ -932,10 +933,14 @@ EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
 static struct page *m2p_find_override(unsigned long mfn)
 {
 	unsigned long flags;
-	struct list_head *bucket = &m2p_overrides[mfn_hash(mfn)];
+	struct list_head *bucket;
 	struct page *p, *ret;
 
+	if (unlikely(!m2p_overrides))
+		return NULL;
+
 	ret = NULL;
+	bucket = &m2p_overrides[mfn_hash(mfn)];
 
 	spin_lock_irqsave(&m2p_override_lock, flags);
 
-- 
2.1.2

