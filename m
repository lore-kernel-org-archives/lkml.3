Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030423Ab3HICVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:21:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967398Ab3HIB6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 009/102] ARM: fix a cockup in 48be69a02 (ARM: move signal handlers into a vdso-like page)
Date: Thu,  8 Aug 2013 18:56:45 -0700
Message-Id: <20130809015012.442374882@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit e0d407564b532d978b03ceccebd224a05d02f111 upstream.

Unfortunately, I never committed the fix to a nasty oops which can
occur as a result of that commit:

------------[ cut here ]------------
kernel BUG at /home/olof/work/batch/include/linux/mm.h:414!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 0 PID: 490 Comm: killall5 Not tainted 3.11.0-rc3-00288-gabe0308 #53
task: e90acac0 ti: e9be8000 task.ti: e9be8000
PC is at special_mapping_fault+0xa4/0xc4
LR is at __do_fault+0x68/0x48c

This doesn't show up unless you do quite a bit of testing; a simple
boot test does not do this, so all my nightly tests were passing fine.

The reason for this is that install_special_mapping() expects the
page array to stick around, and as this was only inserting one page
which was stored on the kernel stack, that's why this was blowing up.

Reported-by: Olof Johansson <olof@lixom.net>
Tested-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/process.c |    9 +++++----
 arch/arm/kernel/signal.c  |   41 +++++++++++++++++++----------------------
 2 files changed, 24 insertions(+), 26 deletions(-)

--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -478,17 +478,18 @@ const char *arch_vma_name(struct vm_area
 		 "[sigpage]" : NULL;
 }
 
+static struct page *signal_page;
 extern struct page *get_signal_page(void);
 
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
 	struct mm_struct *mm = current->mm;
-	struct page *page;
 	unsigned long addr;
 	int ret;
 
-	page = get_signal_page();
-	if (!page)
+	if (!signal_page)
+		signal_page = get_signal_page();
+	if (!signal_page)
 		return -ENOMEM;
 
 	down_write(&mm->mmap_sem);
@@ -500,7 +501,7 @@ int arch_setup_additional_pages(struct l
 
 	ret = install_special_mapping(mm, addr, PAGE_SIZE,
 		VM_READ | VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC,
-		&page);
+		&signal_page);
 
 	if (ret == 0)
 		mm->context.sigpage = addr;
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -609,35 +609,32 @@ do_work_pending(struct pt_regs *regs, un
 	return 0;
 }
 
-static struct page *signal_page;
-
 struct page *get_signal_page(void)
 {
-	if (!signal_page) {
-		unsigned long ptr;
-		unsigned offset;
-		void *addr;
+	unsigned long ptr;
+	unsigned offset;
+	struct page *page;
+	void *addr;
 
-		signal_page = alloc_pages(GFP_KERNEL, 0);
+	page = alloc_pages(GFP_KERNEL, 0);
 
-		if (!signal_page)
-			return NULL;
+	if (!page)
+		return NULL;
 
-		addr = page_address(signal_page);
+	addr = page_address(page);
 
-		/* Give the signal return code some randomness */
-		offset = 0x200 + (get_random_int() & 0x7fc);
-		signal_return_offset = offset;
+	/* Give the signal return code some randomness */
+	offset = 0x200 + (get_random_int() & 0x7fc);
+	signal_return_offset = offset;
 
-		/*
-		 * Copy signal return handlers into the vector page, and
-		 * set sigreturn to be a pointer to these.
-		 */
-		memcpy(addr + offset, sigreturn_codes, sizeof(sigreturn_codes));
+	/*
+	 * Copy signal return handlers into the vector page, and
+	 * set sigreturn to be a pointer to these.
+	 */
+	memcpy(addr + offset, sigreturn_codes, sizeof(sigreturn_codes));
 
-		ptr = (unsigned long)addr + offset;
-		flush_icache_range(ptr, ptr + sizeof(sigreturn_codes));
-	}
+	ptr = (unsigned long)addr + offset;
+	flush_icache_range(ptr, ptr + sizeof(sigreturn_codes));
 
-	return signal_page;
+	return page;
 }


