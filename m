Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbaEEXHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:07:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57829 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870AbaEEXG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:06:59 -0400
Date: Mon, 5 May 2014 16:06:34 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-uxm3j3w3odglcwhafwq5tjqu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        herbert@gondor.apana.org.au, luto@amacapital.net, tglx@linutronix.de,
        hpa@linux.intel.com, mouli@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, luto@amacapital.net, tglx@linutronix.de,
        hpa@linux.intel.com, mouli@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, build: Don't get confused by local symbols
Git-Commit-ID: ac008fe0a3236729751ccde655c215b436dfdaeb
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

Commit-ID:  ac008fe0a3236729751ccde655c215b436dfdaeb
Gitweb:     http://git.kernel.org/tip/ac008fe0a3236729751ccde655c215b436dfdaeb
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 5 May 2014 15:23:35 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 5 May 2014 15:23:35 -0700

x86, build: Don't get confused by local symbols

arch/x86/crypto/sha1_avx2_x86_64_asm.S introduced _end as a local
symbol, which broke the build under certain circumstances.  Although
the wisdom of _end as a local symbol can definitely be questioned, the
build should not break for that reason.

Thus, filter the output of nm to only get global symbols of
appropriate type.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-uxm3j3w3odglcwhafwq5tjqu@git.kernel.org
---
 arch/x86/boot/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index abb9eba..dbe8dd2 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -71,7 +71,7 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
 
 SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
 
-sed-voffset := -e 's/^\([0-9a-fA-F]*\) . \(_text\|_end\)$$/\#define VO_\2 0x\1/p'
+sed-voffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(_text\|_end\)$$/\#define VO_\2 0x\1/p'
 
 quiet_cmd_voffset = VOFFSET $@
       cmd_voffset = $(NM) $< | sed -n $(sed-voffset) > $@
@@ -80,7 +80,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
