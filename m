Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaGJXpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:45:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52396 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaGJXpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:45:49 -0400
Date: Thu, 10 Jul 2014 16:45:33 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-d093601be5e97d2729614419d0d256ed3b6a56b0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@oracle.com, jbeulich@suse.com, luto@amacapital.net,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, jbeulich@suse.com, luto@amacapital.net,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <53B5863B02000078000204D5@mail.emea.novell.com>
References: <53B5863B02000078000204D5@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32, vdso:
  Fix vDSO build error due to missing align_vdso_addr()
Git-Commit-ID: d093601be5e97d2729614419d0d256ed3b6a56b0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d093601be5e97d2729614419d0d256ed3b6a56b0
Gitweb:     http://git.kernel.org/tip/d093601be5e97d2729614419d0d256ed3b6a56b0
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 3 Jul 2014 15:35:07 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 10 Jul 2014 16:06:04 -0700

x86-32, vdso: Fix vDSO build error due to missing align_vdso_addr()

Relying on static functions used just once to get inlined (and
subsequently have dead code paths eliminated) is wrong: Compilers are
free to decide whether they do this, regardless of optimization level.
With this not happening for vdso_addr() (observed with gcc 4.1.x), an
unresolved reference to align_vdso_addr() causes the build to fail.

[ hpa: vdso_addr() is never actually used on x86-32, as calculate_addr
  in map_vdso() is always false.  It ought to be possible to clean
  this up further, but this fixes the immediate problem. ]

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/53B5863B02000078000204D5@mail.emea.novell.com
Acked-by: Andy Lutomirski <luto@amacapital.net>
Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index e1513c4..5a5176d 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -62,6 +62,9 @@ struct linux_binprm;
    Only used for the 64-bit and x32 vdsos. */
 static unsigned long vdso_addr(unsigned long start, unsigned len)
 {
+#ifdef CONFIG_X86_32
+	return 0;
+#else
 	unsigned long addr, end;
 	unsigned offset;
 	end = (start + PMD_SIZE - 1) & PMD_MASK;
@@ -83,6 +86,7 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 	addr = align_vdso_addr(addr);
 
 	return addr;
+#endif
 }
 
 static int map_vdso(const struct vdso_image *image, bool calculate_addr)
