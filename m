Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaGKWln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:41:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaGKWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:41:42 -0400
Date: Fri, 11 Jul 2014 15:41:11 -0700
Message-Id: <201407112241.s6BMfBFB031943@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.16-rc5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: akpm@linux-foundation.org, boris.ostrovsky@oracle.com, hpa@linux.intel.com,
        hpa@zytor.com, jbeulich@suse.com, linux-kernel@vger.kernel.org,
        luto@amacapital.net, mingo@kernel.org, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A couple of further build fixes for the VDSO code.  This is turning
into a bit of a headache, and Andy has already come up with a more
ultimate cleanup, but most likely that is 3.17 material.

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to d093601be5e97d2729614419d0d256ed3b6a56b0:

  x86-32, vdso: Fix vDSO build error due to missing align_vdso_addr() (2014-07-10 16:06:04 -0700)

----------------------------------------------------------------
Jan Beulich (2):
      x86-64, vdso: Fix vDSO build breakage due to empty .rela.dyn
      x86-32, vdso: Fix vDSO build error due to missing align_vdso_addr()

 arch/x86/vdso/vdso2c.h | 3 +++
 arch/x86/vdso/vma.c    | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index df95a2f..11b65d4 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -93,6 +93,9 @@ static void BITSFUNC(copy_section)(struct BITSFUNC(fake_sections) *out,
 	uint64_t flags = GET_LE(&in->sh_flags);
 
 	bool copy = flags & SHF_ALLOC &&
+		(GET_LE(&in->sh_size) ||
+		 (GET_LE(&in->sh_type) != SHT_RELA &&
+		  GET_LE(&in->sh_type) != SHT_REL)) &&
 		strcmp(name, ".altinstructions") &&
 		strcmp(name, ".altinstr_replacement");
 
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
