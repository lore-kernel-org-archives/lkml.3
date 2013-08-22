Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3HVL1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:27:35 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40346 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3HVL1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:27:33 -0400
Date: Thu, 22 Aug 2013 15:27:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xen-devel@lists.xen.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Emelyanov <xemul@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130822112727.GL18673@moon>
References: <5214C524.1050900@citrix.com>
 <20130821141223.GS18673@moon>
 <5214F09002000078000ED5C3@nat28.tlf.novell.com>
 <20130821154238.GV18673@moon>
 <521500E102000078000ED65C@nat28.tlf.novell.com>
 <20130821161946.GW18673@moon>
 <5215D23A02000078000ED7FC@nat28.tlf.novell.com>
 <20130822070305.GH18673@moon>
 <5215D99102000078000ED838@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5215D99102000078000ED838@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 08:27:45AM +0100, Jan Beulich wrote:
> >>> On 22.08.13 at 09:03, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > Ok, how about this?
> > 
> > static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
> > {
> > 	BUG_ON(pte_present(pte));
> > 	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
> > }
> 
> Sure, fine with me. Perhaps VM_BUG_ON() or some other similar
> construct limiting the scope when any extra code gets generated
> would do too.

Sorry for delay, the patch is below.

> 
> But as said, even better would perhaps be to have it act on a
> swp_entry_t.

swp_entry_t is too small already to keep additional status bit,
unfortunately.
---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] mm: Make sure _PAGE_SWP_SOFT_DIRTY bit is not set on present pte

_PAGE_SOFT_DIRTY bit should never be set on present pte so add
VM_BUG_ON to catch any potential future abuse.

Also add a comment on _PAGE_SWP_SOFT_DIRTY definition explaining
scope of its usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/include/asm/pgtable.h       |   34 +++++++++++++++++++---------------
 arch/x86/include/asm/pgtable_types.h |    3 +++
 2 files changed, 22 insertions(+), 15 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/pgtable.h
+++ linux-2.6.git/arch/x86/include/asm/pgtable.h
@@ -314,21 +314,6 @@ static inline pmd_t pmd_mksoft_dirty(pmd
 	return pmd_set_flags(pmd, _PAGE_SOFT_DIRTY);
 }
 
-static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
-{
-	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
-}
-
-static inline int pte_swp_soft_dirty(pte_t pte)
-{
-	return pte_flags(pte) & _PAGE_SWP_SOFT_DIRTY;
-}
-
-static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
-{
-	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
-}
-
 static inline pte_t pte_file_clear_soft_dirty(pte_t pte)
 {
 	return pte_clear_flags(pte, _PAGE_SOFT_DIRTY);
@@ -445,6 +430,7 @@ pte_t *populate_extra_pte(unsigned long
 
 #ifndef __ASSEMBLY__
 #include <linux/mm_types.h>
+#include <linux/mmdebug.h>
 #include <linux/log2.h>
 
 static inline int pte_none(pte_t pte)
@@ -863,6 +849,24 @@ static inline void update_mmu_cache_pmd(
 {
 }
 
+static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
+{
+	VM_BUG_ON(pte_present(pte));
+	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
+}
+
+static inline int pte_swp_soft_dirty(pte_t pte)
+{
+	VM_BUG_ON(pte_present(pte));
+	return pte_flags(pte) & _PAGE_SWP_SOFT_DIRTY;
+}
+
+static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
+{
+	VM_BUG_ON(pte_present(pte));
+	return pte_clear_flags(pte, _PAGE_SWP_SOFT_DIRTY);
+}
+
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
 
Index: linux-2.6.git/arch/x86/include/asm/pgtable_types.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/pgtable_types.h
+++ linux-2.6.git/arch/x86/include/asm/pgtable_types.h
@@ -75,6 +75,9 @@
  * with swap entry format. On x86 bits 6 and 7 are *not* involved
  * into swap entry computation, but bit 6 is used for nonlinear
  * file mapping, so we borrow bit 7 for soft dirty tracking.
+ *
+ * Please note that this bit must be treated as swap dirty page
+ * mark if and only if the PTE has present bit clear!
  */
 #ifdef CONFIG_MEM_SOFT_DIRTY
 #define _PAGE_SWP_SOFT_DIRTY	_PAGE_PSE
