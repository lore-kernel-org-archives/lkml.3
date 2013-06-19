Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935238Ab3FSWD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:03:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934979Ab3FSWD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:03:57 -0400
Date: Wed, 19 Jun 2013 15:03:42 -0700
From: tip-bot for Paul Gortmaker <tipbot@zytor.com>
Message-ID: <tip-949785996ec2250fa958fc3a924e5186e9a8fa2c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        paul.gortmaker@windriver.com
In-Reply-To: <1371654926-11729-1-git-send-email-paul.gortmaker@windriver.com>
References: <1371654926-11729-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix section mismatch on load_ucode_ap
Git-Commit-ID: 949785996ec2250fa958fc3a924e5186e9a8fa2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 15:03:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  949785996ec2250fa958fc3a924e5186e9a8fa2c
Gitweb:     http://git.kernel.org/tip/949785996ec2250fa958fc3a924e5186e9a8fa2c
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Wed, 19 Jun 2013 11:15:26 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 Jun 2013 14:43:59 -0700

x86: Fix section mismatch on load_ucode_ap

We are in the process of removing all the __cpuinit annotations.
While working on making that change, an existing problem was
made evident:

  WARNING: arch/x86/kernel/built-in.o(.text+0x198f2): Section mismatch
  in reference from the function cpu_init() to the function
  .init.text:load_ucode_ap()   The function cpu_init() references
  the function __init load_ucode_ap().  This is often because cpu_init
  lacks a __init annotation or the annotation of load_ucode_ap is wrong.

This now appears because in my working tree, cpu_init() is no longer
tagged as __cpuinit, and so the audit picks up the mismatch.  The 2nd
hypothesis from the audit is the correct one, as there was an incorrect
__init tag on the prototype in the header (but __cpuinit was used on
the function itself.)

The audit is telling us that the prototype's __init annotation took
effect and the function did land in the .init.text section.  Checking
with objdump on a mainline tree that still has __cpuinit shows that
the __cpuinit on the function takes precedence over the __init on the
prototype, but that won't be true once we make __cpuinit a no-op.

Even though we are removing __cpuinit, we temporarily align both
the function and the prototype on __cpuinit so that the changeset
can be applied to stable trees  if desired.

[ hpa: build fix only, no object code change ]

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: stable <stable@vger.kernel.org> # 3.9+
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Link: http://lkml.kernel.org/r/1371654926-11729-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/microcode.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 6825e2e..6bc3985 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -60,11 +60,11 @@ static inline void __exit exit_amd_microcode(void) {}
 #ifdef CONFIG_MICROCODE_EARLY
 #define MAX_UCODE_COUNT 128
 extern void __init load_ucode_bsp(void);
-extern __init void load_ucode_ap(void);
+extern void __cpuinit load_ucode_ap(void);
 extern int __init save_microcode_in_initrd(void);
 #else
 static inline void __init load_ucode_bsp(void) {}
-static inline __init void load_ucode_ap(void) {}
+static inline void __cpuinit load_ucode_ap(void) {}
 static inline int __init save_microcode_in_initrd(void)
 {
 	return 0;
