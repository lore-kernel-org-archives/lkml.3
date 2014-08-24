Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaHXU3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 16:29:05 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52794 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaHXU3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 16:29:00 -0400
Date: Sun, 24 Aug 2014 22:28:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20140824202853.GA17622@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 80b304fd00e8b667775ff791121b61ecd7cd0c03 Merge tag 'efi-urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/urgent

A couple of EFI fixes, plus misc fixes all around the map.

  out-of-topic modifications in x86-urgent-for-linus:
  -----------------------------------------------------
  arch/arm64/kernel/efi.c            # 6a7519e81321: efi/arm64: Store Runtime Ser
  drivers/firmware/efi/vars.c        # aee530cfecf4: firmware: Do not use WARN_ON

 Thanks,

	Ingo

------------------>
Dave Hansen (1):
      x86/mm: Fix RCU splat from new TLB tracepoints

Guenter Roeck (1):
      firmware: Do not use WARN_ON(!spin_is_locked())

Jeremiah Mahler (2):
      x86/mm: Fix sparse 'tlb_single_page_flush_ceiling' warning and make the variable read-mostly
      x86/doc: Fix the 'tlb_single_page_flush_ceiling' sysconfig path

Semen Protsenko (1):
      efi/arm64: Store Runtime Services revision

Stefan Bader (1):
      x86_32, entry: Clean up sysenter_badsys declaration


 Documentation/x86/tlb.txt   |  2 +-
 arch/arm64/kernel/efi.c     |  2 ++
 arch/x86/kernel/entry_32.S  |  2 +-
 arch/x86/mm/tlb.c           | 10 ++++++++--
 drivers/firmware/efi/vars.c |  8 ++++----
 5 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/Documentation/x86/tlb.txt b/Documentation/x86/tlb.txt
index 2b3a82e69151..39d172326703 100644
--- a/Documentation/x86/tlb.txt
+++ b/Documentation/x86/tlb.txt
@@ -35,7 +35,7 @@ invlpg instruction (or instructions _near_ it) show up high in
 profiles.  If you believe that individual invalidations being
 called too often, you can lower the tunable:
 
-	/sys/debug/kernel/x86/tlb_single_page_flush_ceiling
+	/sys/kernel/debug/x86/tlb_single_page_flush_ceiling
 
 This will cause us to do the global flush for more cases.
 Lowering it to 0 will disable the use of the individual flushes.
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e72f3100958f..5dbb7bd3b838 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -463,6 +463,8 @@ static int __init arm64_enter_virtual_mode(void)
 	efi_native_runtime_setup();
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
+	efi.runtime_version = efi.systab->hdr.revision;
+
 	return 0;
 
 err_unmap:
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 47c410d99f5d..4b0e1dfa2226 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -683,7 +683,7 @@ END(syscall_badsys)
 sysenter_badsys:
 	movl $-ENOSYS,%eax
 	jmp sysenter_after_call
-END(syscall_badsys)
+END(sysenter_badsys)
 	CFI_ENDPROC
 
 .macro FIXUP_ESPFIX_STACK
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 1fe33987de02..ee61c36d64f8 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -49,7 +49,13 @@ void leave_mm(int cpu)
 	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
 		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
 		load_cr3(swapper_pg_dir);
-		trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
+		/*
+		 * This gets called in the idle path where RCU
+		 * functions differently.  Tracing normally
+		 * uses RCU, so we have to call the tracepoint
+		 * specially here.
+		 */
+		trace_tlb_flush_rcuidle(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
 	}
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -174,7 +180,7 @@ void flush_tlb_current_task(void)
  *
  * This is in units of pages.
  */
-unsigned long tlb_single_page_flush_ceiling = 33;
+static unsigned long tlb_single_page_flush_ceiling __read_mostly = 33;
 
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index f0a43646a2f3..5abe943e3404 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -481,7 +481,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_remove);
  */
 static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
 {
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	list_del(&entry->list);
 	spin_unlock_irq(&__efivars->lock);
@@ -507,7 +507,7 @@ int __efivar_entry_delete(struct efivar_entry *entry)
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -667,7 +667,7 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 	int strsize1, strsize2;
 	bool found = false;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	list_for_each_entry_safe(entry, n, head, list) {
 		strsize1 = ucs2_strsize(name, 1024);
@@ -739,7 +739,7 @@ int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	WARN_ON(!spin_is_locked(&__efivars->lock));
+	lockdep_assert_held(&__efivars->lock);
 
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
