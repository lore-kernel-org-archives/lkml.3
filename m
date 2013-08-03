Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3HCAsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 20:48:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39995 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3HCAso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 20:48:44 -0400
Date: Sat, 3 Aug 2013 01:48:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Build breakage due to latest ARM fixes
Message-ID: <20130803004838.GU23006@n2100.arm.linux.org.uk>
References: <CAOesGMgWeP-CdmOE-S7XZmJ-+1buP9a1cqavUns2gpgKrrhaxQ@mail.gmail.com> <20130803000731.GS23006@n2100.arm.linux.org.uk> <CAOesGMi3FBz7-tQSxgQMgHiHmPTnO4k57MkhQTQTvtB0Q6WyNw@mail.gmail.com> <20130803004111.GT23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130803004111.GT23006@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 01:41:11AM +0100, Russell King - ARM Linux wrote:
> On Fri, Aug 02, 2013 at 05:24:21PM -0700, Olof Johansson wrote:
> > On Fri, Aug 2, 2013 at 5:07 PM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > On Fri, Aug 02, 2013 at 04:41:11PM -0700, Olof Johansson wrote:
> > >> Russell,
> > >>
> > >> Looks like you sent up some fixes to Linus that broke one of the atmel
> > >> configs (CONFIG_MMU=n):
> > >>
> > >> commit 48be69a026b2c1 ARM: move signal handlers into a vdso-like page
> > >>
> > >> seems to have caused it:
> > >>
> > >> arch/arm/kernel/signal.c: In function 'setup_return':
> > >> arch/arm/kernel/signal.c:413:25: error: 'mm_context_t' has no member
> > >> named 'sigpage'
> > >>
> > >> I see it with at91x40_defconfig.
> > >
> > > I'll look into that.  Obviously, I never build nommu because it isn't
> > > part of the build system and the nommu platform I do have - OKI67001 -
> > > doesn't have mainline kernel support.  (And if it did, it would not be
> > > DT, so I doubt it's submittable.)
> > 
> > I just noticed a whole bunch of boot/runtime failures too across the board too.
> > 
> > tegra2 seaboard, exynos arndale, ux500 snowball all panicked. Panda,
> > cubox and sama5 were the only systems that stayed up. Note that I
> > don't do much with them per boot though, so with more runtime they
> > might have hit something too.
> > 
> > Some of the oopses below, they're probably not very useful though. Let
> > me know if I can help collect data in any way.
> 
> Gah, it looks like I didn't commit an update to these patches.

Okay, this should fix it - *untested* though because of the fscking time
it is here again.  The problem is that install_special_mapping() assumes
that the pointer to the pages will be persistent, and it wasn't.  I found
that during testing and thought I'd merged the patches in, but I seem to
have totally destroyed the original fixes for this.

 arch/arm/kernel/process.c |    9 +++++----
 arch/arm/kernel/signal.c  |   41 +++++++++++++++++++----------------------
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 16ed3f7..536c85f 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -474,17 +474,18 @@ const char *arch_vma_name(struct vm_area_struct *vma)
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
@@ -496,7 +497,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	ret = install_special_mapping(mm, addr, PAGE_SIZE,
 		VM_READ | VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC,
-		&page);
+		&signal_page);
 
 	if (ret == 0)
 		mm->context.sigpage = addr;
diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 0f17e06..39e7105 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -614,35 +614,32 @@ do_work_pending(struct pt_regs *regs, unsigned int thread_flags, int syscall)
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

