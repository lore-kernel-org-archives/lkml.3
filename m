Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaDYLkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:40:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbaDYLkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:40:10 -0400
Date: Fri, 25 Apr 2014 13:40:10 +0200
From: Borislav Petkov <bp@suse.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        ricardo.neri-calderon@linux.intel.com, tglx@linutronix.de,
        matt.fleming@intel.com, linux-tip-commits@vger.kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [tip:x86/efi] x86/efi: Save and restore FPU context around
 efi_calls (x86_64)
Message-ID: <20140425114010.GA20275@nazgul.tnic>
References: <tip-de05764e0b2a3d9559e099a2e134f8cef4500fdd@git.kernel.org>
 <20140420002811.GA18663@pd.tnic>
 <20140425110936.GB26088@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140425110936.GB26088@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:09:36PM +0100, Matt Fleming wrote:
> Hmm... note that we may call EFI runtime services from interrupt context
> in efi_pstore_write(), so it seems like it would be possible to trigger
> that WARN_ON_ONCE() there.
> 
> Seiji (Cc'd) might have some opinions on this.
> 
> Either way, if someone sends me a patch ontop of this one that swaps the
> __kernel_fpu_begin() for kernel_fpu_begin() I can try them out in my
> lab.

Well, the more I think about it, the more I'm persuaded that
you actually do *really* need that WARN_ON_ONCE check there to
make sure you're not fiddling with the FPU while in an interrupt
context and in an unsafe way (see interrupted_kernel_fpu_idle() and
interrupted_user_mode()). And so you do need the variants without the
"__" which include the check.

Anyway, here it is, do give it a good run:

---
From: Borislav Petkov <bp@suse.de>
Date: Fri, 25 Apr 2014 13:30:21 +0200
Subject: [PATCH] efi: Check for unsafe dealing with FPU state in irq ctxt

efi_call can happen in an irq context (pstore) and there we really need
to make sure we're not scribbling over FPU state while we've interrupted
a thread or kernel mode with a live FPU state. Therefore, use the
kernel_fpu_begin/end() variants which do that check.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/efi.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 1eb5f6433ad8..f969ce8bea24 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -67,11 +67,9 @@ extern u64 asmlinkage efi_call(void *fp, ...);
 	efi_status_t __s;						\
 									\
 	efi_sync_low_kernel_mappings();					\
-	preempt_disable();						\
-	__kernel_fpu_begin();						\
+	kernel_fpu_begin();						\
 	__s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);	\
-	__kernel_fpu_end();						\
-	preempt_enable();						\
+	kernel_fpu_end();						\
 	__s;								\
 })
 
-- 
1.9.0.258.g00eda23

