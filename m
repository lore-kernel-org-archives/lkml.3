Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab3L3ViD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:38:03 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:33791 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab3L3ViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:38:00 -0500
Date: Mon, 30 Dec 2013 13:37:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, peterz@infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk,
        ralf@linux-mips.org, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, james.hogan@imgtec.com,
        Michal Marek <mmarek@suse.cz>, lethal@linux-sh.org,
        shawn.guo@linaro.org, Kees Cook <keescook@chromium.org>,
        sfr@canb.auug.org.au, linux-kbuild@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: [patch core/stackprotector] stackprotector: Fix build when compiler
 lacks support
In-Reply-To: <tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1312301331520.10482@chino.kir.corp.google.com>
References: <1387481759-14535-3-git-send-email-keescook@chromium.org> <tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1315487975-1388439477=:10482"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1315487975-1388439477=:10482
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

8779657d29c0 ("stackprotector: Introduce CONFIG_CC_STACKPROTECTOR_STRONG") 
causes the build to break when the compiler doesn't support 
-fstack-protector-strong:

	cc1: error: unrecognized command line option ‘-fstack-protector-strong’
	cc1: error: unrecognized command line option ‘-fstack-protector-strong’

with at least gcc 4.6.3.

Instead of breaking the build, just warn of the failure and disable the 
feature.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
--- a/Makefile
+++ b/Makefile
@@ -603,10 +603,11 @@ ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
 	      -fstack-protector not supported by compiler))
   endif
 else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
-  stackp-flag := -fstack-protector-strong
-  ifeq ($(call cc-option, $(stackp-flag)),)
+  ifeq ($(call cc-option, -fstack-protector-strong),)
     $(warning Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: \
 	      -fstack-protector-strong not supported by compiler)
+  else
+    stackp-flag := -fstack-protector-strong
   endif
 else
   # Force off for distro compilers that enable stack protector by default.
--531381512-1315487975-1388439477=:10482--
